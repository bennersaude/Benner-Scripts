#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

while getopts 'd:f:c:p:' flag; do
  case "${flag}" in
    d) solutiondir="${OPTARG}" ;;
    c) CONFIGURATION="${OPTARG}" ;;
    f) filename="${OPTARG}" ;;
    p) publishPath="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

if [[ -z "$solutiondir" ]]; then
	echo "Missing solutiondir. Try again passing -d \"\$PATH\""
	exit 1
fi
if [[ -z "$CONFIGURATION" ]]; then
	CONFIGURATION="$DEFAULT_PUBLISH_CONFIGURATION"
fi
if [[ -z "$publishPath" ]]; then
	publishPath="$DEFAULT_PUBLISH_PATH"
fi

pushd "$solutiondir"
windowsSolutionPath=$(convertPathToWindows "$solutiondir")
build.sh -d "$solutiondir" -f "$filename" -p "//p:Configuration=$CONFIGURATION //p:OutputPath=obj\\$CONFIGURATION //t:WebPublish //p:WebPublishMethod=FileSystem //p:DeleteExistingFiles=True //p:publishUrl=$publishPath //p:SolutionDir=$windowsSolutionPath\\"
popd
