# CLAUDE.md — Global

## Code Conventions

- Accessibility-first: semantic HTML, ARIA when needed, keyboard navigation
- Test with React Testing Library and Vitest — test behavior, not implementation
- TailwindCSS for styling
- Learning context (exploring, understanding): guidance and trade-offs. Building context (creating, implementing): complete implementations. Infer from request language — "how does X work" vs "build X"
- **Swift/SwiftUI/iOS:** Consult the `swift-dev` skill for conventions, patterns, and specialist skill routing. Do not generate Swift code without checking it first.

## Orchestration Patterns

### Batch Deterministic Operations

When a task involves multiple deterministic operations (build/lint/test sequences, file scanning, data aggregation, pattern matching), generate and execute a single script rather than running commands individually with reasoning between each.

- Build, lint, and test are one script call, not three bash calls
- File scanning across a directory is one grep/find pipeline, not per-file reads
- Data aggregation from multiple sources is one script with structured output

### Structured Script Output

Scripts should output JSON to `{state-dir}/script-output.json` for the next step to consume. Parsing stdout between inference passes wastes context on string interpretation.

### Reserve Inference for Judgment

Don't spend tokens on:
- Interpreting exit codes (script handles pass/fail logic)
- String concatenation of multi-file results (script aggregates)
- Deciding which file to read next in a known sequence (script iterates)

### MCP Tool Batching

When chaining MCP operations (multiple Shortcuts, multiple Filesystem reads), prefer generating a coordination script over sequential tool calls when the sequence is predictable. If the MCP server supports batch operations, use them.

### Subagent Dispatch

When dispatching Task subagents (iter, code-audit), batch the pre-dispatch preparation into the prompt rather than running discovery commands and synthesizing results across multiple inference passes before dispatch.

## Commit Messages

- **No Claude signature** - Omit "Generated with Claude Code" and "Co-Authored-By"
- **Conventional commits** - Use `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `style` prefixes
- **Match project conventions** - Follow existing casing (e.g., `Feat(scope)` in Swift, `feat(scope)` elsewhere)
- **Concise description** - Brief summary of what changed

## Writing Rules

Apply to ALL written output — code comments, docs, commit messages, PR descriptions.

**Voice:** Direct, conversational, honest. Technical precision without jargon. Specific examples over abstract claims.

Avoid corporate filler: "leverage", "seamless", "robust", "elegant", "crafting" — use plain alternatives.

## File Conventions

- Scratch files use `*.local` or `*.local.*` extensions (e.g., `notes.local`, `plan.local.md`) — gitignored across projects
- Skill state lives under `.workflow.local/{skill}/` (e.g., `.workflow.local/writing/`, `.workflow.local/code-audit/`) — the `*.local` gitignore pattern keeps it untracked

## Playwright CLI

- Do NOT run image tools (`chafa`, `viu`, etc.) directly — they freeze the TUI. Instead open a Zellij floating pane: `zellij run --floating -- viu <file>`

## Constraints

- Never alter quoted scripture — maintain source integrity
- Prefer automation over manual repetition — if performing the same operation 3+ times, write a script
- Skill descriptions must be trigger conditions ("Use when..."), not workflow summaries — summaries cause Claude to shortcut the description instead of reading the full skill body
