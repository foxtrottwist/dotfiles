# Verification Hierarchy

Defense-in-depth strategy for validating knowledge work. Each layer catches different failure modes.

## The Problem

Agents are fallible. Even well-scoped phases can fail in subtle ways:
- Confirmation bias (agent thinks their work is correct)
- Shallow completion (meets letter of criteria, not intent)
- Missing nuances (surface-level analysis, overlooked sources)
- Quality gaps (works but lacks depth or rigor)

**The core question:** When an agent declares a phase "done" after one iteration, is that because:
1. The phase was well-defined and genuinely complete? OR
2. The agent was overconfident and we got lucky?

We cannot distinguish these without independent validation.

## Verification Layers

```
┌─────────────────────────────────────────────────────────────┐
│                     HUMAN REVIEW                            │
│  Final authority. Judgment calls. Quality assessment.       │
├─────────────────────────────────────────────────────────────┤
│                   TASK REVIEW                               │
│  Cross-phase integration. Coherence. Completeness.          │
├─────────────────────────────────────────────────────────────┤
│              VERIFICATION AGENT (Quality Review)            │
│  Adversarial scrutiny. Depth check. Gap analysis.           │
├─────────────────────────────────────────────────────────────┤
│            MANDATORY CONFIRMATION PASS (N+1)                │
│  Fresh agent attempts the SAME phase. Independent agreement.│
├─────────────────────────────────────────────────────────────┤
│              PHASE PASS (1...N)                             │
│  Initial work. Agent iterates until it believes done.       │
└─────────────────────────────────────────────────────────────┘
```

## The Key Insight: Work Consensus

The mandatory N+1 pass is **NOT** a verification step. It is another **work attempt**.

- Same prompt as iteration 1: "Complete phase R2"
- Fresh agent with no memory of doing the work
- Reads phase criteria, examines outputs, decides what needs doing
- If work is truly complete → agent finds nothing to do → declares DONE
- If gaps exist → agent naturally finds and fills them → may iterate further

This creates **work consensus**: two independent agents, both given the same mandate ("complete this phase"), both concluding the work is complete.

Only after work consensus do we move to explicit quality review (verification agent).

## Layer Details

### Layer 1: Phase Pass (1...N)

**What it is:** Agent works on the phase until it believes criteria are met.

**Output:** `PRELIMINARY_DONE` signal (not final)

**Failure mode:** Agent is overconfident, stops too early, or misunderstands criteria.

---

### Layer 2: Mandatory Confirmation Pass (N+1)

**What it is:** Another work attempt with the **exact same prompt** as iteration 1.

**Critical distinction:** This agent doesn't know it's a "confirmation pass." It receives: "Complete phase R{N}" — the same instruction the original agent received. It then:
1. Reads phase criteria
2. Examines the actual outputs
3. Attempts to complete the phase
4. If nothing to do → declares DONE
5. If finds work → does it, may iterate further

**What it catches:**
- Incomplete work that the first agent thought was complete
- Gaps the first agent missed
- Criteria the first agent misunderstood
- Missing depth or analysis

**When to require:** Always. Every phase gets N+1 regardless of complexity.

**Output:**
- DONE (agrees work is complete) → proceed to verification
- Continues working → iterate until DONE, then another N+1

---

### Layer 3: Verification Agent (Quality Review)

**What it is:** Dedicated agent with adversarial mindset. See `agents/verify.md`.

**Purpose:** Independent validation. Actively tries to find problems.

**What it catches:**
- Shallow analysis that misses nuance
- Missing sources or perspectives
- Logical gaps in arguments
- Quality issues (clarity, structure, depth)
- Criteria interpreted too loosely

**Output:** `VERIFIED` or `GAPS_FOUND` with specific issues.

---

### Layer 4: Task Review

**What it is:** Cross-phase verification after all phases complete. See `agents/review.md`.

**Purpose:** Ensure phases work together coherently.

**What it catches:**
- Inconsistencies between phases
- Missing connections
- Gaps that span phases
- Overall coherence and flow

---

### Layer 5: Human Review

**What it is:** Final human approval.

**Purpose:** Ultimate authority on quality and correctness.

**What it catches:**
- Everything above layers might miss
- Judgment calls on quality
- Domain expertise validation
- "Does this actually answer the question?"

## Phase Lifecycle with All Layers

```
Phase R{N} Start
│
├─► Work Loop (Agent A, iterations 1...N)
│   └── Agent A declares DONE
│
├─► Mandatory Confirmation Pass (Agent B)
│   │
│   │   Agent B receives SAME prompt: "Complete phase R{N}"
│   │   Agent B doesn't know this is confirmation
│   │   Agent B reads criteria, examines outputs, attempts to complete
│   │
│   ├── Agent B finds work to do?
│   │   └── YES → Does the work → Eventually declares DONE
│   │             └── Loop: Another fresh agent (Agent C) gets same prompt
│   │
│   └── Agent B finds nothing to do?
│       └── Declares DONE → We have work consensus
│
├─► Verification Agent (Quality Review)
│   │
│   │   NOW we explicitly review. Agent knows this is review, not work.
│   │   Adversarial mindset: try to find problems.
│   │
│   ├── VERIFIED → Phase complete
│   └── GAPS_FOUND → Revise iteration → Re-verify (max 3 cycles)
│
└─► Phase Complete (R{N}_DONE)

After all phases complete:
│
├─► Task Review Phase
│   └── Cross-phase coherence check
│
└─► Human Review
    └── Final approval
```

## Why This Works

The confirmation pass answers: "Would a different agent, given the same phase, agree it's complete?"

- If YES → We have confidence. Two independent attempts, same conclusion.
- If NO → The first agent was overconfident. Good thing we checked.

This is different from verification because:
- Confirmation agent tries to DO work (and finds none if done)
- Verification agent tries to CRITIQUE work (assumes done, looks for flaws)

Both are valuable. Confirmation catches incomplete work. Verification catches flawed work.

## When to Skip Layers

Very few layers are skippable.

| Layer | Skippable? | Rationale |
|-------|------------|-----------|
| Confirmation (N+1) | No | Core mechanism for catching overconfidence |
| Verification | Rarely | Skip only for trivial phases |
| Task Review | No | Catches cross-phase issues |
| Human Review | No | Final authority |

## Summary

| Layer | Purpose | Catches |
|-------|---------|---------|
| Work Pass | Do the work | — |
| **Confirmation (N+1)** | **Independent agreement** | **Incomplete work, misunderstood criteria** |
| Verification | Quality review | Shallow work, gaps, quality issues |
| Task Review | Integration check | Cross-phase issues, coherence |
| Human Review | Final authority | Judgment calls, quality assessment |

**Key distinction:**
- **Confirmation** = "Do this phase" (agent tries to complete, finds nothing if done)
- **Verification** = "Review this work" (agent explicitly critiques completed work)

Both are necessary. Confirmation catches work that isn't done. Verification catches work that's done but flawed.
