# Vulnerability triage and remediation

Not all findings are equal. Triage turns a pile of issues into an ordered action list.

## Rate by impact × likelihood

Score each finding on two axes:

- **Impact** — what an attacker gains: full compromise / data breach (High) → limited data or
  single-user effect (Medium) → negligible (Low).
- **Likelihood** — how reachable and easy: unauthenticated & remote & trivial (High) → needs
  privileged access or unusual conditions (Low).

```
              Impact
            Low   Med   High
Likelihood
High         M     H    Crit
Med          L     M     H
Low          L     L     M
```

For a standardized score, use **CVSS**; but always sanity-check it against real reachability in
*this* system — a "critical" CVE in an unreachable code path may be a low priority, and a "medium"
on an internet-facing auth endpoint may be your top fix.

## Establish reachability

The most important triage question: **can an attacker actually reach this, and what do they need?**
Trace the path from an entry point to the vulnerable code. A finding with no reachable path is
lower priority than its raw severity suggests — say so, with the reasoning.

## Prioritize

1. Reachable + high impact → fix now (and consider whether it's been exploited).
2. High impact but hard to reach, or easy to reach but low impact → schedule.
3. Low/low → backlog or accept with documented rationale.

Factor in exposure (internet-facing vs internal), whether it's actively exploited in the wild, and
the presence of compensating controls.

## Remediate

- Prescribe the **smallest effective fix** and where it goes. Prefer fixing the root cause over
  papering the symptom.
- Give a concrete direction: "parameterize this query", "add a server-side ownership check here",
  "upgrade lib X to ≥ y.z".
- Note **compensating controls** if a full fix takes time (WAF rule, rate limit, feature flag off).
- Add a **regression test** or detection so the issue can't silently return.

## Report

Per finding: severity (and score), a one-line description, the concrete impact, the reachability/
path, the remediation, and the location. Lead with the ones that must be fixed now.
