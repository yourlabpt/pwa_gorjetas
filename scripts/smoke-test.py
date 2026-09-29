#!/usr/bin/env python3
"""Read-only smoke test of a running stack (used by scripts/sandbox-test.sh).

Checks that the frontend and API answer, login works, and that stored daily
finance read through the API matches the database exactly (row count and sum
of valor_pago per restaurant), so a release cannot silently change history.

Usage:
  smoke-test.py --api URL --web URL --email E --password P --expected FILE
The --expected file is JSON produced from the database by the sandbox script:
  [{"restID": 4, "from": "2026-06-11", "to": "2026-08-10", "rows": 123, "sum_pago": "4567.89"}, ...]
"""
import argparse
import json
import sys
import urllib.error
import urllib.parse
import urllib.request
from decimal import Decimal

FAILS = []


def check(ok, msg):
    print(("PASS " if ok else "FAIL ") + msg)
    if not ok:
        FAILS.append(msg)


def request(url, token=None, body=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method="POST" if body is not None else "GET")
    req.add_header("Content-Type", "application/json")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    try:
        with urllib.request.urlopen(req, timeout=120) as r:
            raw = r.read()
            try:
                return r.status, json.loads(raw) if raw else None
            except ValueError:
                return r.status, raw
    except urllib.error.HTTPError as e:
        return e.code, None
    except Exception as e:  # connection refused, timeout
        return 0, str(e)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--api", required=True)
    ap.add_argument("--web", required=True)
    ap.add_argument("--email", required=True)
    ap.add_argument("--password", required=True)
    ap.add_argument("--expected", required=True)
    a = ap.parse_args()
    api = a.api.rstrip("/")

    for path in ("/", "/login", "/financeiro-diario"):
        st, _ = request(a.web.rstrip("/") + path)
        check(st == 200, f"frontend {path} -> {st}")

    st, _ = request(api + "/auth/me")
    check(st == 401, f"API protects /auth/me without login -> {st}")

    st, body = request(api + "/auth/login", body={"email": a.email, "password": a.password})
    token = (body or {}).get("accessToken") if isinstance(body, dict) else None
    check(st in (200, 201) and bool(token), f"login as sandbox super admin -> {st}")
    if not token:
        return finish()

    st, rests = request(api + "/restaurantes", token)
    check(st == 200 and isinstance(rests, list) and len(rests) > 0, f"GET /restaurantes -> {st}, {len(rests or [])} restaurants")

    expected = json.load(open(a.expected))
    for exp in expected:
        rid = exp["restID"]
        for path in (f"/funcionarios?restID={rid}", f"/regras-distribuicao?restID={rid}", f"/acerto-final/list?restID={rid}"):
            st, _ = request(api + path, token)
            check(st == 200, f"GET {path} -> {st}")

        q = urllib.parse.urlencode({"restID": rid, "from": exp["from"], "to": exp["to"]})
        st, days = request(f"{api}/faturamento-diario/snapshot/range?{q}", token)
        ok = st == 200 and isinstance(days, list)
        check(ok, f"GET snapshot/range restID={rid} {exp['from']}..{exp['to']} -> {st}")
        if not ok:
            continue
        rows = sum(len(d.get("entries") or []) for d in days)
        total = sum(Decimal(str(e.get("valor_pago") or 0)) for d in days for e in (d.get("entries") or []))
        exp_total = Decimal(exp["sum_pago"])
        check(rows == exp["rows"], f"restID={rid}: API returns {rows} stored rows, database has {exp['rows']}")
        check(abs(total - exp_total) < Decimal("0.01"), f"restID={rid}: API sum valor_pago {total:.2f} equals database {exp_total:.2f}")

    return finish()


def finish():
    print(f"\nSMOKE FAILURES: {len(FAILS)}")
    for f in FAILS:
        print(" -", f)
    return 1 if FAILS else 0


if __name__ == "__main__":
    sys.exit(main())
