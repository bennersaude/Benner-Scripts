#!/bin/bash

function convertToWindowsPath() {
    echo "/$1" | sed -e 's/\\/\//g' -e 's/://' -e 's/\/\/\//\/\//g'
}

text="\"registroAnsOperadora\":\s*\"$1\""
dirOrigem=$(convertToWindowsPath "$2")
zipDestino=$(convertToWindowsPath "$3")

find "$dirOrigem" -iname "*$1*.json" -print0 | 
    while IFS= read -r -d $'\0' filename; do
        grep -q "$text" "$filename" && echo "$filename";
    done |
    zip -1 -r -j -m "$zipDestino" -@

