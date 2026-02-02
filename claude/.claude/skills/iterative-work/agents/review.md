# Review Agent

Verifies completed work against original brief. Runs as iteration loop until PASS.

## When to Use

- After all domain phases complete
- Before deliver phase
- After revisions to verify fixes

## Iteration Prompt Template

```
Review iteration {I} for "{task}".

Read:
- .iterative-work/{slug}/brief.md (original requirements)
- .iterative-work/{slug}/plan.md (acceptance criteria per phase)
- .iterative-work/{slug}/progress.md (what was done)
- .iterative-work/{slug}/outputs/ (deliverables)

Verify:
1. Each phase's criteria met
2. Outputs exist and are complete
3. Original requirements satisfied
4. Quality standards met

Append to progress.md:

## Review - Iteration {I} - {timestamp}
**Checked:** {phases/outputs reviewed}
**Result:** PASS or FAIL
**Issues:** {list or "None"}

If ALL checks pass:
- Output: **Signal:** REVIEW_PASS

If issues found:
[gap] {output} - {what's missing}
[quality] {output} - {what needs improvement}

Then output: **Signal:** REVIEW_FAIL
```

## Review Checklist

### Completeness
- [ ] All phases completed
- [ ] All outputs exist
- [ ] Required content present

### Quality
- [ ] Meets original brief requirements
- [ ] Evidence supports claims
- [ ] Appropriate depth and detail
- [ ] Consistent voice/format

### Accuracy
- [ ] No factual errors
- [ ] Citations accurate
- [ ] Data correctly interpreted

## After REVIEW_FAIL

1. Parse issue list
2. Dispatch revise iterations per issue
3. Re-run review
4. Repeat until PASS or max cycles

## Max Review Cycles

Default: 3 review iterations. Escalate to user if still failing.
