#! /bin/bash

# Isaiah Hermance && Graham Swain
# 16 November 2022

# $1 - fileName
# $2 - category
# $3 - item

echo "!!!!!!!!!!!!!!!"

appendToFile=""

count=$(awk -F: "BEGIN { count = 0; IGNORECASE = 1;} /^$2/ { count++ } END {print count}" $1)

count=$(($3 - $count)) # gets how many more items we need

while [[ $count > 0 ]]; do
    echo -n "Please enter the name of a $2 item > "
    read newItem
    echo -n "Please enter a price per unit of $newItem > "
    read newPrice
    echo -n "Please enter the amount of $newItem units to purchase > "
    read newQuantity

    appendToFile="${appendToFile}\n$2: $newItem, $newPrice, $newQuantity"
    ((recordsChanged++))

    ((count--))
done

echo -e $appendToFile