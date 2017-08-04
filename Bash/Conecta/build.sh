#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

if [[ -z "$1" ]]; then
    echo "Invalid build attempt: missing file."
    exit 1
fi

params=''
filename=''
solutiondir=''

while getopts 'd:f:p:' flag; do
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

if [[ -n "$solutiondir" ]]; then
	pushd "$solutiondir"
fi

filenameWithoutDir=$(basename "$filename")
directory=$(dirname "$filename")

if [[ -z "$solutiondir" ]]; then
	$nuget restore "$filename"
else
	"$directory/.nuget/Nuget.exe" restore "$filename"
fi

"$MSBUILD" $filename $params
ECODE="$(echo $?)"

if [[ -n "$solutiondir" ]]; then
	popd
fi

echo "Build from: $PWD"
echo "Build command: $MSBUILD $filename $params"

echo "Build finished with exit code $ECODE"

exit "$ECODE"
