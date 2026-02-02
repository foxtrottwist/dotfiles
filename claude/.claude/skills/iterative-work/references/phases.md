# Phase Format

Structure for phases that will each run as an iteration loop.

## Template

```markdown
# {Task} - Phases

**Created:** {timestamp}
**Domain:** {research|writing|analysis|planning}
**Total:** {N} phases
**Status:** {X} done, {Y} in progress, {Z} pending

## Dependencies

```
R1 ──► R2 ──► R3 ──► R4
```

## Phases

- [ ] **R1**: {title}
  - Criteria: {measurable acceptance}
  - Output: `{file_path}`
  - Completion: `<signal>R1_DONE</signal>`
  - Max iterations: 5
  - Depends: none
  - Model: sonnet

- [ ] **R2**: {title}
  - Criteria: {acceptance}
  - Output: `{file_path}`
  - Completion: `<signal>R2_DONE</signal>`
  - Max iterations: 5
  - Depends: R1
  - Model: sonnet

## Notes

{Context for iterations}
```

## Field Definitions

### Required Fields

| Field | Purpose |
|-------|---------|
| Title | Clear, outcome-oriented description |
| Criteria | Measurable acceptance conditions |
| Output | Path to deliverable file(s) |
| Completion | Signal to emit when done |
| Max iterations | Safety limit for the loop |
| Depends | Phase dependencies (or "none") |
| Model | haiku, sonnet, or opus |

### Max Iterations Guide

| Phase Complexity | Max Iterations | Signals |
|------------------|----------------|---------|
| Simple | 3 | Clear criteria, single output, mechanical work |
| Medium | 5 | Some judgment, multiple aspects, moderate synthesis |
| Complex | 8 | Heavy synthesis, quality bar, multiple sources |

**Rule**: Start conservative. You can always increase if a phase times out. Better to iterate than to have a runaway loop.

### Model Selection

| Phase Type | Model | Rationale |
|------------|-------|-----------|
| Source listing, data collection | haiku | Pattern matching, straightforward extraction |
| Simple evaluation, formatting | haiku | Mechanical judgment |
| Standard research synthesis | sonnet | Balanced capability |
| Document drafting | sonnet | Structured output |
| Section revision | sonnet | Targeted improvements |
| Complex pattern analysis | opus | Multi-factor reasoning |
| Final synthesis, recommendations | opus | Nuanced judgment |
| Strategic planning, tradeoffs | opus | Complex evaluation |

**Default**: sonnet (best balance of capability and cost)

**Parallel optimization**: For phases that spawn multiple sub-agents (e.g., analyzing 5 documents), consider haiku for straightforward extraction to minimize cost and latency.

## Good vs Bad Phases

### Good Phase

```markdown
- [ ] **R2**: Source Evaluation
  - Criteria:
    - Each source rated on credibility (1-5)
    - Recency assessment (current, dated, historical)
    - Synthesis value noted (primary, supporting, background)
    - Priority sources identified per topic area
  - Output: `sources/evaluation.md`
  - Completion: `<signal>R2_DONE</signal>`
  - Max iterations: 5
  - Depends: R1
  - Model: sonnet
```

Why it's good:
- Clear, specific title
- Measurable criteria (can verify each point)
- Single output file
- Reasonable iteration limit
- Appropriate model for judgment-based work

### Bad Phase

```markdown
- [ ] **R1**: Research the topic
  - Criteria: find good sources
  - Output: notes
  - Completion: `<signal>R1_DONE</signal>`
  - Max iterations: 3
  - Depends: none
  - Model: haiku
```

Problems:
- Too vague ("research the topic")
- Unmeasurable criteria ("good sources")
- Unclear output location ("notes")
- Too few iterations for research complexity
- Wrong model (haiku for open-ended research)

### Fixed Version

```markdown
- [ ] **R1**: Source Discovery - AI Governance Frameworks
  - Criteria:
    - 10+ relevant sources identified
    - Sources span academic, policy, and industry perspectives
    - Bibliography includes title, author, date, URL, source type
    - Topic areas mapped (regulatory, technical, ethical, economic)
  - Output: `sources/bibliography.md`
  - Completion: `<signal>R1_DONE</signal>`
  - Max iterations: 5
  - Depends: none
  - Model: sonnet
```

## Status Annotations

As phases complete, update the checkbox and add notes:

```markdown
- [x] **R1**: Source Discovery <!-- DONE: 3 iterations -->
- [ ] **R2**: Source Evaluation <!-- IN_PROGRESS: iteration 2 -->
- [ ] **R3**: Pattern Extraction <!-- BLOCKED: Waiting on R2 -->
- [ ] **R4**: Synthesis <!-- PENDING -->
```

## Dependency Notation

- `none` — Can start immediately
- `R1` — Wait for R1 to complete
- `R1, R2` — Wait for both (all must complete)
- `R1 | R2` — Wait for either (any can unblock)

## Iteration Budget Planning

For a task, estimate total iterations:

```
R1: 5 max → expect 3
R2: 5 max → expect 4
R3: 5 max → expect 3
R4: 8 max → expect 5
Review: 3 max → expect 2
Revisions: 5 max → expect 2
─────────────────────────
Total budget: ~19 iterations
```

This helps estimate execution time and manage expectations.

## Multi-Session Tasks

For large tasks (>6 phases or >40 total iterations):

1. Split into parts: `plan-part1.md`, `plan-part2.md`
2. Each part should end at a stable, usable state
3. Track in state.json: `{ "current_part": "part2" }`
4. Archive completed parts

Example split:
- Part 1: Research phases (R1-R4)
- Part 2: Writing phases (D1-D4)

## Criteria Writing Guide

Good criteria are:
- **Specific**: Name exact deliverables, counts, categories
- **Verifiable**: Can check against the output
- **Complete**: Cover all aspects of "done"
- **Independent**: Don't rely on other phases

Examples:

| Weak | Strong |
|------|--------|
| "Sources found" | "10+ sources with title, author, date, URL" |
| "Analysis complete" | "Patterns documented with 3+ examples each" |
| "Draft written" | "All sections drafted, 500+ words per section" |
| "Good quality" | "Meets style guide, no unsupported claims" |

## Parallel Execution

Some phases can run sub-agents in parallel:

```markdown
- [ ] **A1**: Document Analysis (5 documents)
  - Criteria: Each document analyzed for claims, methodology, limitations
  - Output: `analysis/{doc-name}.md` per document
  - Completion: `<signal>A1_DONE</signal>`
  - Max iterations: 3
  - Depends: none
  - Model: haiku (per-document agents)
  - Parallel: true
```

When `Parallel: true`:
- Launch one sub-agent per document/item
- Use haiku for straightforward extraction
- Progress entries will interleave
- Phase completes when all sub-agents finish

## Domain-Specific Guidance

See [domains.md](domains.md) for phase templates per domain:
- Research: R1→R2→R3→R4
- Writing: D1→D2→D3→D4
- Analysis: A1→A2→A3→A4
- Planning: P1→P2→P3→P4
