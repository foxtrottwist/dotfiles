#!/bin/bash
# permission-router.sh — PermissionRequest hook
# Auto-approve safe operations, deny dangerous ones. Fail-open on errors.

INPUT=$(cat) || exit 0

# Skip in subagents
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // empty') || exit 0
[[ -n "$AGENT_ID" ]] && exit 0

TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty') || exit 0
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty') || exit 0

# Auto-approve safe git operations
if [[ "$TOOL" == "Bash" ]]; then
  case "$COMMAND" in
    git\ add*|git\ commit*|git\ status*|git\ diff*|git\ log*|git\ branch*)
      echo '{"decision":"approve"}'; exit 0 ;;
    speak\ *)
      echo '{"decision":"approve"}'; exit 0 ;;
    swift\ build*|swift\ test*|xcodebuild\ *)
      echo '{"decision":"approve"}'; exit 0 ;;
    *rm\ -rf*|*--force*|*reset\ --hard*)
      # Only deny rm -rf on non-.local paths
      if ! echo "$COMMAND" | grep -qE '\.local'; then
        echo '{"decision":"deny","reason":"Dangerous operation blocked by permission router."}'; exit 0
      fi ;;
  esac
fi

exit 0
