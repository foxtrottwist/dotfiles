#!/bin/bash
# instructions-validator.sh — InstructionsLoaded hook
# Validates CLAUDE.md at load time. Replaces PreToolUse bloat guard with earlier timing.

INPUT=$(cat) || exit 0

# Skip in subagents
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // empty') || exit 0
[[ -n "$AGENT_ID" ]] && exit 0

FILE=$(echo "$INPUT" | jq -r '.file_path // empty') || exit 0

[[ "$FILE" != */CLAUDE.md ]] && exit 0
[[ ! -f "$FILE" ]] && exit 0

WARNINGS=()

# Line count check
LINES=$(wc -l < "$FILE" | tr -d ' ')
if [[ "$LINES" -gt 50 ]]; then
  WARNINGS+=("CLAUDE.md is $LINES lines (threshold 50). Audit for bloat.")
fi

# Stale content check (>30 days since modification)
if [[ "$(uname)" == "Darwin" ]]; then
  MOD_EPOCH=$(stat -f %m "$FILE")
else
  MOD_EPOCH=$(stat -c %Y "$FILE")
fi
NOW_EPOCH=$(date +%s)
DAYS_AGO=$(( (NOW_EPOCH - MOD_EPOCH) / 86400 ))
if [[ "$DAYS_AGO" -gt 30 ]]; then
  WARNINGS+=("CLAUDE.md last modified $DAYS_AGO days ago. Consider auditing for stale content.")
fi

if [[ ${#WARNINGS[@]} -gt 0 ]]; then
  COMBINED=$(printf '%s ' "${WARNINGS[@]}")
  COMBINED=$(echo "$COMBINED" | sed 's/"/\\"/g')
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "InstructionsLoaded",
    "additionalContext": "$COMBINED"
  }
}
EOF
fi
