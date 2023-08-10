#!/bin/bash

###CONF VARIABLES###

text_editor=nvim
gui_text_editor_status="no" # is your text editor gui based ?
image_viewer=sxiv
pdf_viewer=zathura
browser=brave
media_player=mpv
terminal_emulator=alacritty
document_reader=libreoffice

playlist_path=~/ssd1/ms/

quit_on_run="yes"
sound_effect="yes"
on_track="yes"
save_on_quit="no"

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

        if [ "$keep_running" = "no" ]
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

while true
do

        echo "" > ~/all_media/all_media_read.txt

        ls $a | xargs -I X echo $a/X > ~/all_media/all_media_read.txt 

        cat ~/all_media/command_a.txt >> ~/all_media/all_media_read.txt

        cat ~/all_media/regular.txt >> ~/all_media/all_media_read.txt

        cat ~/all_media/command_alias.txt >> ~/all_media/all_media_read.txt

        echo "QUIT" >> ~/all_media/all_media_read.txt

        echo "BACK" >> ~/all_media/all_media_read.txt

        echo "STOP" >> ~/all_media/all_media_read.txt

        echo "PLAYLIST" >> ~/all_media/all_media_read.txt

        echo "FROM" >> ~/all_media/all_media_read.txt

        echo "KILL LAST" >> ~/all_media/all_media_read.txt

        echo "SYSTEM" >> ~/all_media/all_media_read.txt

        a=$(cat ~/all_media/all_media_read.txt | dmenu -l 20 -p "File manager")

        ext=${a##*.}

        frst=${a:0:1}

        if [[ $a = "QUIT" ]]
        then

                exit 0

        elif [[ "$a" = "FROM" ]]
        then

                a=~/

                echo $a >> ~/all_media/history_list.txt

                echo $a > ~/all_media/save_on_quit.txt

        elif [[ "$a" = "SYSTEM" ]]
        then

                bash ~/all_media/system_decision.sh

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

                                python3 ~/all_media/error_play.py &

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

                a=$playlist_path

                echo $a > ~/all_media/save_on_quit.txt

        elif [ $frst = "!" ]
        then

                lnght=${#a}

                n_com=${a:1:$lnght}

                condition=$(if grep -q "$a" ~/all_media/regular.txt; then echo "yes"; fi)

                if [ "$condition" = "" ]
                then

                        echo $a >> ~/all_media/regular.txt

                fi

                if [ -d $HOME/$n_com ] || [ -f $HOME/$n_com ]
                then

                        if [ -f $HOME/$n_com ]
                        then

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

                                        if [ "$quit_on_run" = "yes" ] [ "$unquit_exception" = "no" ]
                                        then

                                                exit 0

                                        else

                                                recheck

                                                a=$dir_in/

                                        fi

                                elif [[ -f $a ]]
                                then

                                        if [ "$gui_text_editor_status" = "no" ]
                                        then

                                                touch ~/source_launcher

                                                echo "$text_editor $a" > ~/all_media/source_launcher_ex.sh

                                                $terminal_emulator &

                                                pid_last=$!

                                                echo "kill $pid_last" >> ~/all_media/source_launcher_ex.sh

                                                dir_in=$(dirname $a)

                                                unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                                        else

                                                $text_editor $a

                                        fi

                                        if [ "$quit_on_run" = "yes" ] && [ "$unquit_exception" = "no" ]
                                        then

                                                exit 0

                                        else

                                                recheck

                                                a=$dir_in/

                                        fi


                                fi
                        
                        else

                                a=~/$n_com

                                echo $a > ~/all_media/save_on_quit.txt

                        fi

                else

                        if [ "$sound_effect" = "yes" ] 
                        then 
                        
                                python3 ~/all_media/error_play.py &
                        
                        fi

                        a=~/

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

                        echo $alias_com

                        echo "$alias_com$arguments" > ~/all_media/command_alias.sh

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
                        
                                python3 ~/all_media/error_play.py &
                        
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

                if [ "$quit_on_run" = "yes" ] [ "$unquit_exception" = "no" ]
                then

                        exit 0

                else

                        recheck

                        a=$dir_in/

                fi

        elif [[ -f $a ]]
        then

                if [ "$gui_text_editor_status" = "no" ]
                then

                        touch ~/source_launcher

                        echo "$text_editor $a" > ~/all_media/source_launcher_ex.sh

                        $terminal_emulator &

                        pid_last=$!

                        echo "kill $pid_last" >> ~/all_media/source_launcher_ex.sh

                        dir_in=$(dirname $a)

                        unquit_exception=$(if grep -q "$dir_in" ~/all_media/stay_behavior.txt; then echo "yes"; else echo "no"; fi)

                else

                        $text_editor $a

                fi

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
