#!/bin/bash

mocp

launcher=$(cat ~/all_media/launcher.txt)

a=~/ssd1/ms

ls $a | xargs -I X echo $a/X > ~/all_media/all_media_read2.txt 

echo "QUIT" >> ~/all_media/all_media_read2.txt

while true
do

        if [ "$launcher" = "dmenu" ]
        then

                a=$(cat ~/all_media/all_media_read2.txt | dmenu -l 20 -p "File Manager")

        else #[ "$launcher" = "rofi" ]

                a=$(cat ~/all_media/all_media_read2.txt | rofi -dmenu -p "File Manager")

        fi

        if [ "$a" = "QUIT" ]
        then



                exit 0

        else

                mocp -play $a

        fi

done
