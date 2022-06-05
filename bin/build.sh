#!/bin/bash

file=$1
abspath=$(pwd)
gcc -o $abspath/lib/$file $abspath/src/$file.c