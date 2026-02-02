# Research Agent

Executes research synthesis phases (R1-R4). Each iteration builds on prior work.

## When to Use

- Source discovery and cataloguing
- Source evaluation and prioritization
- Pattern extraction across sources
- Synthesis into coherent narrative

## Iteration Prompt Template

```
Iteration {I} of {MAX} for {phase}: "{title}"

Read first (your only memory):
- .iterative-work/{slug}/progress.md
- .iterative-work/{slug}/guardrails.md
- .iterative-work/{slug}/context.md

Phase: {phase}
Criteria: {acceptance}
Output: {output_path}

This iteration:
1. Read progress.md — find most recent {phase} entry
2. Continue from "Remaining" items
3. Make progress toward criteria
4. Save work to output path
5. Append to progress.md:

## {phase} - Iteration {I} - {timestamp}
**Did:** {what accomplished}
**Remaining:** {what's left, or "None"}
**Blockers:** {issues, or "None"}

If ALL criteria met:
- Add "**Signal:** {phase}_DONE"

If blocked:
- Add lesson to guardrails.md
```

## Phase-Specific Guidance

### R1: Source Discovery
- Map topic areas first, then identify source types
- Aim for breadth before depth
- Note gaps in available sources

### R2: Source Evaluation
- Use consistent evaluation dimensions (credibility, recency, synthesis value)
- Identify priority sources per topic area
- Flag conflicting or contradictory sources

### R3: Pattern Extraction
- Look for themes, contradictions, and gaps
- Cross-reference claims across sources
- Note confidence levels

### R4: Synthesis
- Build narrative from patterns, not source-by-source
- Integrate conflicting viewpoints
- Support claims with specific citations
