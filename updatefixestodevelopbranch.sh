#!/bin/bash

branchPrefix="remotes/origin/"
RELEASE_BRANCH=""

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


function setReleaseBranch() {
    if [[ -z "$RELEASE_BRANCH" ]]; then
        RELEASE_BRANCH=$(git branch -a | grep origin/release)
        if [[ "$RELEASE_BRANCH" == *$'\n'* ]]; then
            echo "Multiple release branches found"
            exit 1
        fi

        RELEASE_BRANCH=${RELEASE_BRANCH//$branchPrefix/}
        RELEASE_BRANCH=$(echo "$RELEASE_BRANCH" | xargs)
    fi
}

function exitIfLastHasError() {
    if [[ $? -ne 0 ]]; then
        iexit "$1"
    fi
}

function iexit() {
    echo "Exit with code $1"
    echo "Re-run passing $1 to continue..."
    exit $1
}

function updateBranch() {
    git checkout "$2"
    git reset --hard origin/"$2"
    exitIfLastHasError "$1"
}

function deleteBranchRemote() {
    git push origin :"$1"
}

function updateCurrentBranchWith() {
    git pull origin "$2"
    exitIfLastHasError "$1"
    deleteBranchRemote $(git rev-parse --abbrev-ref HEAD)
    git push -u origin $(git rev-parse --abbrev-ref HEAD)
}

function createUpdateBranch() {
    git branch -D "$2-updated" || :
    git checkout -b "$2-updated"
    exitIfLastHasError "$1"
}

function start() {
    pushd "$CONECTA_DIR"
    git fetch --prune
    
    setReleaseBranch


    if [[ $nextStep -le 1 ]]; then
        updateBranch 1 $RELEASE_BRANCH
    fi

    if [[ $nextStep -le 2 ]]; then
        createUpdateBranch 2 $RELEASE_BRANCH
    fi

    if [[ $nextStep -le 3 ]]; then
        updateCurrentBranchWith 3 "master"
        git pr
    fi

    if [[ $nextStep -le 4 ]]; then
        read -p "Release precisa ser atualizada (s/n)? " answer
        case ${answer:0:1} in
            y|Y|s|S )
                iexit 4
            ;;
            * )
                deleteBranchRemote "$RELEASE_BRANCH-updated"
                echo "Continuando..."
            ;;
        esac

        updateBranch 4 "develop"
    fi

    if [[ $nextStep -le 5 ]]; then
        createUpdateBranch 5 "develop"
    fi

    if [[ $nextStep -le 6 ]]; then
        updateCurrentBranchWith 6 $RELEASE_BRANCH
        git pr
    fi

    popd
}

start