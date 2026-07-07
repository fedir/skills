# Making and defending architecture decisions

## Reversibility: the first question

Before agonizing over an option, classify the decision:

- **One-way door (Type 1)** — expensive or near-impossible to reverse: data model & schema
  semantics, public API contracts, the primary language/runtime, splitting a system into services,
  choice of database engine, event schemas other teams consume. Spend real scrutiny here; prefer the
  most flexible option that meets the need.
- **Two-way door (Type 2)** — cheap to change later: internal module layout, a library choice behind
  an interface, caching strategy, most config. Decide fast, move on, revisit if it hurts.

Always label which kind you're deciding. Teams waste time debating Type 2 decisions as if they were
Type 1, and rush Type 1 decisions as if they were Type 2.

## Structured trade-off analysis

For a contested choice, don't argue vibes — make a matrix.

1. **List the options** (2–4; more is usually noise).
2. **List the criteria that matter for *this* problem** — e.g. latency, operational cost, team
   familiarity, time-to-ship, scalability ceiling, failure blast radius, vendor lock-in.
3. **Weight the criteria** by how much they matter here (not in general).
4. **Score each option** per criterion, and — more importantly — **write the reasoning**, not just
   the number.

```
Criterion (weight)      | Option A            | Option B
------------------------|---------------------|---------------------
Time to ship (H)        | fast, known stack   | slow, new tooling
Ops burden (H)          | one deploy          | N services to run
Scale ceiling (M)       | vertical only       | horizontal
Failure isolation (M)   | shared fate         | isolated
Team familiarity (H)    | high                | low
```

The matrix is a thinking tool, not an oracle. The written reasoning per cell is the deliverable.

## Choosing well

- **Optimize explicitly.** State the one or two things you're optimizing for (e.g. time-to-first-
  release, or p99 latency) and accept that other axes suffer.
- **Prefer boring, proven technology** for load-bearing parts. Spend your "innovation budget" on the
  1–2 places it's a differentiator, not everywhere.
- **Beware résumé-driven and hype-driven design.** The question is fit to *this* problem and team.
- **Quantify when you can.** "10k RPS, 200GB, growing 2×/yr" kills more bad debates than any
  principle. If numbers are unknown, say what you assumed.
- **Name the sacrifice.** Every recommendation gives something up. If you can't name what you're
  sacrificing, you haven't understood the trade-off yet.

## Common false choices

- "Monolith vs microservices" is usually **modular monolith first, extract services when a real
  scaling or team-autonomy boundary demands it.** See `styles.md`.
- "SQL vs NoSQL" is really "what are my access patterns, consistency needs, and scale?" See
  `styles.md`.
- "Build vs buy" — buy the undifferentiated heavy lifting; build only your differentiator.
