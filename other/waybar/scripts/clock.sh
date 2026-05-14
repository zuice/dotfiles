#!/usr/bin/env bash

date_str=$(date +'%m/%d')
time_str=$(date +'%-I:%M %p')

text="<span font_weight='normal'>$date_str</span>  <b>$time_str</b>"
printf '{"text":"%s"}\n' "$text"
