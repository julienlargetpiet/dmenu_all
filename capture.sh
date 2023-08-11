#!/bin/bash

nb=$(ls ~/all_media/screenshots/*jpg | wc -l)

scrot ~/all_media/screenshots/${nb}.jpg

notify-send "Capture d'écran" "${nb}.jpg"

python3 ~/all_media/play.py
