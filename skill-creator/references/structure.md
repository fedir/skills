# Structure, progressive disclosure, and bundled resources

## Directory layout

```
<skill-name>/
  SKILL.md              # required — frontmatter + body
  references/           # optional — docs opened on demand
    <topic>.md
  scripts/              # optional — executables the agent runs
    <tool>.sh
  assets/               # optional — templates/boilerplate to copy from
    <template>
```

The folder name **is** the skill name. Everything under it travels together when the skill is
installed (the installer symlinks the whole directory), so reference bundled files by **relative
path** (`references/foo.md`, `scripts/bar.sh`) — never an absolute path.

## Progressive disclosure — what goes where

Three load levels, three budgets (see the table in `SKILL.md`). Decide placement by *cost × how
often it's needed*:

- **Level 1 — `name` + `description`** (always loaded, for every installed skill). Every token here
  is paid on every request. Spend it only on discovery.
- **Level 2 — the body** (loaded when the skill triggers). The *procedure* and the *judgment*: when
  to use, the steps, the gotchas, the output shape, done-when. Keep it scannable.
- **Level 3 — `references/`, `scripts/`, `assets/`** (loaded only when the body points to them).
  Everything long, rarely-needed, or executable.

Rule of thumb: if a section is long, only relevant in a sub-case, or a big example, it belongs in
Level 3 with a one-line pointer from the body ("For X, see `references/x.md`").

## Length budget

- Target the body **< 200 lines**; treat **~500 lines** as a hard ceiling.
- A bloated body is paid every time the skill fires and buries the signal. When you feel the urge to
  add a fourth long example or an exhaustive spec, move it to `references/`.
- Density beats length: cut anything the agent already knows by default.

## references/ — on-demand docs

Use for: full specifications, long checklists, decision tables, extended examples, edge-case
catalogs, background theory. Split by topic so the agent opens only what it needs. Link from the
body with a short imperative pointer.

## scripts/ — executables

Use for deterministic work better done by code than by the model: validators, scaffolders, linters,
formatters, data transforms. Guidelines:
- Keep them **dependency-light and portable** (prefer POSIX `sh`/`python3` stdlib). Cross-tool users
  won't all have your toolchain.
- Make them self-locating (resolve their own dir) so they run regardless of CWD.
- Document usage in a top comment and reference it from the body.
- Fail loudly with a clear message and a non-zero exit on error.

## assets/ — templates

Use for boilerplate the skill instantiates: file templates, config skeletons, scaffold trees. The
body tells the agent to copy and fill them.

## Frontmatter fields

| Field | Required | Portable? | Notes |
|-------|:--------:|:---------:|-------|
| `name` | yes | yes | `^[a-z0-9]+(-[a-z0-9]+)*$`, ≤64, == folder name |
| `description` | yes | yes | ≤1024 chars; see `description-guide.md` |
| `license` | no | yes | e.g. `MIT` |
| `metadata` | no | yes | string→string map; extra info; unknown keys ignored |
| `compatibility` | no | **no** | scopes the skill to one tool — **omit** for portability |
| tool-specific (e.g. `allowed-tools`) | no | partial | honored by some tools, ignored by others; don't depend on it |

Unknown frontmatter keys are ignored by conformant tools, so `metadata` is a safe place for extra
signals (audience, workflow, owner) without breaking portability.

## Naming

- Lowercase kebab-case, matching the regex, ≤64 chars, equal to the folder.
- Prefer a **role** (`security-engineer`) or a **gerund/task** (`debugging-flaky-tests`,
  `writing-adrs`). Avoid generic names (`helper`, `utils`) and tool-brand names.
- One skill = one coherent job. If a skill needs "and" to describe it, consider splitting.
