# SLOs, error budgets, and alerting

Good alerting wakes someone only when users are being hurt, and gives them a reason to act. That
requires defining what "good" means (SLOs) and alerting on its violation (symptoms).

## SLIs and SLOs

- **SLI (indicator)** — a measured ratio of good events to total: successful requests / all
  requests, or requests faster than 300ms / all requests. Measure it as close to the user as
  possible (at the edge, not deep internals).
- **SLO (objective)** — the target for an SLI over a window: "99.9% of requests succeed over 30
  days". Set it from what users actually need, not 100% (which is impossible and not worth the cost).
- **Error budget** — `100% − SLO`. At 99.9% you may "spend" 0.1% on failures. The budget turns
  reliability into a number you can manage: budget remaining → ship features; budget exhausted →
  stop and stabilize.

Pick a few SLOs on the **key user journeys** (availability + latency); don't SLO everything.

## Alert on symptoms, not causes

- **Page on SLO burn** — user-facing errors and latency — because that's what actually matters.
  A saturated CPU that isn't hurting users is not a page.
- **Cause-based signals** (CPU, memory, disk, queue depth) belong on **dashboards** and as
  **warnings/tickets**, not pages. They help diagnose once a symptom fires.
- **Every page must be actionable and urgent.** If there's nothing to do, or it can wait until
  morning, it's not a page.

## Burn-rate alerting

Alert on how fast you're consuming the error budget, using **multi-window, multi-burn-rate** alerts:

- **Fast burn** (e.g. 14× rate over 1h) → page: a major incident is eating the budget quickly.
- **Slow burn** (e.g. 2× over 6h) → ticket/warning: a persistent low-grade problem.

This catches both sudden outages and slow degradations while avoiding alerts on brief, harmless
blips.

## Killing alert noise

Alert fatigue is a reliability risk — ignored alerts hide real ones. Fix noise:

- Delete alerts that never lead to action. If it's been snoozed 10 times, it's not an alert.
- Alert on **sustained** breaches (for-duration), not single scrapes.
- **Group and deduplicate** related alerts into one incident; suppress downstream alerts when an
  upstream cause is already firing.
- Route by severity: page only for urgent+actionable; everything else to tickets/channels.
- Attach a **runbook link** to every alert (see the `tech-writer` skill for runbook format).

## Checklist

- [ ] SLIs measured close to the user on the key journeys
- [ ] SLOs set from user need, with error budgets
- [ ] Pages fire on user-facing symptoms (SLO burn), not raw resource causes
- [ ] Multi-window burn-rate alerts for fast and slow burn
- [ ] Every alert is actionable and links a runbook
- [ ] Noisy/never-actioned alerts removed
