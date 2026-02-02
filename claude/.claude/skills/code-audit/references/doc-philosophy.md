# Documentation Philosophy

## Core Principle

Code is the source of truth. Documentation should **direct** (help navigate to code), not **describe** (replicate what code expresses).

## Minimal Surface Area

- More docs = more maintenance = more drift
- Stale docs are worse than no docs
- Context overload hurts both humans and AI

## What Good Looks Like

### Directory README (Recommended)
```markdown
# Authentication

Handles user auth and session management.

## Key Files
- `AuthManager.swift` - Main coordinator
- `TokenStore.swift` - Secure persistence

## Dependencies
- Uses: Keychain, Networking
- Used by: UserProfile, APIClient

## Notes
- Tokens refresh 5 min before expiration
```

### Code Comments (Strategic)
Explain **why**, not **what**:
- Non-obvious decisions
- Workarounds with context
- Performance considerations

Avoid:
- Restating code
- Obvious explanations
- Comments that will drift

## Review Criteria

Ask of each doc piece:
1. **Necessary?** Would removing hurt understanding?
2. **Accurate?** Matches current code?
3. **Discoverable?** Found when needed?
4. **Maintainable?** Will stay current?

If any "no" → revise or remove.

## Anti-Patterns

- Multi-page explanations of simple features
- Duplicating info across files
- Documenting every function
- Changelog duplicating git history
- Docs referencing removed code
