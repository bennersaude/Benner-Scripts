#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Invalid build attempt: missing file."
    exit 1
fi

params=''
filename=''

while getopts 'f:p:' flag; do
  case "${flag}" in
    p) params="${OPTARG}" ;;
    f) filename="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

if [[ -z "$filename" ]]; then
	echo "Invalid build attempt: missing file."
	exit 1
fi

filenameWithoutDir=$(basename "$filename")
directory=$(dirname "$filename")

nuget='./.nuget/NuGet.exe'
msbuild='/c/Program Files (x86)/MSBuild/14.0/Bin/MSBuild.exe'

pushd $directory
$nuget restore $filenameWithoutDir
"$msbuild" $filenameWithoutDir $params //v:minimal //m
ECODE="$(echo $?)"
popd

echo "Build from: $(pwd)"
echo "Build command: $msbuild $filename $params //v:minimal //m"

echo "Build finished with exit code $ECODE"

exit "$ECODE"
