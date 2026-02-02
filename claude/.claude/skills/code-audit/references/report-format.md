# Report Format

## Subagent Finding Report

```markdown
## Review: [Directory]

### Summary
[1-2 sentences: what reviewed, overall health]

### Findings

#### [CRITICAL|WARNING|INFO]: [Title]
- **Location**: `path/file:line`
- **Issue**: [what's wrong]
- **Fix**: [specific action]

[Repeat per finding]

### Documentation Status
- README: exists/missing, accurate/stale
- Comments: adequate/sparse/excessive

### Clean Areas
[What's in good shape - confirms coverage]
```

## Severity Levels

| Level | Criteria |
|-------|----------|
| CRITICAL | Docs contradict code; missing public API docs; security gaps |
| WARNING | Stale but not misleading; orphaned docs; inconsistent naming |
| INFO | Minor improvements; style issues; reduction opportunities |

## Aggregated Report

```markdown
# Audit Summary: [Project]

## Overview
- Partitions: [N]
- Critical: [N] | Warnings: [N] | Info: [N]

## Critical Issues
[Aggregated, deduplicated]

## Warnings
[Grouped by type]

## Recommendations
[Prioritized actions]
```
