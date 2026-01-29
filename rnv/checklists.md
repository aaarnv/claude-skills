# CoVe Stack-Specific Verification Checklists

## Quick Reference: When to Apply Which Checklist

| Stack/Pattern | Trigger Keywords |
|---------------|------------------|
| React State | useState, useReducer, context, state |
| React Effects | useEffect, useMemo, useCallback |
| TanStack Query | useQuery, useMutation, queryClient |
| TanStack Table | useReactTable, columns, virtualizer |
| tRPC | trpc, procedure, router |
| Prisma | prisma, database, query, transaction |
| Next.js | server component, API route, middleware |
| Supabase | supabase, RLS, realtime |
| Auth | login, session, token, permission |
| Forms | form, validation, submit |

---

## React State Management

### useState / useReducer
```
VERIFY:
- [ ] Initial state is correct type and value
- [ ] State updates are immutable (no direct mutation)
- [ ] Functional updates used when depending on previous state
- [ ] State is lifted appropriately (not duplicated)
- [ ] Derived state calculated during render, not stored

ADVERSARIAL:
- What if setState is called twice in same event handler?
- What if component unmounts before async setState completes?
- What if parent re-renders with same props?
```

### useContext
```
VERIFY:
- [ ] Provider wraps all consumers
- [ ] Default value is meaningful (or error if missing)
- [ ] Context value is memoized to prevent re-renders
- [ ] Context is not overused (prop drilling may be clearer)

ADVERSARIAL:
- What if provider value changes every render?
- What if consumer renders outside provider?
```

---

## React Effects

### useEffect
```
VERIFY:
- [ ] Dependency array is complete (no missing deps)
- [ ] Dependency array has no extra deps
- [ ] Cleanup function handles all subscriptions/timers
- [ ] Effect doesn't run on every render unnecessarily
- [ ] Async operations check if component still mounted
- [ ] AbortController used for fetch operations

ADVERSARIAL:
- What if deps change faster than effect runs?
- What if component unmounts during async operation?
- What if effect cleanup fails?

RED FLAGS:
- Empty dependency array with state/props inside
- Object/array in deps (will always be "new")
- Missing cleanup for subscriptions
```

### useMemo / useCallback
```
VERIFY:
- [ ] Actually provides performance benefit (measured)
- [ ] Dependencies are primitives or stable references
- [ ] Not used for simple calculations
- [ ] Not breaking referential equality when it matters

ANTI-PATTERNS:
- Memoizing primitive calculations
- Empty deps for callback that uses state
- Memoizing already-stable values
```

---

## TanStack Query

### useQuery
```
VERIFY:
- [ ] Query key uniquely identifies the data
- [ ] Query key includes all parameters that affect result
- [ ] staleTime appropriate for data freshness needs
- [ ] Error boundary or error handling present
- [ ] Loading state provides good UX
- [ ] Enabled flag prevents unnecessary fetches
- [ ] Select used to transform/derive data

ADVERSARIAL:
- What if query key changes rapidly?
- What if multiple components use same query with different params?
- What if cached data is stale but still shown?
```

### useMutation
```
VERIFY:
- [ ] onSuccess invalidates related queries
- [ ] onError provides user feedback
- [ ] Optimistic update has correct rollback
- [ ] Loading state prevents double-submit
- [ ] Mutation variables are validated before call
- [ ] Side effects happen in onSuccess, not mutationFn

ADVERSARIAL:
- What if mutation fails mid-operation?
- What if network drops after request sent but before response?
- What if user triggers same mutation twice?
- What if related query refetches before mutation completes?
```

### useInfiniteQuery
```
VERIFY:
- [ ] getNextPageParam handles last page correctly
- [ ] getPreviousPageParam if bidirectional
- [ ] Page boundary doesn't miss or duplicate items
- [ ] Total count syncs with actual items
- [ ] Mutation properly updates all pages

ADVERSARIAL:
- What if items are added/removed between page fetches?
- What if sort order changes mid-pagination?
- What if refetch happens during page load?
```

