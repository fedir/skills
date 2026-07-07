# Team Skills

A shared set of role-based **Agent Skills** for the team. Each skill is a portable `SKILL.md`
that works **unchanged in both [Claude Code](https://code.claude.com/docs/en/skills) and
[opencode](https://opencode.ai/docs/skills/)** (and other SKILL.md-compatible agents).

## Skills

| Skill | What it does |
|-------|--------------|
| `architect` | System & software design — options, trade-offs, boundaries, ADRs |
| `developer` | Implement features & fix bugs matching existing patterns, verified |
| `k8s-administrator` | Kubernetes operations, debugging, rollouts, workload hygiene |
| `skill-creator` | Author new portable SKILL.md files (the AI skill creator) |
| `code-reviewer` | Diff/PR review — bugs, security, reuse, style, ranked by severity |
| `devops-cicd` | CI/CD pipelines, Docker images, IaC, release strategy |
| `security-engineer` | Threat modeling, secure-coding review, vuln triage (defensive) |
| `tech-writer` | READMEs, ADRs, runbooks, API docs — clear and example-driven |

## Compatibility

Both tools discover skills from the same paths, so one install covers both:

| Location | Claude Code | opencode |
|----------|:-----------:|:--------:|
| `~/.claude/skills/<name>/SKILL.md` (global) | ✅ | ✅ |
| `.claude/skills/<name>/SKILL.md` (project) | ✅ | ✅ |
| `~/.config/opencode/skills/`, `.opencode/skills/` | — | ✅ |

Skills stay portable by using only the standard `name`/`description` frontmatter, omitting a
`compatibility:` field (which would scope a skill to one tool), and keeping bodies tool-agnostic.

## Install

```sh
git clone git@github.com:fedir/skills.git
cd skills
./install.sh                 # symlinks every skill into ~/.claude/skills (read by both tools)
```

Install somewhere else (e.g. a project or the opencode-native path):

```sh
./install.sh ./.claude/skills                     # project-local, both tools
./install.sh ~/.config/opencode/skills            # opencode-native
```

The installer symlinks (doesn't copy), so `git pull` updates all installed skills instantly. It is
idempotent and refuses to overwrite non-symlink files.

## Add a new skill

Use the `skill-creator` skill, or by hand:

1. Create `<skill-name>/SKILL.md` (folder name **must** equal the `name` field).
2. Frontmatter needs `name` and `description`; keep the body tool-agnostic; don't add
   `compatibility:`.
3. Add an entry to [`skills.json`](./skills.json).
4. Run `./install.sh` and confirm the skill appears in your agent.

## License

[MIT](./LICENSE).
