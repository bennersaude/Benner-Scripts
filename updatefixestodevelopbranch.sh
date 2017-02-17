#!/bin/bash

branchPrefix="remotes/origin/"
RELEASE_BRANCH=$(git branch -a | grep origin/release)
RELEASE_BRANCH=${RELEASE_BRANCH//$branchPrefix/}
RELEASE_BRANCH=$(echo "$RELEASE_BRANCH" | xargs)

CONFIGURATION="Loc.SqlS.Release"
CONECTA_DIR="/e/Compart/Conecta/Conecta"
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

if [[ "$RELEASE_BRANCH" == *$'\n'* ]]; then
    echo "Multiple release branches found"
    exit 1
fi

function exitIfLastHasError() {
    if [[ $? -ne 0 ]]; then
        iexit "$1"
    fi
}

function iexit() {
    echo "Exit with code $1"
    echo "Re-run passing $1 to continue..."
    popd
    exit $1
}

function buildInternal() {
    build.sh -f "Conecta-coverage.sln" -p "//p:Configuration=$CONFIGURATION //p:OutputPath=bin\\$CONFIGURATION"
    exitIfLastHasError "$1"
}

function runTestsInternal() {
    runtestsfromconecta.sh -d "." -c "$CONFIGURATION"
    exitIfLastHasError "$1"
}

function updateRelease() {
    git checkout $RELEASE_BRANCH
    git reset --hard origin/$RELEASE_BRANCH
    git pull origin master
    exitIfLastHasError "$1"
}

function updateDevelop() {
    git checkout develop
    git reset --hard origin/develop
    git pull origin $RELEASE_BRANCH
    exitIfLastHasError "$1"
}

function start() {
    pushd "$CONECTA_DIR"
    git fetch

    if [[ $nextStep -le 1 ]]; then
        updateRelease 1
    fi

    if [[ $nextStep -le 2 ]]; then
        git checkout $RELEASE_BRANCH
        buildInternal 2
    fi

    if [[ $nextStep -le 3 ]]; then
        git checkout $RELEASE_BRANCH
        runTestsInternal 3
    fi

    if [[ $nextStep -le 4 ]]; then
        git checkout $RELEASE_BRANCH
        git push origin $RELEASE_BRANCH --no-verify
    fi

    if [[ $nextStep -le 5 ]]; then
        updateDevelop 5
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

    popd
}

start