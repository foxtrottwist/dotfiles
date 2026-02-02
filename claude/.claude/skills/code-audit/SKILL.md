---
name: code-audit
description: Verify documentation accuracy against code behavior using parallel subagents. Supports resume after interruption, accumulates codebase-specific lessons, and includes verification gates. Triggers on "audit the codebase", "verify documentation", "check docs match code", "review codebase", "documentation health", "doc drift", "stale documentation", or requests to validate code/doc alignment.
---

# Code Audit

Verify documentation accuracy against code using parallel subagents with state persistence and verification gates.

## Core Pattern

```
State persists across sessions.
Parallel subagents review partitions.
Verification gates catch false positives.
Guardrails accumulate lessons.
```

## Workflow

```
RESUME?  →  SCOPE  →  PARTITION  →  REVIEW  →  VERIFY  →  PROPOSE
(check      (what to   (spawn       (parallel  (confirm   (present
 state)     audit)     subagents)   review)    findings)  actions)
```

## Phase 0: Resume Check

Every invocation:

```bash
ls .code-audit/ 2>/dev/null
```

**If state exists**, read `state.json` and present:
```
Found audit of "{project}" at {phase}:
- Reviewed: src/, lib/
- Pending: tests/, docs/
- Findings: 3 critical, 5 warnings

Resume, start fresh, or view findings?
```

**If no state**, proceed to Scope.

## Phase 1: Scope

Use **AskUserQuestion** to determine audit type:

```yaml
Question 1: "What type of audit?"
options:
  - "Full codebase review"
  - "Specific directory/module"
  - "Quick sync (smoke test)"
  - "Feature exploration"

Question 2: "Focus area?"
options:
  - "Documentation accuracy"
  - "Missing documentation"
  - "Stale/excessive docs"
  - "All of the above"
```

**Output:**
- Create `.code-audit/{project-slug}/`
- Write `brief.md` with scope
- Write `state.json`: `{ "phase": "partition" }`

## Phase 2: Partition

Divide codebase into reviewable units.

**Default: Directory-based**
1. List top-level directories (exclude build artifacts, dependencies)
2. Group small related directories
3. Target 3-6 partitions

**Feature-based** (for targeted audits):
1. Identify feature entry point
2. Trace primary dependencies
3. Create partitions: core, dependencies, consumers

**Output:**
- Write `partitions.md` listing units
- Update `state.json`: `{ "phase": "review", "pending": [...], "complete": [] }`

## Phase 3: Review (Parallel Subagents)

Spawn parallel Task agents for each partition. See [references/subagent-prompts.md](references/subagent-prompts.md).

```
Launch [N] parallel review agents:

Task 1: Audit `src/auth/` - authentication module
Task 2: Audit `src/api/` - API layer
Task 3: Audit `src/models/` - data models
...
```

Each subagent:
1. Reviews assigned partition only
2. Returns structured findings (see [references/report-format.md](references/report-format.md))
3. Notes cross-cutting concerns

**Limits:**
- 3-6 concurrent subagents
- 2-3 directory levels per agent
- Split partitions >20 files

**After completion:**
- Aggregate findings into `findings.md`
- Update `state.json` with completed partitions
- Append session to `progress.md`

## Phase 4: Verify (Gates)

Before presenting findings, run verification gates.

### Gate 1: Confirmation Pass
Fresh agent reviews aggregated findings:
- Are findings consistent across partitions?
- Any contradictions or duplicates?
- Do severity levels seem accurate?

### Gate 2: Verification Agent
Adversarial review:
- Spot-check 2-3 findings against actual code
- Look for false positives
- Verify proposed fixes are correct

**If issues found:** Adjust findings, re-run affected checks.

**If gates pass:** Proceed to Propose.

## Phase 5: Propose

Present verified findings with action options:

```
## Audit Summary: {project}

**Reviewed:** {N} partitions
**Findings:** {critical} critical, {warning} warnings, {info} info

### Critical Issues
[List with locations and recommended fixes]

### Warnings
[Grouped by type]

### Recommendations
[Prioritized action list]

---

Options:
1. Address all critical issues
2. Address specific items
3. Generate remediation plan
4. Export findings and close
```

**Important:** Always get approval before modifying files.

## State Files

```
.code-audit/{project-slug}/
├── state.json       # Current phase, partition status
├── brief.md         # Audit scope and requirements
├── partitions.md    # Review units
├── findings.md      # Aggregated, verified findings
├── progress.md      # Session log
└── guardrails.md    # Codebase-specific lessons
```

## Guardrails

Read before each session. Append when discovering patterns:

```markdown
## {Pattern Name}
- **Context:** {when this applies}
- **Lesson:** {what to watch for or ignore}
- **Source:** {which audit session}
```

Examples:
- "This codebase uses `// MARK:` for section headers - not stale comments"
- "Generated files in `src/gen/` - skip documentation checks"
- "Team convention: minimal README, detailed doc comments"

## Progress Tracking

Append after each session:

```markdown
## Session - {timestamp}
**Partitions reviewed:** src/auth/, src/api/
**Findings:** 2 critical, 3 warnings
**Notes:** {observations}
```

Enables resume and provides audit history.

## Documentation Philosophy

See [references/doc-philosophy.md](references/doc-philosophy.md):
- Code is source of truth
- Documentation should direct, not describe
- Less documentation = less maintenance burden
- Stale docs are worse than no docs

## Quick Reference

| Audit Type | Partitions | Depth | Output |
|------------|------------|-------|--------|
| Full review | All directories | Deep | Complete findings |
| Quick sync | All directories | Shallow | Status + blockers |
| Module audit | Single partition | Deep | Focused findings |
| Feature exploration | Traced dependencies | Medium | Feature map |
