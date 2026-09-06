#!/bin/bash
DATA=$(sensors -j)

CPU=$(echo "$DATA" | jq -r '.["k10temp-pci-00c3"].Tctl.temp1_input | round')
GPU_EDGE=$(echo "$DATA" | jq -r '.["amdgpu-pci-0500"].edge.temp1_input | round')
GPU_JUNCTION=$(echo "$DATA" | jq -r '.["amdgpu-pci-0500"].junction.temp2_input | round')
GPU_FAN=$(echo "$DATA" | jq -r '.["amdgpu-pci-0500"].fan1.fan1_input | round')
GPU_POWER=$(echo "$DATA" | jq -r '.["amdgpu-pci-0500"].PPT.power1_average | round')

HISTFILE="$HOME/.local/share/cpu-history.json"
mkdir -p "$(dirname "$HISTFILE")"
[ -f "$HISTFILE" ] || echo "[]" > "$HISTFILE"

jq --argjson v "$CPU" '. + [$v] | .[-20:]' "$HISTFILE" > "$HISTFILE.tmp" && mv "$HISTFILE.tmp" "$HISTFILE"
CPU_HISTORY=$(cat "$HISTFILE")

jq -n \
  --argjson cpu "$CPU" \
  --argjson gpu_edge "$GPU_EDGE" \
  --argjson gpu_junction "$GPU_JUNCTION" \
  --argjson gpu_fan "$GPU_FAN" \
  --argjson gpu_power "$GPU_POWER" \
  --argjson cpu_history "$CPU_HISTORY" \
  '{cpu: $cpu, gpu_edge: $gpu_edge, gpu_junction: $gpu_junction, gpu_fan: $gpu_fan, gpu_power: $gpu_power, cpu_history: $cpu_history}'
