#!/bin/bash
TOKEN=$(cat ~/Documents/secrets/proxmox)
HOST="https://192.168.1.125:8006"
NODE="proxmox"

AUTH_HEADER="Authorization: PVEAPIToken=$TOKEN"

VMS=$(curl -sk -H "$AUTH_HEADER" "$HOST/api2/json/nodes/$NODE/qemu")
LXCS=$(curl -sk -H "$AUTH_HEADER" "$HOST/api2/json/nodes/$NODE/lxc")
STORAGE=$(curl -sk -H "$AUTH_HEADER" "$HOST/api2/json/nodes/$NODE/storage/local-lvm/status")
NODESTATUS=$(curl -sk -H "$AUTH_HEADER" "$HOST/api2/json/nodes/$NODE/status")

VM_RUNNING=$(echo "$VMS" | jq '[.data[] | select(.status=="running")] | length')
VM_TOTAL=$(echo "$VMS" | jq '.data | length')
LXC_RUNNING=$(echo "$LXCS" | jq '[.data[] | select(.status=="running")] | length')
LXC_TOTAL=$(echo "$LXCS" | jq '.data | length')

DISK_PCT=$(echo "$STORAGE" | jq '(.data.used / .data.total * 100) | floor')
CPU_PCT=$(echo "$NODESTATUS" | jq '(.data.cpu * 100) | round')
RAM_PCT=$(echo "$NODESTATUS" | jq '(.data.memory.used / .data.memory.total * 100) | floor')

jq -n \
  --argjson vm_running "$VM_RUNNING" \
  --argjson vm_total "$VM_TOTAL" \
  --argjson lxc_running "$LXC_RUNNING" \
  --argjson lxc_total "$LXC_TOTAL" \
  --argjson disk_pct "$DISK_PCT" \
  --argjson cpu_pct "$CPU_PCT" \
  --argjson ram_pct "$RAM_PCT" \
  '{
    vm_running: $vm_running,
    vm_total: $vm_total,
    lxc_running: $lxc_running,
    lxc_total: $lxc_total,
    disk_pct: $disk_pct,
    cpu_pct: $cpu_pct,
    ram_pct: $ram_pct
  }'
