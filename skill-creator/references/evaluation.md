# Testing and iterating on a skill

A skill isn't done when it's written — it's done when it *reliably triggers on the right prompts and
produces output that meets the bar*. Evaluate both, then iterate.

## 1. Trigger evaluation

Discovery is a matching problem: does the agent load the skill exactly when it should?

Build a tiny eval set before you ship:

- **Should-trigger prompts** (5–10): the varied ways a user would ask for this — different
  vocabulary, and symptom-style phrasings, not just the obvious keyword.
- **Should-NOT-trigger prompts** (3–5): nearby tasks owned by sibling skills, plus unrelated tasks.
  These catch over-triggering.

Run each in a **fresh session** (no prior context priming it) and record whether the skill loads.

| Symptom | Cause | Fix |
|---------|-------|-----|
| Misses should-trigger prompts | description too narrow/abstract | add real user vocabulary + situations |
| Fires on should-NOT prompts | description too broad / generic verbs | add the distinguisher, remove catch-alls |
| Loses to a sibling skill | descriptions overlap | sharpen each one's distinguishing clause |

## 2. Output evaluation

When it triggers, is the result actually better? Define acceptance criteria up front (they usually
mirror the body's "Done when"), then judge real runs against them.

- Give the triggered skill a representative task and inspect the output against the criteria.
- Look for: did it follow the workflow? apply the judgment/gotchas? produce the specified format?
- Common fixes:
  - Output inconsistent → add an explicit **Output format** with an example.
  - Agent skips key steps → make them a numbered checklist, not prose.
  - Agent does the wrong thing in an edge case → encode the rule in **Principles** or a
    `references/` decision table.
  - Body too long / slow → move depth into `references/`.

## 3. Portability check

- Run `scripts/validate_skill.sh <dir>` — zero errors, understood warnings.
- Grep the body for tool-specific tool names and for `compatibility:` — expect none.
- If practical, load the skill in a second tool (e.g. opencode as well as Claude Code) and confirm
  it appears and behaves.

## 4. Iterate

Change **one thing at a time** (usually the description first), re-run the eval set, and keep the
prompts as a lightweight regression suite for future edits. Most skills need 2–3 tightening passes
before both trigger precision and output quality are solid.

## Quick rubric

- [ ] Triggers on all should-trigger prompts, none of the should-NOT prompts
- [ ] Output meets the "Done when" criteria on representative tasks
- [ ] Passes `validate_skill.sh`; portable and tool-agnostic
- [ ] Eval prompts saved for regression
