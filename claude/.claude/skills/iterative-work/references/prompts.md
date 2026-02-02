# Iteration Prompts

Minimal prompts for fresh-context iterations. Each iteration reads files for context—prompts provide orientation only.

## Core Principle

Every iteration is completely fresh. The prompt tells it:
- What phase and iteration
- Where to read state (not the state itself)
- What signal to emit when done

**Never include**: Previous iteration output, full brief, other phase details.

## Generic Iteration Prompt

```
Iteration {I} of {MAX} for {phase}: "{title}"

Read these files first (your only memory):
- .iterative-work/{slug}/progress.md
- .iterative-work/{slug}/guardrails.md
- .iterative-work/{slug}/context.md

Phase: {phase}
Criteria: {acceptance}
Output: {output_path}

This iteration:
1. Read progress.md — find most recent {phase} entry
2. See what "Remaining" items exist
3. Continue from where last iteration stopped
4. Save work to output path
5. Append to progress.md:

## {phase} - Iteration {I} - {timestamp}
**Did:** {what accomplished}
**Remaining:** {what's left, or "None"}
**Blockers:** {issues, or "None"}

6. If ALL criteria met:
   - Add "**Signal:** {phase}_DONE"

7. If blocked:
   - Add lesson to guardrails.md
   - Note blocker for user input

8. If not done, just exit. Next iteration continues.
```

## First Iteration Variant

For iteration 1 of a phase (no prior progress):

```
Iteration 1 of {MAX} for {phase}: "{title}"

Read these files first:
- .iterative-work/{slug}/guardrails.md (lessons from prior phases)
- .iterative-work/{slug}/context.md (task overview)

Phase: {phase}
Criteria: {acceptance}
Output: {output_path}

This is the first iteration. Start fresh:
1. Understand the phase requirements
2. Plan your approach
3. Begin work
4. Save progress to output path
5. Append to progress.md:

## {phase} - Iteration 1 - {timestamp}
**Did:** {what accomplished}
**Remaining:** {what's left}
**Blockers:** {issues, or "None"}

If you complete everything in one iteration:
- Add "**Signal:** {phase}_DONE"
```

## Mandatory Confirmation Pass (N+1)

After an agent declares DONE, we spawn a fresh agent with the **exact same prompt** as the first iteration. This agent doesn't know it's a "confirmation" — it just tries to complete the phase.

**Critical:** Use the First Iteration Variant prompt above. Do NOT use a special "confirmation" prompt. The agent should approach the phase fresh, examine the outputs, and decide what needs doing.

What happens:
- If work is truly complete → Agent reads criteria, examines outputs, finds nothing to do → Declares DONE
- If work is incomplete → Agent naturally finds and completes the remaining work → May iterate

**Why this works:** Two independent agents, same mandate ("complete this phase"), both concluding done = work consensus. This is fundamentally different from one agent saying "I'm done" and us trusting it.

**When confirmation agent also declares DONE:** Proceed to verification (quality review).

**When confirmation agent finds work:** Let it iterate. When it declares DONE, spawn another confirmation agent. Repeat until an agent finds nothing to do.

## Review Prompt

```
Review iteration {I} for "{task}".

Read:
- .iterative-work/{slug}/brief.md (requirements)
- .iterative-work/{slug}/plan.md (criteria per phase)
- .iterative-work/{slug}/progress.md (what was done)

Verify each completed phase:
1. Acceptance criteria explicitly met
2. Outputs exist and are complete
3. Quality standards satisfied

If ALL checks pass:
- Add "**Signal:** REVIEW_PASS"

If issues found, list each:
[gap] {output} - {description}
[quality] {output} - {description}

Then add: **Signal:** REVIEW_FAIL

Append to progress.md:

## Review - Iteration {I} - {timestamp}
**Checked:** {phases reviewed}
**Result:** PASS or FAIL
**Issues:** {list or "None"}
```

## Revise Prompt

```
Revise iteration {I} for issue in "{task}".

Read:
- .iterative-work/{slug}/guardrails.md
- .iterative-work/{slug}/progress.md

Issue to fix:
- Output: {path}
- Type: {gap|quality|accuracy}
- Problem: {description}

Fix the issue:
1. Locate the problem
2. Implement targeted fix
3. Verify fix works
4. Append to progress.md:

## Revise - Iteration {I} - {timestamp}
**Issue:** {description}
**Output:** {path}
**Fix:** {what changed}

If fixed:
- Add "**Result:** FIXED"

If broader changes needed:
- Add "**Result:** NEEDS_ESCALATION"

Add guardrail if this reveals pattern to avoid.
```

## Signal Reference

| Signal | Meaning | Next Action |
|--------|---------|-------------|
| `{phase}_DONE` | Phase work complete | Run confirmation pass |
| `{phase}_VERIFIED` | Verification passed | Mark phase complete, move to next |
| `{phase}_GAPS:{count}` | Verification found issues | Run revise iterations |
| `BLOCKED:{reason}` | Cannot proceed | Ask user for input |
| `REVIEW_PASS` | All task checks pass | Move to deliver |
| `REVIEW_FAIL` | Task issues found | Dispatch revise loops |
| `FIXED` | Issue resolved | Re-run verification/review |
| `NEEDS_ESCALATION` | Beyond scope | Ask user |

## Prompt Size Target

Each prompt under 500 tokens. Work happens in file reading.

| Component | Max Tokens |
|-----------|------------|
| Phase description | 50 |
| File paths | 50 |
| Criteria | 100 |
| Instructions | 200 |
| Format template | 100 |
