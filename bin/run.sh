#!/bin/bash
# http://mywiki.wooledge.org/BashFAQ/100#Removing_part_of_a_string

file=$1
type="${file##*.}"
abspath=$(realpath $0)
abspath=${abspath%/*/*}
case $type in

  lua)
    lua $abspath/src/$file $@
    ;;

  rb)
    ruby $abspath/src/$file $@
    ;;

  py)
    python $abspath/src/$file $@
    ;;

  *)
    echo "Not support this file for an interpreter"
    ;;
esac
