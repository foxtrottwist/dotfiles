# Hookify Rule: warn-corner-radius

- **Pattern:** `\.cornerRadius\(`
- **Scope:** file
- **Action:** warn
- **Enabled:** true
- **Message:** Use `.clipShape(.rect(cornerRadius:))` instead of deprecated `.cornerRadius()`.
