#!/bin/bash

file=$1
abspath=$(pwd)
# $abspath/bin/build.sh $file &&
# $abspath/lib/fifo
ruby $abspath/src/$file.rb