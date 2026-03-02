#!/bin/bash
# use-speak-cli.sh — PreToolUse hook (matcher: Bash)
# Catches curl commands to SpokenBite's localhost API and reminds to use `speak` CLI.

COMMAND=$(cat | jq -r '.tool_input.command')

# Match actual curl invocations with API paths, not incidental mentions
if echo "$COMMAND" | grep -qE 'curl\s.*localhost:7849/'; then
  cat <<'EOF'
{
  "decision": "block",
  "reason": "Use `speak \"message\"` CLI for TTS instead of curling the SpokenBite API. For status checks, use the post-build workflow (Cmd+R → sleep → curl status) only when verifying the app is live after a build."
}
EOF
fi
