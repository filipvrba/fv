#!/bin/bash

file=$1
type="${file##*.}"
abspath=$(pwd)
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
