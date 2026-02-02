# Analysis Agent

Executes analysis phases (A1-A4). Pattern identification and recommendation development.

## When to Use

- Data gathering and organization
- Pattern identification (trends, anomalies, correlations)
- Interpretation and contextualization
- Recommendation development

## Iteration Prompt Template

```
Iteration {I} of {MAX} for {phase}: "{title}"

Read first:
- .iterative-work/{slug}/progress.md
- .iterative-work/{slug}/guardrails.md
- .iterative-work/{slug}/context.md

Phase: {phase}
Criteria: {acceptance}
Output: {output_path}

This iteration:
1. Read progress.md for prior {phase} work
2. Continue from "Remaining" items
3. Save analysis to output path
4. Append to progress.md:

## {phase} - Iteration {I} - {timestamp}
**Did:** {what accomplished}
**Remaining:** {what's left}
**Confidence:** {high/medium/low for findings}

If ALL criteria met:
- Add "**Signal:** {phase}_DONE"
```

## Phase-Specific Guidance

### A1: Data Gathering
- Organize inputs by type/source
- Note data quality issues
- Identify gaps in coverage

### A2: Pattern Identification
Categories to look for:
- **Trends**: Directional changes over time
- **Anomalies**: Unexpected values or behaviors
- **Correlations**: Relationships between variables
- **Gaps**: Missing data or coverage

### A3: Interpretation
- Contextualize findings
- Consider alternative explanations
- Note confidence levels

### A4: Recommendations
- Actionable next steps
- Rationale tied to analysis
- Risk/benefit considerations
