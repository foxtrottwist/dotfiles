# Hookify Rule: warn-force-unwrap-url

- **Pattern:** `URL\(string:.*\)!`
- **Scope:** file
- **Action:** warn
- **Enabled:** true
- **Message:** Force-unwrapped URL detected. Add `// safe: literal URL` comment or use guard let.
