# Dashboards and debugging from telemetry

Dashboards and telemetry earn their keep during an incident. Design them for the on-call engineer at
3am, and know the method for going from alert to root cause.

## Dashboard design

- **Design for a question, not for completeness.** A dashboard nobody can read under pressure is
  worse than none. Each dashboard should answer "is this service healthy?" or "where is the
  problem?" — not show every metric that exists.
- **Top-down layout**: user-facing SLIs (RED: rate, errors, latency) at the top; dependencies and
  resources (USE) below; drill-downs last. The eye should hit "are users hurting?" first.
- **Consistent structure across services** so responders don't relearn each one.
- **Annotate** deploys, config changes, and incidents on the timeline — correlation with "what
  changed" is the fastest path to cause.
- **Percentiles, not averages**, for latency (p50/p95/p99) — averages hide the tail users feel.
- **Every panel should prompt an action or answer a question.** Delete decoration.

## The debugging method (alert → cause)

1. **Confirm the symptom.** Which SLI is breaching, since when, how bad, who's affected? Start at the
   user-facing metrics.
2. **Localize with RED/USE.** Which service/endpoint shows the error or latency? Is a resource
   saturated (USE) on the suspect service?
3. **Correlate with change.** What deployed or changed at the onset time? Roll back first if a
   deploy lines up — restore service, investigate after.
4. **Pivot to traces.** Open exemplar traces from the bad time window; find the span where time is
   spent or the error originates — that localizes the failing dependency/operation.
5. **Pivot to logs.** Using the trace/request ID from the failing span, read the exact error and
   context.
6. **Confirm root cause**, apply the fix, and **verify the SLI recovers** on the dashboard.

## The four golden signals (quick reference)

For any user-facing service, watch: **Latency**, **Traffic**, **Errors**, **Saturation**. If you
track only four things, track these — they cover most incidents.

## After the incident

Capture what the telemetry showed and what it *couldn't* show. Every incident is feedback on your
observability: add the missing metric, log field, or trace attribute that would have made this
faster next time. Feed the resolution steps into a runbook (see the `tech-writer` skill).
