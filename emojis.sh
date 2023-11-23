#!/bin/bash

a=$(cat ~/all_media/emojis.txt | dmenu -l 20 -p "emojis")

if [ "$a" = "CANCEL" ]
then

        bash ~/all_media/all_media_read.sh 

else

        a=$(echo $a | cut -d "#" -f 2)

        a=${a:1:1}

        echo $a | xclip

        exit 0

fi
