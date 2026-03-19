#!/usr/bin/env bash
# CWS session start hook — surfaces working state and handoffs at session open.
# Safe to run anywhere; no-ops if no CWS files are present.

CWS_DIR="$PWD/.claude/cws"

if [[ -f "$CWS_DIR/state.md" ]]; then
  echo "[CWS] Working state for this session:" >&2
  cat "$CWS_DIR/state.md" >&2
fi

if [[ -f "$CWS_DIR/handoff.md" ]]; then
  echo "" >&2
  echo "[CWS] Cross-surface handoff found:" >&2
  cat "$CWS_DIR/handoff.md" >&2
fi

exit 0
