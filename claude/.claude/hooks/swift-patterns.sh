#!/bin/bash
# swift-patterns.sh — PreToolUse hook (matcher: Edit|Write)
# Blocks deprecated/unwanted patterns in Swift files.

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

[[ "$FILE" != *.swift ]] && exit 0

NEW_CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // .tool_input.content // empty')
[[ -z "$NEW_CONTENT" ]] && exit 0

# Each rule: pattern|message
RULES=(
  '"sparkles"|Don'\''t use "sparkles" SF Symbol — AI cliché.'
  'NSLock|os_unfair_lock|pthread_mutex|Don'\''t use locks in audio code — use Atomic only. Locks cause priority inversion.'
  'DispatchQueue\.|DispatchGroup|Use async/await instead of GCD. DispatchQueue.main.async is unnecessary (MainActor default). Use Task.detached for background work.'
  'ObservableObject|@Published|Use @Observable macro instead of ObservableObject/@Published.'
  '\.cornerRadius\(|Use .clipShape(.rect(cornerRadius:)) instead of deprecated .cornerRadius().'
  'NavigationView|Use NavigationStack instead of deprecated NavigationView.'
  'URL\(string:.*\)!|Force-unwrapped URL — use guard let or add "// safe: literal URL" comment.'
  '\.foregroundColor\(|Use .foregroundStyle() instead of deprecated .foregroundColor().'
)

VIOLATIONS=()
for rule in "${RULES[@]}"; do
  PATTERN="${rule%|*}"
  MESSAGE="${rule##*|}"
  if echo "$NEW_CONTENT" | grep -qE "$PATTERN"; then
    VIOLATIONS+=("• $MESSAGE")
  fi
done

if [[ ${#VIOLATIONS[@]} -gt 0 ]]; then
  COMBINED=$(printf '%s\n' "${VIOLATIONS[@]}")
  # Escape for JSON
  COMBINED=$(echo "$COMBINED" | sed 's/"/\\"/g' | tr '\n' ' ')
  cat <<EOF
{
  "decision": "block",
  "reason": "$COMBINED"
}
EOF
fi
