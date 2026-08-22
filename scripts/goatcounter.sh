#!/bin/bash
TOKEN=$(cat ~/Documents/secrets/goatcounter_token)
TODAY=$(date +%Y-%m-%d)
START="2020-01-01"

TECH=$(curl -s "https://shanetalkstech.goatcounter.com/api/v0/stats/total?start=$START&end=$TODAY" \
  -H "Authorization: Bearer $TOKEN" | jq -r '.total')

SPORTS=$(curl -s "https://shanetalkssports.goatcounter.com/api/v0/stats/total?start=$START&end=$TODAY" \
  -H "Authorization: Bearer $TOKEN" | jq -r '.total')

jq -n --argjson tech "$TECH" --argjson sports "$SPORTS" '{tech: $tech, sports: $sports}'
