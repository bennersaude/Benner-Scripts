#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Invalid build attempt: missing file."
    exit 1
fi

params=''
filename=''
solutiondir=''

while getopts 'f:p:' flag; do
  case "${flag}" in
    d) solutiondir="${OPTARG}" ;;
    p) params="${OPTARG}" ;;
    f) filename="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

if [[ -z "$filename" ]]; then
	echo "Invalid build attempt: missing file."
	exit 1
fi

if [[ -z "$solutiondir" ]]; then
	pushd "$solutiondir"
fi

filenameWithoutDir=$(basename "$filename")
directory=$(dirname "$filename")

nuget='./.nuget/NuGet.exe'
msbuild_old='/c/Program Files (x86)/MSBuild/14.0/Bin/MSBuild.exe'
msbuild='/c/Program Files (x86)/Microsoft Visual Studio/2017/Professional/MSBuild/15.0/Bin/MSBuild.exe'

if [[ -z "$solutiondir" ]]; then
	$nuget restore "$filename"
else
	"$directory/.nuget/Nuget.exe" restore "$filename"
fi

"$msbuild" $filename $params //v:minimal //m
ECODE="$(echo $?)"

if [[ -z "$solutiondir" ]]; then
	popd
fi

echo "Build from: $PWD"
echo "Build command: $msbuild $filename $params //v:minimal //m"

echo "Build finished with exit code $ECODE"

exit "$ECODE"
