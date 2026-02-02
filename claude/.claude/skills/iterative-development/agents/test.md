# Test Agent

Generate tests for completed implementation. Runs as a loop until coverage met.

## Model

`sonnet` — Structured test generation.

## When to Use

- After implementation tasks complete
- When acceptance criteria include test coverage
- Before review phase (tests inform review)

## Test Loop Structure

```
Test Loop for feature
├── Iteration 1: Create test files, basic coverage
├── Iteration 2: Add edge cases
├── Iteration 3: Fix failing tests, verify green
└── TESTS_PASS → proceed to review
```

## Iteration Prompt Template

```
Test iteration {I} of {MAX} for "{feature}".

Read:
- .claude/iterative-dev/{slug}/tasks.md (what to test)
- .claude/iterative-dev/{slug}/progress.md (implementation details)
- Existing test patterns in project

Files needing tests: {list}

This iteration:
1. If iteration 1: Create test file structure
2. Review what tests exist from prior iterations
3. Add tests for uncovered criteria
4. Include edge cases from progress.md
5. Run tests to verify
6. Commit: "test({slug}): {summary}"
7. Append to progress.md:

## Tests - Iteration {I} - {timestamp}
**Files:** {test files created/modified}
**Tests added:** {count and descriptions}
**Coverage:** {what is now tested}
**Run result:** {pass/fail with details}
**Commit:** {hash}

If all tests pass and coverage complete:
- Add "**Result:** TESTS_PASS"
- Output: <signal>TESTS_PASS</signal>

If tests fail:
- List failures
- Note what needs fixing
- Output: <signal>TESTS_FAIL:{summary}</signal>
```

## Test Categories to Cover

### Unit Tests
- Individual functions/methods
- Isolated from dependencies
- Fast execution

### Integration Tests (if applicable)
- Component interactions
- Real dependencies where appropriate

### Edge Cases
- Null/nil handling
- Empty collections
- Boundary values
- Error conditions

## Project Convention Matching

Each iteration should:
1. Check existing test patterns
2. Match naming conventions
3. Use same assertion styles
4. Follow directory structure

## Iteration Strategy

**Iteration 1**: Foundation
- Create test file(s)
- Add happy path tests
- Establish patterns

**Iteration 2-N**: Coverage expansion
- Add edge cases
- Cover error paths
- Fill gaps

**Final iteration**: Verification
- All tests green
- Coverage meets criteria
- Clean commit

## Output Formats

### TESTS_PASS
```
## Tests - Iteration {I} - {timestamp}
**Files:** UserTests.swift, AuthServiceTests.swift
**Tests added:** 12 total
**Coverage:** 
- User model: init, codable, validation
- AuthService: login success, login failure, token refresh
**Run result:** 12/12 passing
**Result:** TESTS_PASS

<signal>TESTS_PASS</signal>
```

### TESTS_FAIL
```
## Tests - Iteration {I} - {timestamp}
**Files:** AuthServiceTests.swift
**Tests added:** 4 this iteration
**Coverage:** login flow
**Run result:** 10/12 passing
**Failures:**
- testLoginWithExpiredToken: Expected error, got success
- testTokenRefresh: Timeout

**Result:** TESTS_FAIL

<signal>TESTS_FAIL:2 failures in auth flow</signal>
```

## After TESTS_FAIL

Options:
1. Continue test iterations to fix test issues
2. If tests reveal implementation bugs, spawn fix loops
3. Escalate to user if unclear whether bug is in test or implementation

## Test Quality Checklist

- [ ] Tests are independent (no shared state)
- [ ] Tests are deterministic (no flaky tests)
- [ ] Test names describe behavior
- [ ] Assertions are specific
- [ ] Edge cases covered
- [ ] Error paths tested
- [ ] Follows project conventions
