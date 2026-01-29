# CoVe Prompt Templates

Copy-paste these templates for different scenarios.

---

## Universal CoVe Template

```
Task: [TASK DESCRIPTION]

## Stage 1 — Initial Solution (Unverified)
Produce a complete solution to the task.
Mark clearly as [UNVERIFIED DRAFT].

## Stage 2 — Verification Plan
List all:
- Factual claims that must be verified
- API usages that could be incorrect
- Edge cases that could fail
- Concurrency risks
- Type safety concerns
- Environment assumptions

Do NOT re-solve the problem. Only enumerate verification targets.

## Stage 3 — Independent Verification
Verify each item from Stage 2 independently.
Do NOT rely on the reasoning from Stage 1.
For each item, provide:
- Verdict: ✓ PASSED / ✗ FAILED / ⚠ WARNING
- Evidence: Concrete proof or counterexample
- Fix: If failed, what change is required

## Stage 4 — Final Corrected Solution
Produce a corrected and fully verified solution that incorporates all fixes from Stage 3.
List all changes made and why.
```

---

## TanStack Query + tRPC Template

```
Task: [DESCRIBE THE QUERY/MUTATION]

## Stage 1 — Initial Implementation
Write the useQuery/useMutation with all handlers.

## Stage 2 — TanStack Verification Plan
- [ ] Query key uniquely identifies this data
- [ ] Query key includes all filter/sort/pagination params
- [ ] staleTime/gcTime are appropriate
- [ ] Error handling with onError or errorBoundary
- [ ] Loading state provides good UX
- [ ] Mutation invalidates correct queries
- [ ] Optimistic update has proper rollback
- [ ] No race conditions between mutations

## Stage 3 — Adversarial Testing
Attempt to break this code with:
1. Rapid successive calls
2. Network failure mid-request
3. Concurrent conflicting mutations
4. Stale data after successful mutation
5. Component unmount during pending query

## Stage 4 — Verified Implementation
Produce corrected code with all fixes.
```

---

## Prisma Database Template

```
Task: [DESCRIBE THE DATABASE OPERATION]

## Stage 1 — Initial Query/Mutation
Write the Prisma operation.

## Stage 2 — Database Verification Plan
- [ ] Transaction wraps all related operations
- [ ] Isolation level is appropriate (READ COMMITTED, SERIALIZABLE, etc.)
- [ ] N+1 queries avoided (use include/select)
- [ ] Null handling is explicit
- [ ] Unique constraints won't be violated
- [ ] Foreign key relationships are valid
- [ ] Indexes exist for WHERE/ORDER BY columns

## Stage 3 — Concurrent Access Testing
Verify under these conditions:
1. Two users update same record simultaneously
2. Parent record deleted while child being created
3. Unique constraint race condition
4. Long-running transaction blocking others
5. Deadlock potential with multiple updates

## Stage 4 — Verified Database Code
Produce corrected code with transaction boundaries and error handling.
```

---

## React Component Template

```
Task: [DESCRIBE THE COMPONENT]

## Stage 1 — Initial Component
Write the React component with all hooks and handlers.

## Stage 2 — React Verification Plan
- [ ] useEffect dependency array is complete
- [ ] useEffect has cleanup for subscriptions/timers
- [ ] useMemo/useCallback have correct dependencies
- [ ] Event handlers don't have stale closures
- [ ] Keys are stable and unique for lists
- [ ] State updates are immutable
- [ ] Derived state calculated during render, not stored
- [ ] Error boundary handles failures

## Stage 3 — Render Cycle Testing
Attempt to cause incorrect rendering:
1. Props changing faster than render cycle
2. Parent re-render with same props (referential equality)
3. State update during render
4. Async setState after unmount
5. Multiple rapid state updates

## Stage 4 — Verified Component
Produce corrected component with proper memoization and cleanup.
```

---

## API Endpoint Template

```
Task: [DESCRIBE THE API ENDPOINT]

## Stage 1 — Initial Endpoint
Write the API route/server action.

## Stage 2 — API Verification Plan
- [ ] Authentication checked before data access
- [ ] Authorization checked for resource ownership
- [ ] Input validated with schema (Zod, etc.)
- [ ] Response has correct HTTP status codes
- [ ] Errors don't leak sensitive information
- [ ] Rate limiting considered
- [ ] Idempotency for retryable operations

## Stage 3 — Security Testing
Attempt to break this endpoint:
1. Missing or malformed input
2. Expired/invalid auth token
3. SQL/NoSQL injection attempts
4. Accessing another user's data
5. Excessive request rate
6. Large payload attack

## Stage 4 — Verified Endpoint
Produce corrected endpoint with validation and security checks.
```

---

## Form Submission Template

```
Task: [DESCRIBE THE FORM]

## Stage 1 — Initial Form
Write the form component with validation and submission.

## Stage 2 — Form Verification Plan
- [ ] Client validation matches server validation
- [ ] Required fields are enforced
- [ ] Error messages are user-friendly
- [ ] Submit button disabled during submission
- [ ] Success/error feedback is clear
- [ ] Form resets or redirects after success
- [ ] Unsaved changes warning on navigation
- [ ] Accessibility (labels, ARIA, focus management)

## Stage 3 — Edge Case Testing
Attempt to break this form:
1. Submit with JavaScript disabled
2. Double-click submit button
3. Network failure during submission
4. Paste extremely long input
5. Special characters and Unicode
6. Server returns validation errors

## Stage 4 — Verified Form
Produce corrected form with all edge cases handled.
```

---

## State Machine Template

```
Task: [DESCRIBE THE STATE MACHINE]

## Stage 1 — Initial State Machine
Define states, transitions, and effects.

## Stage 2 — State Machine Verification Plan
- [ ] All valid states are reachable
- [ ] No invalid state transitions are possible
- [ ] Terminal states are correct (if any)
- [ ] Side effects happen at correct transitions
- [ ] Concurrent transitions are handled
- [ ] State persistence works correctly
- [ ] History/undo is possible (if required)

## Stage 3 — Transition Testing
Attempt to reach invalid states:
1. Rapid successive transitions
2. Concurrent transition attempts
3. Side effect failure during transition
4. Network partition during async transition
5. Browser back/forward during transition

## Stage 4 — Verified State Machine
Produce corrected state machine with guards and proper transitions.
```

---

## Performance Optimization Template

```
Task: [DESCRIBE THE PERFORMANCE ISSUE]

## Stage 1 — Initial Optimization
Implement the performance optimization.

## Stage 2 — Performance Verification Plan
- [ ] Optimization actually improves measured metric
- [ ] No regression in other areas
- [ ] Memory usage is acceptable
- [ ] Doesn't introduce bugs
- [ ] Works across all browsers/environments
- [ ] Maintainability is acceptable

## Stage 3 — Measurement
Verify with actual measurements:
1. Before/after comparison with profiler
2. Lighthouse scores
3. Core Web Vitals
4. Memory usage over time
5. Bundle size impact

## Stage 4 — Verified Optimization
Produce corrected optimization with measurements documented.
```

---

## Quick One-Liner for Any Task

When you receive any lazy prompt, mentally prepend:

```
Apply CoVe Protocol:
1. Generate initial solution [UNVERIFIED]
2. List all verification targets (claims, APIs, edge cases, concurrency, types, env)
3. Verify each independently with adversarial testing
4. Produce corrected final solution

Now: [ORIGINAL PROMPT]
```

---

## Mental Model Reminder

> "LLM-assisted code review, not LLM-generated code."
> Generation is cheap. Verification is where correctness lives.

Think of CoVe as: **Implement → Review → Test → Fix**

Applied at the prompt level.
