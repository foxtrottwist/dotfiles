#!/bin/bash
# use-speak-cli.sh — PreToolUse hook (matcher: Bash)
# Catches curl commands to SpokenBite's localhost API and reminds to use `speak` CLI.

COMMAND=$(cat | jq -r '.tool_input.command')

# Allow /v1/status for post-build health checks, block everything else
if echo "$COMMAND" | grep -qE 'curl\s.*localhost:7849/' && \
   ! echo "$COMMAND" | grep -qE 'localhost:7849/v1/status'; then
  cat <<'EOF'
{
  "decision": "block",
  "reason": "Use `speak \"message\"` CLI for TTS instead of curling the SpokenBite API. Status checks via /v1/status are allowed."
}
EOF
fi
