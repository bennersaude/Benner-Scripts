#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

fromTISS="V321"
toTISS="V331"

filesToPatch=($(git status --porcelain *"$fromTISS"*.cs | sed s/^...//))

# Patch replication
for i in "${filesToPatch[@]}"
do
    # Replace parts of the path
    fileToPatch=$(echo "$i" | sed s/$fromTISS/$toTISS/)
    echo "$i > $fileToPatch"
    code --diff "$i" "$fileToPatch"
done

