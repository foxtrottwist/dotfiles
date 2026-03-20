---
name: cws
description: "Read and update the workspace's current working state across sessions. Use this skill at the START of every session to load context about active work, recent decisions, and open questions. Use at the END of every session to persist what happened. Triggers on: session start, 'what am I working on', 'save state', 'update state', 'cws', '/cws', 'working state', 'where did I leave off', 'what's in progress', or any request to check or update cross-session context. Also use when switching between Claude Code and Cowork to ensure both surfaces stay in sync."
---

# CWS — Current Working State

Lightweight cross-session context in `.claude/cws/`. Read on session start, write on session close. Ambient "what's happening" layer — not a deep snapshot (that's chat-migration).

## Directory Structure

```
.claude/cws/
├── state.md      # tracked — the working state file
├── handoff.md    # gitignored — ephemeral cross-surface comms (consumed on read)
└── (other)       # session-generated references as needed
```

`state.md` is git-tracked so state changes appear in diffs. `handoff.md` is gitignored — written by one surface (e.g., Cowork), consumed and cleared by another (e.g., Claude Code).

## Read (session start)

1. Read `.claude/cws/state.md`
2. Check for `.claude/cws/handoff.md` — if it exists, read it, act on its instructions, then clear or remove it
3. Surface relevant context for the current task
4. Prune anything stale in state.md: decisions older than 30 days, completed work still listed as active, resolved questions

No user interaction needed — orient and proceed.

## Save (session end)

1. Read the current `.claude/cws/state.md`
2. Scan the conversation for state changes:
   - Work completed or started → update Active Work
   - Choices made with rationale → add to Decisions
   - Unresolved items → add to Open Questions
   - Session summary → prepend to Session Log
3. Write the updated file
4. Verify: `wc -l .claude/cws/state.md` — must be under 50 content lines. If over, prune: completed items out, old decisions removed, resolved questions dropped.
5. If the next session is on a different surface (e.g., handing off to Claude Code), write `.claude/cws/handoff.md` with specific instructions for that session.

If nothing meaningful changed, don't force an update.

## State File Format

Four sections in `state.md`:

- **Active Work** — zone-path keyed (`projects/dashboard`, `tmp/repos/SpokenBite`). Each entry has a "Next:" or "Blocked:" suffix. Status without direction is noise.
- **Decisions** — YYYY-MM-DD date + what was decided + why. Prune after 30 days unless still load-bearing.
- **Open Questions** — question + context for why it matters. Resolve or expire.
- **Session Log** — YYYY-MM-DD + surface label `(Cowork)`, `(Claude Code)`, `(Claude.ai)` + one-line summary. Keep last 10 entries.

Absolute dates only. Never "yesterday" or "last week."

## Worked Example

A session where the user moved repos and designed a new feature:

```markdown
# Current Working State

Updated: 2026-03-18T15:30:00

## Active Work

- `tmp/repos/SpokenBite` — Expanding MCP server with EventKit + command execution tools. Next: Phase 1 EventKit integration.
- `.claude/cws` — Restructured to subdirectory, skill updated.

## Decisions

- 2026-03-18: Moved repos/ to tmp/repos/ to avoid iCloud sync issues with .git directories.
- 2026-03-18: CWS uses subdirectory (.claude/cws/) — state.md tracked, handoff.md gitignored.

## Open Questions

- Does Cowork render HTML from MCP tool responses inline? Affects SpokenBite rich response design.

## Session Log

- 2026-03-18 (Cowork): Explored Dispatch, moved repos to tmp/, designed CWS system, wrote SpokenBite bridge brief.
```

## Relationship to Chat Migration

CWS: "What's happening across all my work?" — lightweight, every session.
Chat migration: "Exactly where did this specific conversation leave off?" — heavy, when hitting context limits or handing off complex work. Chat migration reads CWS as input when generating its handoff doc.

## Constraints

- `state.md` under 50 content lines. Verify with `wc -l` after save.
- Never duplicate CLAUDE.md content (conventions, zone map, build commands).
- Never include code snippets — that's chat-migration's job.
- No `[placeholder]` fill-in patterns in state.md — write real content, not templates.
- Flat sections, no nesting. One list per section.
- `handoff.md` is ephemeral. Read it, act on it, clear it. Don't accumulate.
