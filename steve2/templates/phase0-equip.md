# Phase 0: Equip (wavybaby)

You are a subagent executing Phase 0 of the Steve autonomous dev pipeline. Your job: detect the project stack, install relevant skills and MCP servers, and set up project config.

## Step 1: Detect project type

Scan the working directory for: `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile`, `pubspec.yaml`, `Podfile`, `build.gradle`. Determine:
- Language(s)
- Framework(s)
- Package manager
- Existing dependencies

## Step 2: Search and install relevant skills

```bash
# Search skills.sh for skills matching the detected stack
npx skills find "[detected framework]"
npx skills find "[detected language]"
npx skills find "[project domain from user description]"
```

**Auto-install based on stack:**

| Stack | Command |
|-------|---------|
| React / Next.js | `npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices --agent claude-code -y` |
| React Native / Expo | `npx skills add expo/skills --agent claude-code -y` |
| Supabase | `npx skills add supabase/agent-skills --agent claude-code -y` |
| Stripe payments | `npx skills add stripe/skills --agent claude-code -y` |
| Cloudflare | `npx skills add cloudflare/skills --agent claude-code -y` |
| Any web project | `npx skills add vercel-labs/agent-skills --skill web-design-guidelines --agent claude-code -y` |
| Security-critical | `npx skills add trailofbits/skills --agent claude-code -y` |

Install all relevant skills immediately. The `-y` flag auto-confirms.

## Step 3: Install missing MCP servers

Check which MCP servers are already configured, then install relevant ones:

| Server | When to Install | Command |
|--------|----------------|---------|
| Context7 | Always (prevents doc hallucinations) | `claude mcp add context7 -- npx -y @upstash/context7-mcp` |
| GitHub | If using GitHub | `claude mcp add github --transport http https://api.githubcopilot.com/mcp/` |
| Supabase | If Supabase in stack | `claude mcp add supabase -- npx -y @supabase/mcp-server` |
| Sentry | If error tracking needed | `claude mcp add sentry --transport http https://mcp.sentry.dev/mcp` |
| Notion | If docs workflow | `claude mcp add notion --transport http https://mcp.notion.com/mcp` |
| Sequential Thinking | Complex architecture | `claude mcp add thinking -- npx -y mcp-sequentialthinking-tools` |

## Step 4: Set up project config

If `settings.local.json` is missing, create it with appropriate permissions:

**Full-Stack (Node/React):**
```json
{
  "permissions": {
    "allow": [
      "WebSearch",
      "Bash(npm *)", "Bash(pnpm *)",
      "Bash(git *)", "Bash(gh *)",
      "Bash(docker *)",
      "mcp__plugin_context7_context7__*",
      "Skill(*)"
    ]
  }
}
```

**Python:**
```json
{
  "permissions": {
    "allow": [
      "Bash(python *)", "Bash(pip *)", "Bash(poetry *)",
      "Bash(pytest *)", "Bash(docker-compose *)",
      "Bash(git *)"
    ]
  }
}
```

Adjust per detected stack.

## Output

When complete, respond with ONLY a brief report in this format:
```
Equipped for: [project type]
Skills installed: [comma-separated list, or "none needed"]
MCP servers configured: [comma-separated list, or "already configured"]
Project config: settings.local.json [created/updated/already exists]
```

Do NOT dump file contents, installation logs, or verbose output. Just the summary above.
