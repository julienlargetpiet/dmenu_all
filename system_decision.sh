#/bin/bash

launcher=$(cat ~/all_media/launcher.txt)

if [ "$launcher" = "dmenu" ]
then

        a=$(cat ~/all_media/system_decision.txt | dmenu -l 5 -p "system")

else

        a=$(cat ~/all_media/system_decision.txt | rofi -dmenu -l 5 -p "system")

fi

if [ $a = "poweroff" ]
then

        sudo poweroff

elif [ $a = "suspend" ]
then

        sudo systemctl suspend

elif [ $a = "reboot" ]
then

        sudo reboot

elif [ $a = "lock" ]
then

        betterlockscreen -l dim

elif [ $a = "CANCEL" ]
then

        bash ~/all_media/all_media_read.sh

fi
