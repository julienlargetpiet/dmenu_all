#!/bin/bash

if [[ -d ~/all_media/screenshots ]]
then

        nb=$(ls ~/all_media/screenshots/*jpg | wc -l)

        scrot -s ~/all_media/screenshots/${nb}.jpg

        notify-send "Capture d'écran" "${nb}.jpg"

        python3 ~/all_media/play.py

else 

        mkdir ~/all_media/screenshots

        touch ~/all_media/screenshots/0.jpg

fi

