#! /bin/bash

#Isaiah Hermance && Graham Swain
#Project 3: Shell scripts used to insert records into invoice and print invoice as a table
#16 November 2022


if [ $# -eq 2 ]; then
    fileName=$1
    categoryName=$2
elif [$# -eq 1 ]; then
    fileName=$1
else
    #usage
    exit 1
fi

if ! [-f $fileName ]; then
    echo no such fileName
    exit 2
fi

recordsChanged=0

if [$# -eq 2 ]; then

    #set ENV var to category? have to pass it to awk somehow

else

    valid=0
    until [ $valid ]; do

        #insert record into invoice

        recordsChanged+=1

        #run awk to cheack if missing records

        #valid=$?

    done

fi

echo "$recordsChanged records added to \"$fileName\" invoice"

#This gets a list of categoires in the invoice, delimited by ','

someVar=$(echo $(grep -i "categories" fileName) | cut -d: -f2)# Produce, Services, Homeware, Toiletries


#This gets a list of numbers of items for each category in the invoice, delimited by ','

anotherVar=$(echo $(grep -i "items" fileName) | cut -d: -f2) # 3, 1, 2, 1



