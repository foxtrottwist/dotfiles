---
name: chat-migration
description: Capture conversation context for seamless continuation in a new chat. Creates structured handoff documents with decisions, code context, and continuation guidance. Triggers on "save context", "migrate chat", "export conversation", "hitting context limit", "save this session", or requests to preserve work before starting fresh.
---

# Chat Migration

Generate context transfer documents for conversation continuation.

## When Invoked

Analyze the current conversation and produce a handoff document. No user questions needed—scan the full context and extract what matters.

## Output Structure

Generate a markdown artifact with these sections:

```markdown
# Context Migration: {Brief Title}

## Summary
{2-3 sentence overview of what this conversation accomplished}

## Key Decisions
{Bulleted list of choices made and rationale}

## Technical Context
{Code snippets, configurations, or technical choices that must carry forward}

## Current State
- **Completed:** {what's done}
- **In Progress:** {what was being worked on}
- **Blocked/Pending:** {what needs resolution}

## Open Questions
{Unresolved items that need attention}

## Files Modified
{List of files created or changed, with brief notes}

## Continuation Instructions
{Specific guidance for the next session—what to do first, what to avoid}
```

## Constraints

- Extract only information relevant to continuation
- Preserve exact code snippets when critical
- Include file paths for all referenced files
- Omit pleasantries and meta-discussion
- Keep decisions with their rationale (not just the choice)

## Success Criteria

- New session can resume immediately without re-explaining context
- All technical choices documented with reasoning
- No critical information lost
- Document is self-contained (no external references needed)
