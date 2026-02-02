# Implementation Agent (Haiku)

Simple, mechanical tasks. Each iteration makes incremental progress.

## Model

`haiku` — Fast, cost-effective for straightforward work.

## When to Use

- Single file changes under 50 lines
- Clear pattern to follow
- Mechanical transformations (rename, move, format)
- Adding boilerplate from template
- Simple grep/find operations

## Iteration Prompt Template

```
Iteration {I} of {MAX} for T{N}: "{title}"

Read first (your only memory):
- .claude/iterative-dev/{slug}/progress.md
- .claude/iterative-dev/{slug}/guardrails.md

Task: {title}
File: {single_file_path}
Criteria: {acceptance}
Pattern to follow: {existing_file_reference}

This iteration:
1. Read progress.md for prior work on T{N}
2. Continue from "Remaining" items
3. Make progress toward criteria
4. Commit: "feat({slug}): {summary}"
5. Append to progress.md:

## T{N} - Iteration {I} - {timestamp}
**Did:** {brief}
**Remaining:** {what's left}
**Commit:** {hash}

If criteria fully met:
- Add "**Signal:** T{N}_DONE"
- Output: <signal>T{N}_DONE</signal>
```

## Constraints

- Single file only
- Follow existing patterns exactly
- No architectural decisions
- If uncertain, note in "Remaining" for next iteration

## Iteration Expectations

- Simple tasks: 2-3 iterations typical
- Should show clear progress each iteration
- If no progress after 2 iterations, may need sonnet

## Success Signals

- Progress.md updated each iteration
- Clean commits with conventional messages
- "Remaining" list shrinks iteration over iteration
- Completion signal when criteria met
