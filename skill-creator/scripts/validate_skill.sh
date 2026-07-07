#!/bin/sh
# Validate an Agent Skill (SKILL.md) for correctness and cross-tool portability.
#
# Usage:
#   scripts/validate_skill.sh [SKILL_DIR]
#   Default SKILL_DIR = the skill directory this script is bundled in (its parent).
#
# Exit code 0 = no errors (warnings allowed); non-zero = at least one error.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DIR=${1:-$(dirname -- "$SCRIPT_DIR")}
DIR=$(CDPATH= cd -- "$DIR" && pwd)
skill="$DIR/SKILL.md"
folder=$(basename -- "$DIR")

errors=0
warnings=0
err()  { printf 'ERROR  %s\n' "$1"; errors=$((errors + 1)); }
warn() { printf 'WARN   %s\n' "$1"; warnings=$((warnings + 1)); }
ok()   { printf 'ok     %s\n' "$1"; }

printf 'Validating skill: %s\n\n' "$DIR"

if [ ! -f "$skill" ]; then
    err "no SKILL.md found in $DIR"
    printf '\n%s error(s), %s warning(s)\n' "$errors" "$warnings"
    exit 1
fi

# Frontmatter must open on line 1 and be terminated by a second '---'.
if [ "$(head -1 "$skill")" != "---" ]; then
    err "SKILL.md must open with '---' on line 1"
fi
fm=$(awk 'NR==1 && $0=="---"{f=1; next} f && $0=="---"{exit} f{print}' "$skill")
if [ -z "$fm" ]; then
    err "frontmatter is empty or not terminated by a second '---'"
fi

# get <key>: print the value of a top-level frontmatter scalar
get() { printf '%s\n' "$fm" | awk -v k="$1" 'index($0,k":")==1{sub(/^[^:]*:[[:space:]]*/,""); print; exit}'; }

# --- name ---
name=$(get name)
if [ -z "$name" ]; then
    err "frontmatter missing 'name'"
elif ! printf '%s' "$name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    err "name '$name' must match ^[a-z0-9]+(-[a-z0-9]+)*\$ (lowercase, hyphen-separated)"
elif [ "${#name}" -gt 64 ]; then
    err "name '$name' exceeds 64 characters"
elif [ "$name" != "$folder" ]; then
    err "name '$name' must equal the folder name '$folder'"
else
    ok "name '$name'"
fi

# --- description ---
desc=$(get description)
if [ -z "$desc" ]; then
    err "frontmatter missing 'description'"
else
    n=${#desc}
    if [ "$n" -gt 1024 ]; then
        err "description is $n chars (max 1024)"
    else
        ok "description ($n chars)"
    fi
    [ "$n" -ge 40 ] || warn "description is short ($n chars) — add concrete trigger cues"
    printf '%s' "$desc" | grep -Eqi 'use (when|this)|when the user|when you' \
        || warn "description lacks an explicit 'Use when…' trigger cue"
fi

# --- portability ---
if printf '%s\n' "$fm" | grep -Eq '^compatibility:'; then
    warn "'compatibility:' scopes the skill to one tool — omit it for Claude Code + opencode portability"
fi

# --- body length ---
lines=$(awk 'END{print NR}' "$skill")
if [ "$lines" -gt 500 ]; then
    warn "SKILL.md is $lines lines (>500) — push depth into references/"
else
    ok "SKILL.md length $lines lines"
fi

# --- resources ---
if [ -d "$DIR/references" ]; then
    ok "references/ present ($(find "$DIR/references" -type f | wc -l | tr -d ' ') file(s))"
fi
if [ -d "$DIR/scripts" ]; then
    ok "scripts/ present"
fi

printf '\n%s error(s), %s warning(s)\n' "$errors" "$warnings"
[ "$errors" -eq 0 ]
