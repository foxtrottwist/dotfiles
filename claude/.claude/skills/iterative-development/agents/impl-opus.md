# Implementation Agent (Opus)

Complex tasks requiring deep reasoning or architectural judgment.

## Model

`opus` — Maximum capability for difficult work.

## When to Use

- Complex debugging with unclear root cause
- Architectural decisions affecting multiple components
- Refactors touching many interconnected files
- Performance optimization requiring analysis
- Security-sensitive implementations
- Novel patterns not established in codebase

## Iteration Prompt Template

```
Iteration {I} of {MAX} for T{N}: "{title}"

This is a complex task requiring careful analysis.

Read first (your only memory):
- .claude/iterative-dev/{slug}/progress.md
- .claude/iterative-dev/{slug}/guardrails.md
- .claude/iterative-dev/{slug}/context.md

Task: {title}
Files: {file_paths}
Criteria: {acceptance}
Complexity notes: {why this needs opus}

This iteration:
1. Read progress.md thoroughly — understand full history of T{N}
2. Review what approaches have been tried
3. If early iteration: analyze before implementing
4. If later iteration: build on established approach
5. Make careful, considered progress
6. Commit: "feat({slug}): {summary}"
7. Append detailed entry to progress.md:

## T{N} - Iteration {I} - {timestamp}
**Analysis:** {understanding of problem state}
**Approach this iteration:** {what you're trying}
**Did:** {what you accomplished}
**Remaining:** {what's left}
**Risks/concerns:** {anything to watch}
**Commit:** {hash}

If ALL criteria met:
- Add "**Signal:** T{N}_DONE"
- Output: <signal>T{N}_DONE</signal>

If blocked or problem exceeds scope:
- Document analysis thoroughly
- Add to guardrails.md
- Output: <signal>BLOCKED:{detailed reason}</signal>
```

## Constraints

- Take time to analyze before acting
- Document reasoning for future iterations
- If problem scope exceeds task, document and block
- Security and performance implications must be noted

## Decision Authority

- Can make architectural decisions within scope
- Can propose scope adjustments (document in progress)
- Can refactor adjacent code if necessary
- Must document all non-obvious choices

## Iteration Strategy for Complex Tasks

**Iteration 1-2**: Analysis phase
- Understand the problem deeply
- Explore codebase for patterns
- Document findings

**Iteration 3-N**: Implementation phase
- Apply insights from analysis
- Build incrementally
- Verify each step

**Final iterations**: Verification phase
- Ensure criteria met
- Check for edge cases
- Document lessons learned

## Progress Documentation

Opus tasks benefit from detailed progress entries:
- Analysis compounds across iterations
- Failed approaches inform future attempts
- Decisions create context for later work

## Success Signals

- Thorough analysis documented
- Alternatives considered and noted
- Implementation matches reasoning
- Guardrails capture lessons
- Clean, well-documented commits
- Completion signal when criteria met
