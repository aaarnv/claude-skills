# Phase 4: Loop Configuration

You are a subagent executing Phase 4 of the Steve autonomous dev pipeline. Your job: set up Ralph for autonomous execution with GSD + CoVe integration.

## Step 1: Check Ralph installation

```bash
which ralph-loop 2>/dev/null || which ralph 2>/dev/null
```

If not installed:
```bash
git clone https://github.com/frankbria/ralph-claude-code.git /tmp/ralph-claude-code
cd /tmp/ralph-claude-code && ./install.sh
```

## Step 2: Generate .ralphrc

Write `.ralphrc` in the project root:

```bash
PROJECT_NAME="[project name]"
PROJECT_TYPE="[detected type]"
MAX_CALLS_PER_HOUR=100
CLAUDE_TIMEOUT_MINUTES=20
CLAUDE_OUTPUT_FORMAT="json"
ALLOWED_TOOLS="Write,Read,Edit,Bash(git *),Bash(npm *),Bash(npx *),Skill(gsd:*)"
SESSION_CONTINUITY=true
SESSION_EXPIRY_HOURS=24
TASK_SOURCES="local"
CB_NO_PROGRESS_THRESHOLD=3
CB_SAME_ERROR_THRESHOLD=5
CB_OUTPUT_DECLINE_THRESHOLD=70
```

Adjust `ALLOWED_TOOLS` per project type:
- **TypeScript/Node**: `Bash(npm *),Bash(npx *),Bash(node *)`
- **Python**: `Bash(python *),Bash(pip *),Bash(pytest *)`
- **Rust**: `Bash(cargo *),Bash(rustc *)`
- **Go**: `Bash(go *)`
- Add `Bash(docker *)` if Dockerfile present

## Step 3: Generate PROMPT.md

Write `.ralph/PROMPT.md`:

