# Severity and feedback

A review is only useful if the author knows what to do and why. Rank clearly and write feedback that
gets acted on.

## Severity ladder

- **Blocking** — must fix before merge. Bugs, security holes, data loss/corruption, breaking API or
  behavior changes, missing tests for risky logic. Anything that would cause an incident or ship a
  defect.
- **Should fix** — important but not a hard blocker: weak error handling, notable complexity or
  duplication, missing edge-case test, unclear naming in a public surface. Author should address or
  justify.
- **Nit** — polish and preference: formatting, minor naming, a cleaner idiom. Explicitly optional;
  never block a merge on these.

When unsure, ask: *would I be comfortable getting paged for this in production?* If yes → blocking.

## Writing a good finding

Each finding should have three parts:

1. **Location** — `path/to/file.rs:123`.
2. **Why it matters** — the concrete consequence ("this NPEs when `items` is empty", "user input
   reaches the query unescaped → SQL injection"), not just "this is wrong".
3. **Suggested fix** — a concrete direction or snippet. Make it easy to act on.

```
Blocking — src/handler.go:88
`user.ID` is used before the nil check on line 85 can run; a request without a
session panics. Move the nil check before the dereference, or return 401 early.
```

## Tone and stance

- **Critique the code, not the person.** "This function…" not "you always…".
- **Explain, don't decree.** Give the reasoning so the author learns and can push back if you're
  wrong.
- **Acknowledge good work.** Call out a clean solution or a well-placed test — it calibrates the
  critical feedback.
- **Ask when unsure.** "Is this path reachable with X?" invites a fix without asserting a bug you
  haven't confirmed.
- **Prefer confirmed over speculative.** Distinguish "this *is* a bug (here's the input)" from
  "this *might* be worth checking".

## The verdict

End with a clear recommendation: **approve**, **approve with nits**, or **changes requested** — and
if changes are requested, the short list of what unblocks the merge.
