# Review checklist

Work the passes in order — correctness first, because a beautifully-styled wrong answer is still
wrong. Not every item applies to every diff; use judgment.

## Correctness (highest priority)

- [ ] Logic does what the PR intends; no off-by-one, inverted condition, or wrong operator.
- [ ] Edge cases: empty/zero/one/many, null/None/missing, boundary values, large input, unicode.
- [ ] Error paths handled — failures caught, propagated, or surfaced correctly; no silent swallow.
- [ ] Concurrency: shared mutable state guarded; no data races, deadlocks, or check-then-act bugs.
- [ ] Resource handling: files/connections/locks released on all paths; no leaks.
- [ ] Assumptions about inputs/state are validated, not trusted.
- [ ] Tests exist, actually exercise the new behavior and its edge/error cases, and would fail
      without the change.

## Security

- [ ] Input validated at trust boundaries; output encoded for its sink (SQL, HTML, shell, path).
- [ ] No injection: parameterized queries, no string-built commands.
- [ ] AuthZ/AuthN enforced server-side on every sensitive action.
- [ ] No secrets in code, logs, or fixtures; sensitive data not leaked in errors/logs.
- [ ] Dependencies added are necessary, reputable, and not known-vulnerable.
- (For depth, defer to the `security-engineer` skill.)

## Reuse & simplification

- [ ] No duplicated logic or reinvented existing utilities.
- [ ] No dead code, commented-out blocks, or debug leftovers.
- [ ] Complexity is justified; simpler equivalent isn't available.
- [ ] Functions/modules are cohesive and reasonably sized; names reveal intent.

## Consistency & maintainability

- [ ] Matches project style, naming, and patterns; nothing introduces a foreign idiom.
- [ ] Public behavior/API changes are documented; comments explain *why*, not *what*.
- [ ] Docs/README/changelog updated if behavior changed.
- [ ] No unrelated changes bundled into the diff.

## Performance (when relevant)

- [ ] No obvious N+1 queries, needless allocations in hot paths, or accidental O(n²).
- [ ] Appropriate use of caching/pagination/streaming for large data. Don't micro-optimize cold
      paths.
