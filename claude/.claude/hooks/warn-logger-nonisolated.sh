#!/bin/bash
# warn-logger-nonisolated.sh — PreToolUse hook (matcher: Edit|Write)
# Warns when introducing `private let log = Logger.` without `nonisolated`.

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

[[ "$FILE" != *.swift ]] && exit 0

NEW_CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // .tool_input.content // empty')
[[ -z "$NEW_CONTENT" ]] && exit 0

if echo "$NEW_CONTENT" | grep -qE 'private let log = Logger\.' && \
   ! echo "$NEW_CONTENT" | grep -qE 'nonisolated.*let log = Logger\.'; then
  cat <<'EOF'
{
  "decision": "block",
  "reason": "File-scope `private let log = Logger.*` needs `nonisolated` — without it, MainActor default isolation prevents access from actors. Use `private nonisolated let log = Logger.*`."
}
EOF
fi
