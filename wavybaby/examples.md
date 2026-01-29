# Best Tools Examples

## Example 1: SaaS Dashboard

**Input:** `/best-tools I want to build a SaaS dashboard with React, TypeScript, and Supabase`

**Analysis:**
- Project Type: Full-stack web application
- Complexity: High (10+ steps)
- Technologies: React, TypeScript, Supabase, TailwindCSS
- Integrations: Database, Auth, Real-time subscriptions

**Recommended Toolkit:**

### MCP Servers
1. **Context7** - Up-to-date React/Supabase documentation
2. **Supabase MCP** - Direct database queries and migrations
3. **Playwright** - E2E testing and visual verification

### Skills
1. `/frontend-design` from anthropics/skills - High-quality UI
2. `/write-plan` from obra/superpowers - Implementation planning
3. React optimization skills from vercel-labs

### Configuration
```json
{
  "permissions": {
    "allow": [
      "Bash(npm *)", "Bash(npx *)",
      "Bash(supabase *)",
      "Bash(git *)",
      "WebSearch",
      "mcp__plugin_context7_context7__*",
      "mcp__plugin_playwright_playwright__*",
      "Skill(frontend-design)"
    ]
  }
}
```

### Execution Strategy
1. Use Plan agent for architecture
2. Phase-based implementation (.planning/)
3. `/frontend-design` for each component
4. Playwright for visual testing

---

## Example 2: Security Audit

**Input:** `/best-tools Security audit of our Node.js API`

**Analysis:**
- Project Type: Security audit
- Complexity: Medium
- Technologies: Node.js, Express/Fastify
- Focus: OWASP Top 10, dependency vulnerabilities

**Recommended Toolkit:**

### MCP Servers
1. **GitHub MCP** - Access to code history and PRs
2. **Context7** - Security best practices docs

### Skills
1. `/differential-review` from trailofbits/skills
2. `/entry-point-analyzer` from trailofbits/skills
3. Static analysis with Semgrep patterns

### Configuration
```json
{
  "permissions": {
    "allow": [
      "Read", "Grep", "Glob",
      "Bash(npm audit *)",
      "Bash(semgrep *)",
      "Bash(git log *)", "Bash(git diff *)",
      "Bash(gh pr *)"
    ],
    "deny": ["Write", "Edit", "Bash(rm *)"]
  }
}
```

### Execution Strategy
1. Explore agent for codebase mapping
2. Dependency audit first
3. Entry point analysis
4. Code review with security focus
5. Generate findings report

---

## Example 3: Python ML Pipeline

**Input:** `/best-tools Build a machine learning pipeline for customer churn prediction`

**Analysis:**
- Project Type: Data Science / ML
- Complexity: High
- Technologies: Python, pandas, scikit-learn, possibly PyTorch
- Integrations: Database, possibly cloud services

**Recommended Toolkit:**

### MCP Servers
1. **Context7** - ML library documentation
2. **Database MCP** - Data access
3. **AWS/GCP MCP** - Cloud deployment (optional)

### Skills
1. Scientific skills from K-Dense-AI/claude-scientific-skills
2. `/write-plan` for pipeline architecture

### Configuration
```json
{
  "permissions": {
    "allow": [
      "Bash(python *)", "Bash(pip *)", "Bash(poetry *)",
      "Bash(pytest *)", "Bash(jupyter *)",
      "Bash(git *)",
      "mcp__plugin_context7_context7__*"
    ]
  }
}
```

### Execution Strategy
1. Plan agent for pipeline architecture
2. Data exploration with Jupyter
3. Feature engineering phase
4. Model training with experiment tracking
5. Evaluation and validation
6. Deployment preparation

---

## Example 4: CLI Tool in Rust

**Input:** `/best-tools Create a CLI tool for JSON transformation in Rust`

**Analysis:**
- Project Type: Systems programming
- Complexity: Medium
- Technologies: Rust, clap, serde_json
- Focus: Performance, ergonomics

**Recommended Toolkit:**

### MCP Servers
1. **Context7** - Rust/clap/serde documentation

### Skills
1. `/write-plan` for architecture
2. `/tdd-style` for test-driven development

### Configuration
```json
{
  "permissions": {
    "allow": [
      "Bash(cargo *)", "Bash(rustc *)",
      "Bash(git *)",
      "mcp__plugin_context7_context7__*"
    ]
  }
}
```

### Execution Strategy
1. Scaffold with `cargo new`
2. TDD approach - tests first
3. Iterative implementation
4. Documentation and examples

---

## Example 5: Documentation Project

**Input:** `/best-tools Create comprehensive API documentation for our REST endpoints`

**Analysis:**
- Project Type: Documentation
- Complexity: Medium
- Output: OpenAPI spec, Markdown docs, possibly PDF

**Recommended Toolkit:**

### MCP Servers
1. **GitHub MCP** - Access to codebase
2. **Notion MCP** - If publishing to Notion (optional)

### Skills
1. `/docx` or `/pdf` from anthropics/skills
2. OpenAPI generation patterns

### Configuration
```json
{
  "permissions": {
    "allow": [
      "Read", "Grep", "Glob",
      "Bash(git *)",
      "Skill(docx)", "Skill(pdf)"
    ]
  }
}
```

### Execution Strategy
1. Explore agent to map all endpoints
2. Extract request/response schemas
3. Generate OpenAPI specification
4. Create human-readable documentation
5. Export to desired format

---

## Example 6: Migration Project

**Input:** `/best-tools Migrate our Express.js app to Fastify`

**Analysis:**
- Project Type: Refactoring/Migration
- Complexity: High
- Risk: Breaking changes, regression bugs

**Recommended Toolkit:**

### MCP Servers
1. **Context7** - Fastify documentation
2. **GitHub MCP** - Branch management, PRs

### Skills
1. `/write-plan` for migration strategy
2. `/tdd-style` for safety net
3. `/differential-review` to verify changes

### Configuration
```json
{
  "permissions": {
    "allow": [
      "Bash(npm *)", "Bash(npx *)",
      "Bash(git *)", "Bash(gh *)",
      "Bash(jest *)", "Bash(vitest *)",
      "mcp__plugin_context7_context7__*"
    ]
  }
}
```

### Execution Strategy
1. Comprehensive test suite first (safety net)
2. Phased migration plan
3. Route-by-route conversion
4. Parallel testing old vs new
5. Gradual rollout

---

## Decision Matrix

| If you're building... | Primary MCP | Key Skills | Approach |
|-----------------------|-------------|------------|----------|
| Web Frontend | Context7, Playwright | `/frontend-design` | Visual-first |
| Backend API | Context7, Database | `/api-conventions` | TDD |
| Full-Stack | Context7, DB, GitHub | Multiple | Phased |
| Mobile App | Context7 | RN/Flutter skills | Device testing |
| CLI Tool | Context7 | `/tdd-style` | TDD |
| Security Audit | GitHub | Trail of Bits | Read-only |
| ML Pipeline | Context7, DB | Scientific | Experimental |
| Documentation | GitHub, Notion | `/docx`, `/pdf` | Exploration first |
| Migration | Context7, GitHub | `/differential-review` | Safety-first |
