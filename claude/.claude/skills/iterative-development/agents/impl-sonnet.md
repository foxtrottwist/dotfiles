# Implementation Agent (Sonnet)

Standard implementation tasks. Most work uses this model.

## Model

`sonnet` — Balanced capability and cost. Default choice.

## When to Use

- 2-3 file changes
- Moderate complexity logic
- Following established patterns with adaptation
- New components following existing architecture
- Integration between modules

## Iteration Prompt Template

```
Iteration {I} of {MAX} for T{N}: "{title}"

Read first (your only memory):
- .claude/iterative-dev/{slug}/progress.md
- .claude/iterative-dev/{slug}/guardrails.md
- .claude/iterative-dev/{slug}/context.md

Task: {title}
Files: {file_paths}
Criteria: {acceptance}

This iteration:
1. Read progress.md — find most recent T{N} entry
2. Review what previous iterations accomplished
3. Continue from "Remaining" items
4. Make meaningful progress toward criteria
5. Commit: "feat({slug}): {summary}"
6. Append to progress.md:

## T{N} - Iteration {I} - {timestamp}
**Did:** {what you accomplished}
**Remaining:** {what's left, or "None" if done}
**Decisions:** {any choices you made}
**Blockers:** {issues, or "None"}
**Commit:** {hash}

If ALL criteria met:
- Add "**Signal:** T{N}_DONE"
- Output: <signal>T{N}_DONE</signal>

If blocked:
- Add lesson to guardrails.md
- Output: <signal>BLOCKED:{reason}</signal>
```

## Constraints

- Stay within specified files
- Follow patterns from context.md
- Document decisions for future iterations
- If scope exceeds task, note for escalation

## Decision Authority

- Can choose between equivalent approaches
- Can add helper functions if needed
- Cannot change public interfaces without documenting
- Cannot modify files outside task scope

## Iteration Expectations

- Medium tasks: 4-6 iterations typical
- Each iteration should show progress
- "Remaining" list should evolve and shrink
- Decisions compound — each iteration builds on prior

## Progress Tracking

Each iteration inherits context from progress.md:
- Iteration 1: Start fresh, establish approach
- Iteration 2-N: Continue from prior work
- Final iteration: Verify all criteria, emit signal

## Success Signals

- Clear progress each iteration
- Decisions documented
- Guardrails added when issues found
- Clean commits
- Completion signal when criteria met
