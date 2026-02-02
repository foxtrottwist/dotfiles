# State Management

File schemas for iterative-work state persistence.

## Directory Structure

```
.iterative-work/
├── {task-slug}/
│   ├── state.json      # Machine-readable status
│   ├── brief.md        # Requirements from discovery
│   ├── plan.md         # Phase breakdown
│   ├── context.md      # Brief summary for iterations
│   ├── progress.md     # Iteration log (critical)
│   ├── guardrails.md   # Accumulated lessons
│   ├── sources/        # Research inputs
│   └── outputs/        # Deliverables
└── archive/            # Completed tasks
```

## state.json Schema

```json
{
  "task": "future-of-work-synthesis",
  "slug": "future-work",
  "created": "2026-01-16T10:00:00Z",
  "updated": "2026-01-16T14:30:00Z",
  "domain": "research",
  "phase": "execute",
  "current_phase": "R3",
  "current_iteration": 2,
  "phases": {
    "R1": {
      "status": "done",
      "iterations_used": 3,
      "confirmations_used": 1,
      "verification_passed": true,
      "max_iterations": 5,
      "completed_at": "2026-01-16T11:00:00Z"
    },
    "R2": {
      "status": "done",
      "iterations_used": 4,
      "confirmations_used": 1,
      "verification_passed": true,
      "max_iterations": 5,
      "completed_at": "2026-01-16T13:00:00Z"
    },
    "R3": {
      "status": "confirming",
      "iterations_used": 2,
      "confirmations_used": 1,
      "max_iterations": 5
    },
    "R4": {
      "status": "pending",
      "max_iterations": 8
    }
  }
}
```

### Status Values

| Status | Description |
|--------|-------------|
| `pending` | Not yet started |
| `in_progress` | Currently in work iteration loop |
| `confirming` | Work declared done, running mandatory N+1 confirmation |
| `verifying` | Confirmation passed, running verification (quality review) |
| `done` | Passed all gates: work, confirmation, verification |
| `blocked` | Cannot proceed |
| `timeout` | Hit max iterations |

### Phase Lifecycle

```
pending → in_progress → confirming → verifying → done
                ↑            │            │
                └────────────┴────────────┘
                    (if issues found)
```

### Phase Values

| Phase | Description |
|-------|-------------|
| `discover` | Gathering requirements |
| `plan` | Decomposing into phases |
| `execute` | Running iteration loops |
| `verify` | Reviewing completed work |
| `deliver` | Final packaging |
| `complete` | Archived |

## brief.md Template

```markdown
# {Task Name}

**Created:** {timestamp}
**Domain:** {research|writing|analysis|planning}

## Outcome Needed
{What the user wants to achieve}

## Done When
- {Criterion 1}
- {Criterion 2}

## Constraints
- {Time, format, scope constraints}

## Notes
{Additional context}
```

## plan.md Template

```markdown
# {Task Name} - Phases

**Created:** {timestamp}
**Domain:** {domain}
**Total:** {N} phases

## Phases

- [ ] **R1**: {title}
  - Criteria: {measurable}
  - Output: `{path}`
  - Max iterations: {N}

- [ ] **R2**: {title}
  ...

## Dependencies

R1 → R2 → R3 → R4 (sequential)
```

## progress.md Format

```markdown
# Progress Log

## R1 - Iteration 1 - {timestamp}
**Did:** {what accomplished}
**Remaining:** {what's left}
**Blockers:** {issues or "None"}

## R1 - Iteration 2 - {timestamp}
**Did:** {what accomplished}
**Remaining:** None
**Signal:** R1_DONE

## R2 - Iteration 1 - {timestamp}
...
```

**Rules:**
- Each iteration appends; never modify previous entries
- Include timestamp for resumption tracking
- "Remaining" guides next iteration
- "Signal" marks phase completion

## guardrails.md Format

```markdown
# Guardrails

Read before starting any iteration. Append when issues discovered.

## {Pattern Name}
- **Context:** {when this applies}
- **Problem:** {what went wrong}
- **Solution:** {how to avoid}
- **Learned:** R{N} iteration {I}
```

## context.md Template

Keep brief (<200 words). Provides orientation.

```markdown
# {Task} Context

**Goal:** {One sentence}

**Approach:** {One sentence}

**Key outputs:**
- `outputs/synthesis.md` — Final deliverable
- `analysis/patterns.md` — Intermediate findings

**Patterns to follow:**
- {Any conventions or style notes}

**Phase signals:**
- R1: Source discovery complete
- R2: Evaluation complete
- R3: Patterns extracted
- R4: Synthesis complete
```

## Recovery Scenarios

### Session Interruption
1. Read `state.json` for current phase/iteration
2. Read `progress.md` for last entry
3. Resume from "Remaining" items

### Phase Timeout
1. Mark phase status as `timeout`
2. Log in progress.md what was attempted
3. Ask user: increase max, simplify criteria, or intervene

### Blocked Phase
1. Document blocker in progress.md
2. Add to guardrails.md if pattern
3. Ask user for input or skip to next unblocked phase
