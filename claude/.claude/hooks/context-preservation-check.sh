#!/bin/bash
# context-preservation-check.sh — SessionStart hook (matcher: clear)
# Fires when a coding session begins after plan approval or /clear.
# Reminds about subagent delegation, skill usage, and context hygiene.

INPUT=$(cat) || exit 0

# Skip in subagents
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // empty')
[[ -n "$AGENT_ID" ]] && exit 0

cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Session start reminder: (1) Delegate exploration and multi-file tasks to subagents via the Agent tool — do not explore or implement inline. (2) Check available skills before starting work (swift-dev for Swift/iOS, workflow-tools for orchestration). (3) Keep this context for planning and reviewing results only."
  }
}
EOF

exit 0
