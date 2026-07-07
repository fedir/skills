# Testing your change

Tests are part of the change, not an afterthought. They prove the behavior and lock it against
regression.

## What to test

- **The behavior you added/changed** — the happy path, expressed as the user/caller sees it.
- **Edge cases**: empty/zero/one/many, boundaries, null/None/missing, invalid input, large input.
- **Error paths**: the code should fail the way you intend — assert on it.
- **The bug you fixed**: add a test that fails before the fix and passes after (regression test).

Don't chase coverage numbers; cover behavior and risk. Untested error handling is where bugs hide.

## How to test well

- **Follow the project's conventions** — same framework, layout, naming, and fixtures as existing
  tests. A test that looks foreign is as bad as foreign code.
- **One reason to fail per test.** Clear name that states the expectation.
- **Arrange–Act–Assert**: set up, do the thing, assert the outcome.
- **Deterministic**: no reliance on wall-clock, network, ordering, or shared mutable state. Control
  time/randomness via injection.
- **Test behavior, not implementation** — assert observable outcomes, so refactors don't break tests.

## Test doubles — use the lightest that works

- **Prefer real objects** when cheap and deterministic.
- **Fakes** (in-memory implementations) for things like repositories.
- **Stubs** to supply canned inputs; **mocks** to assert an interaction happened (use sparingly —
  over-mocking couples tests to implementation).
- Mock at architectural boundaries (network, clock, filesystem), not internal collaborators.

## When it's enough

Enough is when the important behaviors and failure modes are covered, the tests are deterministic,
and a future reader can see what the code is supposed to do from the tests alone. Then run the full
suite and confirm green before handing back.
