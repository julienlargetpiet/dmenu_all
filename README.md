# dmenu_all
Bash script to manage your files, run application, run custom scripts and run custom dmenu scripts

## Searching files and other

   - This script allows to **search files**, and **open them** regarding their extension with the softwares informed in conf variables at the top of "all_media_read.sh"

## Quick search

     - Example:

           !ssd1/ms

   - You can **directly access** to the file or folder you want specifying "!" at the beginning. When it comes to the **history** of directories or files accessed, the behavior is the same as for the command except that the history file is named "regular.txt"  

## Alias for custom scripts

    - Example: 

           :brave wikipedia.org

   - This script allows to **run command** (including app launcher) specified with ":" at the beginning of each one. If the command is not found it will indicate you that there is an error. If the command exist, it will be written in your **history** of command (if not already the case) to the file "command_a.txt". Basically all command can be run.

   - You can run **custom script with aliases** if you create a file in this programm folder following this synthax:
     
     **alias_you_want.als**
     
   After that, write: "bash _path of the custom script_" in the created file
   
   Now you can run your custom script from dmenu with all options you want to add!

## Others custom dmenu scripts

   - You can run custom dmenu script as the one named: **system_decision.sh** which is a menu selecting if you want to poweroof, lock... your system.

     To add custom dmenu script just follow these steps:

     - Arround the line 104
         
            echo "NEW ACTION" >> ~/all_media/all_media_read.txt

     - Arround the line 116
    
            elif [ "$a"  = "NEW ACTION" ]
             then

                   bash path_of_your_custom_script

                   exit 0

     - I suggest you to include a "CANCEL" command in your custom script as in "system_decision.sh" and make it return to "all_media_read.sh"

## Stay behavior

   - If you want this script continue running while openning a file in a certain directory, just edit the file "stay_behavior.txt" following this synthax

        - example for directory named ssd1

                 /home/$USER/ssd1
                 /home/$USER//ssd1

## Quick Access

   Like "PLAYLIST" option do, it direct automatically in your playlist path indicated in the **conf variables**
             
   -To add one follow these steps:

    - Add in "all_media_read.sh" arround line 104

        echo "NEW DIRECT PATH" >> ~/all_media/all_media_read.txt

     - Add in "all_media_read.sh" arround line 174

        elif [ "$a"  = "NEW DIRECT PATH" ]
        then

                   a=path_you_want

   
   
