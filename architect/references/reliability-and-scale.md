# Reliability and scale

Design for failure and growth explicitly. For every dependency and every hot path, state what
happens when load rises and when things break.

## Failure modes — ask these for each dependency

- What happens when it is **slow** (latency spike)? Do callers pile up and exhaust threads/
  connections?
- What happens when it is **down**? Does the whole request fail, or degrade gracefully?
- What happens when it returns **wrong/partial data**? Is it validated?
- What is the **blast radius** — one user, one feature, or the whole system?

Good architecture makes failures **partial and contained**, not total.

## Resilience patterns

- **Timeouts** — every network call has one. Unbounded waits are the #1 cause of cascading failure.
- **Retries with backoff + jitter** — only for idempotent operations; cap attempts; never retry a
  non-idempotent write blindly.
- **Circuit breaker** — stop hammering a failing dependency; fail fast and recover.
- **Bulkheads** — isolate resource pools so one slow dependency can't starve everything.
- **Idempotency** — make writes safe to repeat (idempotency keys) so retries and redeliveries don't
  double-charge/double-send.
- **Graceful degradation** — serve stale cache, a reduced feature, or a clear error rather than
  hanging or 500ing.
- **Backpressure & load shedding** — bound queues; shed or throttle rather than collapse under
  overload.

## Scaling axes

Scale the axis that's actually constrained; measure before you shard.

- **Vertical** (bigger box) — simplest; do this first. Has a ceiling.
- **Horizontal** (more instances) — requires stateless services (push state to a store/cache) and a
  load balancer.
- **Read scaling** — caching (with an invalidation strategy), read replicas, CDNs.
- **Write scaling** — batching, async processing, partitioning/sharding by a key. Sharding is a
  one-way door — delay it until the numbers force it.
- **Data scaling** — partitioning, archival/tiering of cold data, appropriate indexes.

Attack the bottleneck with data, not guesses: know your p50/p99 latency, throughput, and the
resource that saturates first.

## Consistency and CAP

- In a partition, you choose **availability** or **consistency** — decide per data type, not
  globally. Money/inventory usually need strong consistency; feeds/counts often tolerate eventual.
- **Strong consistency** — simpler to reason about; costs latency and availability.
- **Eventual consistency** — higher availability and scale; the app must tolerate stale reads and
  reconcile. Make this a conscious, documented choice, not an accident.
- Prefer **idempotent, event-sourced, or reconcilable** designs where eventual consistency is
  unavoidable.

## Operability (don't design a system you can't run)

Bake in observability from the start: structured logs, metrics (RED/USE), traces, health checks,
and clear failure signals. A design you cannot observe is a design you cannot operate.
