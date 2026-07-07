# Manifest patterns

Prefer declarative manifests in version control. Keep them minimal, explicit, and reviewable.

## Deployment essentials

Every production Deployment should set:

- **Resource requests and limits** on each container. Requests drive scheduling; limits cap usage.
  Set requests to real typical usage; be careful with CPU limits (throttling) vs memory limits
  (OOMKill).
- **Probes**:
  - *readiness* — gates traffic; fail it when the app can't serve.
  - *liveness* — restarts a wedged app; keep it lenient so it doesn't kill slow-but-healthy pods.
  - *startup* — for slow-booting apps, so liveness doesn't fire during boot.
- **Rolling update strategy** — `maxSurge`/`maxUnavailable` tuned to capacity; the default rolling
  update gives zero-downtime when readiness is correct.
- **Labels** consistent across Deployment selector, pod template, and Service selector.
- **Image pinned** by tag or digest (avoid `:latest` in prod for reproducible rollouts).
- **securityContext**: run as non-root, drop capabilities, read-only root filesystem where possible.

## Service & Ingress

- **Service** selector must match pod labels; verify with `kubectl get endpoints <svc>`.
- Pick the right type: `ClusterIP` (internal), `NodePort`/`LoadBalancer` (external), or an
  **Ingress** for HTTP routing/TLS.
- Ingress: terminate TLS, set host/path routes, and mind controller-specific annotations.

## Scaling

- **HorizontalPodAutoscaler** on CPU/memory or custom metrics; requires resource requests to be set.
- Keep pods **stateless** so they scale horizontally; push state to a datastore/cache.
- Use **PodDisruptionBudgets** to keep minimum availability during voluntary disruptions
  (node drains, upgrades).

## Config & secrets

- **ConfigMaps** for non-secret config; **Secrets** (or an external secret manager / sealed secrets)
  for sensitive values. Mount as env or files; never bake secrets into images.
- Roll pods when config changes (checksum annotation trick) so updates take effect.

## Apply safely

- `kubectl diff -f manifest.yaml` — preview the change.
- `kubectl apply -f manifest.yaml --dry-run=server` — validate against the API server.
- Manage related resources with Kustomize or Helm; keep environments as overlays/values, not forks.
