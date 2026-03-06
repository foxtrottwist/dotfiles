#!/bin/bash
# verification-nudge.sh — Stop hook
# If Swift files were modified this session, prompt Claude to confirm
# verification (build + tests) before stopping.

INPUT=$(cat)

# Skip in subagents — they operate under supervision of the main session
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // empty')
[[ -n "$AGENT_ID" ]] && exit 0

CWD=$(echo "$INPUT" | jq -r '.cwd')
cd "$CWD" || exit 0
git rev-parse --git-dir > /dev/null 2>&1 || exit 0

# Only fire when Swift files were modified
SWIFT_CHANGES=$(git status --porcelain | grep '\.swift$' | wc -l | tr -d ' ')
[[ "$SWIFT_CHANGES" -eq 0 ]] && exit 0

cat <<EOF
{
  "continue": false,
  "stopReason": "Swift files were modified ($SWIFT_CHANGES file(s)). Before stopping: confirm build passes and tests were run. If verification is already complete or not applicable, state why and proceed."
}
EOF
