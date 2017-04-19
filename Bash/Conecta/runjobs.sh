#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

pushd "$CONECTA_DIR"

# KILL IISEXPRESS
WMIC path win32_process get Caption,Processid,Commandline | grep -P "iisexpress.exe.*?/site:\"{0,1}$SITE_NAME_JOBS" | grep -Po "\d+\s*$" | xargs -I{} taskkill //F //PID {}

# Build Jobs
windowsSolutionPath=$(convertPathToWindows "$CONECTA_DIR")
build.sh -f Benner.Conecta.Jobs/Web/Benner.Conecta.Jobs.WebApplication.csproj -p "//p:SolutionDir=$windowsSolutionPath\\"
exitIfLastHasError 1

# Start IISEXPRESS
start bash -c "cd $CONECTA_DIR; \"$IISEXPRESS\" \"//site:$SITE_NAME_JOBS\" \"//config:.vs\config\applicationhost.config\""

popd