```markdown
# Project: [PROJECT_NAME]

## Your Mission

You are working autonomously in a Ralph loop executing GSD plans. You are equipped with wavybaby tools — use them. Each iteration:

### 0. Use your tools

You have been equipped with skills and MCP servers for this project. USE THEM:
- **Context7**: Query up-to-date docs before using any library. Don't guess APIs.
- **Installed skills**: Follow best practices from installed skill files.
- **CoVe verification**: For any non-trivial code (stateful, async, database, auth, security), run the 4-stage CoVe protocol from /rnv before committing.

### 1. Read current state
- Read `.planning/STATE.md` to find current phase and plan
- Read `.planning/ROADMAP.md` for phase context and dependencies

### 2. Determine next action

Follow this decision tree:

Is current phase's DISCOVERY.md missing?
  YES -> Run research: read PRD, explore codebase, write DISCOVERY.md. Use Context7 for unfamiliar tech.
  NO ->

Are there ungenerated plans for current phase?
  YES -> Generate next {NN}-{NN}-PLAN.md from DISCOVERY.md + PRD
  NO ->

Is there an unexecuted plan in current phase?
  YES -> Execute it (see "Execute a Plan" below)
  NO ->

Are all plans in current phase complete?
  YES -> Complete phase: update ROADMAP.md, advance STATE.md to next phase
  NO -> Something is wrong. Set STATUS: BLOCKED.

Are all phases complete?
  YES -> Run verification gate. If passing, set EXIT_SIGNAL: true
  NO -> Continue to next phase (loop back to top)

### 3. Execute a Plan

When executing a `{NN}-{NN}-PLAN.md`:

1. Read the plan file completely
2. Execute each `<task>` in order
3. **For non-trivial tasks**, apply CoVe:
   - Generate code [UNVERIFIED]
   - Plan verification targets specific to THIS code
   - Independently verify each target
   - Apply fixes -> [VERIFIED] code
4. After each task, run its `<verify>` checks
5. After all tasks, run the plan's `<verification>` section
6. Write `{NN}-{NN}-SUMMARY.md` with results
7. Commit changes with descriptive message
8. Update `.planning/STATE.md` (increment plan, update metrics)

### 4. CoVe triggers

Apply the full 4-stage CoVe protocol (from /rnv) for:
- Stateful code (useState, useReducer, context, stores)
- Async/concurrent logic (useEffect, mutations, subscriptions)
- Database operations (queries, transactions, migrations)
- Auth/security code
- Cache invalidation logic
- Financial or precision-critical calculations
- Any code where the bug would be subtle, not obvious

Skip CoVe only for: trivial one-liners, pure formatting, config files.

### 5. Generate plans for next phase (just-in-time)

When advancing to a new phase:
1. Read DISCOVERY.md for that phase (or create it first)
2. Read relevant PRD sections (the phase's "Traces to" field)
3. Use Context7 to look up any new tech introduced in this phase
4. Generate all {NN}-{NN}-PLAN.md files for the phase
5. Begin executing plan 01

## Visual Verification (MANDATORY for UI tasks)

After implementing any task that changes the UI:

1. **Start the dev server** if not already running:
   - Detect the correct command from AGENT.md / package.json
   - Run it in the background
   - Wait for the server to be ready

2. **Screenshot with Playwright MCP**:
   - Navigate to the relevant page: `browser_navigate`
   - Take a snapshot: `browser_snapshot`
   - Take a screenshot: `browser_take_screenshot`
   - If the UI doesn't match expected design, fix before marking complete

3. **Iterate until correct**:
   - If screenshot shows broken layout, missing elements, or wrong styling -> fix and re-screenshot
   - Only mark done when visual output matches acceptance criteria

Do NOT skip visual verification for UI tasks.

## Key Rules

- ONE plan per loop iteration (stay focused)
- Always run tests after implementation tasks
- Write SUMMARY.md after every completed plan
- Update STATE.md after every completed plan
- Reference the PRD for acceptance criteria
- Use Context7 for library docs
- Apply CoVe on non-trivial code
- If blocked, set STATUS: BLOCKED and explain why
- Never skip verification steps
- Commit atomically per task when possible

## Required Output Format

At the END of every response, output EXACTLY:

---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
PHASE: [current phase number and name]
PLAN: [current plan number or "generating" or "researching"]
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: PASSING | FAILING | NOT_RUN
WORK_TYPE: RESEARCH | PLANNING | IMPLEMENTATION | VERIFICATION
COVE_APPLIED: true | false | N/A
EXIT_SIGNAL: false
RECOMMENDATION: <what was done and what's next>
---END_RALPH_STATUS---

Set EXIT_SIGNAL: true ONLY when:
- ALL phases in ROADMAP.md are complete
- ALL SUMMARY.md files written
- Final verification gate passes
- STATE.md shows 100% progress
```

## Step 4: Generate AGENT.md

Write `.ralph/AGENT.md`:

```markdown
# Agent Instructions

## Build
[detected build command]

## Test
[detected test command]

## Run
[detected run command]

## Lint
[detected lint command]

## Type Check
[detected type check command if applicable]

## Equipped Tools
- Context7: Use `mcp__plugin_context7_context7__resolve-library-id` then `query-docs` for any library docs
- Installed skills: [list skills installed in Phase 0]
- CoVe: Apply 4-stage verification on non-trivial code (see PROMPT.md section 4)

## GSD Commands
- Execute plan: Read the PLAN.md and follow its tasks
- Write summary: Create SUMMARY.md after plan completion
- Update state: Modify STATE.md with progress
```

Detect the build/test/run/lint commands from package.json scripts, pyproject.toml, Cargo.toml, Makefile, or equivalent.

## Step 5: Add to .gitignore

Append Ralph state files to `.gitignore` if not already present:

```
# Ralph loop state
.ralph/logs/
.ralph/status.json
.ralph/progress.json
.ralph/.call_count
.ralph/.last_reset
.ralph/.exit_signals
.ralph/.response_analysis
.ralph/.circuit_breaker_state
.ralph/.claude_session_id
.ralph/.ralph_session
.ralph/.ralph_session_history
```

## Output

When complete, respond with ONLY:
```
Loop configured. Ralph: [installed/already installed]. Created: .ralphrc, .ralph/PROMPT.md, .ralph/AGENT.md. Updated .gitignore.
```

Do NOT dump file contents. Just confirm what was created.
