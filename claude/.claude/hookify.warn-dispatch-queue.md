# Hookify Rule: warn-dispatch-queue

- **Pattern:** `DispatchQueue\.|DispatchGroup`
- **Scope:** file
- **Action:** warn
- **Enabled:** true
- **Message:** Use async/await instead of GCD (DispatchQueue/DispatchGroup). See CLAUDE.md concurrency rules.
