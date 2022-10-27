#!/bin/bash

#Isaiah Hermance && Graham Swain
#Project 2: Shell scripts used to set up and verify the formatting of simple text invoice files.
#28  October 2022


#assigns command line arguments to variables and asks for input if none are provided.
if [ $# -eq 2 ]; then 
    flag=$1
    fileName=$2
elif [ $# -eq 0 ]; then
    while [ ${#fileName} -eq 0 ]; do
        echo -e "Please provide a flag AND filename:\n<-i|-o> <filename>"
        read flag fileName
    done
else
    echo 'usage: create.sh -i|-o filename'
    exit 1 #Invalid syntax
fi

#assigns the proper file extension given the flag argument or exists if flag is invalid
if [[ $flag == "-o" ]]; then
    fileExt='.oso'
elif [[ $flag == "-i" ]]; then
    fileExt='.iso'
else
    echo 'invalid flag. usage: create.sh -i|-o filename'
    exit 1
fi

newFileName=$fileName$fileExt

if [[ -f $newFileName ]]; then #checks to see if file exists
    echo 'File already exists'
    exit 2 #File to create already exists
fi

itemsInPurchase=""
echo -n "Please enter customer name > "
read name
echo -n "Please enter street address > "
read address
echo -n "Please enter city > "
read city
address+=", $city" #adds city to address with formatting
if [[ $flag == "-o" ]]; then #only need state in address if customer is out of state
    echo -n "please enter state > "
    read state
    if [ ${#state} -gt 2 ]; then 
        echo "Invalid state abbreviation. Please use a maximum of 2 characters."
        exit 3 #Invalid state abbreviation
    fi
    if [[ $state =~ [Nn][Cc] ]]; then
        echo 'Please use flag "-i" for in-state invoices'
        exit 4 #User tried to use oso for in state invoice
    fi
else
    state="NC"
fi
address+=", $state" #adds state to address with formatting
echo -n "Please enter the fields that comprise the order > "
read fields
for i in $fields; do
    echo -n "Please enter the number of "$i" items you want to purchase > "
    read numOfItems
    itemsInPurchase+="$numOfItems " #adds num of items of each category 
                                            #to a running list "string" in itemsInPurchase
done


#create file

fields=$(echo $fields | awk '{$1=$1;print}' | tr -s " " ",")

itemsInPurchase=$(echo $itemsInPurchase | awk '{$1=$1;print}' | tr -s " " ",")

newFile="customer:$name\n\nadress:$address\n\ncategories:$fields\n\nitems:$itemsInPurchase"

echo -e $newFile > $newFileName


#call valid
echo -e "calling valid with $newFileName\n"

bash valid.sh $newFileName

echo -e "\"$newFileName\" has been created for \ncustomer:$name\naddress:$address"