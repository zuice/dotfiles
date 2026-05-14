#!/usr/bin/env bash

WAYBAR_DIR="$HOME/.config/waybar"

detect_and_update() {
	local hidpi_content
	local current=""

	if [ -f "$WAYBAR_DIR/hidpi.css" ]; then
		current=$(cat "$WAYBAR_DIR/hidpi.css")
	fi

	if hyprctl monitors -j 2>/dev/null | grep -q '"scale"[[:space:]]*:[[:space:]]*2'; then
		hidpi_content=$(cat "$WAYBAR_DIR/hidpi.css.tmp" 2>/dev/null || cat <<'CSS'
* {
	font-size: 11px;
}

#waybar > box {
	border-radius: 10px;
	margin: 4px 8px;
	padding: 0 4px;
}

button {
	border-radius: 6px;
	min-width: 12px;
	padding: 0 4px;
}

tooltip label {
	font-size: 10px;
}

#workspaces button.active label {
	font-size: 12px;
}

#workspaces {
	margin-left: 1px;
	padding: 0 2px;
}

#workspaces button {
	padding: 0 4px;
	border-radius: 6px;
}

#window {
	padding: 0 8px;
	font-size: 10px;
}

#clock.time {
	padding: 0 16px;
	font-size: 11px;
}

#cpu,
#memory,
#temperature,
#disk,
#network,
#bluetooth,
#pulseaudio,
#battery,
#idle_inhibitor,
#tray {
	padding: 0 6px;
	font-size: 11px;
}

#tray {
	padding: 0 6px;
}
CSS
)
		if [ "$current" != "$hidpi_content" ]; then
			echo "$hidpi_content" > "$WAYBAR_DIR/hidpi.css"
		fi
	else
		if [ -s "$WAYBAR_DIR/hidpi.css" ]; then
			: > "$WAYBAR_DIR/hidpi.css"
		fi
	fi
}

detect_and_update

socat -U UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - 2>/dev/null | while read -r line; do
	if [[ "$line" == monitor* ]]; then
		sleep 0.5
		detect_and_update
	fi
done
