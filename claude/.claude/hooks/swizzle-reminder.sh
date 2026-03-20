#!/bin/bash
# Post-build/test reminder to use swizzle for log monitoring.
# For Shortcuts MCP, only fires when the shortcut targets Xcode.

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

# For Shortcuts MCP, check if the shortcut name mentions Xcode
if [ "$TOOL_NAME" = "mcp__plugin_workflow-tools_shortcuts__run_shortcut" ]; then
    SHORTCUT_NAME=$(echo "$INPUT" | jq -r '.tool_input.name // ""')
    if ! echo "$SHORTCUT_NAME" | grep -qi "xcode"; then
        exit 0
    fi
fi

echo '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"After builds/tests in Swift/iOS projects, consider using `swizzle stream-logs` to monitor os_log output for errors, warnings, or unexpected behavior. Use `swizzle stream-logs --subsystem <bundle-id>` to filter by app. Check the swizzle skill for more options."}}'
