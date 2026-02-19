# CLAUDE.md — Global

## Identity

- **Name:** Law Horne
- **Role:** Senior AI Engineer (frontend/accessibility focus)
- **Location:** Remote (Indianapolis-based)
- **Background:** 7+ years frontend engineering (React/TS/Node). Former retail buyer turned self-taught engineer. ASL fluent, deaf/HoH community volunteer.

## Tech Stack

- **Languages & Frameworks:** JavaScript (ES6+), TypeScript, React, Node.js, Next.js, Swift/SwiftUI, Go
- **UI:** HTML5, CSS3/SCSS, TailwindCSS, Responsive Design, Styled-Components
- **Testing:** React Testing Library, Vitest, Accessibility Testing
- **Standards:** WCAG 2.1 AA, ARIA patterns, keyboard navigation, inclusive design
- **State:** React Query, React Hook Form, Redux, Context API
- **Tools:** Neovim, Vite, Git, GitHub Workflows, iA Writer, DEVONthink, Shortcuts automation, Audio Hijack

## Security Warnings

- DO NOT ACCESS Support/Claude/claude_desktop_config.json IN WITH METHOD THIS INCLUDES Reading OR THE USE OF cat THIS IS MAJOR SECURITY RISK

## Code Conventions

- TypeScript strict mode preferred
- Functional components with hooks (no class components)
- Accessibility-first: semantic HTML, ARIA when needed, keyboard navigation
- Test with React Testing Library and Vitest — test behavior, not implementation
- TailwindCSS for styling
- Keep components small and composable
- Learning context (exploring, understanding): guidance and trade-offs
- Building context (creating, implementing): complete implementations
- Infer from request language — "how does X work" vs "build X"
- Production-ready standards and accessibility compliance when providing implementations
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

Do spend tokens on:
- Interpreting results that require judgment
- Making architectural or design decisions
- Generating creative output (writing, code design, user-facing content)
- Debugging when the script's assertions fail

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

**Prohibited terms — replace immediately:**
- "crafting" → building, creating
- "drove/championed" → led, implemented
- "elegant/performant" → clean, efficient
- "passionate/innovative" → show through examples
- "leverage/seamless/robust" → use, apply, works well

**Content criteria:** Include 2 of 3: actionable (specific tools/methods), evidence-based (results or metrics), problem-solving (real challenges with tested solutions).

**Alerts:** Flag if prohibited terms used, voice inconsistency detected, or claims lack evidence.

## SF Symbols

- Do not use "sparkles" SF Symbol or any sparkle-style icon - overused for AI features

## File Conventions

- When creating scratch files, notes, or tracking artifacts in a repo, prefer `*.local` or `*.local.*` extensions (e.g., `notes.local`, `plan.local.md`) — these are gitignored across projects
- This does not replace built-in task tracking — use whichever fits the situation
- Script outputs: structured JSON to `{state-dir}/script-output.json`, not stdout parsing
- State directories use `.local` suffix (`.iter.local/`, `.code-audit.local/`)

## Agent Teams

- Terminal multiplexer is Zellij, not tmux — use `in-process` teammate mode until Zellij is supported as a split-pane backend
- When Zellij split-pane support is available, prefer `"teammateMode": "zellij"` (or equivalent)
- After spawning a team, press **Shift+Tab** to enable delegate mode — restricts the lead to coordination-only (spawn, message, task management) and prevents it from implementing directly

## Playwright CLI

- Always use `--browser=chromium` when opening browser sessions
- Do NOT use terminal image tools (`chafa`, `viu`, etc.) inside CC — they freeze or dump escape codes since the TUI can't pass through image protocols
- After screenshots or image generation, open a floating Zellij pane with `viu`: `zellij run --floating -- viu <file>`

## Constraints

- Only take actions when confident of the outcome
- Alert on unverified claims or fabricated information
- Never alter quoted scripture — maintain source integrity
- Prefer automation over manual repetition — if performing the same operation 3+ times, write a script
- When running multiple bash commands in sequence where each output feeds the next, combine into a single script with error handling rather than separate calls
