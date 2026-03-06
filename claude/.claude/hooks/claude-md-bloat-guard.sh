#!/bin/bash
# claude-md-bloat-guard.sh — PreToolUse hook (matcher: Edit|Write)
# Warns when a CLAUDE.md edit pushes the file toward the ~50-line threshold.

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check CLAUDE.md files
[[ "$FILE" != */CLAUDE.md ]] && exit 0
[[ ! -f "$FILE" ]] && exit 0

LINES=$(wc -l < "$FILE" | tr -d ' ')

if [[ "$LINES" -gt 45 ]]; then
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "CLAUDE.md bloat warning: file is $LINES lines (threshold ~50). Before adding content, verify each line is a hard requirement Claude cannot discover from the code. Remove anything descriptive, architectural, or already covered by skills."
  }
}
EOF
fi
