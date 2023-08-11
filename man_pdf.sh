#!/bin/bash

a=$(cat ~/all_media/all_media_read.sh | grep "pdf_viewer=")

lnght=${#a}

x=${a:11:$lnght}

pdf_viewer=$x

manual=$1

man_out="${manual}.pdf"

man -Tpdf $manual > $man_out && $pdf_viewer $man_out

rm $man_out
