# Threat modeling

Threat modeling answers four questions: *What are we building? What can go wrong? What do we do
about it? Did we do a good job?* Do it on designs and significant changes, early, when fixes are
cheap.

## Process

1. **Model the system.** Sketch components, data stores, external entities, and the **data flows**
   between them. Draw the **trust boundaries** — where data or control crosses from one trust level
   to another (internet→app, app→DB, service→service, user→admin). Boundaries are where controls
   belong.
2. **Enumerate threats** at each element and flow using STRIDE (below).
3. **Decide a response** per threat: mitigate (add a control), eliminate (remove the feature),
   transfer (offload risk), or accept (document why).
4. **Validate** that each significant threat has a control, and that the controls actually work.

## STRIDE

| Category | Violates | Ask | Typical controls |
|----------|----------|-----|------------------|
| **Spoofing** | Authenticity | Can someone impersonate a user/service? | Strong authN, MFA, mutual TLS, signed tokens |
| **Tampering** | Integrity | Can data/requests be modified in transit or at rest? | Integrity checks, signing, TLS, access controls |
| **Repudiation** | Non-repudiation | Can an actor deny an action? | Tamper-evident audit logs, signed records |
| **Information disclosure** | Confidentiality | What leaks via responses, logs, errors, timing? | Encryption, least privilege, output filtering |
| **Denial of service** | Availability | Can work be made unbounded / resources exhausted? | Rate limits, quotas, timeouts, autoscaling |
| **Elevation of privilege** | Authorization | Can a user do more than intended? | Server-side authZ, least privilege, input validation |

## Where to focus

- **Trust boundaries first** — the crossing points are the highest-value review targets.
- **Data flows carrying sensitive data** — follow PII, credentials, and money end to end.
- **Anything parsing untrusted input** — deserialization, file upload, template rendering, query
  building.
- **Authn/authz logic** — the most common source of high-impact bugs.

## Output

A short list: for each significant threat — the element/flow, the STRIDE category, the concrete
scenario, and the chosen control (or an explicit, justified acceptance). Keep it living: revisit as
the design changes.
