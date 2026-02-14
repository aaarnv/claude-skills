# Phase 2+3: GSD Bootstrap + Plan Generation

You are a subagent executing Phases 2 and 3 of the Steve autonomous dev pipeline. Your job: read the PRD, create the full `.planning/` structure, generate all project files, and generate Phase 1 plans.

## Step 1: Read the PRD

Read `.planning/specs/PRD.md` completely. This is your source of truth for everything below.

## Step 2: Create directory structure

```bash
mkdir -p .planning/specs .planning/codebase .planning/phases
```

## Step 3: Generate PROJECT.md

Write `.planning/PROJECT.md` using this template, populated from the PRD:

```markdown
# Project: [Name]

## Vision
[From PRD section 1 Overview]

## Requirements

### Validated
[From PRD section 7 MVP In Scope — confirmed requirements]

### Active (Under Discussion)
[From PRD section 9 Open Questions — unresolved items]

### Out of Scope
[From PRD section 7 Out of Scope]

## Constraints
[From PRD section 4 Stack rationale and section 6 Non-Functional Requirements]

## Key Decisions
| Decision | Status | Rationale |
|----------|--------|-----------|
| [Stack choice from PRD section 4] | Approved | [Rationale] |
```

## Step 4: Generate ROADMAP.md

Write `.planning/ROADMAP.md`. Derive phases from the PRD:

```markdown
# Roadmap — Milestone 1: MVP

## Progress
| Phase | Name | Status | Plans |
|-------|------|--------|-------|
| 1 | Infrastructure & Setup | Not Started | TBD |
| 2 | [Next phase] | Not Started | TBD |
| ... | ... | ... | ... |

---

### Phase 1: Infrastructure & Setup
**Goal**: Project scaffolding, database schema, auth config, navigation skeleton
**Depends on**: None
**Research**: Likely
**Research topics**: [Stack from PRD section 4]
**Traces to**: PRD section 4 (Technical Requirements)

### Phase 2: [From PRD epics]
**Goal**: [From user story epic]
**Depends on**: Phase 1
**Research**: [Likely/Unlikely]
**Traces to**: PRD section 3 Epic: [Name]

(Continue for all phases)

### Phase N: Polish & Verification
**Goal**: Error states, empty states, performance, accessibility
**Depends on**: All previous phases
**Traces to**: PRD section 6 Non-Functional Requirements
```

**Derivation rules:**
1. Infrastructure/setup is always Phase 1
2. Auth is Phase 2 (if applicable)
3. Each PRD Epic becomes one or more phases
4. PRD section 5 Screen Map informs navigation phases
5. PRD section 6 Non-Functional becomes a final polish phase
6. Every phase traces back to a PRD section

Also create phase directories: `.planning/phases/{NN}-{phase-name}/` for each phase.

## Step 5: Generate STATE.md

Write `.planning/STATE.md`:

```markdown
# Project State

## Current Position
- **Phase**: 1 of N (Infrastructure & Setup)
- **Plan**: Not started
- **Status**: Not started
- **Progress**: [..........] 0%

## Performance Metrics
- Plans completed: 0
- Average duration: N/A
- Total execution time: 0

## Accumulated Context
- Decisions: See PROJECT.md
- Deferred issues: None
- Blockers: None

## Session
- Last activity: [date] — Project initialized
- Mode: Autonomous (Ralph loop)
```

## Step 6: Generate config.json

Write `.planning/config.json`:

```json
{
  "mode": "yolo",
  "depth": "comprehensive",
  "gates": {
    "confirm_project": false,
    "confirm_phases": false,
    "confirm_roadmap": false,
    "confirm_breakdown": false,
    "confirm_plan": false,
    "execute_next_plan": true,
    "issues_review": false,
    "confirm_transition": false
  },
  "safety": {
    "always_confirm_destructive": true,
    "always_confirm_external_services": true
  }
}
```

## Step 7: Generate codebase docs

If the project directory already has code, analyze it and generate:
- `.planning/codebase/STACK.md` — technologies, deps, versions
- `.planning/codebase/ARCHITECTURE.md` — patterns, layers, data flow
- `.planning/codebase/STRUCTURE.md` — directory layout
- `.planning/codebase/CONVENTIONS.md` — naming, style, patterns

If it's a new project, create skeleton versions that get populated during Phase 1.

## Step 8: Generate Phase 1 Plans (Phase 3 of Steve)

For **Phase 1 only**, generate detailed plan files. Subsequent phases get planned just-in-time by the Ralph loop.

For each plan, write `.planning/phases/{NN}-{phase-name}/{XX}-{YY}-PLAN.md`:

```xml
<plan>
  <phase>1</phase>
  <plan-number>01</plan-number>
  <type>execute</type>
  <name>[Descriptive name]</name>
</plan>

<objective>
[What this plan delivers and why, traced to PRD section]
</objective>

<context>
- PRD: .planning/specs/PRD.md
- Project: .planning/PROJECT.md
- Stack: .planning/codebase/STACK.md
</context>

<tasks>
  <task type="auto">
    <name>[Task name]</name>
    <files>[Files to create/modify]</files>
    <action>
      [Detailed implementation instructions]
    </action>
    <verify>
      - [ ] [Verification step]
      - [ ] [Verification step]
    </verify>
    <done>[Success indicator]</done>
  </task>
</tasks>

<verification>
  - [ ] All files created/modified as specified
  - [ ] Tests pass
  - [ ] No TypeScript/lint errors
  - [ ] Acceptance criteria from PRD met
</verification>

<success_criteria>
[Definition of done for this plan]
</success_criteria>
```

## Output

When complete, respond with ONLY a brief summary:
```
GSD bootstrap complete.
Files created: PROJECT.md, ROADMAP.md (N phases), STATE.md, config.json, codebase docs
Phase directories: 01-[name] through 0N-[name]
Phase 1 plans: 01-01-PLAN.md through 01-0M-PLAN.md (M plans)
```

Do NOT dump file contents. Just confirm what was created.
