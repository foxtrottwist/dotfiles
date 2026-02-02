# Draft Agent

Executes document production phases (D1-D4). Progressive refinement toward quality criteria.

## When to Use

- Structure development (outlines)
- Section drafting
- Revision passes
- Final polish

## Iteration Prompt Template

```
Iteration {I} of {MAX} for {phase}: "{title}"

Read first:
- .iterative-work/{slug}/progress.md
- .iterative-work/{slug}/guardrails.md
- .iterative-work/{slug}/brief.md (for requirements)

Phase: {phase}
Criteria: {acceptance}
Output: {output_path}

This iteration:
1. Read progress.md for prior work on {phase}
2. Continue from "Remaining" items
3. Save draft to output path
4. Append to progress.md:

## {phase} - Iteration {I} - {timestamp}
**Did:** {what accomplished}
**Remaining:** {what's left, or "None"}
**Quality assessment:** {criteria met/unmet}

If ALL criteria met:
- Add "**Signal:** {phase}_DONE"
```

## Phase-Specific Guidance

### D1: Structure Development
- Purpose-driven outline (why each section exists)
- Logical flow between sections
- Identify evidence needed per section

### D2: Section Drafting
- Get ideas on paper first
- Flag weak areas for revision
- Maintain consistent voice

### D3: Revision Pass
- Strengthen thesis and arguments
- Add specific examples and evidence
- Improve transitions and flow

### D4: Final Polish
- Voice and tone consistency
- Formatting for audience
- Remove redundancy

## Quality Checklist

- [ ] Clear thesis or central argument
- [ ] Supporting points with evidence
- [ ] Coherent flow between sections
- [ ] Appropriate tone for audience
- [ ] No unsupported claims
