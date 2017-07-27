#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

# options array format: ["OptionName"]="ConectaDir;CsprojLocation;PublishPath;ReleaseConfig;DebugConfig"
declare -A options
options=(
    ["Api"]="$CONECTA_DIR;$API_CSPROJ;$DEFAULT_API_PUBLISH_PATH"
    ["Route"]="$CONECTA_DIR;$ROUTING_CSPROJ;$DEFAULT_ROUTE_PUBLISH_PATH"
    ["Conecta"]="$CONECTA_DIR;$CONECTA_PORTAL_CSPROJ;$DEFAULT_CONECTA_PORTAL_PUBLISH_PATH"
    ["Jobs"]="$CONECTA_DIR;$JOBS_CSPROJ;$DEFAULT_JOBS_PUBLISH_PATH"
)

while getopts 'tdc:p:' flag; do
  case "${flag}" in
    d) DEBUG=true ;;
    t) TEST_ONLY=true ;;
    c) configuration="${OPTARG}" ;;
    p) publishPath="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

function publishChoosenOne() {
    optionSplitted=(${1//;/ })

    path="${optionSplitted[0]}"
    csproj="${optionSplitted[1]}"

    if [[ -z "$publishPath" ]]; then
        publishPath="${optionSplitted[2]}"
    fi
    if [[ -z "$configuration" ]]; then
        if [[ "$DEBUG" = true ]]; then
            configuration="${optionSplitted[4]:-$DEFAULT_DEBUG_CONFIGURATION}"
        else
            configuration="${optionSplitted[3]:-$DEFAULT_RELEASE_CONFIGURATION}"
        fi
    fi

    echo publish.sh -d "$path" -f "$csproj" -c "$configuration" -p "$publishPath"
    if ! [[ "$TEST_ONLY" = true ]]; then
        publish.sh -d "$path" -f "$csproj" -c "$configuration" -p "$publishPath"
    fi
}

function invalidOption() {
    echo "error: Opção inválida" >&2; exit 1
}

echo "O que gostaria de publicar?"
cnt=0
CHOICES=()
for option in "${!options[@]}"; do
    ((cnt++))
    CHOICES+=($option)

    echo $cnt") " $option
done

read -p "Escolha: " -n 1 -r
echo

re='^[0-9]+$'
if ! [[ $REPLY =~ $re ]]; then
   invalidOption
fi

optionMap=${CHOICES[($REPLY-1)]}

isset=${options[$optionMap]+isset}
if ! [ $isset ]; then
   invalidOption
fi

option=${options[$optionMap]}
publishChoosenOne $option

exit 1
