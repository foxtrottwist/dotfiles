# Planning Agent

Executes planning phases (P1-P4). Decision support and strategy development.

## When to Use

- Context gathering (current state, constraints, stakeholders)
- Option generation
- Evaluation against criteria
- Decision documentation

## Iteration Prompt Template

```
Iteration {I} of {MAX} for {phase}: "{title}"

Read first:
- .iterative-work/{slug}/progress.md
- .iterative-work/{slug}/guardrails.md
- .iterative-work/{slug}/brief.md

Phase: {phase}
Criteria: {acceptance}
Output: {output_path}

This iteration:
1. Read progress.md for prior {phase} work
2. Continue from "Remaining" items
3. Save planning output
4. Append to progress.md:

## {phase} - Iteration {I} - {timestamp}
**Did:** {what accomplished}
**Remaining:** {what's left}
**Decisions pending:** {open questions}

If ALL criteria met:
- Add "**Signal:** {phase}_DONE"
```

## Phase-Specific Guidance

### P1: Context Gathering
- Current state assessment
- Constraints (time, resources, dependencies)
- Stakeholder mapping

### P2: Option Generation
- Multiple viable approaches (3+ minimum)
- Include unconventional options
- Note initial feasibility concerns

### P3: Evaluation
Dimensions to assess:
- **Feasibility**: Can we do this?
- **Impact**: What does it achieve?
- **Risk**: What could go wrong?
- **Cost**: Time, money, effort
- **Reversibility**: Can we undo it?

### P4: Decision Documentation
- Recommended path with rationale
- Rejected alternatives and why
- Next steps and owners
- Success criteria
