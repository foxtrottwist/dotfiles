# Domain Templates

Phase templates for each knowledge work domain.

## Research Synthesis

For literature review, source synthesis, investigation.

```markdown
- [ ] **R1**: Source Discovery
  - Criteria: {N} relevant sources identified, topic areas mapped
  - Output: `sources/bibliography.md`
  - Max iterations: 5

- [ ] **R2**: Source Evaluation
  - Criteria: Each source assessed for credibility, relevance, recency
  - Output: `sources/evaluation.md`
  - Max iterations: 5

- [ ] **R3**: Pattern Extraction
  - Criteria: Key themes, contradictions, gaps identified
  - Output: `analysis/patterns.md`
  - Max iterations: 5

- [ ] **R4**: Synthesis
  - Criteria: Coherent narrative integrating sources
  - Output: `outputs/synthesis.md`
  - Max iterations: 8
```

### R1 Criteria Examples
- "5-7 topic areas identified with source types per area"
- "At least 10 relevant sources catalogued"

### R2 Criteria Examples
- "Sources rated on credibility (1-5), recency, synthesis value"
- "Priority sources identified per topic area"

## Document Production

For reports, articles, proposals, written deliverables.

```markdown
- [ ] **D1**: Structure Development
  - Criteria: Outline with section purposes, flow logic
  - Output: `drafts/outline.md`
  - Max iterations: 3

- [ ] **D2**: Section Drafting
  - Criteria: Complete first draft of all sections
  - Output: `drafts/draft-v1.md`
  - Max iterations: 5

- [ ] **D3**: Revision Pass
  - Criteria: Clarity, flow, evidence integration improved
  - Output: `drafts/draft-v2.md`
  - Max iterations: 5

- [ ] **D4**: Final Polish
  - Criteria: Voice consistency, formatting, ready for delivery
  - Output: `outputs/final.md`
  - Max iterations: 3
```

### Quality Checklist (for D3/D4)
- [ ] Clear thesis or central argument
- [ ] Supporting points with evidence
- [ ] Coherent flow between sections
- [ ] Appropriate tone for audience
- [ ] No unsupported claims

## Analysis Workflow

For data interpretation, pattern identification, recommendations.

```markdown
- [ ] **A1**: Data Gathering
  - Criteria: All relevant inputs collected, organized
  - Output: `data/collected/`
  - Max iterations: 5

- [ ] **A2**: Pattern Identification
  - Criteria: Trends, anomalies, relationships documented
  - Output: `analysis/patterns.md`
  - Max iterations: 5

- [ ] **A3**: Interpretation
  - Criteria: Findings contextualized, implications drawn
  - Output: `analysis/interpretation.md`
  - Max iterations: 5

- [ ] **A4**: Recommendations
  - Criteria: Actionable next steps with rationale
  - Output: `outputs/recommendations.md`
  - Max iterations: 5
```

### A2 Pattern Categories
- Trends (directional changes over time)
- Anomalies (unexpected values or behaviors)
- Correlations (relationships between variables)
- Gaps (missing data or coverage)

## Planning Workflow

For decisions, strategy, project planning.

```markdown
- [ ] **P1**: Context Gathering
  - Criteria: Current state, constraints, stakeholders mapped
  - Output: `planning/context.md`
  - Max iterations: 5

- [ ] **P2**: Option Generation
  - Criteria: Multiple viable approaches identified
  - Output: `planning/options.md`
  - Max iterations: 5

- [ ] **P3**: Evaluation
  - Criteria: Options assessed against criteria, tradeoffs clear
  - Output: `planning/evaluation.md`
  - Max iterations: 5

- [ ] **P4**: Decision Documentation
  - Criteria: Recommended path with rationale, next steps
  - Output: `outputs/decision.md`
  - Max iterations: 3
```

### P3 Evaluation Dimensions
- Feasibility (can we do this?)
- Impact (what does it achieve?)
- Risk (what could go wrong?)
- Cost (time, money, effort)
- Reversibility (can we undo it?)

## Iteration Limits

| Phase Complexity | Max Iterations | Characteristics |
|------------------|----------------|-----------------|
| Simple | 3 | Clear criteria, single output |
| Medium | 5 | Some judgment, multiple aspects |
| Complex | 8 | Synthesis required, quality bar |

Start conservative. Increase if phase times out without completion.

## Combining Domains

Some tasks span domains:

**Research → Writing**: R1-R4 then D1-D4
**Analysis → Planning**: A1-A4 then P1-P4
**Research → Analysis**: R1-R2 then A1-A4

Note dependencies in `plan.md`.
