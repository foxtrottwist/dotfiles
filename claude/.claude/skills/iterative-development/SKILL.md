---
name: iterative-development
description: Development task orchestration using stateless iteration. Decomposes features into atomic tasks, runs each through fresh-context iterations until completion, persists state in files. Handles implementation, review, and fix cycles. Supports resuming at any phase after interruption.
---

# Iterative Development

Development task orchestration using fresh-context iteration loops. Each task runs as multiple stateless iterations—context resets every pass, state persists in files.

## Core Pattern

```
Fresh context EVERY iteration.
State persists in files + git.
Progress file = notes to your next iteration.
```

This builds on the Ralph Wiggum Technique (Geoffrey Huntley): instead of growing conversation history until context degrades, reset the context window every iteration. State lives in files. Each fresh agent reads those files to pick up where the last one left off.

## Workflow

```
RESUME?   →   INTERVIEW   →   PLAN   →   LOOP   →   CHECK   →   WRAP
(check        (discover)     (tasks)   (iterate)  (review)   (commit)
 state)
```

## Phase 0: Resume Check

**Every invocation**, check for existing work:

```bash
ls .claude/iterative-dev/ 2>/dev/null
```

**If state exists**, read `state.json` and present:
```
Found "{feature}" at phase {N}:
- Completed: T1, T2, T3
- Current: T4 (iteration 3 of max 10)
- Remaining: T5, T6

Resume, start fresh, or check status?
```

**If no state**, proceed to Interview.

## Phase 1: Interview

Use the **AskUserQuestion tool** to gather requirements. This built-in tool only works in main session—sub-agents cannot ask questions.

**Invoke AskUserQuestion** with structured questions:

```
Use AskUserQuestion to clarify requirements:

Question 1: "What are we building?"
Options:
- {inferred from prompt} (Recommended)
- New feature
- Bug fix  
- Refactor
- Other

Question 2: "How will we know it's done?"
Options (multiSelect: true):
- All tests passing
- Manual verification works
- Specific behavior achieved
- Code review approved

Question 3: "Any constraints?"
Options (multiSelect: true):
- Backward compatibility required
- Performance critical
- Accessibility requirements
- Platform specific
- None

Question 4: "Technical approach?"
Options:
- Follow existing patterns (Recommended)
- Specific approach: [input]
- Explore codebase first
```

**Tool behavior:**
- User sees clickable options
- 60-second timeout per question
- User can always select "Other" for free text
- Mark recommended option first with "(Recommended)"

See [references/interview.md](references/interview.md) for additional question templates.

**Output:**
- Create `.claude/iterative-dev/{feature-slug}/`
- Write `prd.md` with requirements
- Write `state.json`: `{ "phase": "plan" }`

## Phase 2: Plan

Decompose into atomic tasks. Each task will run as its own iteration loop.

**Sizing rule**: Tasks should be completable, but iterations handle complexity. Size for clarity, not minimalism.

| Size | Max Iterations | Characteristics |
|------|----------------|-----------------|
| Simple | 3-5 | Single file, clear pattern |
| Medium | 5-10 | 2-3 files, some complexity |
| Complex | 10-15 | Multiple files, new patterns |

**Task format:**
```markdown
- [ ] **T1**: {title}
  - Files: `{paths}`
  - Criteria: {measurable acceptance}
  - Completion: `<signal>T1_DONE</signal>`
  - Max iterations: 5
  - Depends: none
  - Model: haiku | sonnet | opus
```

**Model selection guide:**

| Task Type | Model | Why |
|-----------|-------|-----|
| File operations, grep, simple edits | haiku | Mechanical work |
| Standard implementation | sonnet | Balanced capability |
| Code review, test generation | sonnet | Structured output |
| Complex debugging, architecture | opus | Deep reasoning |

See [references/tasks.md](references/tasks.md) for format details.

**Output:**
- Write `tasks.md`
- Write `context.md` (brief summary for sub-agents)
- Create empty `guardrails.md`
- Create empty `progress.md`
- Update `state.json`: `{ "phase": "loop", "current": "T1", "iteration": 0 }`
- Present plan for user approval

## Phase 3: Loop (Execute)

This is the core pattern. **Each task runs as its own loop of fresh-context iterations.**

### Task Loop Structure

For each task (respecting dependencies):

