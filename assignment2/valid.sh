#! /bin/bash
# !!! might have to change to /usr/bin/bash depending on location of bash

# Isaiah Hermance
# Graham Swain
# October 26, 2022
# Takes the name of three files, merges the first two in the third file.
# Error code represents how many errors there are.

if [[ $# -ne 1 ]]; then
    echo 'usage: valid.sh <file>'
    exit 1
fi

# Checking if file exists, if it's a directory, and that it has correct permissions
# Assuming we want all permissions
if ! [[ -e "$1" ]]; then
    echo "ERROR: $1 does not exist"
    exit 1
elif [[ -d "$1" ]]; then
    echo "ERROR: $1 is a directory"
    exit 1
else
    if ! [[ -r "$1" ]]; then
        echo "ERROR: $1 does not have read permission"
    exit 1
    fi
    if ! [[ -w "$1" ]]; then
        echo "ERROR: $1 does not have write permission"
    exit 1
    fi
    if ! [[ -x "$1" ]]; then
        echo "ERROR: $1 does not have execute permission"
    exit 1
    fi
fi

# Gets the extension from the given file
ext="${1##*.}"
echo $ext

if [[ $ext != 'iso' && $ext != 'oso' ]]; then
    echo "ERROR: \".$ext\" is not a valid file extension"
fi

# Seems like a rudimentary way of doing it, does not care if header lines are in correct order
awk -E check_headers.awk $1

# TODO check to see if .iso is in NC