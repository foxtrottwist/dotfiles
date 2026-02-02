# Subagent Prompts

Templates for Task tool subagents. Customize based on audit type.

## General Review Agent

```
Audit `[DIRECTORY]` for documentation accuracy.

## Process
1. Inventory files and their purpose
2. Check existing README and comments
3. Verify docs match code behavior
4. Assess: minimal but sufficient?

## Output
Return using report-format.md structure.

## Constraints
- Do not modify files
- Focus only on [DIRECTORY]
- Note cross-module concerns for main session
- Cite file paths and line numbers
```

## Quick Sync Agent

```
Quick sync check on `[DIRECTORY]`.

## Checks
1. Do README file lists match reality?
2. Do interface comments match signatures?
3. Are there references to removed code?

## Output
Status: CLEAN | DRIFT DETECTED | NEEDS REVIEW
Issues: [list]
Recommendation: [one sentence]

Keep output minimal - this is a smoke test.
```

## Feature Exploration Agent

```
Map the `[FEATURE]` feature for planning.

## Explore
1. Find entry points
2. Trace data flow
3. Map dependencies (uses / used by)
4. Identify extension points

## Output
- Entry points with paths
- Core components
- Data flow summary
- Key files table
- Gotchas and non-obvious behavior
```

## Documentation Audit Agent

```
Audit `[DIRECTORY]` against minimal documentation philosophy.

Philosophy: Code is truth. Docs should direct, not describe. Less = better.

## Evaluate each doc piece
- Necessary? (removal hurts understanding?)
- Accurate? (matches current code?)
- Maintainable? (will stay current?)

## Output
- Current state assessment
- Remove: [items reducing maintenance burden]
- Update: [inaccurate items]
- Add: [missing critical context only]
```
