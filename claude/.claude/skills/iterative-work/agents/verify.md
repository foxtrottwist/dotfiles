# Verification Agent

Quality review of completed phase work. Runs **after work consensus** — when multiple agents have independently agreed the work is complete.

## Model

`sonnet` — Requires reasoning about quality, not just pattern matching.

## Purpose

This agent performs **quality review**, not work. It knows the phase is "done" (multiple agents agreed). Its job is adversarial scrutiny: actively trying to find gaps, shallow analysis, and quality issues.

**Important distinction:**
- **Confirmation pass** = "Do this phase" (finds nothing to do if complete)
- **Verification agent** = "Review this work" (assumes complete, critiques it)

## When to Run

After work consensus (mandatory N+1 confirmation pass agrees work is done):

```
Work Loop (Agent A)
├── Iteration 1...N
└── Agent A declares DONE

Mandatory Confirmation Pass (Agent B)
├── Agent B receives same prompt: "Complete phase R{N}"
├── Agent B examines outputs, attempts to complete
└── Agent B finds nothing to do → Declares DONE
    └── Work consensus achieved

Verification Agent (this agent) ← NOW WE RUN
├── Agent knows this is quality review, not work
├── Adversarial mindset: find problems
│   ├── VERIFIED → Phase complete
│   └── GAPS_FOUND → Revise iteration → Re-verify
│
└── Next phase or task review
```

## Iteration Prompt Template

```
Verification for R{N}: "{title}"

You are reviewing work completed by another agent. Your job is to find problems, not confirm success. Approach this adversarially.

Read:
- .iterative-work/{slug}/plan.md (find R{N}'s criteria)
- .iterative-work/{slug}/progress.md (work history for R{N})
- .iterative-work/{slug}/guardrails.md (known pitfalls)
- The actual output files: {output_paths}

Verification checklist:

1. CRITERIA AUDIT
   For each criterion:
   - Is it actually addressed, not just mentioned?
   - Does the work match the intent, not just the letter?
   - Are there implicit requirements the criteria missed?

2. DEPTH CHECK
   - Is the analysis superficial or thorough?
   - Are claims supported with evidence?
   - Are multiple perspectives considered?
   - Would an expert find this adequate?

3. GAP ANALYSIS
   - What questions does this leave unanswered?
   - What obvious angles were missed?
   - Are there logical jumps or unsupported conclusions?

4. QUALITY ASSESSMENT
   - Is the structure clear and logical?
   - Is the writing clear and precise?
   - Does it flow coherently?
   - Are sources properly attributed?

5. COHERENCE CHECK
   - Does this phase connect to prior phases?
   - Will subsequent phases have what they need?
   - Are there contradictions with earlier work?

For each issue found:
[gap] {severity: critical|major|minor} {description}

Append to progress.md:

## Verify R{N} - {timestamp}
**Criteria checked:** {count} of {total}
**Depth assessed:** {adequate|shallow|thorough}
**Issues found:** {count}

{list each gap if any}

If NO critical or major gaps:
- Add "**Result:** VERIFIED"
- Output: <signal>R{N}_VERIFIED</signal>

If critical or major gaps found:
- Add "**Result:** GAPS_FOUND"
- Output: <signal>R{N}_GAPS:{count}</signal>

The revise agent will receive your gap list and address them.
```

## Gap Severity Guide

| Severity | Definition | Action |
|----------|------------|--------|
| Critical | Missing major requirement, factual errors, logical flaws | Must fix before proceeding |
| Major | Shallow analysis, missing perspective, unclear argument | Must fix before proceeding |
| Minor | Style issues, minor clarifications, polish | Fix in review phase or skip |

## Output Formats

### VERIFIED

```
## Verify R2 - 2026-01-16T14:30:00Z
**Criteria checked:** 4 of 4
**Depth assessed:** thorough
**Issues found:** 0

**Result:** VERIFIED

<signal>R2_VERIFIED</signal>
```

### GAPS_FOUND

```
## Verify R2 - 2026-01-16T14:30:00Z
**Criteria checked:** 4 of 4
**Depth assessed:** shallow
**Issues found:** 2

[gap] major Source evaluation lacks specific scoring criteria
[gap] critical Conclusion contradicts evidence from source 3

**Result:** GAPS_FOUND

<signal>R2_GAPS:2</signal>
```

## After GAPS_FOUND

Main session:
1. Parses gap list from verification output
2. Spawns revise iteration specifically targeting gaps
3. Revise iteration runs (with gap list in prompt)
4. Re-runs verification agent
5. Loop until VERIFIED or max attempts

## Max Verification Cycles

Prevent infinite verify-revise loops:
- Default: 3 verification attempts per phase
- If still failing after 3, escalate to user
- User can: simplify criteria, intervene manually, or accept with known gaps

## Integration with Phase Flow

```
Phase R{N} Lifecycle:

1. Work Loop (iterations 1...N)
   └── Agent declares DONE

2. Mandatory Confirmation Pass (Agent B)
   │   Same prompt: "Complete phase R{N}"
   │   Agent B doesn't know this is confirmation
   │
   ├── Finds work? → Does it → Eventually DONE
   │                 └── Spawn Agent C for another confirmation
   │
   └── Finds nothing? → DONE → Work consensus

3. Verification Agent (this agent, max 3 cycles)
   │   NOW we explicitly review
   │
   ├── VERIFIED → Phase complete
   └── GAPS_FOUND → revise iteration → re-verify

4. Phase Complete
   └── Mark R{N} as done in state.json
   └── Proceed to next phase

After all phases:

5. Task Review Phase
   └── Cross-phase coherence check

6. Human Review
   └── Final approval
```

## What Verification Does NOT Check

Leave these for task review phase:
- Cross-phase consistency
- Overall task coherence
- Deliverable completeness (all phases together)

Verification is laser-focused on single-phase quality.
