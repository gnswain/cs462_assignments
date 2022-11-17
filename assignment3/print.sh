#! /bin/bash

#Isaiah Hermance && Graham Swain
#Project 3: Shell scripts used to insert records into invoice and print invoice as a table
#16 November 2022


if [[ $# == 2 ]]; then
    fileName=$1
    if ! [[ $2 == '-c' ]]; then
        echo 'invalid flag, usage: print.sh <invoice filename> [-c]'
        exit 2
    fi
    sortbyCategory=0 #0 in place of true. Will sort by category
elif [[ $# == 1 ]]; then
    fileName=$1
    sortbyCategory=1 #1 in place of false. Will sort by total cost
else
    echo 'usage: print.sh <invoice filename> [-c]'
    exit 1
fi

if ! [[ -f $fileName ]]; then
    echo "ERROR: file \"$fileName\" does not exist"
    exit 3
elif [[ -d "$1" ]]; then
    echo "ERROR: $1 is a directory"
    exit 4
else
    if ! [[ -r "$1" ]]; then
        echo "ERROR: $1 does not have read permission"
        exit 5
    fi
fi

# TODO: probably should check if it's a valid invoice
#if ! [[ $(bash valid $fileName) ]]; then #Assumes valid is in working directory
#    echo "\"$fileName\" is not a valid invoice"
#    exit 7
#fi

#initialize the building of the latex file#\\usepackage{multicolumn}\n

tableFile="\\documentclass[11pt]{article}\n\\\begin{document}\n\\\begin{table}[ht]\n\\\begin{center}\n\\\begin{tabular}{|r r r r r|}\n\\hline\n\\multicolumn{5}{|c|}{"

customerName=$(awk -F[:] '/^customer/ {print $2}' $fileName)
customerAddress=$(awk -F[:] '/^address/ {print $2}' $fileName)

customerName=$(echo $customerName | tr -s " ")
customerAddress=$(echo $customerAddress | tr -s " ")

tableFile+="$customerName}\\\\\ \n\\multicolumn{5}{|c|}{$customerAddress}\\\\\ \n\\hline\nCategory&Item&Cost&Quantity&Total\\\\\ \n\\hline\n\\hline\n"

#insert invoice data

startOfInvoiceData=$(grep -n '[iI]tems' $fileName | cut -d: -f1) # line of the file at which the invoice data starts
((startOfInvoiceData += 2))
tail -n +$startOfInvoiceData $fileName > tmp1.txt #creates temp file with invoice data to sort and read from
echo ' ' >> tmp1.txt

while read -r currLine; do

    currTotal=$(echo $currLine | awk -F, '{total = $2 * $3; print total}')

    currLine+=", $currTotal"

    echo -e $currLine >> tmp2.txt

done < tmp1.txt

if [[ $sortbyCategory == 1 ]]; then
    sort tmp2.txt > tmp3.txt
else
    sort -n -t, -k4 tmp2.txt > tmp3.txt
fi

while IFS=, read -r categoryAndItem cost quantity total; do

    category=$(echo $categoryAndItem | cut -d: -f1)
    item=$(echo $categoryAndItem | cut -d: -f2)

    tableFile+="$category&$item&$cost&$quantity&$total\\\\\ \n"

done < tmp3.txt

tableFile+="\\hline\\\end{tabular}\n\\\end{center}\n\\\end{table}\n\\\end{document}"

fileName=$(echo $fileName | cut -d. -f1)

echo -e $tableFile > tmp.tex

pdflatex -interaction=batchmode tmp.tex > /dev/null 

#okular tmp.pdf

#rm tmp*.*