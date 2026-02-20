# Hookify Rule: warn-logger-missing-nonisolated

- **Pattern:** `private let log = Logger\.`
- **Scope:** file
- **Action:** warn
- **Enabled:** true
- **Message:** Logger declaration missing `nonisolated` keyword. Use `private nonisolated let log = Logger.xxx` to avoid MainActor isolation issues.
