# Infrastructure-as-code and release strategies

## Reviewing infrastructure-as-code (Terraform et al.)

- **State** managed remotely and locked (e.g. remote backend); never commit state files — they can
  contain secrets. One state per environment; avoid a giant shared state.
- **Plan before apply** — every change goes through a reviewed `plan`; apply only what the plan
  showed. Wire `plan` into CI on PRs.
- **No secrets in code or state** — source them from a secret manager; mark sensitive outputs.
- **Modules over copy-paste** — reuse modules; parameterize per environment with variables/
  workspaces, not forked copies.
- **Least-privilege IAM** — the roles the change creates should grant the minimum needed.
- **Tag resources** (owner, env, cost-center) for accountability and cost tracking.
- **Reversibility** — the change is reversible or has a documented rollback; beware operations that
  destroy-and-recreate stateful resources (databases, volumes) — check the plan for `-/+`.
- **Drift** — detect and reconcile drift; the code is the source of truth, not console edits.

## Release strategies

Choose per risk and the cost of a bad release:

| Strategy | How | Fits when | Cost |
|----------|-----|-----------|------|
| **Rolling** | Replace instances gradually | Default; stateless services with good health checks | Brief mixed-version window |
| **Blue/green** | Stand up new version alongside, switch traffic, keep old warm | Need instant rollback, DB-compatible changes | Double the resources during cutover |
| **Canary** | Route a small % to the new version, watch metrics, ramp up | High-risk changes, large user base | Needs good metrics + automation |

For every strategy define:

- **Health checks / smoke tests** that gate promotion.
- **Automatic rollback triggers** — error-rate/latency thresholds that revert without a human.
- **How you verify success** — the concrete signals that say "this release is good".
- **Backward/forward compatibility** — especially for schema and API changes; use expand/contract so
  old and new versions coexist during rollout (see the `architect` skill).

Keep deploys **boring and repeatable**: the same automated path every time, practiced rollback, no
manual ssh-and-fix.
