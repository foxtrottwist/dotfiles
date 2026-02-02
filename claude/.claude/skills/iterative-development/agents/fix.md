# Fix Agent

Address specific issues identified during review. Runs as a loop per issue.

## Model

`sonnet` — Targeted fixes with clear scope.

## When to Use

- After review returns FAIL
- One fix loop per issue (or grouped related issues)
- Quick iteration on specific problems

## Fix Loop Structure

Each issue gets its own loop:

```
Issue: Null check missing in AuthService:45
├── Iteration 1: Locate and fix → FIXED
└── Done, return to review

Issue: Codable incomplete in User:12  
├── Iteration 1: Attempt fix → incomplete
├── Iteration 2: Complete fix → FIXED
└── Done, return to review
```

## Iteration Prompt Template

```
Fix iteration {I} of {MAX} for issue in "{feature}".

Read first:
- .claude/iterative-dev/{slug}/guardrails.md
- .claude/iterative-dev/{slug}/progress.md (find review that identified this)

Issue to fix:
- File: {path}
- Line: {number}
- Severity: {error|warning}
- Problem: {description}

This iteration:
1. Locate the problem in the file
2. Understand the root cause
3. Implement minimal fix
4. Verify the fix addresses the issue
5. Commit: "fix({slug}): {summary}"
6. Append to progress.md:

## Fix - Iteration {I} - {timestamp}
**Issue:** {description}
**File:** {path}:{line}
**Did:** {what you changed}
**Verified:** {how you confirmed fix}
**Commit:** {hash}

If fixed:
- Add "**Result:** FIXED"
- Output: <signal>FIXED</signal>

If fix requires broader changes beyond scope:
- Document what's needed
- Output: <signal>NEEDS_ESCALATION:{reason}</signal>

If not yet fixed:
- Note what was attempted in "Did"
- Next iteration will continue
```

## Constraints

- Fix only the specified issue
- Minimal changes to address problem
- Don't refactor unrelated code
- If fix requires API changes, escalate

## Scope Boundaries

### In Scope
- The specific issue identified
- Directly related code in same function/method
- Obvious related issues in same file

### Out of Scope
- Refactoring beyond the fix
- "While I'm here" improvements
- Issues in other files (separate fix loop)
- Architectural changes

## Guardrail Trigger

If this fix reveals a pattern to avoid:

```markdown
## {Pattern Name}

- **Context:** {when this applies}
- **Problem:** {what went wrong}
- **Solution:** {how to avoid}
- **Learned:** Fix iteration {I} for {issue}
```

Add to guardrails.md so future iterations avoid the same mistake.

## Iteration Expectations

- Most fixes: 1-2 iterations
- If >3 iterations, consider escalation
- Each iteration should show progress toward fix

## Return Values

| Signal | Meaning | Next Action |
|--------|---------|-------------|
| `FIXED` | Issue resolved | Return to review |
| `NEEDS_ESCALATION:{reason}` | Beyond scope | Escalate to user |
| (no signal) | In progress | Continue iteration |
