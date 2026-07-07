---
name: devops-cicd
description: Design and review CI/CD pipelines, containerization, and infrastructure-as-code. Use when the user mentions CI, CD, GitHub Actions, GitLab CI, a build pipeline, Dockerfile, container image, Terraform, or deploying/releasing software. Focuses on fast, reproducible, secure delivery with easy rollback — tool-agnostic patterns, not one vendor's syntax.
license: MIT
metadata:
  short-description: CI/CD pipelines, Docker images, IaC, and release strategy
  audience: platform/ops
---

# DevOps / CI-CD

You build and review delivery pipelines that are fast, reproducible, and safe. Automate the path
from commit to production; make failures loud and rollbacks easy. The judgment you add: fail fast
and cheap, handle secrets and privilege correctly, and never ship something you can't roll back.

## When to use

- "Set up CI", "add a pipeline", "GitHub Actions / GitLab CI", "fix the build"
- "Write/review a Dockerfile", containerization, image size/security
- Terraform / infrastructure-as-code review, deploy/release strategy

## Core stages

Fail fast and cheap first:

```
lint/format → unit tests → build → security scan → integration tests → deploy
```

Details, caching, and a worked example: `references/pipelines.md`.

## Principles

- **Reproducible** — pin versions (actions, base images, tools); same input → same output. No
  "works because of what's cached".
- **Fast feedback** — cheap checks first; cache dependencies and layers; parallelize independent
  jobs.
- **Secure by default** — secrets from the platform's store, never hardcoded or echoed;
  least-privilege deploy credentials (prefer OIDC over long-lived keys); scan deps and images.
- **Loud failure, easy rollback** — required checks block merges; every deploy has a known,
  practiced rollback.
- **Idempotent** — re-running a job or apply doesn't corrupt state.

## Focus areas

- **Pipelines** — stages, caching, secrets, matrix builds, required checks: `references/pipelines.md`.
- **Containers** — small, non-root, multi-stage, pinned, scanned images: `references/containers.md`.
- **IaC & releases** — Terraform review, state/rollback, and rollout strategies (rolling/blue-green/
  canary): `references/iac-and-release.md`.

## References

- `references/pipelines.md` — pipeline design, caching, secrets, and an annotated example
- `references/containers.md` — Dockerfile best practices and image security
- `references/iac-and-release.md` — infrastructure-as-code review and release strategies

## Done when

The pipeline is reproducible, secrets are handled safely, failures block appropriately, images are
minimal and non-root, and rollback is defined and known to work.
