# Verification Agent

Code review of completed task work. Runs **after implementation consensus** — when multiple agents have independently agreed the work is complete.

## Model

`sonnet` — Requires reasoning about correctness, not just pattern matching.

## Purpose

This agent performs **code review**, not implementation. It knows the work is "done" (multiple agents agreed). Its job is adversarial scrutiny: actively trying to find flaws, edge cases, and quality issues.

**Important distinction:**
- **Confirmation pass** = "Do this task" (finds nothing to do if complete)
- **Verification agent** = "Review this work" (assumes complete, critiques it)

## When to Run

After implementation consensus (mandatory N+1 confirmation pass agrees work is done):

```
Implementation Loop (Agent A)
├── Iteration 1...N
└── Agent A declares DONE

Programmatic Gate
└── Build, lint, tests pass

Mandatory Confirmation Pass (Agent B)
├── Agent B receives same prompt: "Complete task T{N}"
├── Agent B examines code, attempts to complete task
└── Agent B finds nothing to do → Declares DONE
    └── Implementation consensus achieved

Programmatic Gate (again)
└── Ensure no regressions

Verification Agent (this agent) ← NOW WE RUN
├── Agent knows this is code review, not implementation
├── Adversarial mindset: find problems
│   ├── VERIFIED → Task complete
│   └── GAPS_FOUND → Fix iteration → Re-verify
│
└── Next task or feature review phase
```

## Verification Hierarchy

Before spawning the verification agent, run programmatic checks. These are faster and objective:

### 1. Programmatic Checks (Automated)

```bash
# Type checking (language-dependent)
tsc --noEmit                    # TypeScript
swift build                     # Swift
cargo check                     # Rust

# Linting
eslint {files}                  # JS/TS
swiftlint lint {files}          # Swift

# Tests
npm test -- --related {files}   # Jest
swift test --filter {module}    # Swift
```

If programmatic checks fail → back to implementation loop immediately. No verification agent needed.

### 2. Verification Agent (This Agent)

Only runs if programmatic checks pass. Focuses on semantic correctness that automation can't catch.

### 3. Feature Review (Later Phase)

Cross-task integration concerns. Verification agent handles single-task correctness.

## Iteration Prompt Template

```
Verification for T{N}: "{title}"

You are verifying work completed by another agent. Your job is to find problems, not confirm success. Approach this adversarially.

Read:
- .claude/iterative-dev/{slug}/tasks.md (find T{N}'s acceptance criteria)
- .claude/iterative-dev/{slug}/progress.md (implementation history for T{N})
- .claude/iterative-dev/{slug}/guardrails.md (known pitfalls)
- The actual implementation files: {file_list}

Verification checklist:

1. CRITERIA AUDIT
   For each acceptance criterion:
   - Is it actually implemented, not just stubbed?
   - Does the implementation match the intent, not just the letter?
   - Are there implicit requirements the criteria missed?

2. EDGE CASE ANALYSIS
   - What happens with empty input?
   - What happens with null/nil/undefined?
   - What happens at boundaries (0, -1, max values)?
   - What happens with malformed data?

3. ERROR HANDLING
   - Are all error paths handled?
   - Are errors propagated correctly?
   - Are error messages meaningful?
   - Can errors leave the system in inconsistent state?

4. INTEGRATION POINTS
   - Do function signatures match callers' expectations?
   - Are types correct at boundaries?
   - Are async/await patterns correct?
   - Are there race conditions?

5. CODE QUALITY
   - Any obvious performance issues? (N+1 queries, unnecessary loops)
   - Any security concerns? (injection, exposure)
   - Does it follow project patterns?

For each issue found:
[gap] {severity: critical|major|minor} {file}:{line} - {description}

Append to progress.md:

## Verify T{N} - {timestamp}
**Criteria checked:** {count} of {total}
**Edge cases examined:** {list}
**Issues found:** {count}

{list each gap if any}

**Programmatic results:**
- Types: {pass/fail}
- Lint: {pass/fail}
- Tests: {pass/fail}

If NO critical or major gaps:
- Add "**Result:** VERIFIED"
- Output: <signal>T{N}_VERIFIED</signal>

If critical or major gaps found:
- Add "**Result:** GAPS_FOUND"
- Output: <signal>T{N}_GAPS:{count}</signal>

The implementation agent will receive your gap list and address them.
```

