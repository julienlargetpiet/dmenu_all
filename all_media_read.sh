#!/bin/bash

###CONF VARIABLES###

launcher=$(cat ~/all_media/launcher.txt)
text_editor=nvim
gui_text_editor_status="no" # is your text editor gui based ?
image_viewer=sxiv
pdf_viewer=zathura
browser=vieb
media_player=mpv
terminal_emulator=alacritty
document_reader=libreoffice
music_player=mocp
play_music_with_mocp="yes"

playlist_path=~/ssd1/ms/

quit_on_run="yes"
sound_effect="yes"
on_track="yes"
save_on_quit="yes"

###################

recheck () {

        max_line=$(cat ~/all_media/stay_behavior.txt | wc -l)

        t=1

        lnght=${#dir_in}

        keep_running="no"

        while [ "$t" -ne "$max_line" ]
        do

                compared=$(grep "$dir_in" ~/all_media/stay_behavior.txt | sed -n ${t}p)

                compared=${#compared}

                if [ "$compared" = "$lnght" ]
                then

                        t=$max_line

                        keep_running="yes"

                else

                        t=$((t+1))


                fi

        done

        if [ "$keep_running" = "no" ] && [ "$quit_on_run" = "yes" ]
        then

                exit 0

        fi

}

echo "" > ~/all_media/last_process.txt

if [[ "$save_on_quit" = "yes" ]]
then

        a=$(cat ~/all_media/save_on_quit.txt)

else
        
        a=~/

fi

echo $a > ~/all_media/history_list.txt

echo $a > ~/all_media/save_on_quit.txt

dir_in=$a

if [ "$sound_effect" = "yes" ]
then

        bash ~/all_media/launcher.sh &

fi

while true
do

        echo "" > ~/all_media/all_media_read.txt

        ls $a | xargs -I X echo $a/X > ~/all_media/all_media_read.txt 

        cat ~/all_media/command_a.txt >> ~/all_media/all_media_read.txt

        #cat ~/all_media/command_a_v.txt >> ~/all_media/all_media_read.txt

        cat ~/all_media/regular.txt >> ~/all_media/all_media_read.txt

        cat ~/all_media/command_alias.txt >> ~/all_media/all_media_read.txt

        echo "QUIT" >> ~/all_media/all_media_read.txt

        echo "BACK" >> ~/all_media/all_media_read.txt

        echo "STOP" >> ~/all_media/all_media_read.txt

        echo "PLAYLIST" >> ~/all_media/all_media_read.txt

        echo "FROM" >> ~/all_media/all_media_read.txt

        echo "KILL LAST" >> ~/all_media/all_media_read.txt

        echo "SYSTEM" >> ~/all_media/all_media_read.txt

        echo "SCREENSHOT" >> ~/all_media/all_media_read.txt

        echo "CALCURSE" >> ~/all_media/all_media_read.txt

        echo "BLACK SCREEN" >> ~/all_media/all_media_read.txt

        echo "MUSIC!!!" >> ~/all_media/all_media_read.txt

        echo "EMOJIS" >> ~/all_media/all_media_read.txt

        echo "STREAM" >> ~/all_media/all_media_read.txt

        if [ "$launcher" = "dmenu" ]
        then

                a=$(cat ~/all_media/all_media_read.txt | dmenu -l 20 -p "File Manager")

        else #[ "$launcher" = "rofi" ]

                a=$(cat ~/all_media/all_media_read.txt | rofi -dmenu -p "File Manager")

        fi

        ext=${a##*.}

        frst=${a:0:1}

        if [[ $a = "QUIT" ]]
        then

                exit 0

        elif [[ $a = "MUSIC!!!" ]]
        then

                $terminal_emulator -e $music_player

                exit 0

        elif [[ "$a" = "FROM" ]]
        then

                a=~/

                echo $a >> ~/all_media/history_list.txt

                echo $a > ~/all_media/save_on_quit.txt

        elif [[ "$a" = "STREAM" ]]
        then

                $media_player $(xclip -o)

                exit 0

        elif [[ "$a" = "SCREENSHOT" ]]
        then

                bash ~/all_media/capture.sh

                exit 0

        elif [[ "$a" = "EMOJIS" ]]
        then

                bash ~/all_media/emojis.sh

                exit 0

        elif [[ "$a" = "SYSTEM" ]]
        then

                bash ~/all_media/system_decision.sh

                exit 0

        elif [[ "$a" = "CALCURSE" ]]
        then

                $terminal_emulator -e calcurse

                exit 0

        elif [[ $a = "BLACK SCREEN" ]]
        then

                xset dpms force off

                exit 0

        elif [[ $a = "BACK" ]]
        then

                max_line=$(cat ~/all_media/history_list.txt | wc -l)

                sed -i "${max_line},${max_line}d" ~/all_media/history_list.txt

                max_line=$((max_line-1))

                a=$(sed -n ${max_line}p ~/all_media/history_list.txt)

        elif [[ "$a" = "KILL LAST" ]]
        then

                max_line=$(cat ~/all_media/last_process.txt | wc -l)

                echo $dir_in

                if [ "$max_line" -ne "1" ]
                then

                        last_process=$(sed -n ${max_line},${max_line}p ~/all_media/last_process.txt)

                        kill $last_process

                        sed -i "${max_line},${max_line}d" ~/all_media/last_process.txt

                else

                        if [ "$sound_effect" = "yes" ]
                        then

                                bash ~/all_media/errorer.sh &

                        fi

                fi

                a=$dir_in

        elif [[ "$a" = "STOP" ]]
        then

                kill $(cat ~/all_media/last_music.txt)

                if [ "$on_track" = "yes" ]
                then

                        a=$playlist_path

                else

                        a=~/ 

                        if [ "$quit_on_run" = "yes" ]
                        then

                                exit 0

                        fi

                fi

        elif [[ "$a" = "PLAYLIST" ]]
        then

                if [ "$play_music_with_mocp" = "yes" ]
                then

                        bash ~/all_media/mocp_.sh &

                        exit 0

                else

                        a=$playlist_path

                        echo $a > ~/all_media/save_on_quit.txt

                fi

        elif [ $frst = "!" ]
        then

                lnght=${#a}

                n_com=${a:1:$lnght}

                if [ -d $HOME/$n_com ] || [ -f $HOME/$n_com ]
                then

                        if [ -f $HOME/$n_com ]
                        then

                                condition=$(if grep -q "$a" ~/all_media/regular.txt; then echo "yes"; fi)

                                if [ "$condition" = "" ]
                                then

                                        echo $a >> ~/all_media/regular.txt

                                fi

                                a=~/$n_com

                                if [ $ext = "jpg" ] || [ $ext = "png" ] || [ $ext = "svg" ] || [ $ext = "gif" ] || [ $ext = "jpeg" ]
                                then

                                        $image_viewer $a &

                                        echo $! >> ~/all_media/last_process.txt

                                        dir_in=$(dirname $a)

                                        unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                                        if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                                        then

                                                exit 0

                                        else

                                                recheck

                                                a=$dir_in/

                                        fi
                                        
                                elif [ $ext = "mp4" ] || [ $ext = "mp3" ] || [ $ext = "wav" ] || [ $ext = "mp4" ] || [ $ext = "avi" ] || [ $ext = "mkv" ]
                                then

                                        kill $(cat ~/all_media/last_music.txt)

                                        $media_player $a & 

                                        echo $! >> ~/all_media/last_process.txt

                                        echo $! > ~/all_media/last_music.txt

                                        dir_in=$(dirname $a)

                                        unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                                        if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                                        then

                                                existenz=$(command -v notify-send)

                                                if (( ${#existenz} > 1 ))
                                                then

                                                        notify-send "Playng" "$a"

                                                fi

                                                exit 0

                                        else

                                                recheck

                                                a=$dir_in/

                                        fi
                                        
                                elif [ $ext = "doc" ] || [ $ext = "docx" ] || [ $ext = "xls" ] || [ $ext = "xlsx" ] || [ $ext = "ppt" ] || [ $ext = "pptx" ]
                                then

                                        $document_reader $a &

                                        echo $! >> ~/all_media/last_process.txt

                                        dir_in=$(dirname $a)

                                        unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                                        if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                                        then

                                                exit 0

                                        else

                                                recheck

                                                a=$dir_in/

                                        fi
                                        
                                elif [ $ext = "pdf" ]
                                then

                                        $pdf_viewer $a &

                                        echo $! >> ~/all_media/last_process.txt

                                        dir_in=$(dirname $a)

                                        unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                                        if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                                        then

                                                exit 0

                                        else

                                                recheck

                                                a=$dir_in/

                                        fi

                                elif [ $ext = "html" ]
                                then

                                        $browser $a &

                                        echo $! >> ~/all_media/last_process.txt

                                        dir_in=$(dirname $a)

                                        unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                                        if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                                        then

                                                exit 0

                                        else

                                                recheck

                                                a=$dir_in/

                                        fi

                                elif [[ -f $a ]]
                                then

#                                        if [ "$gui_text_editor_status" = "no" ]
#                                        then
#
#                                                echo "yes" >  ~/all_media/source_launcher_decision.txt
#
#                                                echo "$text_editor $a" > ~/all_media/source_launcher_ex.sh
#
#                                                $terminal_emulator &
#
#                                                pid_last=$!
#
#                                                echo "kill $pid_last" >> ~/all_media/source_launcher_ex.sh
#
#                                        else
#
#                                                $text_editor $a
#
#                                        fi

                                        $terminal_emulator -e $text_editor $a

                                        dir_in=$(dirname $a)

                                        unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                                        if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                                        then

                                                exit 0

                                        else

                                                recheck

                                                a=$dir_in/

                                        fi


                                fi
                        
                        else

                                a_origin=$a

                                a=~/$n_com

                                dir_in=$a

                                echo $a > ~/all_media/save_on_quit.txt

                        fi

                        condition=$(if grep -q "$a_origin" ~/all_media/regular.txt; then echo "yes"; fi)

                        if [ "$condition" = "" ]
                        then

                                echo $a_origin >> ~/all_media/regular.txt

                        fi

                else

                        if [ "$sound_effect" = "yes" ] 
                        then 
                        
                                bash ~/all_media/errorer.sh &

                        fi

                        a=~/

                fi

        elif [ "$frst" = "*" ]
        then

                filtered_com=$(echo $a | cut -d " " -f 1)

                lnght=${#filtered_com}

                filtered_com=${filtered_com:1:$lnght}

                if [ "$filtered_com" = "mv" ]
                then

                        arg_f=$(echo $a | cut -d " " -f 2)

                        existenz=$(if [ -f $dir_in/$arg_f ]; then echo "yes"; else echo "no"; fi)

                        if [ "$existenz" = "no" ]
                        then

                                if [ "$sound_effect" = "yes" ]
                                then 

                                        bash ~/all_media/errorer.sh &

                                fi

                                a=~/

                        else

                                arg_s=$(echo $a | cut -d " " -f 3)

                                mv $dir_in/$arg_f $dir_in/$arg_s

                                a=$dir_in

                        fi

                fi

                if [ "$filtered_com" = "cp" ]
                then

                        arg_f=$(echo $a | cut -d " " -f 2)

                        existenz=$(if [ -f $dir_in/$arg_f ]; then echo "yes"; else echo "no"; fi)

                        if [ "$existenz" = "no" ]
                        then

                                if [ "$sound_effect" = "yes" ]
                                then 

                                        bash ~/all_media/errorer.sh &

                                fi

                                a=~/

                        else

                                arg_s=$(echo $a | cut -d " " -f 3)

                                cp $dir_in/$arg_f $dir_in/$arg_s

                                a=$dir_in

                        fi

                fi

                if [ "$filtered_com" = "rm" ]
                then

                        arg_f=$(echo $a | cut -d " " -f 2)

                        existenz=$(if [ -f $dir_in/$arg_f ]; then echo "yes"; else echo "no"; fi)

                        if [ "$existenz" = "no" ]
                        then

                                if [ "$sound_effect" = "yes" ]
                                then 

                                        bash ~/all_media/errorer.sh &

                                fi

                                a=~/

                        else

                                rm $dir_in/$arg_f 

                                a=$dir_in

                        fi


                fi

                if [ "$filtered_com" = "touch" ]
                then

                        arg_f=$(echo $a | cut -d " " -f 2)

                        echo $dir_in/$arg_f 

                        touch $dir_in/$arg_f 

                        a=$dir_in


                fi

        elif [ "$frst" = ";" ]
        then

                filtered_com=$(echo $a | cut -d " " -f 1)

                lnght=${#filtered_com}

                s=${filtered_com:1:$lnght}

                arguments=$(echo $a | cut -d " " -f 2-$lnght)

                s2=$s

                s=${s##*/}

                filename=${s%.*}

                existenz=$(if grep -q "$filename" ~/all_media/all_alias.txt; then echo "yes"; fi)

                if [ "$existenz" = "yes" ]
                then

                        existenz=$(if grep -q "$a" ~/all_media/command_alias.txt; then echo "yes"; fi)

                        if [ "$existenz" = "" ]
                        then

                                echo $a >> ~/all_media/command_alias.txt

                        fi

                        alias_com=$(cat ~/all_media/$s2.als)

                        echo "$alias_com $arguments" > ~/all_media/command_alias.sh

                        bash ~/all_media/command_alias.sh &

                        exit 0

                else

                        exit 2

                fi


        elif [ $frst = ":" ]
        then

                lnght=${#a}

                n_com=${a:1:$lnght}

                echo "#!/bin/bash" > ~/all_media/command_a.sh

                echo "" >> ~/all_media/command_a.sh

                echo $n_com >> ~/all_media/command_a.sh

                existing=$(command -v $n_com)

                err_rtrn="no"

                if [ "$existing" = "" ]
                then

                        if [ "$sound_effect" = "yes" ] 
                        then 
                        
                                bash ~/all_media/errorer.sh &

                        fi

                        err_rtrn="yes"

                        a=~/

                else

                        bash ~/all_media/command_a.sh &

                fi

                condition=$(if grep -q "$a" ~/all_media/command_a.txt; then echo "yes"; fi)

                if [ "$condition" = "" ]
                then

                        echo $a >> ~/all_media/command_a.txt

                fi

                if [ "$quit_on_run" = "yes" ] && [ "$err_rtrn" = "no" ]
                then

                        exit 0

                fi

        #elif [ "$frst" = "$" ]
        #then

        #        lnght=${#a}

        #        n_com=${a:1:$lnght}

        #        sed -i "s/COM/${n_com}/g" ~/all_media/command_a_v.sh

        #        existing=$(command -v $n_com)

        #        err_rtrn="no"

        #        if [ "$existing" = "" ]
        #        then

        #                if [ "$sound_effect" = "yes" ] 
        #                then 
        #                
        #                        bash ~/all_media/errorer.sh &

        #                fi

        #                err_rtrn="yes"

        #                a=~/

        #        else

        #                bash ~/all_media/command_a_v.sh 

        #                cat ~/all_media/command_a_v.sh

        #                sed -i "s/${n_com}/COM/g" ~/all_media/command_a_v.sh

        #                #d=$(cat ~/all_media/)

        #        fi

        #        condition=$(if grep -q "$a" ~/all_media/command_a.txt; then echo "yes"; fi)

        #        if [ "$condition" = "" ]
        #        then

        #                echo $a >> ~/all_media/command_a_v.txt

        #        fi

        #        if [ "$quit_on_run" = "yes" ] && [ "$err_rtrn" = "no" ]
        #        then

        #                exit 0

        #        fi

        elif [ $ext = "jpg" ] || [ $ext = "png" ] || [ $ext = "svg" ] || [ $ext = "gif" ] || [ $ext = "jpeg" ]
        then

                $image_viewer $a &

                echo $! >> ~/all_media/last_process.txt

                dir_in=$(dirname $a)

                unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                then

                        exit 0

                else

                        recheck

                        a=$dir_in/

                fi

        elif [ $ext = "mp4" ] || [ $ext = "mp3" ] || [ $ext = "wav" ] || [ $ext = "mp4" ] || [ $ext = "avi" ] || [ $ext = "mkv" ]
        then

                kill $(cat ~/all_media/last_music.txt)

                $media_player $a & 

                echo $! >> ~/all_media/last_process.txt

                echo $! > ~/all_media/last_music.txt

                dir_in=$(dirname $a)

                unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                then

                        existenz=$(command -v notify-send)

                        if (( ${#existenz} > 1 ))
                        then

                                notify-send "Playng" "$a"

                        fi

                        exit 0

                else

                        recheck

                        a=$dir_in/

                fi

        elif [ $ext = "doc" ] || [ $ext = "docx" ] || [ $ext = "xls" ] || [ $ext = "xlsx" ] || [ $ext = "ppt" ] || [ $ext = "pptx" ]
        then

                $document_reader $a &

                echo $! >> ~/all_media/last_process.txt

                dir_in=$(dirname $a)

                unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                then

                        exit 0

                else

                        recheck

                        a=$dir_in/

                fi

        elif [ $ext = "pdf" ]
        then

                $pdf_viewer $a &

                echo $! >> ~/all_media/last_process.txt

                dir_in=$(dirname $a)

                unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                then

                        exit 0

                else

                        recheck

                        a=$dir_in/

                fi

        elif [ $ext = "html" ]
        then

                $browser $a &

                echo $! >> ~/all_media/last_process.txt

                dir_in=$(dirname $a)

                unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                then

                        exit 0

                else

                        recheck

                        a=$dir_in/

                fi

        elif [[ -f $a ]]
        then

#                if [ "$gui_text_editor_status" = "no" ]
#                then
#
#                        echo "yes" >  ~/all_media/source_launcher_decision.txt
#
#                        echo "$text_editor $a" > ~/all_media/source_launcher_ex.sh
#
#                        $terminal_emulator &
#
#                        pid_last=$!
#
#                        echo "kill $pid_last" >> ~/all_media/source_launcher_ex.sh
#
#                else
#
#                        $text_editor $a
#
#                fi

                $terminal_emulator -e $text_editor $a

                dir_in=$(dirname $a)

                unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                then

                        exit 0

                else

                        recheck

                        a=$dir_in/

                fi

        else

                echo $a >> ~/all_media/history_list.txt

                echo $a > ~/all_media/save_on_quit.txt

                dir_in=$a

        fi

done