---

## TanStack Table

### Column Definitions
```
VERIFY:
- [ ] Column defs are stable (useMemo or module-level)
- [ ] Accessors handle null/undefined data
- [ ] Cell renderers are memoized if expensive
- [ ] Sorting is correct for data type
- [ ] Filter functions match expected behavior

ADVERSARIAL:
- What if accessorKey path doesn't exist on some rows?
- What if data changes while user is sorting/filtering?
```

### Virtualization
```
VERIFY:
- [ ] estimateSize is close to actual row height
- [ ] Overscan prevents blank areas during scroll
- [ ] Scroll container has fixed height
- [ ] Row keys are stable during updates
- [ ] No layout shift when rows render

ADVERSARIAL:
- What if row heights vary significantly?
- What if data updates while scrolled to middle?
- What if user scrolls very fast?
```

---

## tRPC

### Procedures
```
VERIFY:
- [ ] Input schema validates all expected fields
- [ ] Output type matches what's returned
- [ ] Auth middleware protects sensitive procedures
- [ ] Error handling uses TRPCError with proper codes
- [ ] Query vs Mutation used correctly

ADVERSARIAL:
- What if input passes schema but is semantically wrong?
- What if procedure throws non-TRPCError?
- What if context doesn't have expected user/session?
```

### Client Usage
```
VERIFY:
- [ ] useQuery for reads, useMutation for writes
- [ ] Error handling at component level
- [ ] Loading states are user-friendly
- [ ] Invalidation happens after mutations
- [ ] Batching is working as expected

ADVERSARIAL:
- What if multiple mutations fire simultaneously?
- What if server returns unexpected shape?
```

---

## Prisma / Database

### Queries
```
VERIFY:
- [ ] select/include used to limit data fetched
- [ ] N+1 queries avoided with proper includes
- [ ] Indexes exist for WHERE/ORDER BY columns
- [ ] Pagination uses cursor or offset correctly
- [ ] Null handling is explicit

ADVERSARIAL:
- What if table is empty?
- What if related record doesn't exist?
- What if query returns millions of rows?
```

### Mutations
```
VERIFY:
- [ ] Transaction wraps related operations
- [ ] Unique constraint violations handled
- [ ] Foreign key constraints respected
- [ ] Cascade deletes are intentional
- [ ] Concurrent updates handled (optimistic locking)

ADVERSARIAL:
- What if two users update same record?
- What if transaction partially fails?
- What if referenced record is deleted mid-transaction?
```

### Migrations
```
VERIFY:
- [ ] Migration is reversible (or documented as not)
- [ ] Data migration handles existing data
- [ ] Indexes added for new query patterns
- [ ] Nullable fields have defaults for existing rows
- [ ] No breaking changes to production data
```

---

## Next.js

### Server Components
```
VERIFY:
- [ ] No useState/useEffect in server components
- [ ] Data fetching uses React cache() for dedup
- [ ] Sensitive data not passed to client components
- [ ] Streaming/Suspense used appropriately
- [ ] Error boundaries handle failures

ADVERSARIAL:
- What if data fetch fails in server component?
- What if client component tries to use server-only module?
```

### API Routes / Server Actions
```
VERIFY:
- [ ] Authentication checked before data access
- [ ] Input validated with Zod or similar
- [ ] Response has correct status codes
- [ ] Errors don't leak sensitive information
- [ ] Rate limiting considered

ADVERSARIAL:
- What if request body is malformed JSON?
- What if auth token is expired mid-request?
- What if handler throws synchronously?
```

### Middleware
```
VERIFY:
- [ ] Matcher config is correct
- [ ] Auth check doesn't block public routes
- [ ] Redirects use correct status codes
- [ ] Headers are set appropriately
- [ ] No heavy computation in middleware

ADVERSARIAL:
- What if auth service is down?
- What if middleware throws?
```

