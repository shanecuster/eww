#!/bin/bash
TOKEN=$(cat ~/Documents/secrets/proxmox)
HOST="https://192.168.1.125:8006"
NODE="proxmox"

UPTIME_SEC=$(curl -sk -H "Authorization: PVEAPIToken=$TOKEN" "$HOST/api2/json/nodes/$NODE/status" | jq '.data.uptime')
DAYS=$((UPTIME_SEC / 86400))
HOURS=$(((UPTIME_SEC % 86400) / 3600))
echo "${DAYS}d ${HOURS}h"
