# State Management

Persistent state enables resumption after any interruption, including mid-iteration.

## Directory Structure

```
.claude/iterative-dev/
├── {feature-slug}/
│   ├── state.json      # Machine-readable status with iteration tracking
│   ├── prd.md          # Requirements from interview
│   ├── tasks.md        # Task breakdown with status checkboxes
│   ├── context.md      # Brief summary for sub-agents
│   ├── progress.md     # Iteration log
│   └── guardrails.md   # Accumulated lessons
└── archive/            # Completed features
```

## state.json Schema

```json
{
  "feature": "user-authentication",
  "slug": "user-auth",
  "created": "2025-01-14T10:30:00Z",
  "updated": "2025-01-14T14:22:00Z",
  "phase": "loop",
  "current_task": "T3",
  "current_iteration": 2,
  "tasks": {
    "T1": {
      "status": "done",
      "iterations_used": 3,
      "confirmations_used": 1,
      "verification_passed": true,
      "max_iterations": 5,
      "completed_at": "2025-01-14T11:15:00Z"
    },
    "T2": {
      "status": "done",
      "iterations_used": 5,
      "confirmations_used": 2,
      "verification_passed": true,
      "max_iterations": 8,
      "completed_at": "2025-01-14T12:45:00Z"
    },
    "T3": {
      "status": "confirming",
      "iterations_used": 2,
      "confirmations_used": 1,
      "max_iterations": 10
    },
    "T4": {
      "status": "pending",
      "max_iterations": 5
    },
    "T5": {
      "status": "blocked",
      "reason": "Waiting on T3",
      "max_iterations": 5
    }
  },
  "commits": [
    "abc1234: feat(user-auth): Add User model",
    "def5678: feat(user-auth): Create auth service skeleton",
    "ghi9012: feat(user-auth): Add login method"
  ]
}
```

### Task Status Values

| Status | Description |
|--------|-------------|
| `pending` | Not yet started |
| `in_progress` | Currently in implementation iteration loop |
| `confirming` | Implementation declared done, running mandatory N+1 confirmation |
| `verifying` | Confirmation passed, running verification (code review) |
| `done` | Passed all gates: implementation, confirmation, verification |
| `blocked` | Cannot proceed (dependency or error) |
| `timeout` | Hit max iterations without completion |

### Task Lifecycle

```
pending → in_progress → confirming → verifying → done
                ↑            │            │
                └────────────┴────────────┘
                    (if issues found)
```

### Phase Values

| Phase | Description |
|-------|-------------|
| `interview` | Gathering requirements |
| `plan` | Decomposing into tasks |
| `loop` | Executing task iteration loops (includes confirmation & verification per task) |
| `review` | Feature-level review: cross-task integration check |
| `wrap` | Final commit and cleanup |
| `complete` | Archived |

**Note:** Per-task verification happens within the `loop` phase. The `review` phase is feature-level review after all tasks are done.

## progress.md — The Memory Bridge

This file is critical. It's how fresh-context iterations communicate.

### Format

```markdown
# Progress Log

## T1 - Iteration 1 - 2025-01-14T10:45:00Z

**Task:** Create User data model
**Did:** 
- Created User.swift file
- Added basic struct skeleton
- Researched SwiftData requirements

**Remaining:**
- Add all properties (id, email, createdAt)
- Implement Codable conformance
- Add SwiftData annotations

**Blockers:** None
**Commit:** abc1234

---

## T1 - Iteration 2 - 2025-01-14T10:52:00Z

**Task:** Create User data model
**Did:**
- Added id (UUID), email (String), createdAt (Date) properties
- Implemented Codable conformance

**Remaining:**
- Add SwiftData annotations (@Model, @Attribute)

**Blockers:** None
**Commit:** def5678

---

## T1 - Iteration 3 - 2025-01-14T10:58:00Z

**Task:** Create User data model
**Did:**
- Added @Model macro
- Added @Attribute(.unique) to email
- Verified all acceptance criteria met

**Remaining:** None
**Signal:** T1_DONE
**Commit:** ghi9012

---

## T2 - Iteration 1 - 2025-01-14T11:05:00Z

**Task:** Create AuthService
...
```

### Why This Format

Each iteration appends. Never modify previous entries. Fresh agents:
1. Read from top to find task context
2. Read most recent entry to see current state
3. Continue from "Remaining" items
4. Append their own entry

## context.md Template

