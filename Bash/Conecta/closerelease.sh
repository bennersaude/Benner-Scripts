#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

branchPrefix="remotes/origin/"
RELEASE_BRANCH=""
RELEASE_NUMBER=""

CONFIGURATION="$DEFAULT_PUBLISH_CONFIGURATION"
CONECTA_DIR="$ALTERNATIVE_CONECTA_DIR"
nextStep="1"

while getopts 'c:d:n:b:' flag; do
  case "${flag}" in
    b) RELEASE_BRANCH="${OPTARG}" ;;
    c) CONFIGURATION="${OPTARG}" ;;
    d) CONECTA_DIR="${OPTARG}" ;;
    n) nextStep="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

function setReleaseBranch() {
    RELEASE_BRANCH="$(getReleaseBranch $RELEASE_BRANCH)" || (echo "$RELEASE_BRANCH" && exit $?)
    echo "Using release branch: $RELEASE_BRANCH"

    RELEASE_NUMBER=$(echo $RELEASE_BRANCH | grep -oP "\d+$")
    RELEASE_NUMBER=$((RELEASE_NUMBER+1))
}

function iexit() {
    echo "Exit with code $1"
    echo "Re-run passing $1 to continue..."
    popd
    exit $1
}

function buildInternal() {
    build.sh -f "Conecta-coverage.sln" -p "//p:Configuration=$CONFIGURATION //p:OutputPath=obj\\$CONFIGURATION"
    exitIfLastHasError "$1"
}

function runTestsInternal() {
    runtestsfromconecta.sh -d "." -c "$CONFIGURATION"
    exitIfLastHasError "$1"
}

function updateMaster() {
    git checkout master
    git reset --hard origin/master
    git tag $(echo master-`date +%Y-%m-%d`)
    git pull origin $RELEASE_BRANCH
    exitIfLastHasError "$1"
    git tag $(echo ${RELEASE_BRANCH#*/})
}

function updateDevelop() {
    git checkout develop
    git reset --hard origin/develop
    git pull origin $RELEASE_BRANCH
    exitIfLastHasError "$1"
}

function createNewReleaseBranch() {
    git checkout develop
    git checkout -b "release/Sprint$RELEASE_NUMBER"
    git push -u
}

function start() {
    pushd "$CONECTA_DIR"
    git fetch --prune

    setReleaseBranch

    if [[ $nextStep -le 1 ]]; then
        updateMaster 1
    fi

    if [[ $nextStep -le 2 ]]; then
        updateDevelop 2
    fi

    if [[ $nextStep -le 3 ]]; then
        git checkout master
        buildInternal 3
    fi
    if [[ $nextStep -le 4 ]]; then
        git checkout master
        runTestsInternal 4
    fi
    if [[ $nextStep -le 5 ]]; then
        git push origin master --no-verify
    fi

    if [[ $nextStep -le 6 ]]; then
        git checkout develop
        buildInternal 6
    fi
    if [[ $nextStep -le 7 ]]; then
        git checkout develop
        runTestsInternal 7
    fi
    if [[ $nextStep -le 8 ]]; then
        git checkout develop
        git push origin develop --no-verify
    fi
    if [[ $nextStep -le 9 ]]; then
        createNewReleaseBranch
    fi

    popd
}

start