# Hookify Rule: warn-locks-in-audio

- **Pattern:** `NSLock|os_unfair_lock|pthread_mutex`
- **Scope:** file
- **Action:** warn
- **Enabled:** true
- **Message:** Do not use locks in audio code — use `Atomic` only. Locks in audio tap callbacks cause priority inversion.
