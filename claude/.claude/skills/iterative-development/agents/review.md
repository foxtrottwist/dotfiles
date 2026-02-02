# Review Agent

Verify completed work. Runs as its own loop until PASS.

## Model

`sonnet` — Structured evaluation task.

## When to Use

- After all implementation tasks complete
- Before wrap phase
- After fixes to verify resolution

## Review Loop

Review runs as iterations until PASS or max attempts:

```
Review Loop
├── Iteration 1: Check all tasks → FAIL (3 issues)
├── [Fix loops run for each issue]
├── Iteration 2: Re-check → FAIL (1 issue)
├── [Fix loop]
├── Iteration 3: Re-check → PASS
└── Proceed to wrap
```

## Iteration Prompt Template

```
Review iteration {I} for "{feature}".

Read:
- .claude/iterative-dev/{slug}/tasks.md (acceptance criteria)
- .claude/iterative-dev/{slug}/progress.md (implementation history)
- .claude/iterative-dev/{slug}/guardrails.md (known issues)

Verify each completed task:
1. Code builds without errors or warnings
2. Each task's acceptance criteria explicitly met
3. Code follows project patterns and style
4. Tests pass (if applicable)
5. No obvious bugs or edge cases missed

Append to progress.md:

## Review - Iteration {I} - {timestamp}
**Checked:** {list of tasks/files reviewed}
**Build:** {pass/fail}
**Tests:** {pass/fail/N/A}
**Issues found:** {count}

If ALL checks pass:
- Add "**Result:** PASS"
- Output: <signal>REVIEW_PASS</signal>

If issues found, list each:
[error] {file}:{line} - {description}
[warning] {file}:{line} - {description}

Then:
- Add "**Result:** FAIL"
- Output: <signal>REVIEW_FAIL</signal>
```

## Review Checklist

### Build Verification
- [ ] Compiles without errors
- [ ] No new warnings introduced
- [ ] Dependencies resolved

### Criteria Verification
- [ ] Each task's criteria explicitly met
- [ ] Edge cases handled
- [ ] Error states considered

### Pattern Verification
- [ ] Naming follows conventions
- [ ] File organization matches project
- [ ] Code style consistent

### Quality Verification
- [ ] No obvious performance issues
- [ ] No security concerns
- [ ] No accessibility regressions (if applicable)

## Output Formats

### PASS
```
## Review - Iteration {I} - {timestamp}
**Checked:** T1, T2, T3, T4
**Build:** Pass
**Tests:** Pass (24/24)
**Issues found:** 0
**Result:** PASS

<signal>REVIEW_PASS</signal>
```

### FAIL
```
## Review - Iteration {I} - {timestamp}
**Checked:** T1, T2, T3, T4
**Build:** Pass
**Tests:** Fail (22/24)
**Issues found:** 3

[error] src/services/AuthService.swift:45 - Null check missing
[error] src/models/User.swift:12 - Codable incomplete
[warning] src/views/LoginView.swift:78 - Hardcoded string

**Result:** FAIL

<signal>REVIEW_FAIL</signal>
```

## After REVIEW_FAIL

Main session:
1. Parses issue list from output
2. Dispatches fix loop for each error (warnings optional)
3. Fix loops run their iterations
4. Re-runs review iteration
5. Repeats until PASS or max review cycles

## Max Review Cycles

Prevent infinite review-fix loops:
- Default: 5 review iterations
- If still failing after 5, escalate to user
- User can: increase limit, intervene manually, or accept current state