---

## Supabase

### Row Level Security (RLS)
```
VERIFY:
- [ ] RLS is enabled on table
- [ ] Policies cover all CRUD operations needed
- [ ] auth.uid() used correctly in policies
- [ ] Policies don't allow privilege escalation
- [ ] Service role bypasses are intentional

ADVERSARIAL:
- What if user manipulates their JWT claims?
- What if policy has OR instead of AND?
- What if user_id column is null?
```

### Realtime
```
VERIFY:
- [ ] Subscription filter is specific enough
- [ ] Unsubscribe happens on cleanup
- [ ] UI updates correctly on INSERT/UPDATE/DELETE
- [ ] Duplicate events handled
- [ ] Offline/reconnect handled

ADVERSARIAL:
- What if realtime connection drops?
- What if events arrive out of order?
- What if same event is received twice?
```

---

## Authentication

### Session Management
```
VERIFY:
- [ ] Session token is secure (httpOnly, secure, sameSite)
- [ ] Session expiry is reasonable
- [ ] Refresh token flow works correctly
- [ ] Logout invalidates session server-side
- [ ] Session is checked on sensitive operations

ADVERSARIAL:
- What if user has multiple tabs open?
- What if session expires during long operation?
- What if refresh token is stolen?
```

### Authorization
```
VERIFY:
- [ ] Role/permission checked before action
- [ ] UI hides options user can't use
- [ ] API enforces permissions (not just UI)
- [ ] Ownership checked for user-specific resources
- [ ] Audit trail for sensitive operations

ADVERSARIAL:
- What if user manipulates request to access other user's data?
- What if permission changes while user is logged in?
- What if role hierarchy has gaps?
```

---

## Forms

### Validation
```
VERIFY:
- [ ] Client-side validation matches server-side
- [ ] Error messages are user-friendly
- [ ] Required fields are enforced
- [ ] Input sanitization prevents XSS
- [ ] Format validation (email, phone, etc.)

ADVERSARIAL:
- What if JavaScript is disabled?
- What if user pastes long string?
- What if validation runs on every keystroke?
```

### Submission
```
VERIFY:
- [ ] Submit button disabled during submission
- [ ] Success feedback is clear
- [ ] Error feedback is actionable
- [ ] Form resets or redirects appropriately
- [ ] Unsaved changes warning on navigation

ADVERSARIAL:
- What if network fails mid-submit?
- What if user double-clicks submit?
- What if server returns validation errors?
```

---

## Performance

### Bundle Size
```
VERIFY:
- [ ] Dynamic imports for heavy components
- [ ] Tree shaking working (no side effects)
- [ ] No duplicate dependencies
- [ ] Images optimized (next/image, etc.)
- [ ] Fonts subset and preloaded

MEASURE:
- Bundle analyzer output
- First contentful paint
- Time to interactive
```

### Runtime Performance
```
VERIFY:
- [ ] No unnecessary re-renders
- [ ] Expensive calculations memoized
- [ ] Lists virtualized if large
- [ ] Debounce/throttle on frequent events
- [ ] Web workers for heavy computation

MEASURE:
- React DevTools profiler
- Performance tab in DevTools
- Lighthouse score
```

---

## Security

### Input Handling
```
VERIFY:
- [ ] All user input validated
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (sanitization, CSP)
- [ ] CSRF tokens on state-changing requests
- [ ] File upload validated (type, size)

ADVERSARIAL:
- Try SQL injection: `'; DROP TABLE users; --`
- Try XSS: `<script>alert('xss')</script>`
- Try path traversal: `../../etc/passwd`
```

### Secrets
```
VERIFY:
- [ ] No secrets in client-side code
- [ ] Environment variables for all secrets
- [ ] .env files in .gitignore
- [ ] Secrets rotated periodically
- [ ] Minimum privilege for API keys
```
