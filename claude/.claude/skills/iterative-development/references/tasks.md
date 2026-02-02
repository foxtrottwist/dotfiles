# Task Format

Structure for tasks that will each run as an iteration loop.

## Template

```markdown
# {Feature} - Tasks

**Created:** {timestamp}
**Total:** {N} tasks
**Status:** {X} done, {Y} in progress, {Z} pending

## Dependencies

```
T1 ──► T3 ──► T5
T2 ────┘
T4 (independent)
```

## Tasks

- [ ] **T1**: {title}
  - Files: `path/to/file.ts`
  - Criteria: {measurable acceptance}
  - Completion: `<signal>T1_DONE</signal>`
  - Max iterations: 5
  - Depends: none
  - Model: sonnet

- [ ] **T2**: {title}
  - Files: `path/to/file.ts`, `path/to/other.ts`
  - Criteria: {acceptance}
  - Completion: `<signal>T2_DONE</signal>`
  - Max iterations: 8
  - Depends: T1
  - Model: sonnet

## Notes

{Context for sub-agents}
```

## Field Definitions

### Required Fields

| Field | Purpose |
|-------|---------|
| Title | Clear, action-oriented description |
| Files | Paths the task will modify |
| Criteria | Measurable acceptance conditions |
| Completion | Signal to emit when done |
| Max iterations | Safety limit for the iteration loop |
| Depends | Task dependencies (or "none") |
| Model | haiku, sonnet, or opus |

### Max Iterations Guide

| Task Complexity | Max Iterations | Signals |
|-----------------|----------------|---------|
| Simple | 3-5 | Single file, clear pattern, <50 lines |
| Medium | 5-10 | 2-3 files, moderate logic, some unknowns |
| Complex | 10-15 | Multiple files, new patterns, research needed |
| Exploratory | 15-20 | Unclear scope, may need multiple approaches |

**Rule**: Start conservative. You can always increase if a task times out. Better to iterate than to have a runaway loop.

### Model Selection

| Task Type | Model | Rationale |
|-----------|-------|-----------|
| File search, grep, glob | haiku | Pattern matching |
| Simple file edits (<50 lines) | haiku | Mechanical changes |
| Standard implementation | sonnet | Balanced capability |
| Code review | sonnet | Standards verification |
| Test generation | sonnet | Structured output |
| Complex debugging | opus | Root cause analysis |
| Architecture decisions | opus | Multi-factor reasoning |
| Refactors touching many files | opus | Coordination complexity |

**Default**: sonnet (best balance of capability and cost)

## Good vs Bad Tasks

### Good Task

```markdown
- [ ] **T1**: Create User data model
  - Files: `src/models/User.swift`
  - Criteria: 
    - Model with id (UUID), email (String), createdAt (Date)
    - SwiftData @Model annotation
    - @Attribute(.unique) on email
  - Completion: `<signal>T1_DONE</signal>`
  - Max iterations: 5
  - Depends: none
  - Model: sonnet
```

Why it's good:
- Clear, specific title
- Single file focus
- Measurable criteria (can verify each point)
- Reasonable iteration limit
- Appropriate model

### Bad Task

```markdown
- [ ] **T1**: Implement authentication
  - Files: multiple
  - Criteria: users can log in
  - Completion: `<signal>T1_DONE</signal>`
  - Max iterations: 3
  - Depends: none
  - Model: haiku
```

Problems:
- Too broad ("implement authentication")
- Vague files ("multiple")
- Unmeasurable criteria ("users can log in")
- Too few iterations for complexity
- Wrong model (haiku for complex work)

### Fixed Version

```markdown
- [ ] **T1**: Create User model with auth fields
  - Files: `src/models/User.swift`
  - Criteria: User struct with id, email, passwordHash, createdAt
  - Completion: `<signal>T1_DONE</signal>`
  - Max iterations: 5
  - Depends: none
  - Model: sonnet

- [ ] **T2**: Create AuthService with login method
  - Files: `src/services/AuthService.swift`
  - Criteria: 
    - login(email, password) method
    - Returns Result<User, AuthError>
    - Validates against stored passwordHash
  - Completion: `<signal>T2_DONE</signal>`
  - Max iterations: 8
  - Depends: T1
  - Model: sonnet

- [ ] **T3**: Create LoginView UI
  - Files: `src/views/LoginView.swift`
  - Criteria:
    - Email and password fields
    - Login button calls AuthService
    - Shows error on failure
    - Navigates on success
  - Completion: `<signal>T3_DONE</signal>`
  - Max iterations: 8
  - Depends: T2
  - Model: sonnet
```

## Status Annotations

As tasks complete, update the checkbox and add notes:

```markdown
- [x] **T1**: Create User model <!-- DONE: 3 iterations -->
- [ ] **T2**: Create AuthService <!-- IN_PROGRESS: iteration 4 -->
- [ ] **T3**: Create LoginView <!-- BLOCKED: Waiting on T2 -->
- [ ] **T4**: Add tests <!-- PENDING -->
```

## Dependency Notation

- `none` — Can start immediately
- `T1` — Wait for T1's loop to complete
- `T1, T2` — Wait for both (all must complete)

## Iteration Budget Planning

For a feature, estimate total iterations:

```
T1: 5 max → expect 3
T2: 8 max → expect 5
T3: 8 max → expect 6
T4: 5 max → expect 3
Review: 3 max → expect 2
Fixes: 5 max → expect 2
─────────────────────────
Total budget: ~21 iterations
```

This helps estimate API costs and time.

## Multi-Session Features

For large features (>8 tasks or >50 total iterations):

1. Split into parts: `tasks-part1.md`, `tasks-part2.md`
2. Each part should end at a stable, buildable state
3. Track in state.json: `{ "current_part": "part2" }`
4. Archive completed parts

Example split:
- Part 1: Models and data layer (T1-T3)
- Part 2: Services and business logic (T4-T6)
- Part 3: UI and integration (T7-T10)

## Criteria Writing Guide

Good criteria are:
- **Specific**: Name exact fields, methods, behaviors
- **Verifiable**: Can check programmatically or visually
- **Complete**: Cover all aspects of "done"
- **Independent**: Don't rely on other tasks

Examples:

| Weak | Strong |
|------|--------|
| "Model works" | "Model has id, name, createdAt properties" |
| "Tests pass" | "Unit tests cover happy path and error cases" |
| "UI looks good" | "UI matches Figma spec for LoginScreen" |
| "Handles errors" | "Returns AuthError.invalidCredentials on wrong password" |
