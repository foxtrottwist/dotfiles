---
name: iterative-work
description: Knowledge work orchestration using stateless iteration. Handles research synthesis, document production, analysis, and planning workflows. Decomposes into phases, runs each through fresh-context iterations until completion. Supports resumption after interruption.
---

# Iterative Work

Knowledge work orchestration using fresh-context iteration loops. Each phase runs as multiple stateless passes—context resets every iteration, state persists in files.

## Core Pattern

```
Fresh context EVERY iteration.
State persists in files.
Progress file = notes to your next iteration.
```

This builds on the Ralph Wiggum Technique (Geoffrey Huntley): instead of growing conversation history until context degrades, reset the context window every iteration. State lives in files. Each fresh agent reads those files to pick up where the last one left off.

## Workflow

```
RESUME?  →  DISCOVER  →  PLAN  →  EXECUTE  →  VERIFY  →  DELIVER
(check      (clarify     (phases)  (iterate)  (review)  (package)
 state)      scope)
```

## Phase 0: Resume Check

Every invocation, check for existing work:

```bash
ls .iterative-work/ 2>/dev/null
```

**If state exists**, read `state.json` and present:
```
Found "{task}" at phase {N}:
- Completed: R1, R2
- Current: R3 (iteration 2)
- Remaining: R4

Resume, start fresh, or check status?
```

**If no state**, proceed to Discover.

## Phase 1: Discover

Use the **AskUserQuestion tool** to gather requirements. This built-in tool presents clickable options.

**Core questions:**
1. What outcome do you need? (research / document / analysis / plan)
2. What does "done" look like?
3. Any constraints (time, format, scope)?

See [references/interview.md](references/interview.md) for question templates.

**Output:**
- Create `.iterative-work/{task-slug}/`
- Write `brief.md` with requirements
- Write `state.json`: `{ "phase": "plan" }`

## Phase 2: Plan

Decompose into phases based on domain. See [references/domains.md](references/domains.md) for templates.

| Domain | Phases | Use When |
|--------|--------|----------|
| Research | R1→R2→R3→R4 | Synthesizing sources, literature review |
| Writing | D1→D2→D3→D4 | Documents, reports, articles |
| Analysis | A1→A2→A3→A4 | Data interpretation, recommendations |
| Planning | P1→P2→P3→P4 | Decisions, strategy, project planning |

**Phase format:**
```markdown
- [ ] **R1**: {title}
  - Criteria: {measurable acceptance}
  - Output: `{file_path}`
  - Max iterations: {3-8}
```

**Output:**
- Write `plan.md` with phase breakdown
- Write `context.md` (brief summary)
- Create empty `progress.md` and `guardrails.md`
- Update `state.json`: `{ "phase": "execute", "current": "R1", "iteration": 0 }`
- Present plan for approval

## Phase 3: Execute (Iteration Loop)

Each phase runs as an iteration loop until criteria met or max iterations, then passes through verification gates.

```
┌─────────────────────────────────────────────────┐
│  PHASE LOOP (R2)                                │
│                                                 │
│  Iteration 1: Fresh agent → reads state → works │
│       ↓                                         │
│  Iteration N: Agent declares DONE               │
│       ↓                                         │
│  Confirmation pass (N+1): Fresh agent, same task│
│       ↓                                         │
│  Verification agent: Quality review             │
│       ↓                                         │
│  Phase complete                                 │
└─────────────────────────────────────────────────┘
```

See [references/verification.md](references/verification.md) for the complete verification hierarchy.

### Per Iteration

1. Read `progress.md` for prior work
2. Read `guardrails.md` for lessons learned
3. Continue from "Remaining" items
4. Make progress toward criteria
5. Save checkpoint to outputs
6. Append to `progress.md`:

```markdown
## R1 - Iteration {I} - {timestamp}
**Did:** {what accomplished}
**Remaining:** {what's left, or "None"}
**Blockers:** {issues, or "None"}
```

7. If ALL criteria met: Add `**Signal:** R1_DONE`
8. If blocked: Note blocker, may need user input

