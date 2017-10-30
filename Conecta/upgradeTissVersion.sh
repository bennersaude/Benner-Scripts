#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

# TODO - Add command line params
# Configs section
fromTISS="30201"
toTISS="30200"
# End Configs section

# Generate Compact Versions
fromTISSCompact=${fromTISS:0:1}${fromTISS:2:1}${fromTISS:4:1}
toTISSCompact=${toTISS:0:1}${toTISS:2:1}${toTISS:4:1}

# Generate Options Array
fromTISSOptions=()
toTISSOptions=()

fromTISSOptions+=("$fromTISS")
toTISSOptions+=("$toTISS")

fromTISSOptions+=("V$fromTISSCompact")
toTISSOptions+=("V$toTISSCompact")

fromTISSOptions+=("Tiss$fromTISSCompact")
toTISSOptions+=("Tiss$toTISSCompact")

function replicateFolders() {
    for (( option = 0; option < ${#fromTISSOptions[@]}; option++ )); do
        echo "$option: ${fromTISSOptions[$option]}"

        allFoldersFromTISS=()
        while IFS=  read -r -d $'\0'; do
            allFoldersFromTISS+=("$REPLY")
        done < <(find . -iname *${fromTISSOptions[$option]}* -not -path '**/obj/**' -not -path '**/bin/**' -not -path '**/.git/**' -print0)

        for tissFolder in "${allFoldersFromTISS[@]}"; do
            newFolder=$(echo "$tissFolder" | sed -e "s/${fromTISSOptions[$option]}/${toTISSOptions[$option]}/g")
            cp -r "$tissFolder" "$newFolder"
            echo "$tissFolder - $newFolder"
        done
    done
}

function updateAllGeneratedCsFiles() {
    for (( option = 0; option < ${#toTISSOptions[@]}; option++ )); do
        allFoldersToTISS=()
        while IFS=  read -r -d $'\0'; do
            allFoldersToTISS+=("$REPLY")
        done < <(find . -iname *${toTISSOptions[$option]}* -not -path '**/obj/**' -not -path '**/bin/**' -not -path '**/.git/**' -print0)

        for tissFolder in "${allFoldersToTISS[@]}"; do
            echo "$tissFolder"
            
            allFilesFromFolder=()
            while IFS=  read -r -d $'\0'; do
                allFilesFromFolder+=("$REPLY")
            done < <(find "$tissFolder" -iname '*.cs' -print0)
            
            for f in "${allFilesFromFolder[@]}"; do
                for (( sedOpt = 0; sedOpt < ${#fromTISSOptions[@]}; sedOpt++ )); do
                    sed -i "s/${fromTISSOptions[$sedOpt]}/${toTISSOptions[$sedOpt]}/g" "$f"
                done
            done
        done
    done
}

function updateAllCsprojs() {
    allCsProjs=()
    while IFS=  read -r -d $'\0'; do
        allCsProjs+=("$REPLY")
    done < <(find . -iname '*.csproj' -not -path '**/obj/**' -not -path '**/bin/**' -not -path '**/.git/**' -print0)
    
    for i in "${allCsProjs[@]}"; do
        for (( option = 0; option < ${#toTISSOptions[@]}; option++ )); do
            powershell upgradeTissIncludesCsproj.ps1 -csproj "$i" -fromTISS "${fromTISSOptions[$option]}" -toTISS "${toTISSOptions[$option]}"
        done
    done
}

replicateFolders
updateAllGeneratedCsFiles
updateAllCsprojs
