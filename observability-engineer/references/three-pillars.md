# The three pillars: logs, metrics, traces

Each answers a different question. Used together — and correlated — they let you go from "something
is wrong" to "here is the exact cause". Tool-agnostic; maps onto OpenTelemetry, Prometheus/Grafana,
Loki, Jaeger/Tempo, ELK, Datadog, etc.

## Metrics — "is something wrong, and how much?"

Numeric, aggregatable time series. Cheap to store, fast to query, ideal for alerting and trends.

- **Types**: counter (monotonic — requests, errors), gauge (point-in-time — queue depth, memory),
  histogram (distributions — latency; enables percentiles p50/p95/p99).
- **RED** (request-driven services): **R**ate, **E**rrors, **D**uration — per endpoint/service.
- **USE** (resources): **U**tilization, **S**aturation, **E**rrors — per CPU, memory, disk, pool.
- **Cardinality is the trap**: each unique label combination is a separate series. Never put
  unbounded values (user ID, request ID, full URL, email) in metric labels — it explodes storage
  and cost. Keep labels to bounded dimensions (route template, status class, region).

## Logs — "what exactly happened for this event?"

Discrete, timestamped records of events. Highest detail, highest volume/cost.

- **Structured** (JSON/key-value), not free text — so you can filter and aggregate. One event per
  meaningful action with fields: timestamp, level, message, and context (trace/request ID, user,
  resource, outcome, duration).
- **Levels used consistently**: ERROR (needs attention), WARN (unexpected but handled), INFO
  (notable state changes), DEBUG (diagnostic, usually off in prod).
- **Never log secrets or PII.** Redact tokens, passwords, card numbers, personal data.
- Control cost: sample high-volume debug logs; don't log the same thing at every layer.

## Traces — "where in the request did time go / did it fail?"

A trace follows one request across services as a tree of spans (each span = one operation with
start/end and attributes).

- **Propagate context** (trace ID + span ID) across every service boundary — HTTP headers, message
  metadata — so one user request is one trace, not N disconnected fragments.
- **Instrument the boundaries**: inbound handler, outbound calls, DB queries, cache, queue
  publish/consume. Add attributes (route, status, key IDs) to spans.
- Traces show the **critical path** and which dependency is slow or failing — the thing metrics
  alone can't localize.
- **Sample** intelligently (head or tail sampling) to control volume while keeping the interesting
  (slow/errored) traces.

## Correlation — the multiplier

The pillars are far more valuable together. Thread a **trace/request ID** through all three:

- From a metric spike → jump to exemplar traces at that time.
- From a trace's failing span → jump to the logs for that span's trace ID.
- From an error log → open the full trace to see the request's path.

Design for this from the start: a shared ID in logs, exemplars on histograms, and consistent
attribute names. **OpenTelemetry** gives you one vendor-neutral way to emit all three with shared
context — prefer it for portability.
