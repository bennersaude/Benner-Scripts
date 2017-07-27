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
    echo "Utilizando a branch de release: $RELEASE_BRANCH"

    RELEASE_NUMBER=$(echo $RELEASE_BRANCH | grep -oP "\d+$")
    RELEASE_NUMBER=$((RELEASE_NUMBER+1))
    echo "Número da release encontrada: $RELEASE_NUMBER"
}

function buildInternal() {
    #find -type d -iname "obj" | xargs rm -rf && find -type d -iname "bin" | xargs rm -rf
    pushd Benner.Conecta.Portal
    echo 0 | ./Prebuild.sh
    popd
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

    echo "Atualizando referências do repositório do Conecta"
    git fetch --prune

    echo "Obtendo branch de release"
    setReleaseBranch

    if [[ $nextStep -le 1 ]]; then
        echo "Atualizando branch master com $RELEASE_BRANCH"
        updateMaster 1
    fi

    if [[ $nextStep -le 2 ]]; then
        echo "Atualizando branch develop com $RELEASE_BRANCH"
        updateDevelop 2
    fi

    if [[ $nextStep -le 3 ]]; then
        echo "Building branch master"
        git checkout master
        buildInternal 3
    fi
    if [[ $nextStep -le 4 ]]; then
        echo "Rodando testes na branch master"
        git checkout master
        runTestsInternal 4
    fi
    if [[ $nextStep -le 5 ]]; then
        echo "Atualizando master remota (git push)"
        git push origin master --no-verify
    fi

    if [[ $nextStep -le 6 ]]; then
        echo "Building branch develop"
        git checkout develop
        buildInternal 6
    fi
    if [[ $nextStep -le 7 ]]; then
        echo "Rodando testes na branch develop"
        git checkout develop
        runTestsInternal 7
    fi
    if [[ $nextStep -le 8 ]]; then
        echo "Atualizando develop remota (git push)"
        git checkout develop
        git push origin develop --no-verify
    fi
    if [[ $nextStep -le 9 ]]; then
        echo "Criando nova branch de release"
        createNewReleaseBranch
    fi

    popd
}

start