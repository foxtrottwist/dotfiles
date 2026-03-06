#!/bin/bash
# precompact-state-check.sh — PreCompact hook
# Before context compression, surface uncommitted state so it isn't lost.

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd')

cd "$CWD" || exit 0
git rev-parse --git-dir > /dev/null 2>&1 || exit 0

MODIFIED=$(git status --porcelain | wc -l | tr -d ' ')
[[ "$MODIFIED" -eq 0 ]] && exit 0

SUMMARY=$(git status --porcelain | head -10)

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreCompact",
    "additionalContext": "Pre-compaction state: $MODIFIED uncommitted file(s) exist. Before context is compressed, note any in-progress work so it can be resumed after compaction.\n$SUMMARY"
  }
}
EOF
