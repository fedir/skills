# Container images

Goal: small, reproducible, secure images that start fast and expose minimal attack surface.

## Dockerfile best practices

- **Multi-stage builds** — compile/install in a build stage, copy only the artifacts into a slim
  runtime stage. Keeps build tools and source out of the final image.
- **Small base images** — `slim`, `alpine`, or `distroless` where practical. Less to patch, smaller
  attack surface, faster pulls. (Watch for musl/glibc and missing-shell gotchas with alpine/
  distroless.)
- **Run as non-root** — create and switch to an unprivileged user; set a read-only root filesystem
  where the app allows.
- **Pin versions** — pin the base image by tag *and* digest, and pin installed package versions, for
  reproducible builds. Avoid `:latest` in anything shipped.
- **Layer order for cache** — copy dependency manifests and install deps *before* copying source, so
  code changes don't bust the dependency layer.
- **`.dockerignore`** — exclude VCS, secrets, local env, build caches, and node_modules/target.
- **One concern per image** — a single main process; use orchestration for multi-process needs.
- **No secrets in layers** — don't `COPY` secrets or bake tokens into the image; use build secrets/
  mounts or inject at runtime. Secrets in an intermediate layer persist in history.
- **Metadata** — set a meaningful `WORKDIR`, `EXPOSE`, healthcheck, and OCI labels.

## Image security

- **Scan in CI** — run a vulnerability scanner on every build; fail on high/critical CVEs (with an
  allowlist process for accepted risks).
- **Minimize contents** — fewer packages = fewer CVEs. Distroless removes the shell and package
  manager entirely.
- **Sign & verify** provenance where supply-chain integrity matters (SBOM, image signing).
- **Rebuild regularly** to pick up base-image security patches; don't let images rot.

## Quick checklist

- [ ] Multi-stage; final image has no build tools or source
- [ ] Slim/distroless base, pinned by digest
- [ ] Runs as non-root; read-only rootfs where possible
- [ ] Dependency layer cached before source copy
- [ ] `.dockerignore` present; no secrets in any layer
- [ ] Scanned in CI; passes the CVE gate
