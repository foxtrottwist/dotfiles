#!/bin/bash
# swift-skill-nudge.sh — UserPromptSubmit hook
# When a prompt references Swift/iOS work, remind Claude to check relevant skills.

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

[[ -z "$PROMPT" ]] && exit 0

# Match Swift/iOS signals in the prompt
if echo "$PROMPT" | grep -qiE '\.swift|swiftui|swiftdata|@model|@observable|foundation model|xcode|ios|ipados|@mainactor|concurrency|async.await'; then
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "Swift/iOS work detected. Check available skills before starting: swift-dev (conventions and routing), swiftui-expert-skill (SwiftUI patterns), swift-concurrency (async/await, actors), workflow-tools:foundation-models (on-device AI). Invoke the relevant skill — don't rely on general knowledge for domain-specific patterns."
  }
}
EOF
fi
