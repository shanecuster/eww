#!/bin/bash
TOKEN=$(cat ~/Documents/secrets/github_token)
REPO="shanecuster/tuxwire"
HISTFILE="$HOME/.local/share/github-clones-history.json"

mkdir -p "$(dirname "$HISTFILE")"
[ -f "$HISTFILE" ] || echo "{}" > "$HISTFILE"

CONTRIB=$(curl -s https://api.github.com/graphql \
  -H "Authorization: bearer $TOKEN" \
  -d '{"query": "query { viewer { contributionsCollection { contributionCalendar { totalContributions weeks { contributionDays { contributionCount date } } } } } }"}')

PUSHES=$(echo "$CONTRIB" | jq '.data.viewer.contributionsCollection.contributionCalendar.totalContributions')
DAYS=$(echo "$CONTRIB" | jq '[.data.viewer.contributionsCollection.contributionCalendar.weeks[].contributionDays[] | .contributionCount] | .[-14:]')

# Pull the daily clone breakdown (not just the rolling total) so we can
# record each day exactly once, building a real accumulating total over
# time instead of GitHub's resetting 14-day window.
CLONES_RAW=$(curl -s -H "Authorization: token $TOKEN" "https://api.github.com/repos/$REPO/traffic/clones")
CLONES_DAILY=$(echo "$CLONES_RAW" | jq -c '[.clones[]? | {(.timestamp): .count}] | add // {}')

# Merge today's fetch into the persistent history (overwrite each date with
# the latest known value, since GitHub's count for the most recent day or
# two can still be finalizing).
jq -s '.[0] * .[1]' "$HISTFILE" <(echo "$CLONES_DAILY") > "$HISTFILE.tmp" && mv "$HISTFILE.tmp" "$HISTFILE"

CLONE_TOTAL=$(jq '[.[]] | add // 0' "$HISTFILE")

jq -n \
  --argjson pushes "$PUSHES" \
  --argjson days "$DAYS" \
  --argjson clones "$CLONE_TOTAL" \
  '{pushes: $pushes, days: $days, clones: $clones}'
