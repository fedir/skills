# Writing skill descriptions

The `description` is the highest-leverage 1–3 sentences in a skill. It is the **only** text the
agent reads when deciding, for every skill installed, whether this one is relevant to the current
task. A great body is worthless if the description never fires. Optimize it first, and re-optimize
it whenever a skill over- or under-triggers.

## The formula

```
<capability: what it does>  +  <triggers: when to use it — keywords AND situations>  +  <what distinguishes it>
```

- **Capability** — lead with a verb phrase describing the outcome: "Review REST API contracts…",
  "Operate and debug Kubernetes workloads…".
- **Triggers** — the concrete words a user would actually type, plus the situations/symptoms that
  should activate it. Phrase as "Use when the user …" or "Use when …".
- **Distinguisher** — one clause that separates it from neighboring skills so the agent picks the
  right one.

## Hard rules

- **Third person, present tense.** Describe the skill, not yourself. No "I help you…", no "You can
  use this to…".
- **≤ 1024 characters.** Usually 1–3 sentences. Longer is not better; denser is.
- **Concrete over abstract.** Name tools, file types, error strings, commands, artifacts — the
  literal tokens that co-occur with the task.
- **No vague verbs**: "helps with", "assists", "deals with", "manages various" → these make the
  matcher fire indiscriminately or not at all.
- **Front-load the discriminating words.** If two skills are close, the difference belongs early.

## Trigger surface: keywords + situations

Cover both how users *name* the task and how they *describe the symptom*:

- Keywords: the nouns/commands (`kubectl`, `Dockerfile`, `ADR`, `PR`, `SKILL.md`).
- Situations: "before releasing API changes", "when a pod is CrashLoopBackOff", "when output isn't
  triggering". Symptoms catch users who don't know the keyword.

## Calibrating trigger breadth

- **Under-triggering** (skill rarely loads when it should): description too narrow or too abstract.
  Add more of the user's real vocabulary and more situations.
- **Over-triggering** (loads on unrelated tasks): description too broad or leans on generic verbs.
  Add the distinguisher and remove catch-all phrases.

Test both directions against real prompts — see `evaluation.md`.

## Examples (❌ weak → ✅ strong)

| ❌ Weak | ✅ Strong |
|--------|----------|
| `Helps with code review.` | `Review a diff or pull request for correctness, security, and quality. Use when the user asks to review code, check a PR, audit a change, or "is this okay to merge". Reports findings ranked by severity with file references.` |
| `Kubernetes helper.` | `Operate, debug, and manage Kubernetes clusters and workloads. Use when the user mentions kubernetes, k8s, kubectl, helm, pods, deployments, ingress, or troubleshoots CrashLoopBackOff / ImagePullBackOff / Pending / OOMKilled / failing rollouts.` |
| `For writing docs.` | `Write clear technical documentation. Use when the user asks to write or improve docs, a README, an ADR, a runbook, or API reference, or asks to "document this". Produces audience-appropriate, structured, example-driven writing.` |
| `Database utilities and helpers for queries and stuff.` | `Write compile-time-checked SQL with sqlx. Use when the user writes queries, migrations, or connection pooling in a sqlx/Rust project, or hits query/mapping errors.` |

Notice the strong ones: capability first, then a burst of literal trigger words *and* symptoms, then
a distinguishing clause — all in third person, under the length limit.

## Checklist

- [ ] Starts with the capability, third person, present tense
- [ ] Contains an explicit "Use when…" with real user keywords **and** situations
- [ ] Has a clause that distinguishes it from sibling skills
- [ ] ≤ 1024 chars; no vague verbs; no first/second person
- [ ] You can name a prompt it *should* fire on and one it *should not*
