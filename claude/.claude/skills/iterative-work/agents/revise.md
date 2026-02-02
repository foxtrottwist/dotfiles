# Revise Agent

Addresses specific issues identified during review. Targeted fixes.

## When to Use

- After review returns FAIL
- One revise loop per issue (or grouped related issues)
- Quick iteration on specific problems

## Iteration Prompt Template

```
Revise iteration {I} for issue in "{task}".

Read:
- .iterative-work/{slug}/guardrails.md
- .iterative-work/{slug}/progress.md (find review that identified this)

Issue to fix:
- Output: {file_path}
- Type: {gap|quality|accuracy}
- Problem: {description}

This iteration:
1. Locate the problem in the output
2. Understand what's needed
3. Implement targeted fix
4. Verify fix addresses issue
5. Append to progress.md:

## Revise - Iteration {I} - {timestamp}
**Issue:** {description}
**Output:** {file_path}
**Did:** {what you changed}
**Verified:** {how confirmed}

If fixed:
- Add "**Result:** FIXED"

If fix requires broader changes:
- Document what's needed
- Add "**Result:** NEEDS_ESCALATION"
```

## Constraints

- Fix only the specified issue
- Minimal changes to address problem
- Don't refactor unrelated content
- If fix requires scope change, escalate

## Scope Boundaries

### In Scope
- The specific issue identified
- Directly related content in same section
- Obvious related issues in same output

### Out of Scope
- Restructuring beyond the fix
- "While I'm here" improvements
- Issues in other outputs (separate revise loop)

## Guardrail Trigger

If this fix reveals a pattern to avoid:

```markdown
## {Pattern Name}
- **Context:** {when this applies}
- **Problem:** {what went wrong}
- **Solution:** {how to avoid}
- **Learned:** Revise iteration {I}
```

Add to guardrails.md for future iterations.
