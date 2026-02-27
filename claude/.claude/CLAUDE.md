# CLAUDE.md — Global

## Response Style

- Concise by default. Don't pad responses with preamble or postamble.

## Code Conventions

- Accessibility-first: semantic HTML, ARIA when needed, keyboard navigation
- Test behavior, not implementation
- **Swift/SwiftUI/iOS:** Consult the `swift-dev` skill for conventions, patterns, and specialist skill routing. Do not generate Swift code without checking it first.

## Orchestration Patterns

### Batch Deterministic Operations

When a task involves multiple deterministic operations (build/lint/test sequences, file scanning, data aggregation, pattern matching), generate and execute a single script rather than running commands individually with reasoning between each.

- Build, lint, and test are one script call, not three bash calls
- File scanning across a directory is one grep/find pipeline, not per-file reads
- Data aggregation from multiple sources is one script with structured output

### Reserve Inference for Judgment

Don't spend tokens on:
- Interpreting exit codes (script handles pass/fail logic)
- String concatenation of multi-file results (script aggregates)
- Deciding which file to read next in a known sequence (script iterates)

Don't script tasks where intermediate results change the approach.

### Context Preservation

When a task involves 3+ files or 2+ distinct operations, prefer dispatching subagents via the Task tool over doing work inline. Keep the primary context for planning, reviewing results, and making decisions — not for implementation.

Exceptions: single-file edits, quick lookups, and tasks where intermediate results change the approach.

## Verification

- After changes, run the project's test/lint/build commands and confirm they pass before reporting completion.

## Commit Messages

- **No Claude signature** - Omit "Generated with Claude Code" and "Co-Authored-By"
- **Conventional commits** - Use `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `style` prefixes
- **Match project conventions** - Follow existing casing (e.g., `Feat(scope)` in Swift, `feat(scope)` elsewhere)
- **Concise description** - Brief summary of what changed
- Example: `feat(nvim): add telescope keybind for live grep`

## Writing Rules

Apply to ALL written output — code comments, docs, commit messages, PR descriptions.

**Voice:** Direct, conversational, honest. Technical precision without jargon. Specific examples over abstract claims.

Avoid corporate filler: "leverage", "seamless", "robust", "elegant", "crafting" — use plain alternatives.

Avoid: "This leverages a robust framework to seamlessly integrate..."
Prefer: "This uses Express to handle routing."

## File Conventions

- Scratch files use `*.local` or `*.local.*` extensions (e.g., `notes.local`, `plan.local.md`) — gitignored across projects

## Playwright CLI

- Do NOT run image tools (`chafa`, `viu`, etc.) directly — they freeze the TUI. Instead open a Zellij floating pane: `zellij run --floating -- viu <file>`

## Constraints

- Never alter quoted scripture — maintain source integrity
