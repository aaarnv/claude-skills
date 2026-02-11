#!/bin/bash
# Claude Agent Schedule Manager
# Usage: manage-agent.sh <create|list|remove|run-now|logs> [args...]

set -euo pipefail

AGENTS_DIR="$HOME/.claude/agents"
SCHEDULES_DIR="$AGENTS_DIR/schedules"
LOGS_DIR="$AGENTS_DIR/logs"
PLIST_DIR="$HOME/Library/LaunchAgents"
PLIST_PREFIX="com.claude.agent"

mkdir -p "$SCHEDULES_DIR" "$LOGS_DIR"

ACTION="${1:?Usage: manage-agent.sh <create|list|remove|run-now|logs>}"
shift

case "$ACTION" in
    create)
        # Args: name prompt schedule [directory] [model] [max_turns] [delivery_chat]
        NAME="${1:?Missing agent name}"
        PROMPT="${2:?Missing prompt}"
        SCHEDULE="${3:?Missing schedule (cron format: 'minute hour day month weekday' or 'every-Xm' or 'every-Xh')}"
        DIRECTORY="${4:-$HOME}"
        MODEL="${5:-sonnet}"
        MAX_TURNS="${6:-50}"
        DELIVERY_CHAT="${7:-!edBouVfejemeEBwbQn:beeper.com}"

        # Save agent config
        cat > "$SCHEDULES_DIR/$NAME.json" <<EOF
{
    "name": "$NAME",
    "prompt": $(echo "$PROMPT" | jq -Rs .),
    "directory": "$DIRECTORY",
    "model": "$MODEL",
    "max_turns": $MAX_TURNS,
    "schedule": "$SCHEDULE",
    "delivery_chat": "$DELIVERY_CHAT",
    "created": "$(date -Iseconds)"
}
EOF

        # Parse schedule into launchd format
        PLIST_FILE="$PLIST_DIR/${PLIST_PREFIX}.${NAME}.plist"

        # Build the calendar interval or interval based on schedule type
        if [[ "$SCHEDULE" == every-*m ]]; then
            MINUTES="${SCHEDULE#every-}"
            MINUTES="${MINUTES%m}"
            INTERVAL_XML="<key>StartInterval</key><integer>$((MINUTES * 60))</integer>"
        elif [[ "$SCHEDULE" == every-*h ]]; then
            HOURS="${SCHEDULE#every-}"
            HOURS="${HOURS%h}"
            INTERVAL_XML="<key>StartInterval</key><integer>$((HOURS * 3600))</integer>"
        else
            # Cron format: minute hour day month weekday
            read -r CMIN CHOUR CDAY CMONTH CWDAY <<< "$SCHEDULE"
            INTERVAL_XML="<key>StartCalendarInterval</key><dict>"
            [[ "$CMIN" != "*" ]] && INTERVAL_XML+="<key>Minute</key><integer>$CMIN</integer>"
            [[ "$CHOUR" != "*" ]] && INTERVAL_XML+="<key>Hour</key><integer>$CHOUR</integer>"
            [[ "$CDAY" != "*" ]] && INTERVAL_XML+="<key>Day</key><integer>$CDAY</integer>"
            [[ "$CMONTH" != "*" ]] && INTERVAL_XML+="<key>Month</key><integer>$CMONTH</integer>"
            [[ "$CWDAY" != "*" ]] && INTERVAL_XML+="<key>Weekday</key><integer>$CWDAY</integer>"
            INTERVAL_XML+="</dict>"
        fi

        # Create launchd plist
        cat > "$PLIST_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${PLIST_PREFIX}.${NAME}</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${AGENTS_DIR}/run-agent.sh</string>
        <string>${NAME}</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin:$HOME/.local/bin</string>
        <key>HOME</key>
        <string>$HOME</string>
    </dict>
    ${INTERVAL_XML}
    <key>StandardOutPath</key>
    <string>${LOGS_DIR}/${NAME}_launchd.log</string>
    <key>StandardErrorPath</key>
    <string>${LOGS_DIR}/${NAME}_launchd_err.log</string>
    <key>RunAtLoad</key>
    <false/>
</dict>
</plist>
EOF

        # Load the agent
        launchctl unload "$PLIST_FILE" 2>/dev/null || true
        launchctl load "$PLIST_FILE"

        echo "Agent '$NAME' created and scheduled."
        echo "Config: $SCHEDULES_DIR/$NAME.json"
        echo "Schedule: $SCHEDULE"
        echo "Plist: $PLIST_FILE"
        ;;

    list)
        echo "=== Scheduled Claude Agents ==="
        echo ""
        if [ -z "$(ls -A "$SCHEDULES_DIR" 2>/dev/null)" ]; then
            echo "No agents scheduled."
        else
            for f in "$SCHEDULES_DIR"/*.json; do
                NAME=$(jq -r '.name' "$f")
                PROMPT=$(jq -r '.prompt' "$f" | head -c 80)
                SCHEDULE=$(jq -r '.schedule' "$f")
                MODEL=$(jq -r '.model // "sonnet"' "$f")
                CREATED=$(jq -r '.created' "$f")

                PLIST_FILE="$PLIST_DIR/${PLIST_PREFIX}.${NAME}.plist"
                if launchctl list "${PLIST_PREFIX}.${NAME}" &>/dev/null; then
                    STATUS="ACTIVE"
                else
                    STATUS="INACTIVE"
                fi

                echo "[$STATUS] $NAME"
                echo "  Prompt:   $PROMPT..."
                echo "  Schedule: $SCHEDULE"
                echo "  Model:    $MODEL"
                echo "  Created:  $CREATED"
                echo ""
            done
        fi
        ;;

    remove)
        NAME="${1:?Missing agent name}"
        PLIST_FILE="$PLIST_DIR/${PLIST_PREFIX}.${NAME}.plist"

        # Unload from launchd
        launchctl unload "$PLIST_FILE" 2>/dev/null || true
        rm -f "$PLIST_FILE"
        rm -f "$SCHEDULES_DIR/$NAME.json"

        echo "Agent '$NAME' removed and unscheduled."
        ;;

    run-now)
        NAME="${1:?Missing agent name}"
        echo "Running agent '$NAME' now..."
        bash "$AGENTS_DIR/run-agent.sh" "$NAME"
        ;;

    logs)
        NAME="${1:-}"
        if [[ -z "$NAME" ]]; then
            echo "=== Recent Agent Logs ==="
            ls -lt "$LOGS_DIR"/*.log 2>/dev/null | head -20
        else
            LATEST=$(ls -t "$LOGS_DIR"/${NAME}_2*.log 2>/dev/null | head -1)
            if [[ -n "$LATEST" ]]; then
                echo "=== Latest log for $NAME ==="
                cat "$LATEST"
            else
                echo "No logs found for agent '$NAME'."
            fi
        fi
        ;;

    *)
        echo "Unknown action: $ACTION"
        echo "Usage: manage-agent.sh <create|list|remove|run-now|logs> [args...]"
        exit 1
        ;;
esac
