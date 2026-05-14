#!/bin/bash

if grep -q closed /proc/acpi/button/lid/LID0/state 2>/dev/null; then
    hyprctl keyword monitor "eDP-1, disable"
else
    hyprctl keyword monitor "eDP-1, preferred, auto, 1"
fi
