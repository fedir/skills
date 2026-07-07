# Document types and templates

## Diátaxis: pick the right kind

Four kinds of docs serve four different reader goals. Don't blend them in one page — it serves none
of them well.

| Kind | Reader goal | Nature |
|------|-------------|--------|
| **Tutorial** | "teach me by doing" (learning) | Lesson: a guaranteed-to-work guided path, hand-held |
| **How-to guide** | "help me do this task" | Recipe: steps to a specific goal, assumes some knowledge |
| **Reference** | "tell me the facts" (lookup) | Dry, complete, consistent — API/config/CLI details |
| **Explanation** | "help me understand why" | Discussion of concepts, trade-offs, background |

If a page is trying to teach *and* be a complete reference, split it.

## README

The front door. Optimize for a newcomer getting to success fast.

```markdown
# Project — one line: what it is and who it's for
Short paragraph: the problem it solves.

## Quick start
Copy-pasteable: install → minimal run → see it work (≤ 5 steps).

## Usage
The 2–3 most common tasks, each with a real example.

## Configuration
Key options, defaults, env vars.

## Links
Deeper docs, contributing, license.
```

Lead with quick start; push depth to linked pages.

## ADR (Architecture Decision Record)

One decision, its context, and consequences. See the `architect` skill's `references/adr.md` for the
full template. Structure: `Context → Options considered → Decision → Consequences`. Record the
rejected options and *why*.

## Runbook

For an operator under stress. Unambiguous, copy-pasteable, no prose.

```markdown
# Runbook: <symptom or task, e.g. "API 5xx spike">
## When to use      — the trigger/alert
## Prerequisites    — access, tools
## Steps            — numbered, exact commands, expected output at each step
## Verify           — how to confirm it's resolved
## Rollback         — how to undo
## Escalation       — who/what if it doesn't work
```

## API / function reference

Complete and consistent per entry:

```markdown
### <endpoint or function>
Purpose — one line.
Parameters — name · type · required? · default · meaning.
Returns — type and shape.
Errors — what can go wrong and the codes/exceptions.
Example — a real request and response.
```

Consistency matters more than prose here — same structure for every entry so readers can scan.
