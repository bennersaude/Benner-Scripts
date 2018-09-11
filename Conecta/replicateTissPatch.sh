#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

fromTISS="V321"
toTISS="V331"

# Remove all patches
find . -iname '*.patch' | xargs rm -f
# Remove previous failures
find . -iname '*.rej' | xargs rm -f

# Patch generation
git status --porcelain *"$fromTISS"*.cs | sed s/^...// | xargs -I {} sh -c "git diff -- '{}' > '{}.patch'"
patchedFiles=($(find . -iname '*.patch'))

# Patch replication
for i in "${patchedFiles[@]}"
do
    # Replace parts of the path
    fileToPatch=$(echo "$i" | sed s/$fromTISS/$toTISS/)
    # Remove .patch from baseName
    fileToPatch="${fileToPatch%.*}"
    # Output intention
    echo "$i > $fileToPatch"
    # Execute patching
    patch -p1 "$fileToPatch" "$i"
    # Remove patch file
    rm -f "$i"
done

