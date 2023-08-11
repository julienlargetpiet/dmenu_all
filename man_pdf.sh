#!/bin/bash

manual=$1

man_out="${manual}.pdf"

man -Tpdf $manual > $man_out && zathura $man_out

rm $man_out
