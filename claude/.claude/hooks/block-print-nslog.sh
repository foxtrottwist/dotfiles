#!/bin/bash
# block-print-nslog.sh — PreToolUse hook (matcher: Edit|Write)
# Blocks introducing print() or NSLog() in Swift files. Use os.Logger instead.

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check Swift files
[[ "$FILE" != *.swift ]] && exit 0

# Check new content for print()/NSLog()
NEW_CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // .tool_input.content // empty')
[[ -z "$NEW_CONTENT" ]] && exit 0

if echo "$NEW_CONTENT" | grep -qE '\bprint\(|NSLog\('; then
  cat <<'EOF'
{
  "decision": "block",
  "reason": "Don't use print() or NSLog() — use Logger.* categories from Logger+SpokenBite.swift (e.g., `log.info(\"message\")`)."
}
EOF
fi
