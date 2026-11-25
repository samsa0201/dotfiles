#!/usr/bin/env bash
# tmux-resurrect post-save-layout hook: rewrite claude panes' command to
# `claude --resume <id>`, id comes from pane option @claude-sid (set by Claude SessionStart hook).
f="$1"
[ -f "$f" ] || exit 0
awk -F'\t' -v OFS='\t' '
$1 == "pane" && $10 == "claude" {
	t = $2 ":" $3 "." $6; gsub(/'\''/, "'\''\\'\'''\''", t)
	sid = ""; c = "tmux show -pqv -t '\''" t "'\'' @claude-sid"
	c | getline sid; close(c)
	if (sid != "") $11 = ":claude --resume " sid
}
{ print }' "$f" >"$f.tmp" && mv "$f.tmp" "$f"
