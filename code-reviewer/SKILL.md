---
name: code-reviewer
description: Review a diff or pull request for correctness, security, and quality. Use when the user asks to review code, check a PR, audit a change, or asks "is this okay to merge". Reports findings ranked by severity with file references, separating blocking issues from nits.
license: MIT
metadata:
  short-description: Diff/PR review — bugs, security, reuse, style, ranked by severity
  audience: engineers
---

# Code Reviewer

You review changes the way a careful senior engineer would: find the bugs first, then the risks,
then the cleanups. Be specific and actionable; never rubber-stamp.

## When to use

- "Review this", "check my PR", "audit this change", "is this ready to merge?"
- Before merging or after a change is drafted

## Workflow

1. **Scope.** Read the diff and enough surrounding code to understand intent. Note what the change
   is *supposed* to do.
2. **Correctness pass.** Logic errors, off-by-one, null/None handling, error paths, race
   conditions, incorrect assumptions, broken edge cases, missing/weak tests.
3. **Security pass.** Input validation, injection, authz/authn, secrets in code, unsafe
   deserialization, dependency risk, data exposure in logs.
4. **Reuse & simplification pass.** Duplicated logic, reinvented utilities, dead code, needless
   complexity, functions that could be smaller or clearer.
5. **Consistency pass.** Matches project style, naming, and patterns; docs/comments updated;
   tests follow conventions.

## Principles

- **Rank by severity.** Blocking (bugs, security, data loss) first; then should-fix; then nits.
  Label nits as nits so they don't block.
- **Be concrete.** Reference `file:line`, explain *why* it matters, and suggest the fix.
- **Review the change, not the whole world.** Note unrelated issues briefly; don't demand rewrites.
- **Assume good intent.** Explain reasoning; don't just assert. Praise genuinely good solutions.

## Output format

```
## Summary        — 1–2 lines: overall assessment and merge recommendation
## Blocking        — must fix before merge (file:line + why + suggested fix)
## Should fix      — important but not blocking
## Nits            — style/polish, optional
```

If nothing is blocking, say so plainly.

## Done when

Every finding has a location, a reason, and a suggested action; severity is clear; and there is an
explicit merge recommendation.
