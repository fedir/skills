---
name: skill-creator
description: Create high-quality, portable Agent Skills (SKILL.md) that work across AI coding tools. Use when the user asks to create, design, author, or improve a skill or SKILL.md, package a repeated workflow into a reusable skill, or fix a skill that is not triggering or not producing good results. Covers description engineering, progressive disclosure, bundled resources, validation, and testing.
license: MIT
metadata:
  short-description: Author excellent, portable SKILL.md skills — with validation and testing
  audience: engineers
---

# Skill Creator

You author Agent Skills that are **discoverable, focused, portable, and effective**. A skill is an
on-demand expansion of the agent's capability: a great one triggers at exactly the right moment,
gives just enough high-signal instruction to lift output quality, and costs almost nothing when
idle. Treat skill quality as the product of three factors — get any one wrong and the skill fails:

> **quality = right trigger × right instructions × low idle cost**

- **Right trigger** — the `description` makes the agent load the skill when (and only when) it helps.
- **Right instructions** — the body encodes the non-obvious expertise the agent lacks, as a
  repeatable procedure, not prose it already knows.
- **Low idle cost** — progressive disclosure keeps the always-loaded footprint tiny.

## When to use

- "Create / design / author a skill", "write a SKILL.md", "add a team skill"
- "Package this workflow / checklist / runbook into a skill"
- "This skill isn't triggering" or "the skill triggers but the output is weak" → diagnose & improve
- Reviewing or refactoring an existing skill for quality and portability

## Mental model: progressive disclosure

Skills load in three levels. Design each level for its budget:

| Level | What loads | When | Budget |
|-------|-----------|------|--------|
| 1. Metadata | `name` + `description` | always, for every skill installed | a few dozen tokens — make every word earn discovery |
| 2. Body | the rest of `SKILL.md` | when the skill triggers | keep scannable; aim < 200 lines, hard cap ~500 |
| 3. Resources | files under `references/`, `scripts/`, `assets/` | only when the body tells the agent to open/run them | unbounded — this is where depth lives |

The craft is deciding what belongs at each level. Put triggering cues in L1, the core procedure in
L2, and exhaustive detail/large examples/executables in L3. **Detail in resources, not the body.**

## Authoring workflow

1. **Define the job to be done.** In one sentence: *what capability, for whom, triggered by what.*
   If you can't name a concrete situation where the agent would fail without it, the skill isn't
   worth writing.
2. **Extract the real expertise.** List only what the agent does *not* already know or reliably do:
   the procedure, the gotchas, the decision rules, the output shape. Cut anything a competent agent
   already does by default — repeating it wastes the trigger.
3. **Write the description** (highest leverage). Capability + explicit trigger cues + what
   distinguishes it from neighbors. See `references/description-guide.md`.
4. **Choose the name.** Lowercase kebab-case, `^[a-z0-9]+(-[a-z0-9]+)*$`, ≤64 chars, **equal to the
   folder name**. Prefer a role or gerund (`code-reviewer`, `debugging-flaky-tests`).
5. **Outline the body**, then fill it: *When to use · Workflow · Principles · Output format ·
   Done when.* Imperative voice, scannable, examples over adjectives.
6. **Decide resources.** Anything long, reused, or executable → move to `references/`/`scripts/`/
   `assets/` and reference it by relative path from the body. See `references/structure.md`.
7. **Validate** — run `scripts/validate_skill.sh <skill-dir>` (bundled with this skill).
8. **Test & iterate** — check that it triggers on the right prompts (and not the wrong ones) and
   that output meets the bar. See `references/evaluation.md`. Tighten and repeat.

## Writing the description (the make-or-break field)

The description is the *only* thing the agent sees when deciding whether to load the skill. Rules:

- **Third person, present tense.** Start with the capability ("Review REST API contracts…"), not
  "I help" / "You can".
- **State the triggers explicitly.** Add "Use when the user …" with the concrete words a user would
  type and the situations/symptoms that should fire it.
- **Be specific enough to disambiguate** from sibling skills. Vague verbs ("helps with", "assists")
  are trigger poison.
- **≤1024 characters**, typically 1–3 sentences.

Weak → Strong:
- ❌ `Helps with Kubernetes stuff.`
- ✅ `Operate, debug, and manage Kubernetes workloads. Use when the user mentions kubectl, helm,
  pods, deployments, or troubleshoots CrashLoopBackOff / ImagePullBackOff / OOMKilled / stuck
  rollouts.`

Deep dive with more examples: `references/description-guide.md`.

## Writing the body

- **Imperative and procedural.** Tell the agent what to do, in order. Checklists and numbered steps
  beat paragraphs.
- **Encode judgment, not just steps** — the "Principles"/gotchas are what a novice agent lacks.
- **Show, don't tell.** Include a concrete example of good output or a template.
- **No time-bound or environment-bound facts** baked in ("as of 2026…", absolute paths, one team's
  URLs) — they rot and hurt portability.
- **Define "Done when"** so the agent knows the acceptance bar.

## Bundled resources

Reference them by **relative path** from the body so they travel with the skill when installed:

- `references/*.md` — deep docs the agent opens on demand (specs, long checklists, big examples).
- `scripts/*` — executables the agent runs (validators, generators). Keep them dependency-light and
  POSIX/portable.
- `assets/*` — templates/boilerplate the skill copies from.

Full guidance and layout: `references/structure.md`.

## Portability (Claude Code + opencode + others)

- **Discovery is shared**: both tools read `.claude/skills/<name>/SKILL.md` (project) and
  `~/.claude/skills/<name>/SKILL.md` (global); installing into `~/.claude/skills` covers both.
- **Omit `compatibility:`** — setting it (e.g. `compatibility: opencode`) scopes the skill to one
  tool. Standard fields only: `name`, `description`, optional `license`/`metadata`.
- **Keep bodies tool-agnostic** — say "read the file / run the command / search the code", never a
  tool-specific tool name. Tool-specific frontmatter (e.g. `allowed-tools`) is fine but is ignored
  elsewhere; don't depend on it.

## Validate

```sh
scripts/validate_skill.sh <path-to-skill-dir>   # defaults to this skill's own dir
```
Checks: frontmatter present and terminated; `name` matches the regex and the folder; `description`
present, ≤1024 chars, and trigger-shaped; no `compatibility:` field; body length; resources
presence. Fix every ERROR; weigh each WARN.

## Anti-patterns (reject these)

- Vague description → skill never triggers, or triggers on everything.
- Kitchen-sink body → bloats every session and buries the signal; move depth to `references/`.
- Restating general knowledge the agent already has (basic git, language syntax).
- Hardcoded paths, dates, URLs, or a single tool's assumptions.
- Folder name ≠ `name`; illegal characters in `name`.
- No examples and no "Done when" → inconsistent output.

## Skeleton

```markdown
---
name: my-skill
description: <capability>. Use when the user <triggers/keywords/situations>. <what makes it distinct>.
license: MIT
metadata:
  short-description: <one line>
---

# My Skill
<one-line purpose>

## When to use     — trigger cues mirroring the description
## Workflow        — numbered steps
## Principles       — the non-obvious rules that make output good
## Output format    — what the result should look like (with an example)
## Done when        — acceptance criteria
```

## Done when

The skill installs cleanly and passes `validate_skill.sh` with zero errors; its description reliably
triggers it on the right prompts and stays quiet on the wrong ones; its body is portable, scannable,
and encodes real expertise; and depth lives in `references/`, not the body.
