#!/bin/bash

output_file=~/sxiv_web/out_sxiv.jpg

dwnl=0

while getopts ":o:i:d:" options; do         
                                          
  case "${options}" in                     
    
    o)                                    
      output_file=${OPTARG}

      output_file=~/sxiv_web/${output_file}

      ;;

    i)
        file_to_read=${OPTARG}

        ;;

    d)

            dwnl=${OPTARG}

            ;;

    :)
            echo "options are -i (input file), -d (1 to download, default is no) -o (output file)"
      exit 1                      
      ;;

    *)


            echo "options are -i (input file), -d (1 to download, default is no) -o (output file)"
      exit 1
      ;;

  esac
done

wget -O $output_file $file_to_read

sxiv $output_file

if [[ "$dwnl" = "0" ]]
then
 
        rm $output_file

fi

