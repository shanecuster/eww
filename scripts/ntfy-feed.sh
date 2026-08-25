#!/bin/bash
FEEDFILE="$HOME/.local/share/ntfy-feed.json"
if [ -f "$FEEDFILE" ]; then
    cat "$FEEDFILE"
else
    echo "[]"
fi
