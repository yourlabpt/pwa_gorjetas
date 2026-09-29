#!/usr/bin/env python3
# Deploy-rehearsal check for employee (de)activation vs. stored daily finance.
# Prerequisites (see docs/procedures or README):
#   1. docker compose -f docker-compose.localtest.yml up -d db_test
#   2. create a NEW, EMPTY database "app_verify" in that isolated test container and restore
#      the latest backups/*.sql into it. NEVER restore into production or the backend/.env database.
#      Never delete anything afterwards (README.md "REGRA N.º 1").
#   3. cd backend && DATABASE_URL=postgresql://app:app@127.0.0.1:55432/app_verify npx prisma migrate deploy
#   4. insert a SUPER_ADMIN user verify@local.test / Verify123! (bcrypt hash) into app_verify
#   5. PORT=3901 DATABASE_URL=... JWT_SECRET=<any long string> node dist/main
# Easiest: scripts/sandbox-test.sh --e2e (sets E2E_BASE/E2E_EMAIL/E2E_PASSWORD).
# Manual: python3 backend/test/e2e-employee-history.py <today YYYY-MM-DD> <tomorrow YYYY-MM-DD>
# Assumes restaurant 4 has day 2026-08-02 saved and restaurant 2 has 2026-08-05 saved (true for the 2026-08-12 dump).

import json, os, sys, urllib.request, urllib.error

BASE = os.environ.get("E2E_BASE", "http://127.0.0.1:3901")
TOKEN = None
FAILS = []


