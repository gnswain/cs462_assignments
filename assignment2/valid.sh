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
ext=$(echo $1 | cut -d. -f2)

if [[ $ext != 'iso' && $ext != 'oso' ]]; then
    echo "ERROR: \".$ext\" is not a valid file extension"
    exit 1
fi

# Seems like a rudimentary way of doing it, does not care if header lines are in correct order
awk -E check_headers.awk $1
valid=$?

if [[ $valid == 1 ]]; then
    exit 1
fi

if [[ $ext == 'iso' ]]; then
    state=$(awk -F, '/^address/ {print $3}' $1 | xargs) # xargs strips whitespace
    if [ "$state" != 'NC' ]; then
        echo 'ERROR: In-state invoices must have "NC" as the state'
        exit 1
    fi
fi

cats=$(awk -F, '/^categories/ {print NF}' $1)
items=$(awk -F, '/^items/ {print NF}' $1)

if [[ $cats != $items ]]; then
    echo "ERROR: invalid item quantities: $cats categories but $items items"
    exit 1
fi

exit 0