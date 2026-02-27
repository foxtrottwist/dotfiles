#!/bin/bash
# commit-reminder.sh
# Warns when uncommitted file count exceeds threshold.

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd')

cd "$CWD" || exit 0
git rev-parse --git-dir > /dev/null 2>&1 || exit 0

# Count modified/untracked files
MODIFIED=$(git status --porcelain | wc -l | tr -d ' ')

# Only warn above threshold
if [[ "$MODIFIED" -ge 5 ]]; then
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Commit reminder: $MODIFIED uncommitted files detected. Commit completed work before continuing to the next task."
  }
}
EOF
fi

exit 0
