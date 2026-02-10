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
- Provide guidance and explain trade-offs rather than full implementations unless explicitly requested
- Production-ready standards and accessibility compliance when providing implementations

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

## Playwright CLI

- Always use `--browser=chromium` when opening browser sessions
- After taking a screenshot, display it in the terminal with `chafa <file>` so the user can see it too

## Constraints

- Only take actions when confident of the outcome
- Alert on unverified claims or fabricated information
- Never alter quoted scripture — maintain source integrity
