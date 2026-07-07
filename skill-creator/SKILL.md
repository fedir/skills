---
name: skill-creator
description: Create new Agent Skills (SKILL.md) that work across AI coding tools. Use when the user asks to create a skill, write a SKILL.md, add a team skill, or improve an existing skill's description or structure. Covers the cross-tool format, trigger-oriented descriptions, and validation.
license: MIT
metadata:
  short-description: Author portable SKILL.md files for Claude Code, opencode, and other agents
  audience: engineers
---

# Skill Creator

You author Agent Skills that are portable across AI coding tools (Claude Code, opencode, and
other SKILL.md-compatible agents). A good skill is discoverable (great description), focused,
and tool-agnostic.

## When to use

- "Create a skill for …", "write a SKILL.md", "add a team skill"
- "Improve this skill's description / structure"
- Turning a repeated workflow or checklist into a reusable skill

## The format

A skill is a directory whose name **is** the skill name, containing `SKILL.md`:

```
<skill-name>/
  SKILL.md
  references/        # optional: deeper docs the body links to
```

`SKILL.md` frontmatter:

```yaml
---
name: my-skill            # required; must equal the folder name
description: ...           # required; ≤1024 chars; trigger-oriented (see below)
license: MIT              # optional
metadata:                 # optional; string→string map, tool-specific extras
  short-description: ...
---
```

Rules:
- **name** matches `^[a-z0-9]+(-[a-z0-9]+)*$` (lowercase, hyphen-separated, no leading/trailing/
  double hyphens), 1–64 chars, equal to the folder name.
- **description** is 1–1024 chars.
- **Unknown frontmatter fields are ignored**, so extra metadata is safe.

## Portability rules (works in both Claude Code and opencode)

- **Omit `compatibility:`.** Setting `compatibility: opencode` scopes the skill to opencode only.
  Leaving it out keeps the skill available everywhere.
- **Keep the body tool-agnostic.** Refer to generic capabilities — "read the file", "run the
  command", "search the code" — not tool-specific tool names. Both tools provide shell, read, edit,
  and search.
- **Discovery paths are shared**: both tools read `.claude/skills/<name>/SKILL.md` (project) and
  `~/.claude/skills/<name>/SKILL.md` (global); opencode also reads `.opencode/skills` and
  `~/.config/opencode/skills`. Installing into `~/.claude/skills` covers both.

## Writing a high-signal description

The description is the *only* thing the agent sees when deciding whether to load the skill. Make it
trigger-oriented:
- Lead with the capability, then the concrete cues: keywords the user would type, and situations.
- Prefer "Use when the user … / mentions … / asks to …".
- Be specific enough to distinguish this skill from neighbors; avoid vague verbs like "helps with".

## Body template

```
# <Title>
one-line purpose.
## When to use    — trigger cues, mirroring the description
## Workflow       — numbered steps or a checklist
## Principles     — the non-obvious rules that make output good
## Output format  — what the result should look like
## Done when      — the completion criteria
```

Add a `references/` subdir only when the guidance is long or reused; link to it from the body and
keep `SKILL.md` itself scannable.

## Validation checklist

- [ ] Folder name == `name` and matches the regex
- [ ] `description` present, ≤1024 chars, trigger-oriented
- [ ] No `compatibility:` field; body uses no tool-specific tool names
- [ ] Body has clear "When to use" and "Done when"
- [ ] If part of this repo: added an entry to `skills.json` and it installs via `install.sh`

## Done when

The new skill installs cleanly, its description reliably triggers it in the right situations, and
its body is portable and scannable.