```
┌─────────────────────────────────────────────────┐
│  TASK LOOP (T1)                                 │
│                                                 │
│  Iteration 1: Fresh agent → reads state → works │
│       ↓                                         │
│  Iteration 2: Fresh agent → reads progress → continues
│       ↓                                         │
│  Iteration N: Agent declares DONE               │
│       ↓                                         │
│  Programmatic checks (build, lint, tests)       │
│       ↓                                         │
│  Confirmation pass (N+1): Fresh agent, same task│
│       ↓                                         │
│  Verification agent: Code review                │
│       ↓                                         │
│  Task complete                                  │
└─────────────────────────────────────────────────┘
```

See [references/verification.md](references/verification.md) for the complete verification hierarchy.

### Dispatch Fresh Sub-Agent (Each Iteration)

**Critical**: Each iteration spawns a completely fresh sub-agent. No memory of previous iterations except what's in files.

```
Iteration {I} of {MAX} for T{N}: "{title}"

Read these files first (your only memory):
- .claude/iterative-dev/{slug}/progress.md
- .claude/iterative-dev/{slug}/guardrails.md
- .claude/iterative-dev/{slug}/context.md

Task: {title}
Files: {paths}
Criteria: {acceptance}

Your job this iteration:
1. Read progress.md to see what previous iterations accomplished
2. Continue from where they left off
3. Work toward the criteria
4. Commit any meaningful progress: "feat({slug}): {summary}"
5. Update progress.md with what you did and what remains
6. If criteria fully met, output: <signal>T{N}_DONE</signal>
7. If blocked, output: <signal>BLOCKED:{reason}</signal>

If not done and not blocked, just exit. Next iteration will continue.
```

### Progress File is Critical

The progress file bridges context windows. Each iteration appends:

```markdown
## T1 - Iteration 1 - {timestamp}
**Did:** Set up file structure, created User model skeleton
**Remaining:** Add properties, implement Codable
**Blockers:** None
**Commit:** abc1234

## T1 - Iteration 2 - {timestamp}  
**Did:** Added all properties, Codable conformance
**Remaining:** SwiftData annotations
**Blockers:** None
**Commit:** def5678

## T1 - Iteration 3 - {timestamp}
**Did:** Added SwiftData annotations, all criteria met
**Remaining:** None
**Signal:** T1_DONE
**Commit:** ghi9012
```

### Loop Control

**Main session orchestrates** but does not carry task context:

```python
# Pseudocode for main session
for task in tasks:
    iteration = 0
    while iteration < task.max_iterations:
        iteration += 1
        update_state(task, iteration)
        
        # Dispatch fresh sub-agent
        result = spawn_fresh_agent(task, iteration)
        
        if "DONE" in result:
            mark_complete(task)
            break
        elif "BLOCKED" in result:
            log_blocked(task, result)
            break
        # else: continue to next iteration
    
    if iteration >= task.max_iterations:
        log_timeout(task)
```

### Fresh Context Discipline

**Include** in sub-agent prompt:
- Task ID, title, criteria
- Current iteration number and max
- File paths to read (progress, guardrails, context)
- File paths to modify

**Exclude** from sub-agent prompt:
- Full PRD content
- Other task details
- Previous iteration outputs
- Conversation history

**Let agents read files.** Don't paste content into prompts.

### After Each Iteration

1. Check for completion signal in output
2. Update `state.json` with iteration count
3. Verify progress.md was updated
4. If DONE: proceed to task completion gates
5. If BLOCKED: log reason, move to next unblocked task
6. If max iterations: log timeout, report to user

### Task Completion Gates

When an agent declares DONE, the task passes through verification gates:

1. **Programmatic checks** — Build, lint, tests must pass
2. **Confirmation pass (N+1)** — Fresh agent receives same task prompt, attempts to complete it. If truly done, finds nothing to do. If incomplete, continues work.
3. **Verification agent** — Code review with adversarial mindset. See [agents/verify.md](agents/verify.md).

Only after all gates pass is the task marked complete. This catches both incomplete work (confirmation) and flawed work (verification).

### Parallel Task Execution

Tasks without dependencies can run concurrent loops:

```
Launch parallel task loops:

T2 Loop: max 5 iterations [model: sonnet]
T4 Loop: max 3 iterations [model: haiku]

Each task runs its own iteration cycle independently.
```

## Phase 4: Check (Review)

Review runs as its own iteration loop until PASS or max attempts:

```
Review iteration {I} for "{feature}".

Read:
- .claude/iterative-dev/{slug}/tasks.md
- .claude/iterative-dev/{slug}/progress.md
- .claude/iterative-dev/{slug}/guardrails.md

Verify:
1. Code builds without warnings
2. Each task's acceptance criteria met
3. Code follows project patterns
4. Tests pass (if applicable)

If all checks pass: <signal>REVIEW_PASS</signal>

If issues found, list them:
[error] {file}:{line} - {issue}
[warning] {file}:{line} - {issue}

Then output: <signal>REVIEW_FAIL</signal>
```

