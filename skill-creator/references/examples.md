# Worked examples

## A. From vague idea to shippable skill

**Idea:** "We keep writing inconsistent database migrations — make a skill."

**Step 1 — job to be done:** *Guide writing safe, reversible SQL migrations, triggered when someone
adds/edits a migration.* Concrete failure without it: destructive, irreversible, or unordered
migrations reach production.

**Step 2 — real expertise (what the agent lacks by default):** reversibility patterns,
expand/contract for zero-downtime, backfill batching, locking pitfalls, ordering/naming
conventions. (Not: what SQL is — the agent knows that.)

**Step 3 — description (weak → strong):**
- ❌ `Helps write database migrations.`
- ✅ `Write safe, reversible database migrations. Use when the user adds or edits a migration,
  changes a schema, or asks about zero-downtime schema changes, backfills, or migration ordering.
  Emphasizes expand/contract, reversibility, and avoiding long locks.`

**Step 4 — name:** `writing-migrations` (gerund) or `db-migrations`. Folder must match.

**Step 5 — body outline:** When to use · Workflow (plan change → expand → backfill in batches →
switch → contract) · Principles (always reversible; never lock a big table; one concern per
migration) · Output format (up/down pair + checklist) · Done when.

**Step 6 — resources:** move the per-database locking gotchas and a full expand/contract example to
`references/zero-downtime.md`; keep the body a scannable procedure.

**Step 7–8 — validate & test:** run `validate_skill.sh`; eval set includes "add a column",
"rename a column without downtime" (should trigger) and "optimize this SELECT" (should not).

## B. Diagnosing a skill that "doesn't work"

**"It never activates."** Almost always the description. Compare the prompts users actually type to
the words in the description; they don't overlap. Add the user's vocabulary and symptom phrasings.
Re-run the trigger eval.

**"It activates but the output is mediocre."** The body is prose the agent already knew, or lacks an
output spec. Replace generic advice with the specific procedure + gotchas, add an **Output format**
with an example, and pin **Done when**.

**"It fires on the wrong tasks."** Over-broad description. Add the distinguishing clause, drop
generic verbs, and add should-NOT prompts to the eval set to lock it down.

## C. Annotated minimal skeleton

```markdown
---
name: writing-adrs
description: Write Architecture Decision Records. Use when the user asks to write or review an ADR,
  document an architecture/technology decision, or capture "why we chose X over Y". Produces a
  Context / Decision / Consequences record, one decision per file.
license: MIT
metadata:
  short-description: Author clear, one-decision ADRs
---

# Writing ADRs
Capture one architecture decision and its rationale so future readers understand the trade-off.

## When to use
- "Write an ADR", "document this decision", "why did we choose X over Y"

## Workflow
1. State the decision in the title as an outcome ("Use Postgres for the ledger").
2. Context: the forces — requirements, constraints, options considered.
3. Decision: what was chosen and the reasoning.
4. Consequences: what this makes easy, what it makes hard, follow-ups.

## Principles
- One decision per ADR. Immutable once accepted; supersede rather than edit.
- Record the rejected options and *why* — that's the value.

## Output format
`# ADR-NNN: <title>` then `## Context / ## Decision / ## Consequences`.

## Done when
A reader who wasn't in the room understands what was decided and why, and what it costs.
```

Every strong example shares the same shape: a trigger-rich description, a procedural body that
encodes judgment (not general knowledge), an explicit output format with an example, and a clear
done-when — with any depth pushed into `references/`.
