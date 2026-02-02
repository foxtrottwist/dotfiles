# Verification Hierarchy

Defense-in-depth strategy for validating agent work. Each layer catches different failure modes.

## The Problem

Coding agents are fallible. Even well-scoped tasks can fail in subtle ways:
- Confirmation bias (agent thinks their work is correct)
- Shallow completion (meets letter of criteria, not intent)
- Missing edge cases (happy path works, edge cases don't)
- Integration gaps (works in isolation, breaks in context)

**The core question:** When an agent declares "done" after one iteration, is that because:
1. The task was well-defined and genuinely complete? OR
2. The agent was overconfident and we got lucky that no tests caught bugs?

We cannot distinguish these without independent validation. No single verification mechanism catches everything. Stack multiple layers.

## Verification Layers

```
┌─────────────────────────────────────────────────────────────┐
│                     HUMAN REVIEW                            │
│  Final authority. Judgment calls. Business logic.           │
├─────────────────────────────────────────────────────────────┤
│                   FEATURE REVIEW                            │
│  Cross-task integration. Pattern consistency. Completeness. │
├─────────────────────────────────────────────────────────────┤
│              VERIFICATION AGENT (Code Review)               │
│  Adversarial scrutiny. Edge cases. Semantic correctness.    │
├─────────────────────────────────────────────────────────────┤
│            MANDATORY CONFIRMATION PASS (N+1)                │
│  Fresh agent attempts the SAME task. Independent agreement. │
├─────────────────────────────────────────────────────────────┤
│               PROGRAMMATIC CHECKS                           │
│  Tests. Linting. Type checking. Build verification.         │
├─────────────────────────────────────────────────────────────┤
│              IMPLEMENTATION PASS (1...N)                    │
│  Initial work. Agent iterates until it believes done.       │
└─────────────────────────────────────────────────────────────┘
```

## The Key Insight: Implementation Consensus

The mandatory N+1 pass is **NOT** a verification step. It is another **implementation attempt**.

- Same prompt as iteration 1: "Complete this task"
- Fresh agent with no memory of doing the work
- Reads task criteria, examines actual code, decides what needs doing
- If work is truly complete → agent finds nothing to do → declares DONE
- If gaps exist → agent naturally finds and fills them → may iterate further

This creates **implementation consensus**: two independent agents, both given the same mandate ("do this task"), both concluding the work is complete. This is fundamentally different from one agent saying "I'm done" and another agent saying "looks good to me."

Only after implementation consensus do we move to explicit code review (verification agent).

## Layer Details

### Layer 1: Implementation Pass

**What it is:** Agent works on the task until it believes criteria are met.

**What it catches:**
- Nothing yet — this is where issues are introduced

**Output:** `PRELIMINARY_DONE` signal (not final)

**Failure mode:** Agent is overconfident, stops too early, or misunderstands criteria.

---

### Layer 2: Programmatic Checks

**What it is:** Automated, objective verification.

**Components:**

| Check | Purpose | Example |
|-------|---------|---------|
| Build | Code compiles | `swift build`, `tsc`, `cargo check` |
| Types | Type safety | `tsc --noEmit`, `mypy` |
| Lint | Style/patterns | `swiftlint`, `eslint`, `rustfmt --check` |
| Tests | Behavior | `swift test`, `npm test`, `cargo test` |

**What it catches:**
- Syntax errors
- Type mismatches
- Style violations
- Regression bugs (if tests exist)
- Obvious runtime errors

**What it misses:**
- Logic errors that pass type checking
- Missing functionality (if no test for it)
- Edge cases without test coverage
- Semantic correctness

**Output:** Pass/fail for each check. All must pass to proceed.

**Speed:** Fast. Run on every completion attempt.

---

### Layer 3: Mandatory Confirmation Pass (N+1)

**What it is:** Another implementation attempt with the **exact same prompt** as iteration 1. Not a review — an attempt to do the work.

**Critical distinction:** This agent doesn't know it's a "confirmation pass." It receives: "Complete task T{N}: {title}" — the same instruction the original agent received. It then:
1. Reads task criteria
2. Examines the actual code/files
3. Attempts to complete the task
4. If nothing to do → declares DONE
5. If finds work → does it, may iterate further

**Purpose:** Independent agreement that work is complete. Two agents, same mandate, both concluding done.

**What it catches:**
- Incomplete work that the first agent thought was complete
- Gaps the first agent missed
- Criteria the first agent misunderstood
- Edge cases not implemented

**What makes this different from verification:**
- Verification says: "Assume this is done. Critique it."
- Confirmation says: "Do this task." (And if done, finds nothing to do.)

The confirmation agent has no bias toward confirming — it's trying to **do work**, not **review work**.

**When to require:** Always. Every task gets N+1 regardless of complexity.

**Output:**
- DONE (agrees work is complete) → proceed to verification
- Continues working → iterate until DONE, then another N+1

**Implication:** A task may have multiple N+1 cycles if each "confirmation" agent keeps finding work. That's fine — it means the work wasn't actually done.

---

### Layer 4: Verification Agent

**What it is:** Dedicated agent with adversarial mindset. See `agents/verify.md`.

**Purpose:** Independent validation. Actively tries to find problems.

**What it catches:**
- Edge cases (empty, null, boundary values)
- Unhandled error paths
- Logic errors
- Integration point mismatches
- Security concerns
- Performance issues

**What it misses:**
- Cross-task integration issues
- Feature-level completeness
- Business logic correctness (needs human judgment)

**Output:** `VERIFIED` or `GAPS_FOUND` with specific issues.

**Speed:** Medium. One agent spawn per task.

---

### Layer 5: Feature Review

**What it is:** Cross-task verification after all implementation complete. See `agents/review.md`.

**Purpose:** Ensure tasks work together correctly.

**What it catches:**
- Integration issues between tasks
- Pattern inconsistency across files
- Missing pieces that span tasks
- Feature completeness as a whole

**What it misses:**
- Business logic correctness
- UX quality
- Requirements interpretation

**Output:** `REVIEW_PASS` or `REVIEW_FAIL` with issues.

---

### Layer 6: Human Review

**What it is:** Final human approval before merge/deploy.

**Purpose:** Ultimate authority on correctness and quality.

**What it catches:**
- Everything above layers might miss
- Business logic correctness
- UX and design quality
- Requirements interpretation
- "Does this actually solve the problem?"

**What it costs:**
- Human time and attention
- Slowest layer

**When:** After all automated layers pass.

## Task Lifecycle with All Layers

```
Task T{N} Start
│
├─► Implementation Loop (Agent A)
│   ├── Iteration 1: Start work
│   ├── Iteration 2: Continue
│   └── Iteration N: Agent A declares DONE
│
├─► Programmatic Gate
│   ├── Build ──────► fail? → back to implementation
│   ├── Lint ───────► fail? → back to implementation
│   └── Tests ──────► fail? → back to implementation
│
├─► Mandatory Confirmation Pass (Agent B) ← ALWAYS HAPPENS
│   │
│   │   Agent B receives SAME prompt: "Complete task T{N}: {title}"
│   │   Agent B has no knowledge this is a "confirmation"
│   │   Agent B reads criteria, examines code, attempts to complete task
│   │
│   ├── Agent B finds work to do?
│   │   └── YES → Does the work → May iterate → Eventually declares DONE
│   │             └── Loop: Another fresh agent (Agent C) gets same prompt
│   │                       └── Repeat until an agent finds nothing to do
│   │
│   └── Agent B finds nothing to do?
│       └── Declares DONE → We have implementation consensus
│
├─► Programmatic Gate (again, after confirmation)
│   └── Ensure confirmation work didn't break anything
│
├─► Verification Agent (Code Review)
│   │
│   │   NOW we explicitly review. Agent knows this is review, not implementation.
│   │   Adversarial mindset: try to find problems.
│   │
│   ├── VERIFIED → Task complete
│   └── GAPS_FOUND → Fix iteration → Re-verify (max 3 cycles)
│
└─► Task Complete (T{N}_DONE)

After all tasks complete:
│
├─► Feature Review Phase
│   └── Cross-task integration check
│       ├── REVIEW_PASS → proceed
│       └── REVIEW_FAIL → fix loops → re-review
│
├─► Wrap Phase
│   └── Final commit, cleanup
│
└─► Human Review
    └── Approve or request changes
```

## Why This Works

The confirmation pass answers the question: "Would a different agent, given the same task, agree it's complete?"

- If YES → We have confidence. Two independent attempts, same conclusion.
- If NO → The first agent was overconfident. Good thing we checked.

This is different from verification because:
- Confirmation agent tries to DO work (and finds none if done)
- Verification agent tries to CRITIQUE work (assumes done, looks for flaws)

Both are valuable. Confirmation catches incomplete work. Verification catches flawed work.

## When to Skip Layers

Very few layers are skippable. The whole point is defense-in-depth.

| Layer | Skippable? | Rationale |
|-------|------------|-----------|
| Programmatic | No | Fast, objective, no reason to skip |
| Confirmation (N+1) | No | Core mechanism for catching overconfidence |
| Verification | Rarely | Skip only for trivial tasks (rename, typo) |
| Feature Review | No | Catches cross-task issues |
| Human Review | No | Final authority |

**The confirmation pass is never skipped.** Even "trivial" tasks get confirmed. The cost is one agent spawn. The benefit is confidence that "done" actually means done.

If a task is so trivial it doesn't need confirmation, question whether it should be a separate task at all.

## Failure Escalation

When a layer repeatedly fails:

| Layer | Max Attempts | Escalation |
|-------|--------------|------------|
| Programmatic | 3 | Escalate to user with error log |
| Second Pass | 2 | Proceed to verification anyway |
| Verification | 3 | Escalate to user with gap list |
| Feature Review | 5 | Escalate to user with issue list |

Escalation means: stop automated processing, present findings to human, await decision.

## Cost-Benefit

Each layer has costs:

| Layer | Cost | Benefit |
|-------|------|---------|
| Programmatic | Seconds, compute | Catches obvious errors fast |
| Second Pass | 1 agent iteration | Catches incomplete work |
| Verification | 1 agent spawn | Catches semantic errors |
| Feature Review | 1+ agent spawns | Catches integration issues |
| Human Review | Human time | Catches everything else |

**Investment rationale:** Issues caught early are cheaper to fix. A bug found in verification costs 1 fix iteration. The same bug found in human review costs context-switching, communication, and potentially rework of dependent tasks.

## Configuring Per-Project

Projects can adjust verification intensity:

```json
{
  "verification": {
    "programmatic": {
      "build": true,
      "lint": true,
      "types": true,
      "tests": true
    },
    "second_pass": {
      "required_above_iterations": 4,
      "always_for_complexity": ["complex", "exploratory"]
    },
    "verification_agent": {
      "enabled": true,
      "max_cycles": 3
    },
    "feature_review": {
      "enabled": true,
      "max_cycles": 5
    }
  }
}
```

## Summary

| Layer | Purpose | Catches |
|-------|---------|---------|
| Implementation | Do the work | — |
| Programmatic | Objective checks | Syntax, types, regressions |
| **Confirmation (N+1)** | **Independent agreement** | **Incomplete work, misunderstood criteria** |
| Verification | Code review | Edge cases, logic errors, quality issues |
| Feature Review | Integration check | Cross-task issues, pattern drift |
| Human Review | Final authority | Business logic, judgment calls |

**Key distinction:**
- **Confirmation** = "Do this task" (agent tries to complete work, finds nothing to do)
- **Verification** = "Review this work" (agent explicitly critiques completed work)

Both are necessary. Confirmation catches work that isn't done. Verification catches work that's done but flawed.

Stack all layers. Accept that each has holes. The combination catches what any single layer would miss.
