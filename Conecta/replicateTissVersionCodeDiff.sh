#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

# V321 V331 V332
fromTISS="$1"

# Generate Compact Versions
fromTISSCompact=${fromTISS:0:1}${fromTISS:2:1}${fromTISS:4:1}

# Generate Options Array
fromTISSOptions=()

fromTISSOptions+=("$fromTISS")

fromTISSOptions+=("V$fromTISSCompact")

fromTISSOptions+=("Tiss$fromTISSCompact")

function replicate() {
    filesToPatch=($(git status --porcelain *"$fromTISS"*.cs | sed s/^...//))

    # Patch replication
    for i in "${filesToPatch[@]}"
    do
        # Replace parts of the path
        fileToPatch=$(echo "$i" | sed s/$fromTISS/$1/)
        echo "$i > $fileToPatch"

        if [ -e "$fileToPatch" ]; then
            /C/Program\ Files/Perforce/p4merge.exe "$i" "$fileToPatch" "$fileToPatch" "$fileToPatch"
            #code --diff "$i" "$fileToPatch"
        else
            targetDir="$(dirname $fileToPatch/)"
            mkdir -p "$targetDir"
            cp "$i" "$targetDir"
        fi

    done
}

argc=$#
argv=($@)

for i in "${@:2}"; do
    replicate "$i"
done

