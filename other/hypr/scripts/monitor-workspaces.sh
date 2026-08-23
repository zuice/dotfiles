#!/usr/bin/env bash

OMEN_DESCRIPTION="HP Inc. OMEN 27qs CNC3370ZVP"
DELL_DESCRIPTION="Dell Inc. DELL AW2518HF W5VJ108T091U"

command -v jq >/dev/null || exit 0

# Resolve connector names only when this exact pair is present.
attempt=0
while ((attempt < 50)); do
	monitors=$(hyprctl monitors -j 2>/dev/null) || monitors=
	omen=$(jq -r --arg description "$OMEN_DESCRIPTION" '.[] | select(.description == $description) | .name' <<< "$monitors" 2>/dev/null)
	dell=$(jq -r --arg description "$DELL_DESCRIPTION" '.[] | select(.description == $description) | .name' <<< "$monitors" 2>/dev/null)

	if [[ -n "$omen" && -n "$dell" ]]; then
		break
	fi

	((attempt++))
	sleep 0.1
done

[[ -n "$omen" && -n "$dell" ]] || exit 0

for workspace in 1 2 3 4 5; do
	options="persistent:true"
	[[ "$workspace" == 1 ]] && options="default:true,$options"
	hyprctl keyword workspace "$workspace,monitor:$omen,$options" >/dev/null
done

hyprctl keyword workspace "6,monitor:$dell,default:true,persistent:true" >/dev/null

for workspace in 7 8 9 10; do
	hyprctl keyword workspace "$workspace,monitor:$dell" >/dev/null
done