## Gap Severity Guide

| Severity | Definition | Action |
|----------|------------|--------|
| Critical | Broken functionality, data loss risk, security hole | Must fix before proceeding |
| Major | Missing requirement, unhandled error path, logic error | Must fix before proceeding |
| Minor | Style issue, optimization opportunity, documentation | Fix in review phase or skip |

## Output Formats

### VERIFIED

```
## Verify T3 - 2025-01-14T14:30:00Z
**Criteria checked:** 4 of 4
**Edge cases examined:** empty input, nil user, network timeout
**Issues found:** 0

**Programmatic results:**
- Types: pass
- Lint: pass
- Tests: pass (8/8)

**Result:** VERIFIED

<signal>T3_VERIFIED</signal>
```

### GAPS_FOUND

```
## Verify T3 - 2025-01-14T14:30:00Z
**Criteria checked:** 4 of 4
**Edge cases examined:** empty input, nil user, network timeout
**Issues found:** 2

[gap] major src/services/AuthService.swift:67 - Network timeout not handled, will hang indefinitely
[gap] critical src/services/AuthService.swift:82 - Password compared in plain text, not hashed

**Programmatic results:**
- Types: pass
- Lint: pass
- Tests: pass (8/8) — but tests don't cover timeout case

**Result:** GAPS_FOUND

<signal>T3_GAPS:2</signal>
```

## After GAPS_FOUND

Main session:
1. Parses gap list from verification output
2. Spawns implementation iteration specifically targeting gaps
3. Gap-fix iteration runs (with gap list in prompt)
4. Re-runs programmatic checks
5. Re-runs verification agent
6. Loop until VERIFIED or max attempts

## Gap-Fix Iteration Prompt

```
Fix gaps in T{N}: "{title}"

The verification agent found these issues:

{gap_list}

Read:
- .claude/iterative-dev/{slug}/progress.md (see verification entry)
- .claude/iterative-dev/{slug}/guardrails.md

For each gap:
1. Locate the problem
2. Implement a fix
3. Add test coverage if missing
4. Update guardrails.md if this reveals a pattern

Commit: "fix({slug}): {summary}"

Append to progress.md:

## T{N} Gap Fix - {timestamp}
**Gaps addressed:** {count}
**Fixes:**
- {file}:{line} - {what you changed}
**Tests added:** {list or "None"}
**Commit:** {hash}

Output: <signal>T{N}_GAPS_FIXED</signal>
```

## Max Verification Cycles

Prevent infinite verify-fix loops:
- Default: 3 verification attempts per task
- If still failing after 3, escalate to user
- User can: simplify criteria, intervene manually, or accept with known gaps

## Integration with Task Flow

```
Task T{N} Lifecycle:

1. Implementation Loop (Agent A, iterations 1...N)
   └── Agent A declares DONE

2. Programmatic Gate
   ├── Build passes?
   ├── Lint passes?
   └── Tests pass?
   └── If any fail → back to implementation

3. Mandatory Confirmation Pass (Agent B)
   │   Agent B receives SAME prompt: "Complete task T{N}: {title}"
   │   Agent B doesn't know this is confirmation
   │   Agent B examines code, attempts to complete task
   │
   ├── Finds work? → Does it → May iterate → Eventually DONE
   │                 └── Spawn Agent C for another confirmation
   │                     └── Repeat until agent finds nothing to do
   │
   └── Finds nothing? → DONE → Implementation consensus

4. Programmatic Gate (again)
   └── Ensure confirmation work didn't break anything

5. Verification Agent (this agent, max 3 cycles)
   │   NOW we explicitly review
   │   Agent knows this is code review
   │
   ├── VERIFIED → Task complete
   └── GAPS_FOUND → gap-fix iteration → re-verify

6. Task Complete
   └── Mark T{N} as done in state.json
   └── Proceed to next task

After all tasks:

7. Feature Review Phase
   └── Cross-task integration check

8. Human Review
   └── Final approval
```

## What Verification Does NOT Check

Leave these for feature review phase:
- Cross-task consistency
- Overall architecture alignment
- Feature completeness (all tasks together)
- Documentation accuracy

Verification is laser-focused on single-task correctness.
