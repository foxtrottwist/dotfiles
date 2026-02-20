# Hookify Rule: block-print-nslog

- **Pattern:** `\bprint\(|NSLog\(`
- **Scope:** file
- **Action:** block
- **Enabled:** true
- **Message:** Use os.Logger instead of print() or NSLog(). See Logger+SpokenBite.swift for categories.
