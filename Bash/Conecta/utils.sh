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

function getReleaseBranch() {
	local branchPrefix="remotes/origin/"
	local RELEASE_BRANCH

    if [[ -z "$1" ]]; then
        RELEASE_BRANCH=$(git branch -a | grep origin/release)
        if [[ "$RELEASE_BRANCH" == *$'\n'* ]]; then
            echo "Multiple release branches found"
            exit 1
        fi

        RELEASE_BRANCH=${RELEASE_BRANCH//$branchPrefix/}
        RELEASE_BRANCH=$(echo "$RELEASE_BRANCH" | xargs)
    else
    	RELEASE_BRANCH="$1"
    fi

    echo "$RELEASE_BRANCH"
}

function convertPathToWindows() {
    if [[ -z "$1" ]]; then
        echoerr "No path found at '$FUNCNAME' function"
        exit 1
    fi

    echo "$1" | sed -r 's/^\/(\w)/\1:/' | sed -r 's/\//\\/g' | sed -r 's/\\$//'
}

function echoerr() { echo "$@" 1>&2; }
