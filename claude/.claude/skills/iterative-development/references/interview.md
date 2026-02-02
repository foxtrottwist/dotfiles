# Interview Questions

Use the **AskUserQuestion** built-in tool during Phase 1. This tool presents clickable options to the user.

## Tool Usage

```
Invoke AskUserQuestion with:
- question: The question text
- options: Array of choices (first option can end with "(Recommended)")
- multiSelect: true/false (allow multiple selections)
```

Users can always select "Other" to provide free text input.

## Core Questions

### 1. What are we building?

```yaml
question: "What are we building?"
options:
  - "{auto-detected from prompt} (Recommended)"
  - "New feature"
  - "Bug fix"
  - "Refactor"
  - "Other"
```

### 2. Completion criteria

```yaml
question: "How will we know it's done?"
multiSelect: true
options:
  - "All tests passing"
  - "Manual verification works"
  - "Specific behavior: [describe]"
  - "Performance target met"
  - "Code review approved"
```

### 3. Constraints

```yaml
question: "Any constraints to consider?"
multiSelect: true
options:
  - "Maintain backward compatibility"
  - "Performance critical"
  - "Accessibility requirements"
  - "Platform specific (iOS/Android/Web)"
  - "Time constraint"
  - "None / flexible"
```

### 4. Technical approach

```yaml
question: "Technical approach?"
options:
  - "Follow existing patterns (Recommended)"
  - "Specific approach: [describe]"
  - "Need to explore codebase first"
  - "Let me decide based on what I find"
```

## Feature-Specific Questions

### UI/Frontend

```yaml
question: "UI requirements?"
options:
  - "Match existing design system"
  - "New design provided"
  - "Minimal viable UI"
  - "Need design review first"
```

### API/Backend

```yaml
question: "API style?"
options:
  - "Follow existing conventions (Recommended)"
  - "REST"
  - "GraphQL"
  - "RPC"
```

### Refactor

```yaml
question: "Refactor scope?"
options:
  - "Minimal - fix immediate issue"
  - "Moderate - improve surrounding code"
  - "Comprehensive - full module cleanup"
```

## Question Limits

- **Max questions**: 4-6 per interview
- **Timeout**: AskUserQuestion has 60s timeout
- **Fallback**: If uncertain, note in PRD for clarification during planning

## PRD Template

Generate after interview:

```markdown
# {Feature Name}

**Created:** {timestamp}
**Status:** ready-for-planning

## Problem
{From question 1}

## Done When
{From question 2, as checklist}

## Constraints
{From question 3}

## Approach
{From question 4}

## Open Questions
{Anything unclear—resolve during planning}
```
