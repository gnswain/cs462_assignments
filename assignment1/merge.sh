#! /usr/bin/bash

if [[ $# > 0 && $# < 3 ]]; then
    echo 'usage: merge.sh [FILE FILE FILE]'
elif [[ $# == 0 ]]; then
    echo -n 'Enter files to merge > '
    read $file1 $file2 $file3
fi