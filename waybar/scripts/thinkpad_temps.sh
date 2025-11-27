#!/usr/bin/env bash
cpu=$(cat /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon3/temp1_input)
gpu=$(cat /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon3/temp2_input)

cpuC=$((cpu/1000))
gpuC=$((gpu/1000))

# Default styling
style_class="normal"

# If CPU temp is >= 70°C, set critical styling
if [ "$cpuC" -ge 70 ] || [ "$gpuC" -ge 70 ]; then
  style_class="critical"
fi

# Output JSON Waybar understands
echo "{\"text\": \" CPU: $cpuC°C GPU: $gpuC°C\", \"class\": \"$style_class\"}"
