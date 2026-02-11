#!/bin/bash
# Scheduled Claude Agent Runner
# Runs a claude prompt headlessly and delivers results

set -euo pipefail

AGENT_NAME="${1:?Usage: run-agent.sh <agent-name>}"
AGENTS_DIR="$HOME/.claude/agents"
SCHEDULES_DIR="$AGENTS_DIR/schedules"
LOGS_DIR="$AGENTS_DIR/logs"
AGENT_FILE="$SCHEDULES_DIR/$AGENT_NAME.json"

if [[ ! -f "$AGENT_FILE" ]]; then
    osascript -e "display notification \"Agent config not found: $AGENT_NAME\" with title \"Claude Agent Error\" sound name \"Basso\""
    exit 1
fi

# Parse agent config
PROMPT=$(jq -r '.prompt' "$AGENT_FILE")
WORK_DIR=$(jq -r '.directory // "~"' "$AGENT_FILE")
WORK_DIR="${WORK_DIR/#\~/$HOME}"
MAX_TURNS=$(jq -r '.max_turns // 10' "$AGENT_FILE")
MODEL=$(jq -r '.model // "sonnet"' "$AGENT_FILE")
DELIVERY_CHAT=$(jq -r '.delivery_chat // ""' "$AGENT_FILE")

# Append delivery instructions to prompt if configured
if [[ -n "$DELIVERY_CHAT" ]]; then
    PROMPT="$PROMPT

IMPORTANT DELIVERY INSTRUCTION: After completing the task above, you MUST send the full result as a message to Beeper using the mcp__beeper__send_message tool with chatID \"$DELIVERY_CHAT\". Format it nicely with markdown. Start the message with \"**Agent: $AGENT_NAME**\" and include a timestamp. This is a scheduled autonomous agent delivering results - do NOT skip this step."
fi

# Ensure log directory exists
mkdir -p "$LOGS_DIR"

LOG_FILE="$LOGS_DIR/${AGENT_NAME}_$(date +%Y%m%d_%H%M%S).log"

# Send start notification
osascript -e "display notification \"Running: $AGENT_NAME\" with title \"Claude Agent\" subtitle \"Started\" sound name \"Tink\""

# Run claude headlessly
cd "$WORK_DIR"
RESULT=$(/Users/aarnavsheth/.local/bin/claude -p "$PROMPT" \
    --output-format text \
    --model "$MODEL" \
    --max-turns "$MAX_TURNS" \
    --dangerously-skip-permissions \
    --verbose 2>&1) || true

# Save full output to log
echo "=== Agent: $AGENT_NAME ===" > "$LOG_FILE"
echo "=== Time: $(date) ===" >> "$LOG_FILE"
echo "=== Prompt: $PROMPT ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "$RESULT" >> "$LOG_FILE"

# Send completion notification
osascript -e "display notification \"Agent $AGENT_NAME finished. Check Beeper for results.\" with title \"Claude Agent\" subtitle \"Complete\" sound name \"Glass\""

echo "Agent $AGENT_NAME completed. Log: $LOG_FILE"
