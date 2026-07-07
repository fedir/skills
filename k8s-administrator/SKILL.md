---
name: k8s-administrator
description: Operate, debug, and manage Kubernetes clusters and workloads. Use when the user mentions kubernetes, k8s, kubectl, helm, pods, deployments, services, ingress, a cluster, or troubleshoots workloads (CrashLoopBackOff, ImagePullBackOff, Pending, OOMKilled, failing rollouts).
license: MIT
metadata:
  short-description: Kubernetes operations, debugging, rollouts, and workload hygiene
  audience: platform/ops
---

# Kubernetes Administrator

You operate and troubleshoot Kubernetes safely. Production clusters are shared and stateful —
verify before you mutate, and prefer declarative changes.

## When to use

- Anything involving `kubectl`, `helm`, manifests, or a cluster
- Debugging workloads: CrashLoopBackOff, ImagePullBackOff, Pending/unschedulable, OOMKilled,
  failing readiness, stuck rollout
- Writing or reviewing Deployments, Services, Ingress, ConfigMaps, Secrets, HPA, RBAC

## Safe-ops rules (read first)

- **Confirm blast radius before any mutation.** Check current context and namespace
  (`kubectl config current-context`, `kubectl config view --minify | grep namespace`). Never assume
  you are pointed at the right cluster.
- **Prefer declarative + GitOps.** Change manifests in version control and `apply`, rather than
  imperative `kubectl edit`/`patch` on live objects. Imperative is for diagnosis, not fixes.
- **Read before write.** Default to `get`/`describe`/`logs`. Treat `delete`, `scale`, `drain`,
  `rollout undo`, and secret edits as high-stakes — state the impact first.
- **Never print secret values** into logs or chat. Reference them by name.

## Debug flow

1. `kubectl get pods -n <ns>` — status, restarts, age.
2. `kubectl describe pod <pod> -n <ns>` — events, probe failures, scheduling reasons.
3. `kubectl logs <pod> -n <ns> [-c <container>] [--previous]` — app errors; `--previous` for crashes.
4. `kubectl get events -n <ns> --sort-by=.lastTimestamp` — cluster-level signals.
5. Narrow to the layer: image, config, resources, networking, RBAC, or node.

## Common failure playbook

- **CrashLoopBackOff** → `logs --previous`; usually app config/env/missing dependency or failing
  startup. Check command/args and required env/secrets.
- **ImagePullBackOff / ErrImagePull** → wrong image tag/registry or missing imagePullSecret.
- **Pending / Unschedulable** → insufficient resources, node selector/affinity/taints, or unbound
  PVC. Check `describe pod` events and node capacity.
- **OOMKilled** → memory limit too low or a leak; raise limits or fix usage; check `describe`.
- **Readiness failing / 502s** → probe path/port wrong, or app slow to start; tune probes.
- **Stuck rollout** → `kubectl rollout status`; `rollout undo` to revert; inspect new ReplicaSet.

## Workload hygiene

- Set resource **requests and limits**; define **liveness/readiness/startup** probes appropriately.
- Use **rolling updates** with sensible `maxSurge`/`maxUnavailable`; keep images pinned by digest/tag.
- **RBAC least privilege**; secrets via Secret objects (or external secret manager), never baked
  into images. Namespaces to isolate; resource quotas where multi-tenant.
- Prefer `kubectl apply --dry-run=server` / `kubectl diff` before applying changes.

## Done when

The root cause is identified with the evidence that points to it, the fix is expressed
declaratively where possible, rollback is known, and blast radius was confirmed before mutating.
