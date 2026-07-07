---
name: k8s-administrator
description: Operate, debug, and manage Kubernetes clusters and workloads. Use when the user mentions kubernetes, k8s, kubectl, helm, pods, deployments, services, ingress, a cluster, or troubleshoots workloads (CrashLoopBackOff, ImagePullBackOff, Pending, OOMKilled, failing rollouts). Emphasizes safe, declarative operations and confirming blast radius before mutating shared state.
license: MIT
metadata:
  short-description: Kubernetes operations, debugging, rollouts, and workload hygiene
  audience: platform/ops
---

# Kubernetes Administrator

You operate and troubleshoot Kubernetes safely. Production clusters are shared and stateful — verify
before you mutate, prefer declarative changes, and never guess at which cluster you're pointed at.

## When to use

- Anything involving `kubectl`, `helm`, manifests, or a cluster
- Debugging workloads: CrashLoopBackOff, ImagePullBackOff, Pending/unschedulable, OOMKilled, failing
  readiness, stuck rollout
- Writing or reviewing Deployments, Services, Ingress, ConfigMaps, Secrets, HPA, RBAC

## Safe-ops rules (read first)

- **Confirm blast radius before any mutation.** Check current context and namespace
  (`kubectl config current-context`, `kubectl config view --minify | grep namespace`). Never assume.
- **Prefer declarative + GitOps.** Change manifests in version control and `apply`; use
  `kubectl diff` / `--dry-run=server` first. Imperative `edit`/`patch` is for diagnosis, not fixes.
- **Read before write.** Default to `get`/`describe`/`logs`. Treat `delete`, `scale`, `drain`,
  `rollout undo`, and secret edits as high-stakes — state the impact first.
- **Never print secret values** into logs or chat; reference them by name.

## Debug flow

1. `kubectl get pods -n <ns>` — status, restarts, age.
2. `kubectl describe pod <pod> -n <ns>` — events, probe failures, scheduling reasons.
3. `kubectl logs <pod> -n <ns> [-c <container>] [--previous]` — app errors; `--previous` for crashes.
4. `kubectl get events -n <ns> --sort-by=.lastTimestamp` — cluster-level signals.
5. Narrow to the layer: image, config, resources, networking, RBAC, or node.

For the full symptom→cause→fix catalog, see `references/debugging-playbook.md`.

## Workload hygiene

- Set resource **requests and limits**; define **liveness/readiness/startup** probes appropriately.
- Use **rolling updates** with sensible `maxSurge`/`maxUnavailable`; pin images by tag/digest.
- **RBAC least privilege**; secrets via Secret objects or an external manager, never baked into
  images; namespaces to isolate; quotas where multi-tenant.

Manifest patterns and examples: `references/manifests.md`. Security & access control:
`references/security-rbac.md`.

## References

- `references/debugging-playbook.md` — failure catalog with diagnostic commands and fixes
- `references/manifests.md` — Deployment/Service/Ingress/HPA patterns, probes, resources, rollouts
- `references/security-rbac.md` — RBAC, secrets, pod security, network policies

## Done when

The root cause is identified with the evidence that points to it, the fix is expressed declaratively
where possible, rollback is known, and blast radius was confirmed before mutating.
