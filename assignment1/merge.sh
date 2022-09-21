#! /bin/bash

# Graham Swain
# September 23, 2022
# Takes the name of three files, merges the first two in the third file.
# Error code represents how many errors there are.

if [[ $# -gt 0 && $# -lt 3 || $# -gt 3 ]]; then
    echo 'usage: merge.sh [FILE FILE FILE]'
    echo 'merge.sh > incorrect usage' >> log.txt
    exit 1
fi

error=0

# Handles entering files from the command line or assigning them from arguments
if [[ $# == 0 ]]; then
    echo -n 'Enter files to merge > '
    read file1 file2 file3

    if [[ -z $file1 ]]; then
        echo 'First file name not supplied'
        ((error++))
    fi
    if [[ -z $file2 ]]; then
        echo 'Second file name not supplied'
        ((error++))
    fi
    if [[ -z $file3 ]]; then
        echo 'Third file name not supplied'
        ((error++))
    fi
else
    file1=$1
    file2=$2
    file3=$3
fi

# Error checking for file 1
if ! [[ -e "$file1" ]]; then
    echo "$file1 does not exist"
    ((error++))
elif [[ -d "$file1" ]]; then
    echo "$file1 is a directory"
    ((error++))
else
    if ! [[ -r "$file1" ]]; then
        echo "$file1 does not have read permissions"
        ((error++))
    fi
    if ! [[ -w "$file1" ]]; then
        echo "$file1 does not have write permissions"
        ((error++))
    fi
    if ! [[ -x "$file1" ]]; then
        echo "$file1 does not have execute permissions"
        ((error++))
    fi
fi

# Error checking for file 2
if ! [[ -e "$file2" ]]; then
    echo "$file2 does not exist"
    ((error++))
elif [[ -d "$file2" ]]; then
    echo "$file2 is a directory"
    ((error++))
else 
    if ! [[ -r "$file2" ]]; then
        echo "$file2 does not have read permissions"
        ((error++))
    fi
    if ! [[ -w "$file2" ]]; then
        echo "$file2 does not have write permissions"
        ((error++))
    fi
    if ! [[ -x "$file2" ]]; then
        echo "$file2 does not have execute permissions"
        ((error++))
    fi
fi

# Error checking for file 3
if [[ -e "$file3" ]]; then
    echo -n "Do you want to overwrite $file3 (y)es or (n)o > "
    read overwrite
    if [[ $overwrite =~ ^[Yy] ]]; then
        if ! [[ -r "$file3" ]]; then
            echo "$file3 does not have read permissions"
            ((error++))
        fi
        if ! [[ -w "$file3" ]]; then
            echo "$file3 does not have write permissions"
            ((error++))
        fi
        if ! [[ -x "$file3" ]]; then
            echo "$file3 does not have execute permissions"
            ((error++))
        fi
    else
        ((error++))
    fi
elif [[ $error == 0 ]]; then
    touch $file3
fi

if [[ $error -ge 1 ]]; then
    echo 'Cannot perform merge, please check files'
    echo $(date) "> Failed to merge $file1 and $file2 into $file3" >> log.txt
    exit $error
fi


echo $(date) "> Merged $file1 and $file2 into $file3" >> log.txt
echo "$file1 merged with $file2"

echo -e "\n-------------------- $file1 --------------------\n" > $file3
cat $file1 >> $file3

echo -e "\n\n-------------------- $file2 --------------------\n" >> $file3
cat $file2 >> $file3

exit 0
