# Security, RBAC, and access control

Kubernetes defaults are permissive-ish; harden deliberately. Least privilege everywhere.

## RBAC

- Grant the **minimum** verbs on the minimum resources in the minimum namespace. Prefer `Role` +
  `RoleBinding` (namespaced) over `ClusterRole` + `ClusterRoleBinding` unless truly cluster-wide.
- Bind to **ServiceAccounts** for workloads and to groups/users for humans. Give each workload its
  own ServiceAccount; don't use `default`.
- Avoid wildcards (`*`) on verbs/resources and avoid `cluster-admin` bindings. Audit with
  `kubectl auth can-i --list --as=<subject>`.

## Secrets

- Store sensitive data in **Secret** objects, an external manager (Vault, cloud secret store, CSI
  driver), or sealed/encrypted secrets in Git — never plaintext in manifests or images.
- Enable **encryption at rest** for secrets in etcd. Limit who can `get`/`list` secrets via RBAC.
- Mount secrets as files or env only where needed; rotate them; never log their values.

## Pod & workload security

- Run as **non-root** (`runAsNonRoot: true`, a non-zero `runAsUser`); **drop all capabilities** and
  add back only what's required; **read-only root filesystem**; disallow privilege escalation.
- No privileged containers, no host namespaces (`hostNetwork/hostPID/hostIPC`), no hostPath mounts
  unless justified.
- Enforce with **Pod Security Admission** (baseline/restricted) or a policy engine (Kyverno / OPA
  Gatekeeper).

## Network

- Default-deny with **NetworkPolicies**, then allow only required flows between namespaces/pods.
  Without policies, all pods can talk to all pods.
- Restrict egress where it matters (e.g. to known external endpoints).

## Images & supply chain

- Pull from trusted registries; scan images for vulnerabilities in CI; pin by digest.
- Use minimal base images (distroless/slim) to shrink the attack surface.

## Quick audit checklist

- [ ] Workloads use dedicated, least-privilege ServiceAccounts
- [ ] No `cluster-admin` or wildcard RBAC in app namespaces
- [ ] Secrets encrypted at rest, not in images/manifests, access-restricted
- [ ] Pods non-root, minimal capabilities, no privileged/host access
- [ ] NetworkPolicies enforce default-deny
- [ ] Images scanned and pinned
