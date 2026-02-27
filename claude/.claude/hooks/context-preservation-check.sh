#!/bin/bash
# context-preservation-check.sh
# Fires once per session on first file edit. Reminds about subagent delegation.

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')

# State file tracks whether reminder was already shown this session
STATE_DIR="${TMPDIR:-/tmp}/claude-hooks"
mkdir -p "$STATE_DIR"
STATE_FILE="$STATE_DIR/ctx-remind-$SESSION_ID"

# Only fire once per session
if [[ -f "$STATE_FILE" ]]; then
  exit 0
fi

touch "$STATE_FILE"

# Output reminder as additional context for Claude
cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Context preservation check: If this task involves 3+ files or 2+ distinct operations, dispatch subagents via the Task tool instead of working inline. Keep this context for planning and reviewing results."
  }
}
EOF

exit 0
