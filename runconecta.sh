#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

pushd "$CONECTA_DIR"
windowsSolutionPath=$(convertPathToWindows "$CONECTA_DIR")
build.sh -f Benner.Conecta.Portal/Benner.Conecta.Portal.csproj -p "//p:SolutionDir=$windowsSolutionPath\\"
exitIfLastHasError 1

#iiskill.sh

#portNumber=$(cat .vs/config/applicationhost.config | grep -Pzo "(?s)$SITE_NAME.*?bindingInformation=\"\*:\d+" | grep -Pzo "\d+$")
#netstat -aon | grep -P "$portNumber" | grep -Po "\d+$" | xargs -I{} taskkill //F //PID {}

WMIC path win32_process get Caption,Processid,Commandline | grep -P "iisexpress.exe.*?/site:\"{0,1}$SITE_NAME" | grep -Po "\d+\s*$" | xargs -I{} taskkill //F //PID {}

start bash -c "cd $CONECTA_DIR; \"$IISEXPRESS\" \"//site:$SITE_NAME\" \"//config:.vs\config\applicationhost.config\""
popd
