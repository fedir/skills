# Pipeline design

Principles are tool-agnostic; they map onto GitHub Actions, GitLab CI, CircleCI, Jenkins, etc.

## Stage ordering

Order by cost and signal — cheapest, most-likely-to-fail first, so feedback is fast:

```
1. lint / format / typecheck   (seconds)
2. unit tests                  (fast)
3. build / package
4. security scan (deps, SAST, secrets)
5. integration / e2e tests     (slow)
6. deploy (per environment, gated)
```

Fail the pipeline at the first failing required stage. Run independent jobs in parallel; keep the
critical path short.

## Caching

- Cache dependency downloads and build outputs keyed by a lockfile hash; restore on the next run.
- Cache Docker layers (buildx / registry cache) so unchanged layers aren't rebuilt.
- Caches are an optimization, not correctness — a cold run must still produce identical results.

## Secrets & credentials

- Pull secrets from the platform's secret store or a manager; **never** hardcode them or `echo` them
  to logs. Mask them in output.
- Give deploy jobs **least-privilege, short-lived** credentials — prefer OIDC federation to a cloud
  role over long-lived static keys.
- Scope secrets to the environments/branches that need them; protect production environments with
  required reviewers.

## Quality gates

- Make lint, tests, and scans **required status checks** that block merge.
- Enforce a green pipeline on the default branch; protect it (no direct pushes, require review).
- Keep the pipeline **idempotent** and re-runnable.

## Annotated example (pseudo-CI)

```yaml
on: [pull_request]
jobs:
  check:                      # cheap, fails fast
    steps:
      - checkout
      - restore-cache: key=deps-${{ hashFiles('lockfile') }}
      - run: lint && typecheck
      - run: unit-tests
  build:
    needs: check
    steps:
      - build-image           # multi-stage, pinned base
      - scan-image            # fail on high/critical CVEs
  deploy:
    needs: build
    if: branch == main
    environment: production   # requires approval + scoped secrets
    steps:
      - auth: oidc            # short-lived creds, no static keys
      - deploy
      - smoke-test            # verify; auto-rollback on failure
```

## Observability of the pipeline

Surface build times, flaky tests, and failure rates. A slow or flaky pipeline gets bypassed —
treat pipeline health as a first-class concern.