Keep brief. Provides orientation, not full context.

```markdown
# {Feature} Context

**Goal:** {One sentence}

**Approach:** {One sentence}

**Key files:**
- `src/models/User.swift` — Data model
- `src/services/AuthService.swift` — Business logic

**Patterns to follow:**
- Use existing error handling in `ErrorHandler.swift`
- Follow naming conventions in `CONTRIBUTING.md`

**Completion signals:**
- T1: `<signal>T1_DONE</signal>`
- T2: `<signal>T2_DONE</signal>`
- T3: `<signal>T3_DONE</signal>`
```

Target: Under 200 words. Fresh agents read this first for orientation.

## prd.md Template

```markdown
# {Feature Name}

**Created:** {timestamp}
**Status:** {phase}

## Summary

{One paragraph description}

## Requirements

- {Requirement 1}
- {Requirement 2}

## Acceptance Criteria

- [ ] {Criterion 1}
- [ ] {Criterion 2}

## Constraints

- {Constraint 1}
- {Constraint 2}

## Technical Approach

{Brief approach description}
```

## guardrails.md Template

Lessons accumulate across iterations and tasks.

```markdown
# Guardrails

Read before starting any iteration. Append when you discover issues.

## Always validate tokens server-side

- **Context:** Authentication implementation
- **Problem:** Client-side token validation can be bypassed
- **Solution:** Add server validation in AuthMiddleware
- **Learned:** T3 iteration 2 - security concern

## Use DateFormatter.shared

- **Context:** Date display anywhere in feature
- **Problem:** Creating DateFormatter is expensive
- **Solution:** Use shared instance from Utils
- **Learned:** T2 iteration 4 - performance note

## Check for nil user before navigation

- **Context:** Any authenticated route
- **Problem:** Race condition on logout caused crash
- **Solution:** Guard against nil user in router
- **Learned:** T4 iteration 1 - runtime crash
```

## State Operations

### Initialize Feature

```bash
mkdir -p .claude/iterative-dev/{slug}
cat > .claude/iterative-dev/{slug}/state.json << 'EOF'
{
  "feature": "...",
  "slug": "...",
  "phase": "interview",
  "tasks": {}
}
EOF
touch .claude/iterative-dev/{slug}/progress.md
touch .claude/iterative-dev/{slug}/guardrails.md
```

### Start Task Loop

```bash
jq '.current_task = "T1" | .current_iteration = 1 | .tasks.T1.status = "in_progress"' \
  state.json > tmp && mv tmp state.json
```

### Advance Iteration

```bash
jq '.current_iteration += 1 | .tasks[.current_task].iterations_used = .current_iteration' \
  state.json > tmp && mv tmp state.json
```

### Complete Task

```bash
jq '.tasks[.current_task].status = "done" | .tasks[.current_task].completed_at = now' \
  state.json > tmp && mv tmp state.json
```

### Move to Next Task

```bash
# Find next pending task and start its loop
jq '.current_task = "T2" | .current_iteration = 1 | .tasks.T2.status = "in_progress"' \
  state.json > tmp && mv tmp state.json
```

### Archive on Completion

```bash
mv .claude/iterative-dev/{slug} .claude/iterative-dev/archive/{slug}-$(date +%Y%m%d)
```

## Recovery Scenarios

### Network Interruption Mid-Iteration

1. State shows current_task and current_iteration
2. Progress.md shows what last iteration accomplished
3. Resume spawns fresh agent at iteration N+1
4. Agent reads progress, continues work

### Task Timeout (Max Iterations)

1. Mark task status as "timeout"
2. Log in progress.md what was attempted
3. Move to next unblocked task or escalate to user
4. User can: increase max, simplify task, or intervene

### Review Failure Loop

1. Track review iterations separately
2. If review keeps failing on same issues, escalate
3. Max review cycles prevents infinite fix loops

### Conflicting State

If state.json and git history disagree:

1. Trust git (source of truth for code)
2. Read progress.md for iteration history
3. Rebuild state from commits + progress entries
4. Log discrepancy

## Cleanup

After feature completion:

```bash
# Archive with timestamp
mv .claude/iterative-dev/{slug} .claude/iterative-dev/archive/{slug}-$(date +%Y%m%d)

# Or remove if not needed
rm -rf .claude/iterative-dev/{slug}
```

Keep archive for reference on similar future features — guardrails from past work can seed new features.
