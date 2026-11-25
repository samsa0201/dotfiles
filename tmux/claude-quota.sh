#!/usr/bin/env bash
# tmux status: Claude 5h + weekly quota %, refreshed every 1m, "⚠Nm" = data N minutes stale. >=70% yellow, >=90% red.
cache="${XDG_RUNTIME_DIR:-/tmp}/tmux-claude-quota.json"
try="$cache.try" # mtime = last attempt; $cache mtime = last success
# 6 tmux clients run this every 5s and the endpoint 429s easily: one fetcher (flock), one try per 60s.
if [ ! -e "$try" ] || [ $(($(date +%s) - $(stat -c %Y "$try"))) -ge 60 ]; then
	exec 9>"$try.lock"
	if flock -n 9 && { [ ! -e "$try" ] || [ $(($(date +%s) - $(stat -c %Y "$try"))) -ge 60 ]; }; then
		touch "$try"
		tok=$(jq -r '.claudeAiOauth.accessToken // empty' ~/.claude/.credentials.json 2>/dev/null)
		out=$(curl -sf -m 4 https://api.anthropic.com/api/oauth/usage \
			-H "Authorization: Bearer $tok" -H "anthropic-beta: oauth-2025-04-20") &&
			jq -e .five_hour <<<"$out" >/dev/null && printf '%s' "$out" >"$cache.tmp" && mv "$cache.tmp" "$cache"
	fi
fi
[ -s "$cache" ] || exit 0
jq -r --argjson now "$(date +%s)" --argjson age $(($(date +%s) - $(stat -c %Y "$cache"))) '
def c: if . >= 90 then "#[fg=#ffffff,bg=#d32f2f,bold] " elif . >= 70 then "#[fg=#151515,bg=#ffd166,bold] " else "#[fg=#151515,bold]" end;
def left: (sub("\\.[0-9]+";"") | sub("\\+00:00$";"Z") | fromdateiso8601) - $now | if . < 0 then 0 else . end
	| if . >= 86400 then "\(./86400|floor)d\(.%86400/3600|floor)h" else "\(./3600|floor)h\(.%3600/60|floor)m" end;
"#[fg=#d97757,bg=#151515]#[fg=#151515,bg=#d97757]✻ 5h \(.five_hour.utilization|floor|c)\(.five_hour.utilization|floor)%#[nobold,fg=#151515,bg=#d97757] \(.five_hour.resets_at|left) │ wk \(.seven_day.utilization|floor|c)\(.seven_day.utilization|floor)%#[nobold,fg=#151515,bg=#d97757] \(.seven_day.resets_at|left)\(if $age >= 300 then " ⚠\($age/60|floor)m" else "" end)#[fg=#d97757,bg=#151515] "
' "$cache"