**On REVIEW_FAIL:**
- Dispatch fix loop (fresh iterations) per issue
- Re-run review loop
- Repeat until PASS or max review cycles

## Phase 5: Wrap (Commit)

1. Squash commits if requested (or keep granular)
2. Run final build/test verification
3. Present summary:
   ```
   Feature: {name}
   Tasks: {N} completed
   Total iterations: {sum across tasks}
   Files: {list}
   Commits: {count}
   
   Ready to push?
   ```
4. Archive state to `.claude/iterative-dev/archive/{slug}/`
5. Update `state.json`: `{ "phase": "complete" }`

## State Files

All state lives in `.claude/iterative-dev/{feature-slug}/`:

```
.claude/iterative-dev/
├── {feature-slug}/
│   ├── state.json      # Phase, current task, iteration count
│   ├── prd.md          # Requirements from interview
│   ├── tasks.md        # Task breakdown with status
│   ├── context.md      # Brief summary for sub-agents
│   ├── progress.md     # Iteration log
│   └── guardrails.md   # Accumulated lessons
└── archive/            # Completed features
```

### state.json Schema

```json
{
  "feature": "user-authentication",
  "slug": "user-auth",
  "phase": "loop",
  "current_task": "T3",
  "current_iteration": 2,
  "max_iteration": 10,
  "tasks": {
    "T1": { "status": "done", "iterations": 3 },
    "T2": { "status": "done", "iterations": 5 },
    "T3": { "status": "in_progress", "iterations": 2 },
    "T4": { "status": "pending" },
    "T5": { "status": "pending" }
  },
  "blocked": {}
}
```

See [references/state.md](references/state.md) for full schemas.

## Guardrails

Sub-agents read `guardrails.md` before starting and append when they hit problems:

```markdown
## Don't trust token claims
- **When**: Implementing auth
- **Do**: Always validate server-side
- **Learned**: T3 iteration 2 - Security issue

## Use DateFormatter.shared
- **When**: Displaying dates
- **Do**: Don't create inline formatters
- **Learned**: T2 iteration 4 - Performance note
```

Guardrails accumulate across iterations and tasks. Every fresh agent benefits from past lessons.

## Resuming

**After interruption** (network, timeout, new session):

1. Skill detects existing state
2. Reads `state.json` for phase, task, and iteration
3. Reads `progress.md` for what happened
4. Resumes at exact iteration point

```
Found "user-auth" in loop phase:
- Task: T3 "Create auth service"
- Iteration: 2 of 10
- Last progress: "Added login method, working on token refresh"

Resume from iteration 3?
```

**Skip to phase:**
```
/iter-dev skip-to review
```

**Check status:**
```
/iter-dev status
```

## Sub-Agent Definitions

Install these in `.claude/agents/` for model optimization:

- `impl-haiku.md` — Simple implementations
- `impl-sonnet.md` — Standard implementations
- `impl-opus.md` — Complex implementations
- `review.md` — Feature-level review (cross-task integration)
- `verify.md` — Task-level verification (code review after confirmation)
- `fix.md` — Issue fixes
- `test.md` — Test generation

See [agents/](agents/) directory for definitions.

## Anti-Patterns

- **Carrying context**: Passing previous iteration output into next prompt
- **Giant tasks**: Let iterations handle complexity, but scope tasks reasonably
- **Skipping progress updates**: Next iteration has no idea what happened
- **Ignoring guardrails**: Repeat past mistakes across iterations
- **Too few iterations**: Complex tasks need room to converge
- **Too many iterations**: Thrashing without progress wastes resources

## Quick Reference

| Command | Action |
|---------|--------|
| `/iter-dev {description}` | Start new feature |
| `/iter-dev resume` | Continue from exact point |
| `/iter-dev status` | Check progress with iteration counts |
| `/iter-dev skip-to {phase}` | Jump to phase |

## Attribution

This skill builds on the Ralph Wiggum Technique (Geoffrey Huntley): a loop that repeatedly invokes an agent with a prompt file, allowing iterative refinement until completion. Instead of growing conversation history until context degrades, reset the context window every iteration. State lives in files. Each fresh agent reads those files to pick up where the last one left off.

Anthropic's documentation on long-running agents and sub-agent coordination informed the dispatch mechanics.
