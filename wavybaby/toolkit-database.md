# Complete Toolkit Database

## MCP Servers (Full List)

### Development & Code
| Server | Description | Stars | Install |
|--------|-------------|-------|---------|
| Context7 | Real-time library documentation | High | `npx -y @upstash/context7-mcp` |
| GitHub | Official GitHub integration | 5k+ | HTTP transport |
| Git | Full Git operations | - | stdio |
| Playwright | Browser automation | 12k | Plugin |
| Sequential Thinking | Step-by-step reasoning | 5.5k uses | `npx -y mcp-sequentialthinking-tools` |
| Filesystem | Secure file ops | Official | `@modelcontextprotocol/server-filesystem` |

### Databases
| Server | Description | Best For |
|--------|-------------|----------|
| PostgreSQL | SQL queries | Production relational |
| Prisma | TypeScript ORM | Modern web apps |
| MongoDB | Document DB | NoSQL workloads |
| ClickHouse | Analytics | Large datasets |
| Supabase | Postgres + Auth | Full-stack apps |

### Cloud Providers
| Server | Description |
|--------|-------------|
| AWS MCP | Amazon Web Services |
| Azure MCP | Microsoft Azure |
| GCP MCP | Google Cloud Platform |
| Cloudflare | 16-server ecosystem |

### Productivity
| Server | Description |
|--------|-------------|
| Notion | Workspace automation |
| Slack | Team messaging |
| Linear | Issue tracking |
| Jira | Project management |
| Asana | Task management |
| Zapier | 7,000+ app connections |
| Google Workspace | Calendar, Drive, Gmail, Docs |

### Observability
| Server | Description |
|--------|-------------|
| Sentry | Error tracking |
| Datadog | Monitoring |
| PostHog | Product analytics |

---

## Skill Marketplaces

### Official
| Marketplace | Skills | Focus |
|-------------|--------|-------|
| anthropics/skills | 15+ | Documents, design, enterprise |
| vercel-labs/agent-skills | 5+ | React, Next.js, deployment |

### Community (High Quality)
| Marketplace | Skills | Focus |
|-------------|--------|-------|
| obra/superpowers-marketplace | 20+ | TDD, planning, debugging |
| trailofbits/skills | 12+ | Security auditing |
| K-Dense-AI/claude-scientific-skills | 125+ | Scientific research |
| GPTomics/bioSkills | 322 | Bioinformatics |
| daymade/claude-code-skills | 34 | Development workflows |

### Collections
| Repository | Description |
|------------|-------------|
| travisvn/awesome-claude-skills | Curated list |
| ComposioHQ/awesome-claude-skills | 1000+ app integrations |
| affaan-m/everything-claude-code | Hackathon winner configs |
| jeremylongshore/claude-code-plugins-plus-skills | 739 skills |

---

## Subagent Configurations

### Explore Agent
```yaml
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob, Bash(git *)
```
**Best for:** Codebase exploration, file search, research questions

### Plan Agent
```yaml
context: fork
agent: Plan
allowed-tools: Read, Grep, Glob
```
**Best for:** Architecture design, implementation planning, trade-off analysis

### General-Purpose Agent
```yaml
context: fork
agent: general-purpose
```
**Best for:** Complex multi-step tasks, full autonomy needed

---

## Permission Templates

### Minimal Read-Only
```json
{
  "permissions": {
    "allow": ["Read", "Grep", "Glob"]
  }
}
```

### Development (Node.js)
```json
{
  "permissions": {
    "allow": [
      "Bash(npm *)", "Bash(npx *)", "Bash(node *)",
      "Bash(git *)", "Bash(gh *)",
      "WebSearch",
      "mcp__plugin_context7_context7__*"
    ]
  }
}
```

### Development (Python)
```json
{
  "permissions": {
    "allow": [
      "Bash(python *)", "Bash(pip *)", "Bash(poetry *)",
      "Bash(pytest *)", "Bash(mypy *)", "Bash(ruff *)",
      "Bash(git *)",
      "WebSearch"
    ]
  }
}
```

### Full-Stack + Docker
```json
{
  "permissions": {
    "allow": [
      "Bash(npm *)", "Bash(pnpm *)",
      "Bash(docker *)", "Bash(docker-compose *)",
      "Bash(git *)", "Bash(gh *)",
      "Bash(psql *)", "Bash(redis-cli *)",
      "WebSearch", "WebFetch(domain:*)",
      "Skill(*)"
    ]
  }
}
```

### Security Audit
```json
{
  "permissions": {
    "allow": [
      "Read", "Grep", "Glob",
      "Bash(semgrep *)", "Bash(codeql *)",
      "Bash(git log *)", "Bash(git diff *)", "Bash(git show *)",
      "Bash(npm audit *)", "Bash(pip-audit *)"
    ],
    "deny": [
      "Bash(rm *)", "Bash(mv *)", "Write", "Edit"
    ]
  }
}
```

---

## Project Structure Templates

### GSD Planning System
```
.planning/
├── PROJECT.md          # Core vision and requirements
├── ROADMAP.md          # Phase-based implementation
├── config.json         # Execution configuration
├── STATE.md            # Current status
├── phases/
│   ├── 01-foundation/
│   │   ├── DISCOVERY.md
│   │   ├── 01-01-PLAN.md
│   │   └── 01-01-SUMMARY.md
│   └── 02-core-features/
└── codebase/
    ├── STACK.md
    └── STRUCTURE.md
```

### Standard Claude Code
```
.claude/
├── settings.local.json
├── commands/
│   ├── review.md
│   └── deploy.md
└── skills/
    └── project-conventions/
        └── SKILL.md

CLAUDE.md
```

---

## Hook Patterns

### Auto-Format on Edit
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "npx prettier --write $FILE"
      }]
    }]
  }
}
```

### Block Main Branch Edits
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "test $(git branch --show-current) != 'main'"
      }]
    }]
  }
}
```

### Run Tests on Test File Changes
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit:*.test.ts",
      "hooks": [{
        "type": "command",
        "command": "npm test -- --findRelatedTests $FILE"
      }]
    }]
  }
}
```

---

## Multi-Agent Orchestration

### Parallel Development Pattern
1. Create git worktrees for isolation
2. Spawn subagents per feature
3. Coordinate via shared task board
4. Merge when complete

### Tools
| Tool | Description |
|------|-------------|
| claude-flow | Enterprise orchestration, 60+ agents |
| oh-my-claude | 5 execution modes including Swarm |
| ccswarm | Rust-native with worktree isolation |
| Crystal | Desktop app for session management |

---

## Quick Install Scripts

### Essential Setup
```bash
# MCP Servers
claude mcp add context7 -- npx -y @upstash/context7-mcp
claude mcp add github --transport http https://api.githubcopilot.com/mcp/
claude mcp add thinking -- npx -y mcp-sequentialthinking-tools

# Marketplaces (run in Claude Code)
# /plugin marketplace add anthropics/skills
# /plugin marketplace add obra/superpowers-marketplace
```

### Full Development Setup
```bash
# All essential MCPs
claude mcp add context7 -- npx -y @upstash/context7-mcp
claude mcp add github --transport http https://api.githubcopilot.com/mcp/
claude mcp add thinking -- npx -y mcp-sequentialthinking-tools
claude mcp add fs -- npx -y @modelcontextprotocol/server-filesystem /Users/$USER/Projects

# Database (choose one)
# claude mcp add db -- npx -y @bytebase/dbhub --dsn "YOUR_CONNECTION_STRING"
```