def call(method, path, body=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(BASE + path, data=data, method=method)
    req.add_header("Content-Type", "application/json")
    if TOKEN:
        req.add_header("Authorization", f"Bearer {TOKEN}")
    try:
        with urllib.request.urlopen(req) as r:
            raw = r.read()
            return r.status, (json.loads(raw) if raw else None)
    except urllib.error.HTTPError as e:
        raw = e.read()
        try:
            return e.code, json.loads(raw)
        except Exception:
            return e.code, raw.decode()


def check(cond, msg):
    print(("PASS " if cond else "FAIL ") + msg)
    if not cond:
        FAILS.append(msg)


def entries_key(snap):
    """Comparable, order-independent view of a snapshot's per-employee rows."""
    rows = []
    for e in snap["entries"]:
        rows.append((e["funcID"], e["role"], round(e["valor_pool"], 2), round(e["valor_direto"], 2),
                     round(e["valor_teorico"], 2), round(e["valor_pago"], 2), round(e["desconto"], 2)))
    return sorted(rows, key=lambda r: (r[0] is None, r[0] or 0, r[1]))


def payload_from(snap, data, base_pct, staff_filter=lambda e: True, extra_staff=(), presenca_filter=lambda p: True):
    staff = []
    for e in snap["entries"]:
        if e["funcID"] is None or not staff_filter(e):
            continue
        s = {"funcID": e["funcID"], "valor_pool": e["valor_pool"], "valor_direto": e["valor_direto"],
             "valor_pago": e["valor_pago"]}
        if e["desconto"]:
            s["desconto"] = e["desconto"]
        staff.append(s)
    staff.extend(extra_staff)
    presencas = [{"funcID": p["funcID"], "presente": bool(p["presente"])} for p in snap["presencas"] if presenca_filter(p)]
    body = {
        "data": data,
        "faturamento_global": snap["faturamento_inserido"],
        "base_percentual": base_pct,
        "valor_total_gorjetas": snap["valor_total_gorjetas"] or 0,
        "insufficientFundsPolicy": "PARTIAL",
        "staff": staff,
        "presencas": presencas,
    }
    if snap.get("faturamento_com_gorjeta") is not None:
        body["faturamento_com_gorjeta"] = snap["faturamento_com_gorjeta"]
    if snap.get("faturamento_sem_gorjeta") is not None:
        body["faturamento_sem_gorjeta"] = snap["faturamento_sem_gorjeta"]
    return body


def snapshot(rest, data):
    st, body = call("GET", f"/faturamento-diario/snapshot?restID={rest}&data={data}")
    assert st == 200, (st, body)
    return body


def save(rest, body):
    st, res = call("POST", f"/faturamento-diario/snapshot?restID={rest}", body)
    assert st in (200, 201), (st, res)


def ids_for_day(rest, data):
    st, body = call("GET", f"/funcionarios?restID={rest}&data={data}")
    assert st == 200, (st, body)
    return {f["funcID"] for f in body}


# ---------------------------------------------------------------- login
st, body = call("POST", "/auth/login", {"email": os.environ.get("E2E_EMAIL", "verify@local.test"),
                                        "password": os.environ.get("E2E_PASSWORD", "Verify123!")})
assert st in (200, 201), (st, body)
TOKEN = body.get("access_token") or body.get("token") or body.get("accessToken")
assert TOKEN, body
print("logged in")

TODAY = sys.argv[1]           # Lisbon date, e.g. 2026-09-25
TOMORROW = sys.argv[2]

# ================================================================ Scenario 1
# Restaurant 4, day D1 (saved, 39 employees). Employee B=26 is staff with
# pool input, so removing B would change the proportional staff split.
REST, D1, B = 4, "2026-08-02", 26
BASE_PCT = 12.5
base = snapshot(REST, D1)
check(B in {e["funcID"] for e in base["entries"]}, "S1: baseline D1 contains B")
check(B in ids_for_day(REST, D1), "S1: /funcionarios?data=D1 contains B while active")

# Reference re-save under current rules with everyone active (pre-existing behaviour)
save(REST, payload_from(base, D1, BASE_PCT))
ref = snapshot(REST, D1)
check(entries_key(ref) == entries_key(base), "S1: full re-save reproduces stored values (informational)")

# Deactivate B today
st, res = call("PUT", f"/funcionarios/{B}/toggle-active")
check(st == 200 and res["ativo"] is False, "S1: B deactivated")
check(B in ids_for_day(REST, D1), "S1: B still belongs to D1 after deactivation")
check(B in ids_for_day(REST, TODAY), "S1: B still belongs to today (deactivation day, inclusive)")
check(B not in ids_for_day(REST, TOMORROW), "S1: B does not belong to tomorrow")

# Stale client re-saves D1 WITHOUT B (the exact bug path)
save(REST, payload_from(ref, D1, BASE_PCT, staff_filter=lambda e: e["funcID"] != B,
                        presenca_filter=lambda p: p["funcID"] != B))
r1 = snapshot(REST, D1)
check(entries_key(r1) == entries_key(ref), "S1: re-save omitting B leaves every row identical (B kept, nobody recalculated)")
check(any(p["funcID"] == B for p in r1["presencas"]), "S1: B's presence row survived the re-save")

# Day-aware client re-saves D1 WITH B (what the fixed frontend sends)
save(REST, payload_from(ref, D1, BASE_PCT))
r2 = snapshot(REST, D1)
check(entries_key(r2) == entries_key(ref), "S1: re-save including inactive B leaves every row identical")

# Recalculate-with-current-rules path still sees B and its inputs
st, rec = call("GET", f"/faturamento-diario/snapshot/recomputed?restID={REST}&data={D1}")
recB = [e for e in rec["entries"] if e["funcID"] == B]
refB = [e for e in ref["entries"] if e["funcID"] == B][0]
check(st == 200 and recB and round(recB[0]["valor_pool"], 2) == round(refB["valor_pool"], 2),
      "S1: recomputed snapshot keeps B with stored pool input")
check(entries_key(rec) == entries_key(ref), "S1: recomputed snapshot equals stored (rules unchanged)")

# Reactivate B (cleanup for the DB copy) -> B belongs to today, gap semantics tested in S2
st, res = call("PUT", f"/funcionarios/{B}/toggle-active")
check(st == 200 and res["ativo"] is True, "S1: B reactivated")

# ================================================================ Scenario 2
# Restaurant 2, employee E=617 already inactive since 2026-08-02 (backfilled
# period). Day D3=2026-08-05 was saved without E. Reactivating E today must not
# let a re-save (even one that injects E) change D3.
REST2, D3, E = 2, "2026-08-05", 617
g0 = snapshot(REST2, D3)
check(E not in {e["funcID"] for e in g0["entries"]}, "S2: D3 stored without E")
check(E not in ids_for_day(REST2, D3), "S2: E does not belong to D3 (gap day)")
save(REST2, payload_from(g0, D3, BASE_PCT))
gref = snapshot(REST2, D3)

call("PUT", f"/funcionarios/{E}/restore")  # E is soft-deleted in the dump; restore keeps it inactive
st, res = call("PUT", f"/funcionarios/{E}/toggle-active")
check(st == 200 and res["ativo"] is True, "S2: E reactivated today")
check(E in ids_for_day(REST2, TODAY), "S2: E belongs to today after reactivation")
check(E not in ids_for_day(REST2, D3), "S2: E still does not belong to gap day D3")

# Stale/malicious client injects E into D3 with money
save(REST2, payload_from(gref, D3, BASE_PCT,
                         extra_staff=[{"funcID": E, "valor_pool": 100, "valor_direto": 50, "valor_pago": 50}]))
g1 = snapshot(REST2, D3)
check(E not in {e["funcID"] for e in g1["entries"]}, "S2: injected E was ignored on gap day")
check(entries_key(g1) == entries_key(gref), "S2: gap day rows identical after re-save with injected E")
check(not any(p["funcID"] == E for p in g1["presencas"]), "S2: no presence row created for E on gap day")

# ================================================================ Scenario 3
# Soft delete closes the period too; history stays readable.
D = 646  # staff on D1 of restaurant 4
st, res = call("DELETE", f"/funcionarios/{D}")
check(st == 200 and res["deletedAt"] is not None and res["ativo"] is False, "S3: soft delete ok")
check(D in ids_for_day(REST, D1), "S3: deleted employee still belongs to D1")
check(D not in ids_for_day(REST, TOMORROW), "S3: deleted employee does not belong to tomorrow")
save(REST, payload_from(ref, D1, BASE_PCT, staff_filter=lambda e: e["funcID"] != D))
r3 = snapshot(REST, D1)
check(entries_key(r3) == entries_key(ref), "S3: re-save after soft delete leaves D1 identical")
st, res = call("PUT", f"/funcionarios/{D}/restore")
check(st == 200 and res["deletedAt"] is None and res["ativo"] is False, "S3: restore returns inactive")

print()
print("FAILURES:", len(FAILS))
for f in FAILS:
    print(" -", f)
sys.exit(1 if FAILS else 0)
