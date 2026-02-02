# Sub-Agent Prompts

Minimal prompts for fresh-context iterations. Each agent reads files for context — prompts provide orientation only.

## Core Principle

Every iteration spawns a completely fresh agent. The prompt tells it:
- What task and iteration
- Where to read state (not the state itself)
- What signal to emit when done

**Never include**: Previous iteration output, full PRD, other task details.

## Implementation Prompt (Per Iteration)

```
Iteration {I} of {MAX} for T{N}: "{title}"

Read these files first (your only memory of previous work):
- .claude/iterative-dev/{slug}/progress.md
- .claude/iterative-dev/{slug}/guardrails.md
- .claude/iterative-dev/{slug}/context.md

Task: {title}
Files to modify: {file_list}
Acceptance criteria: {criteria}

Your job this iteration:
1. Read progress.md — find the most recent T{N} entry
2. See what "Remaining" items exist
3. Continue from where the last iteration stopped
4. Make meaningful progress toward the criteria
5. Commit your work: "feat({slug}): {summary}"
6. Append to progress.md:

## T{N} - Iteration {I} - {timestamp}
**Task:** {title}
**Did:** {what you accomplished}
**Remaining:** {what still needs doing}
**Blockers:** {any issues, or "None"}
**Commit:** {hash}

7. If ALL criteria are met:
   - Add "**Signal:** T{N}_DONE" to your progress entry
   - Output: <signal>T{N}_DONE</signal>

8. If blocked and cannot proceed:
   - Add blocker details to progress entry
   - Add lesson to guardrails.md if applicable
   - Output: <signal>BLOCKED:{reason}</signal>

9. If not done and not blocked:
   - Just exit normally
   - Next iteration will continue your work
```

## First Iteration Variant

For iteration 1 of a task, there's no prior progress to read:

```
Iteration 1 of {MAX} for T{N}: "{title}"

Read these files first:
- .claude/iterative-dev/{slug}/guardrails.md (lessons from other tasks)
- .claude/iterative-dev/{slug}/context.md (feature overview)

Task: {title}
Files to modify: {file_list}
Acceptance criteria: {criteria}

This is the first iteration. Start fresh:
1. Understand the task requirements
2. Plan your approach
3. Begin implementation
4. Commit meaningful progress: "feat({slug}): {summary}"
5. Append to progress.md:

## T{N} - Iteration 1 - {timestamp}
**Task:** {title}
**Did:** {what you accomplished}
**Remaining:** {what still needs doing}
**Blockers:** {any issues, or "None"}
**Commit:** {hash}

If you complete everything in one iteration:
- Add "**Signal:** T{N}_DONE" to your progress entry
- Output: <signal>T{N}_DONE</signal>
```

## Mandatory Confirmation Pass (N+1)

After an agent declares DONE, we spawn a fresh agent with the **exact same prompt** as the first iteration. This agent doesn't know it's a "confirmation" — it just tries to complete the task.

**Critical:** Use the First Iteration Variant prompt above. Do NOT use a special "confirmation" prompt. The agent should approach the task fresh, examine the code, and decide what needs doing.

What happens:
- If work is truly complete → Agent reads criteria, examines code, finds nothing to do → Declares DONE
- If work is incomplete → Agent naturally finds and completes the remaining work → May iterate

**Why this works:** Two independent agents, same mandate ("complete this task"), both concluding done = implementation consensus. This is fundamentally different from one agent saying "I'm done" and us trusting it.

**When confirmation agent also declares DONE:** Proceed to verification (code review).

**When confirmation agent finds work:** Let it iterate. When it declares DONE, spawn another confirmation agent. Repeat until an agent finds nothing to do.

## Review Prompt (Per Iteration)

Review also runs as a loop until PASS:

