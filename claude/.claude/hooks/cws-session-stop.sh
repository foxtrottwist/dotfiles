#!/usr/bin/env bash
# CWS session stop hook — reminds to save working state before ending.
# Safe to run anywhere; no-ops if no CWS state file is present.

CWS_DIR="$PWD/.claude/cws"

if [[ -f "$CWS_DIR/state.md" ]]; then
  echo "[CWS] Remember to run /cws save to update working state before ending." >&2
fi

exit 0
