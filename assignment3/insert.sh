#! /bin/bash

#Isaiah Hermance && Graham Swain
#Project 3: Shell scripts used to insert records into invoice and print invoice as a table
#16 November 2022


if [[ $# == 2 ]]; then
    fileName=$1
    categoryName=$2
elif [[ $# == 1 ]]; then
    fileName=$1
else
    echo 'usage: insert.sh <file> [category]'
    exit 1
fi

if ! [[ -f $fileName ]]; then
    echo 'ERROR: file "$fileName" does not exist'
    exit 2
elif [[ -d "$1" ]]; then
    echo "ERROR: $1 is a directory"
    exit 3
else
    if ! [[ -r "$1" ]]; then
        echo "ERROR: $1 does not have read permission"
        exit 4
    elif ! [[ -w "$1" ]]; then
        echo "ERROR: $1 does not have write permission"
        exit 5
    fi
fi

# TODO: probably should check if it's a valid invoice

recordsChanged=0
appendToFile=""

# Gets the categories and items in separate arrays
categories=($(awk -F[:,] '/^categories/ {for (i = 2; i <= NF; i++) print $i}' $fileName))
items=($(awk -F[:,] '/^items/ {for (i = 2; i <= NF; i++) print $i}' $fileName))

if [[ $# == 2 ]]; then

    index=-1
    for i in ${!categories[@]}; do # this checks for index of category in the invoice
        if [[ "${categories[$i],,}" = "${categoryName,,}" ]]; then
            index=$i
        fi
    done

    if [[ $index == -1 ]]; then # if the category does not exist, print error msg and exit
        echo "ERROR: '$categoryName' is not a valid category for this invoice"
        exit 6
    fi

    count=$(awk -F: "BEGIN { count = 0; IGNORECASE = 1;} /^${categories[index]}/ { count++ } END {print count}" $fileName)

    count=$((${items[index]} - $count)) # gets how many more items we need

    while [[ $count > 0 ]]; do
        echo -n "Please enter the name of a ${categories[index]} item > "
        read newItem
        echo -n "Please enter a price per unit of $newItem > "
        read newPrice
        echo -n "Please enter the amount of $newItem units to purchase > "
        read newQuantity

        appendToFile="${appendToFile}\n${categories[index]}: $newItem, $newPrice, $newQuantity"
        ((recordsChanged++))

        ((count--))
    done

    #set ENV var to category? have to pass it to awk somehow

else

    valid=0
    until [ $valid ]; do

        #insert record into invoice

        recordsChanged+=1

        #run awk to check if missing records

        #valid=$?

    done

fi

echo -e $appendToFile >> $fileName
echo -e "\n$recordsChanged records added to \"$fileName\" invoice"

#This gets a list of categories in the invoice, delimited by ','

# someVar=$(echo $(grep -i "categories" $fileName) | cut -d: -f2) # Produce, Services, Homeware, Toiletries


#This gets a list of numbers of items for each category in the invoice, delimited by ','

# anotherVar=$(echo $(grep -i "items" $fileName) | cut -d: -f2) # 3, 1, 2, 1



