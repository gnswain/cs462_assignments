#! /usr/bin/bash

# Graham Swain
# September 23, 2022
# Takes the name of three files, merges the first two in the third file.
# Error code represents how many errors there are.

if [[ $# > 0 && $# < 3 ]]; then
    echo 'usage: merge.sh [FILE FILE FILE]'
    exit 1
fi

valid=0

if [[ $# == 0 ]]; then
    echo -n 'Enter files to merge > '
    read file1 file2 file3

    if [[ -z $file1 ]]; then
        echo 'First file name not supplied'
        ((valid++))
    fi
    if [[ -z $file2 ]]; then
        echo 'Second file name not supplied'
        ((valid++))
    fi
    if [[ -z $file3 ]]; then
        echo 'Third file name not supplied'
        ((valid++))
    fi
else
    file1=$1
    file2=$2
    file3=$3
fi

if ! [[ -e "$file1" ]]; then
    echo "$file1 does not exist"
    ((valid++))
elif [[ -d "$file1" ]]; then
    echo "$file1 is a directory"
    ((valid++))
else
    if ! [[ -r "$file1" ]]; then
        echo "$file1 does not have read permissions"
        ((valid++))
    fi
    if ! [[ -w "$file1" ]]; then
        echo "$file1 does not have write permissions"
        ((valid++))
    fi
    if ! [[ -x "$file1" ]]; then
        echo "$file1 does not have execute permissions"
        ((valid++))
    fi
fi

if ! [[ -e "$file2" ]]; then
    echo "$file2 does not exist"
    ((valid++))
elif [[ -d "$file2" ]]; then
    echo "$file2 is a directory"
    ((valid++))
else 
    if ! [[ -r "$file2" ]]; then
        echo "$file2 does not have read permissions"
        ((valid++))
    fi
    if ! [[ -w "$file2" ]]; then
        echo "$file2 does not have write permissions"
        ((valid++))
    fi
    if ! [[ -x "$file2" ]]; then
        echo "$file2 does not have execute permissions"
        ((valid++))
    fi
fi

if [[ -e "$file3" ]]; then
    echo -n "Do you want to overwrite $file3 (y)es or (n)o > "
    read overwrite
    if [[ $overwrite =~ ^[Yy] ]]; then
        if ! [[ -r "$file3" ]]; then
            echo "$file3 does not have read permissions"
            ((valid++))
        fi
        if ! [[ -w "$file3" ]]; then
            echo "$file3 does not have write permissions"
            ((valid++))
        fi
        if ! [[ -x "$file3" ]]; then
            echo "$file3 does not have execute permissions"
            ((valid++))
        fi
    else
        ((valid++))
    fi
elif [[ $valid == 0 ]]; then
    touch $file3
fi

if [[ $valid -gt 1 ]]; then
    echo 'Cannot perform merge, please check files'
    exit $valid
fi

echo -e "\n-------------------- $file1 --------------------\n" > $file3
cat $file1 >> $file3

echo -e "\n\n-------------------- $file2 --------------------\n" >> $file3
cat $file2 >> $file3

exit 0