```
Review iteration {I} for "{feature}".

Read:
- .claude/iterative-dev/{slug}/tasks.md (acceptance criteria per task)
- .claude/iterative-dev/{slug}/progress.md (what was implemented)
- .claude/iterative-dev/{slug}/guardrails.md (known issues)

Verify each completed task:
1. Code builds without errors or warnings
2. Acceptance criteria explicitly met
3. Code follows project patterns
4. Tests pass (if applicable)

If ALL checks pass:
- Output: <signal>REVIEW_PASS</signal>

If issues found, list each:
[error] {file}:{line} - {description}
[warning] {file}:{line} - {description}

Then output: <signal>REVIEW_FAIL</signal>

Append to progress.md:

## Review - Iteration {I} - {timestamp}
**Checked:** {list of tasks reviewed}
**Result:** PASS or FAIL
**Issues:** {list or "None"}
```

## Fix Prompt (Per Iteration)

Fix loops target specific issues:

```
Fix iteration {I} for issue in "{feature}".

Read:
- .claude/iterative-dev/{slug}/guardrails.md
- .claude/iterative-dev/{slug}/progress.md (find the review that identified this)

Issue to fix:
- File: {path}
- Line: {number}
- Problem: {description}
- Severity: {error|warning}

Fix the issue:
1. Locate the problem
2. Implement minimal fix
3. Verify the fix works
4. Commit: "fix({slug}): {summary}"

Append to progress.md:

## Fix - Iteration {I} - {timestamp}
**Issue:** {description}
**File:** {path}:{line}
**Fix:** {what you changed}
**Commit:** {hash}

If fix requires broader changes:
- Output: <signal>NEEDS_ESCALATION:{reason}</signal>

If fixed:
- Output: <signal>FIXED</signal>

Add guardrail if this reveals a pattern to avoid.
```

## Test Prompt (Per Iteration)

```
Test iteration {I} for "{feature}".

Read:
- .claude/iterative-dev/{slug}/progress.md (implementation details)
- .claude/iterative-dev/{slug}/tasks.md (what to test)
- Existing test patterns in project

Files needing tests: {list}

Requirements:
1. Follow existing test patterns exactly
2. Cover each acceptance criterion
3. Include edge cases from progress.md
4. Test error states

Append to progress.md:

## Tests - Iteration {I} - {timestamp}
**Files:** {test files created/modified}
**Coverage:** {what is tested}
**Result:** PASS or FAIL
**Commit:** {hash}

If all tests pass:
- Output: <signal>TESTS_PASS</signal>

If tests fail:
- List failures
- Output: <signal>TESTS_FAIL:{summary}</signal>
```

## Prompt Size Target

Each prompt should be under 500 tokens. The work happens in file reading, not prompt parsing.

| Component | Max Tokens |
|-----------|------------|
| Task description | 50 |
| File paths | 50 |
| Criteria | 100 |
| Instructions | 200 |
| Format template | 100 |

## Signal Reference

| Signal | Meaning | Next Action |
|--------|---------|-------------|
| `T{N}_DONE` | Task complete | Move to next task |
| `BLOCKED:{reason}` | Cannot proceed | Log, try next task |
| `REVIEW_PASS` | All checks pass | Move to wrap phase |
| `REVIEW_FAIL` | Issues found | Dispatch fix loops |
| `FIXED` | Issue resolved | Re-run review |
| `NEEDS_ESCALATION:{reason}` | Beyond scope | Escalate to user |
| `TESTS_PASS` | Tests green | Continue |
| `TESTS_FAIL:{summary}` | Tests red | Fix or escalate |

## Parallel Dispatch

When tasks have no dependencies:

```
Launch parallel task loops:

Task T2: "{title}"
- Max iterations: {N}
- Model: sonnet
- Signal: T2_DONE

Task T4: "{title}"
- Max iterations: {N}
- Model: haiku
- Signal: T4_DONE

Each runs its own iteration cycle. Progress.md entries will interleave.
```

## What NOT to Include

Never put these in iteration prompts:
- Previous iteration's output
- Full PRD content
- Other task details
- Code snippets from prior work
- Conversation history
- File contents (give paths, let agent read)

The agent reads files. The prompt just points to them.
