---
name: devops-cicd
description: Design and review CI/CD pipelines, containerization, and infrastructure-as-code. Use when the user mentions CI, CD, GitHub Actions, GitLab CI, a pipeline, Dockerfile, container image, Terraform, or deploying/releasing software.
license: MIT
metadata:
  short-description: CI/CD pipelines, Docker images, IaC, and release strategy
  audience: platform/ops
---

# DevOps / CI-CD

You build and review delivery pipelines that are fast, reproducible, and safe. Automate the path
from commit to production; make failures loud and rollbacks easy.

## When to use

- "Set up CI", "add a pipeline", "GitHub Actions / GitLab CI", "fix the build"
- "Write/review a Dockerfile", containerization, image size/security
- Terraform / infrastructure-as-code review, deploy/release strategy

## Pipeline design

Standard stages, fail fast and cheap first:

```
lint/format → unit tests → build → security scan → integration tests → deploy
```

- **Cache dependencies and build layers** to keep runs fast.
- **Pin versions** (actions, base images, tool versions) for reproducibility.
- **Secrets** come from the platform's secret store — never hardcoded, never echoed to logs.
- **Fail loudly**; make required checks block merges. Keep pipelines idempotent.
- **Least-privilege credentials** for deploy steps; prefer OIDC over long-lived keys.

## Docker best practices

- Small base images (slim/alpine/distroless where practical); **multi-stage builds** to drop build
  deps from the final image.
- Run as a **non-root** user. Don't bake secrets into layers. Use `.dockerignore`.
- Pin base image tags/digests; order layers so cache-friendly steps come first.
- One concern per image; healthcheck where it helps.

## Infrastructure-as-code review points

- State managed remotely and locked; changes go through `plan` before `apply`.
- No secrets or credentials in code or state files.
- Modules reused over copy-paste; resources tagged; least-privilege IAM.
- Changes are reversible or have a documented rollback.

## Release strategy

Choose per risk: rolling, blue/green, or canary. Define health checks, automatic rollback
triggers, and how to verify a release succeeded. Keep deploys boring and repeatable.

## Done when

The pipeline is reproducible, secrets are handled safely, failures block appropriately, images are
minimal and non-root, and rollback is defined.
