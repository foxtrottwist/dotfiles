---
name: prompt-dev
description: Create and refine prompt templates following Claude 4 conventions. Use when asked to build a new prompt template, improve an existing prompt, debug why a prompt isn't working, or develop reusable prompts for specific tasks. Triggers on "create a prompt", "build a template", "fix this prompt", "prompt isn't working", or requests to make prompts for specific use cases.
---

# Prompt Development

Iterative prompt template creation using the DISCOVER → DRAFT → TEST → REFINE → VALIDATE workflow. State persists in files for resumption.

## Resume Check

Every invocation, check for existing work:

```bash
ls .prompt-dev/ 2>/dev/null
```

**If state exists**, read `state.json` and present status. Offer to resume, start fresh, or show current template.

**If no state**, proceed to Discover.

## Phase 1: Discover

Use **AskUserQuestion** to gather requirements:

```yaml
Question 1: "What task should this prompt handle?"
options:
  - "{inferred from request} (Recommended)"
  - "Content generation"
  - "Data extraction"
  - "Analysis/review"
  - "Other"

Question 2: "What inputs will users provide?"
multiSelect: true
options:
  - "Structured data (JSON, XML)"
  - "Freeform text"
  - "Images or files"
  - "Parameters/settings"

Question 3: "What output format?"
options:
  - "Structured (specific format)"
  - "Freeform text"
  - "Artifact/file"
  - "Depends on input"

Question 4: "Any specific constraints?"
multiSelect: true
options:
  - "Must follow existing style guide"
  - "Specific tone/voice required"
  - "Integration with other systems"
  - "None"
```

**Output:**
- Create `.prompt-dev/{template-slug}/`
- Write `brief.md` with requirements
- Write `state.json`: `{ "phase": "draft" }`

## Phase 2: Draft

Create minimal viable template following conventions in [references/conventions.md](references/conventions.md).

Template structure:
```markdown
## Task Context
{What Claude is being asked to do}

## Input Structure
{XML format for user inputs}

## Constraints
{Boundaries and requirements}

## Success Criteria
{Measurable outcomes}

## Output Format
{Expected deliverable format}
```

See [references/examples.md](references/examples.md) for patterns.

**Output:**
- Write `template.md` with draft
- Create empty `test-log.md`
- Create empty `guardrails.md`
- Update `state.json`: `{ "phase": "test" }`
- Present template for user review

## Phase 3: Test

This phase requires user collaboration. The template must be tested with real or representative cases.

**Per test case:**
1. User provides test input
2. Run template against input
3. Evaluate output against success criteria
4. Log result in `test-log.md`:

```markdown
## Test {N} - {timestamp}
**Input:** {description}
**Expected:** {what should happen}
**Actual:** {what happened}
**Status:** PASS | FAIL | PARTIAL
**Notes:** {observations}
```

**Exit criteria:**
- Minimum 2-3 test cases run
- At least one edge case tested
- Failure patterns identified (if any)

Update `state.json`: `{ "phase": "refine" }`

## Phase 4: Refine

Analyze test-log.md for failure patterns. For each failure:

1. Identify root cause (unclear constraint, missing context, wrong output format)
2. Add to `guardrails.md`:
```markdown
## {Pattern Name}
- **Symptom:** {what went wrong}
- **Cause:** {why it happened}
- **Fix:** {constraint or change added}
- **Learned:** Test {N}
```
3. Update template.md with fixes
4. Return to Test phase if significant changes made

**Exit criteria:**
- All identified issues addressed
- No new failures in re-tests
- Guardrails documented

Update `state.json`: `{ "phase": "validate" }`

## Phase 5: Validate

Final check against quality checklist:

- [ ] Task context clearly defined
- [ ] Constraints specific and actionable
- [ ] Input structure uses XML when appropriate
- [ ] Output format appropriate for usage context
- [ ] No unnecessary process instructions
- [ ] Success criteria measurable
- [ ] No prohibited terms (see conventions.md)
- [ ] Tested with real cases

**If all pass:**
- Present final template
- Archive to `.prompt-dev/archive/{slug}/` if requested
- Update `state.json`: `{ "phase": "complete" }`

**If issues found:**
- Return to appropriate phase

## State Files

```
.prompt-dev/{template-slug}/
├── state.json      # Current phase
├── brief.md        # Requirements from discovery
├── template.md     # Current template version
├── test-log.md     # Test cases and results
└── guardrails.md   # Patterns that didn't work
```

## Quick Reference

| Command | Action |
|---------|--------|
| `/prompt-dev {description}` | Start new template |
| `/prompt-dev resume` | Continue from last phase |
| `/prompt-dev status` | Show current state |
