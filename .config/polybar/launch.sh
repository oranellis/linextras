#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
if [[ $(find /sys/class/power_supply | grep -i "BAT0") ]]
then
	echo "laptop mode!"
	polybar laptop 2>&1 | tee -a /tmp/polybar1.log & disown
else
	echo "desktop mode!"
	polybar desktop 2>&1 | tee -a /tmp/polybar2.log & disown
fi

echo "Bars launched..."
