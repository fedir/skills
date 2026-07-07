# Secure-coding checklist

Grouped by category, with the *why*. Aligns with the OWASP Top 10 themes. Apply what's relevant to
the code under review.

## Authentication

- [ ] Authentication enforced on every non-public route — server-side, not just hidden UI.
- [ ] Passwords hashed with a strong adaptive function (bcrypt/scrypt/argon2), never plaintext or
      fast hashes. Enforce sane password policy; support MFA where it matters.
- [ ] Session tokens are random, expiring, revocable; cookies `HttpOnly`, `Secure`, `SameSite`.
- [ ] No credentials in URLs, logs, or client-side code.

## Authorization (broken access control is the #1 risk)

- [ ] Every sensitive action checks *this user may do this to this object* — server-side.
- [ ] No insecure direct object references (IDOR): don't trust an ID from the client without an
      ownership/permission check.
- [ ] Fail closed — deny by default; missing/unknown permission = no access.
- [ ] Separate privilege levels; no privilege escalation via mass-assignment of role fields.

## Input handling & injection

- [ ] Validate/normalize input at the boundary (type, length, format, range, allowlist).
- [ ] **SQL**: parameterized queries / prepared statements only — never string concatenation.
- [ ] **OS commands**: avoid shelling out; if unavoidable, use arg arrays, never a shell string.
- [ ] **Output encoding** for the sink: HTML-escape for pages, escape for shell/LDAP/path contexts —
      prevents XSS and injection.
- [ ] File uploads/paths: validate type/size; prevent path traversal; store outside the web root.
- [ ] Deserialization of untrusted data avoided or strictly constrained.

## Secrets & crypto

- [ ] No secrets in source, config committed to VCS, logs, or error messages. Use a secret manager;
      rotate; scan history.
- [ ] Use vetted crypto libraries and current algorithms; **never roll your own crypto**.
- [ ] TLS for data in transit; encryption at rest for sensitive data. Strong randomness from a CSPRNG.

## Data protection & privacy

- [ ] Collect and retain the minimum sensitive data; know where PII lives.
- [ ] Don't log secrets or PII; mask/redact in logs and errors.
- [ ] Errors return generic messages to users; details go to server logs only.

## Dependencies & configuration

- [ ] Dependencies necessary, reputable, pinned, and scanned; no known-vulnerable versions.
- [ ] Security headers set (CSP, HSTS, X-Content-Type-Options, etc.) for web apps.
- [ ] Secure defaults; debug endpoints and verbose errors off in production.
- [ ] Rate limiting / quotas on expensive or abusable endpoints.

## Logging & monitoring

- [ ] Security-relevant events (authn, authz failures, admin actions) are logged, tamper-evident,
      and monitored — without logging the sensitive values themselves.
