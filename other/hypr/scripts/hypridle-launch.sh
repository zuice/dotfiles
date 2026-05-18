#!/bin/bash

if ls /sys/class/power_supply/BAT* &>/dev/null; then
    exec hypridle -c ~/.config/hypr/hypridle-laptop.conf
else
    exec hypridle -c ~/.config/hypr/hypridle-desktop.conf
fi
