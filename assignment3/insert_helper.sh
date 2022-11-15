#! /bin/bash

# Isaiah Hermance && Graham Swain
# 16 November 2022

appendToFile=""

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
