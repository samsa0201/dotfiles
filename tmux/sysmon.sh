#!/usr/bin/env bash
# tmux status: CPU% (delta since last call), RAM used/total, swap. >=70% orange, >=90% red.
state="${XDG_RUNTIME_DIR:-/tmp}/tmux-sysmon-cpu"
read -r _ u n s i w x y z _ </proc/stat
total=$((u + n + s + i + w + x + y + z)); idle=$((i + w))
read -r pt pi cpu 2>/dev/null <"$state"
# 6 tmux clients each run this every 5s; a tiny window between near-simultaneous
# calls has ~0 idle jiffies -> reads 100%. Only resample over windows >= 2s (12 cpus * 100Hz).
if [ -z "$pt" ] || [ $((total - pt)) -ge 2400 ]; then
	[ -n "$pt" ] && cpu=$((100 * ((total - pt) - (idle - pi)) / (total - pt)))
	echo "$total $idle ${cpu:-0}" >"$state"
fi
cpu=${cpu:-0}
awk -v cpu="$cpu" '
function c(p) { return p >= 90 ? "#[fg=#ff5555,bold]" : p >= 70 ? "#[fg=#ffb347,bold]" : "#[fg=#c5c5c3,nobold]" }
/^MemTotal:/ {mt=$2} /^MemAvailable:/ {ma=$2} /^SwapTotal:/ {st=$2} /^SwapFree:/ {sf=$2}
END {
	used = mt - ma; pct = 100 * used / mt
	printf "#[fg=#878785]cpu %s%d%%#[nobold]  #[fg=#878785]mem %s%.1f/%.0fG#[nobold]", c(cpu), cpu, c(pct), used/1048576, mt/1048576
	if (st > 0) printf "  #[fg=#878785]swp #[fg=#c5c5c3]%.1fG", (st - sf)/1048576
	printf ""
}' /proc/meminfo
