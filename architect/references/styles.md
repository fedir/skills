# Selecting styles, storage, and communication

Match the option to the problem's real constraints — not to fashion. Below are the common choices
with when-each-fits and their trade-offs.

## Architecture styles

| Style | Fits when | Cost / trade-off |
|-------|-----------|------------------|
| **Modular monolith** | Most systems, early stage, one team, unknown boundaries | Single deploy & DB; must enforce module boundaries in code, or it rots into a big ball of mud |
| **Microservices** | Independent scaling/deploy needs, multiple teams needing autonomy, clear stable boundaries | Distributed-systems tax: network failure, data consistency, observability, deployment complexity |
| **Event-driven / async** | Decoupling producers & consumers, spiky load, workflows, audit/replay | Eventual consistency, harder debugging, need idempotency & ordering handling |
| **Serverless / FaaS** | Spiky or low baseline load, event glue, minimal ops | Cold starts, vendor lock-in, per-request cost at scale, local-dev friction |

Default: **start with a modular monolith**; extract a service only when a concrete pressure
(independent scale, independent deploy cadence, team ownership, fault isolation) justifies the
distributed-systems tax.

## Data store selection

Ask access patterns, consistency, and scale *first*, then pick:

- **Relational (Postgres/MySQL)** — default. Strong consistency, transactions, flexible queries,
  relational integrity. Reach for it unless you have a specific reason not to.
- **Document (Mongo, DynamoDB)** — flexible/denormalized schema, known key-based access patterns,
  horizontal scale. Weak at ad-hoc cross-entity queries.
- **Key-value / cache (Redis)** — hot reads, sessions, rate limiting, ephemeral state. Not a system
  of record.
- **Search (Elastic/OpenSearch)** — full-text and faceted search; a secondary index, not the source
  of truth.
- **Wide-column / time-series (Cassandra, Timescale, ClickHouse)** — very high write volume, append-
  heavy, analytical or time-series workloads.
- **Queue/log (Kafka, SQS)** — decoupling, buffering, event streams, replay.

Rules of thumb: **one source of truth per piece of data**; add specialized stores as *derived*
indexes, not competing masters. Polyglot persistence is powerful but each store is an operational
burden — justify each one.

## API / communication style

- **REST/HTTP+JSON** — default for external and cross-team APIs; ubiquitous, cacheable, simple.
- **gRPC** — internal service-to-service where performance and typed contracts matter; streaming.
- **GraphQL** — many clients with divergent data needs, aggregation over several sources; adds
  server complexity and caching challenges.
- **Sync (request/response)** — when the caller needs the result now and can wait.
- **Async (queue/event)** — when work can be deferred, load is spiky, or you want to decouple
  availability of producer and consumer. Requires idempotency and retry/dead-letter handling.

Prefer **sync for reads that gate a user action**, **async for writes/side-effects that can be
processed independently**.
