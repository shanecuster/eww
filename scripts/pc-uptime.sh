#!/bin/bash
UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime)
DAYS=$((UPTIME_SEC/86400))
HOURS=$(( (UPTIME_SEC%86400)/3600 ))
echo "${DAYS}d ${HOURS}h"
