#!/bin/bash
TOKEN=$(cat ~/Documents/secrets/github_token)

curl -s https://api.github.com/graphql \
  -H "Authorization: bearer $TOKEN" \
  -d '{"query": "query { viewer { contributionsCollection { contributionCalendar { totalContributions weeks { contributionDays { contributionCount date } } } } } }"}' \
  | jq '{
      pushes: .data.viewer.contributionsCollection.contributionCalendar.totalContributions,
      days: [.data.viewer.contributionsCollection.contributionCalendar.weeks[].contributionDays[] | .contributionCount] | .[-14:]
    }'
