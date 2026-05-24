---
name: client-backend-logic-guard
description: 'Use when requests involve backend changes and business rules. Reframes tasks from client value, maps impacted backend logic, validates invariants, and prevents logic mistakes before implementation.'
argument-hint: 'Feature or bug request + target module (optional)'
user-invocable: true
---

# Client-Backend Logic Guard

Analyze and execute backend work from the client perspective first, then enforce logic-safety checks before coding.

## When to Use
- New feature or bug fix requests that change business behavior
- API, service, calculation, payout, distribution, reporting, or financial logic updates
- Requests that span multiple backend modules or require schema/domain understanding
- Any task where a wrong assumption can create business-impacting logic errors

## Inputs
Provide:
- Request summary in natural language
- Affected module(s) if known
- Expected client outcome (what success looks like to the user/business)

## Procedure
1. Define client outcome first.
   - Rewrite the request as client value and expected behavior.
   - Identify who is impacted (restaurant owner, manager, employee, finance/admin).
   - State observable acceptance behavior in plain language.

2. Map backend logic surface.
   - Identify affected entities, services, controllers, repositories, jobs, and calculations.
   - Trace the current flow: input -> validation -> business rule -> persistence -> response.
   - List upstream/downstream dependencies and side effects.

3. Extract invariants and non-negotiable rules.
   - Data invariants (required fields, valid states, uniqueness, date/period constraints).
   - Financial invariants ($sum(parts)=total$, no double counting, rounding consistency).
   - Authorization invariants (tenant/restaurant scope, role boundaries).
   - Temporal invariants (period closure, transaction ordering, idempotency).

4. Branch by request type.
   - If bug fix: reproduce current behavior, identify failing invariant, propose minimal safe correction.
   - If feature: define target behavior delta and migration/backward-compatibility needs.
   - If refactor: prove behavior preservation with explicit before/after checks.

5. Build a logic safety checklist before coding.
   - What assumptions are being made?
   - Which assumptions are verified in code/docs/tests, and which are not?
   - What can break in edge cases (empty data, partial periods, deleted users, timezone boundaries)?
   - What is the rollback or mitigation path if behavior is wrong?

6. Implement with guardrails.
   - Apply the smallest change that satisfies the behavior delta.
   - Add/adjust validations close to boundaries.
   - Prefer explicit names and small pure functions for sensitive calculations.
   - Preserve existing API contracts unless change is intentional and documented.

7. Validate with evidence.
   - Add or update tests for happy path, boundary cases, and one failure path.
   - Verify invariants with concrete examples and expected outputs.
   - Summarize why the new behavior matches client outcome.

8. Report confidence and residual risks.
   - Confidence level: high/medium/low.
   - Residual risks and monitoring points.
   - Follow-up checks for production safety.

## Decision Points
- Scope unclear: pause implementation and ask targeted questions before changing logic.
- Multiple valid business interpretations: present options with trade-offs and request decision.
- High financial impact: require explicit invariant checklist and scenario testing.
- Cross-module impact: stage changes and validate each stage separately.

## Quality Criteria (Definition of Done)
- Client outcome is explicitly stated and mapped to backend behavior.
- Impacted backend components and data flow are documented.
- Invariants are listed and validated against the proposed change.
- Tests cover at least: happy path, boundary condition, and failure/guard path.
- No unintended contract breakage (or breaking change is documented and approved).
- Final summary includes rationale, risks, and verification evidence.

## Output Format
Return in this order:
1. Client Perspective Summary
2. Backend Logic Map
3. Invariants Checklist
4. Proposed Change (minimal safe delta)
5. Validation Evidence
6. Risks and Next Checks

## Example Prompts
- /client-backend-logic-guard "Fix payout discrepancy when transactions are edited after period close"
- /client-backend-logic-guard "Add support for role-based distribution weights by restaurant"
- /client-backend-logic-guard "Refactor daily revenue aggregation without changing final totals"