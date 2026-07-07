# Architecture Decision Records (ADRs)

An ADR captures **one** significant decision, the forces behind it, and its consequences, so a
future reader who wasn't in the room understands *what* was decided and *why*. The rejected options
and their reasons are the most valuable part.

## Template

```markdown
# ADR-NNN: <decision stated as an outcome, e.g. "Use Postgres for the ledger">

## Status
Proposed | Accepted | Superseded by ADR-MMM

## Context
The problem and the forces at play: requirements, constraints, and the
non-functional needs (scale, latency, consistency, team, deadline) that drive
the decision. State assumptions and any numbers.

## Options considered
- **Option A** — one-line sketch. Trade-offs: …
- **Option B** — one-line sketch. Trade-offs: …
- (2–4 options; include the "do nothing" option when relevant.)

## Decision
The chosen option and the reasoning. What we optimize for and what we sacrifice.
Call out which parts are one-way-door decisions.

## Consequences
- What this makes easy.
- What this makes hard / what we give up.
- Follow-ups, risks, and what would make us revisit this.
```

## Practices

- **One decision per ADR.** If you're using "and", you probably have two ADRs.
- **Immutable once accepted.** Don't rewrite history — supersede with a new ADR that links back.
- **Number them** (`ADR-001`, `ADR-002`) and keep them in the repo (e.g. `docs/adr/`).
- **Record the rejected options and why.** "We chose X" is far less useful than "we chose X over Y
  because Z, accepting trade-off W".
- **Write it when the decision is made**, while the reasoning is fresh — not months later.

## Worked example (compact)

```markdown
# ADR-007: Process payments asynchronously via an outbox + queue

## Status
Accepted

## Context
Checkout must stay responsive (<300ms p99). Payment provider calls are 1–5s and
occasionally fail. We need exactly-once effect on the customer's card and an audit trail.

## Options considered
- **Synchronous call in the request** — simplest, but ties checkout latency and
  availability to the provider; retries are unsafe inline.
- **Outbox table + async worker + queue** — decouples checkout from the provider;
  enables safe retries and audit; adds eventual consistency and a worker to operate.
- **Direct fire-and-forget to queue** — loses atomicity between order write and event.

## Decision
Write the order and an outbox row in one transaction; a worker publishes to the queue
and calls the provider with an idempotency key. Two-way door for the worker internals;
the idempotency-key contract with the provider is a one-way door.

## Consequences
- Easy: checkout stays fast; retries are safe; full audit trail; provider outages don't
  block checkout.
- Hard: payment status is eventually consistent — UI must show "processing"; we now
  operate a worker and a queue, and must monitor the outbox lag.
```
