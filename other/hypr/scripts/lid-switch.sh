#!/bin/bash

for path in /proc/acpi/button/lid/*/state; do
    if [ -f "$path" ]; then
        if grep -q closed "$path"; then
            hyprctl keyword monitor "eDP-1, disable"
        else
            hyprctl keyword monitor "eDP-1, preferred, auto, 2"
        fi
        exit 0
    fi
done
