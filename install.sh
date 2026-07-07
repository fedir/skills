#!/bin/sh
# Install team skills by symlinking each skill directory into a target skills dir.
# Works for both Claude Code and opencode (both read ~/.claude/skills).
#
# Usage:
#   ./install.sh [TARGET_DIR]
# Default TARGET_DIR is ~/.claude/skills (discovered by Claude Code AND opencode).
#
# Symlinks (not copies), so `git pull` updates installed skills. Idempotent.
# Refuses to overwrite a real file/dir that is not already a symlink.

set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TARGET=${1:-"$HOME/.claude/skills"}

mkdir -p "$TARGET"

count=0
for dir in "$REPO_DIR"/*/; do
    [ -f "${dir}SKILL.md" ] || continue
    name=$(basename "$dir")
    link="$TARGET/$name"

    if [ -L "$link" ]; then
        rm "$link"                      # refresh existing symlink
    elif [ -e "$link" ]; then
        printf 'skip  %s (a real file/dir already exists — not overwriting)\n' "$name"
        continue
    fi

    ln -s "${REPO_DIR}/${name}" "$link"
    printf 'link  %s -> %s\n' "$name" "$link"
    count=$((count + 1))
done

printf '\nInstalled %s skill(s) into %s\n' "$count" "$TARGET"