See [agents/](agents/) for domain-specific iteration guidance:
- [agents/research.md](agents/research.md) — R1-R4 phases
- [agents/draft.md](agents/draft.md) — D1-D4 phases
- [agents/analyze.md](agents/analyze.md) — A1-A4 phases
- [agents/plan.md](agents/plan.md) — P1-P4 phases
- [agents/verify.md](agents/verify.md) — Phase-level quality review (after confirmation)
- [agents/review.md](agents/review.md) — Task-level review (cross-phase integration)

See [references/prompts.md](references/prompts.md) for iteration prompt templates.

### Progress File is Critical

The progress file bridges iterations:

```markdown
## R2 - Iteration 1 - 2026-01-16T10:00:00
**Did:** Evaluated 4 of 12 sources, created evaluation template
**Remaining:** 8 sources, synthesize scores
**Blockers:** None

## R2 - Iteration 2 - 2026-01-16T10:15:00
**Did:** Completed remaining evaluations
**Remaining:** None
**Signal:** R2_DONE
```

Each iteration reads this to understand state, then appends.

### Phase Completion Gates

When an agent declares DONE, the phase passes through verification gates:

1. **Confirmation pass (N+1)** — Fresh agent receives same phase prompt, attempts to complete it. If truly done, finds nothing to do. If incomplete, continues work.
2. **Verification agent** — Quality review with adversarial mindset. See [agents/verify.md](agents/verify.md).

Only after all gates pass is the phase marked complete. This catches both incomplete work (confirmation) and flawed work (verification).

## Phase 4: Verify (Task Review)

Review completed work against original brief. Runs as iteration loop until PASS.

See [agents/review.md](agents/review.md) for review process.

**If issues found:**
- List specific gaps
- Run [agents/revise.md](agents/revise.md) iterations per issue
- Re-verify

**If all checks pass:** Proceed to Deliver.

## Phase 5: Deliver

1. Compile final outputs
2. Present summary:
   ```
   Task: {name}
   Phases: {N} completed
   Total iterations: {sum}
   Outputs: {file list}
   ```
3. Archive state to `.iterative-work/archive/{slug}/`

## State Files

All state lives in `.iterative-work/{task-slug}/`:

```
.iterative-work/
├── {task-slug}/
│   ├── state.json      # Phase, progress tracking
│   ├── brief.md        # Requirements from discovery
│   ├── plan.md         # Phase breakdown
│   ├── context.md      # Brief summary
│   ├── progress.md     # Iteration log (critical)
│   ├── guardrails.md   # Accumulated lessons
│   ├── sources/        # Research inputs
│   └── outputs/        # Deliverables
└── archive/            # Completed tasks
```

See [references/state.md](references/state.md) for detailed schemas.

## Guardrails

Read `guardrails.md` before each iteration. Append when discovering issues:

```markdown
## {Pattern Name}
- **Context:** {when this applies}
- **Problem:** {what went wrong}
- **Solution:** {how to avoid}
- **Learned:** R{N} iteration {I}
```

Lessons accumulate across iterations and phases.

## Iteration Limits

| Phase Complexity | Max Iterations | Characteristics |
|------------------|----------------|-----------------|
| Simple | 3 | Clear criteria, single output |
| Medium | 5 | Some judgment, multiple aspects |
| Complex | 8 | Synthesis required, quality bar |

Start conservative. Increase if phase times out without completion.

## Resuming

After interruption:

1. Detect existing `.iterative-work/{slug}/` state
2. Read `state.json` for phase and iteration
3. Read `progress.md` for what happened
4. Resume at exact point

## Quick Reference

| Command | Action |
|---------|--------|
| `/iter-work {description}` | Start new task |
| `/iter-work resume` | Continue from exact point |
| `/iter-work status` | Check progress |

## Anti-Patterns

- **Skipping progress updates** — Next iteration has no context
- **Ignoring guardrails** — Repeat past mistakes
- **Giant phases** — Let iterations handle complexity, but scope reasonably
- **Too few iterations** — Complex work needs room to converge

## Attribution

This skill builds on the Ralph Wiggum Technique (Geoffrey Huntley): a loop that repeatedly invokes an agent with a prompt file, allowing iterative refinement until completion. Instead of growing conversation history until context degrades, reset the context window every iteration. State lives in files. Each fresh agent reads those files to pick up where the last one left off.

Anthropic's documentation on long-running agents and sub-agent coordination informed the architecture.
