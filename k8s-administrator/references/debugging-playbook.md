# Kubernetes debugging playbook

Always start with the debug flow (`get` → `describe` → `logs` → `events`), then match the symptom.

## CrashLoopBackOff

Container starts then exits repeatedly.
- `kubectl logs <pod> --previous` — the crash output from the last run.
- Usual causes: app misconfig, missing/wrong env or secret, failing startup/migration, wrong
  command/args, dependency unreachable, failing liveness probe killing a healthy-but-slow app.
- Check: `describe` for the exit code and probe events; verify required config/secrets exist; loosen
  or fix an aggressive liveness probe (use a startup probe for slow boots).

## ImagePullBackOff / ErrImagePull

Kubelet can't pull the image.
- `describe pod` shows the exact pull error.
- Causes: wrong image name/tag, image not pushed, private registry without `imagePullSecrets`,
  registry auth/network issue. Fix the reference or add the pull secret.

## Pending / Unschedulable

Scheduler can't place the pod.
- `describe pod` events give the reason.
- Causes: insufficient CPU/memory on nodes, node selector/affinity/taints not satisfied, unbound
  PVC, or resource quota exceeded. Check node capacity (`kubectl top nodes`, `describe node`), the
  PVC/StorageClass, and quotas.

## OOMKilled

Container exceeded its memory limit.
- `describe pod` shows `OOMKilled` on the last state.
- Fix: raise the memory limit if the workload legitimately needs it, or fix the leak/allocation.
  Ensure requests reflect real usage so scheduling is accurate.

## Readiness failing / 502s / traffic not served

- Readiness probe path/port wrong, or app slow to become ready → tune the probe or add a startup
  probe. Confirm the Service selector matches pod labels and `kubectl get endpoints` is populated.

## Stuck or bad rollout

- `kubectl rollout status deploy/<name>` — where it's stuck.
- `kubectl rollout undo deploy/<name>` — revert to the previous ReplicaSet.
- Inspect the new ReplicaSet's pods with the flow above to find why new pods aren't becoming ready.

## Networking / DNS

- Service unreachable: check Service selector ↔ pod labels, `endpoints`, and NetworkPolicies.
- DNS failures: test from a debug pod (`nslookup <svc>.<ns>.svc.cluster.local`); check CoreDNS pods.

## Node-level

- `kubectl get nodes` / `describe node` — `NotReady`, disk/memory pressure, taints. Cordon & drain
  before maintenance; check kubelet.

## Handy diagnostics

- `kubectl get events -A --sort-by=.lastTimestamp` — recent cluster-wide signals.
- `kubectl top pods/nodes` — live resource usage (needs metrics-server).
- `kubectl exec -it <pod> -- sh` — inspect inside a running container.
- `kubectl debug` / an ephemeral debug container — for distroless images without a shell.
