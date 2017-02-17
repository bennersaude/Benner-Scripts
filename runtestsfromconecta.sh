#!/bin/bash

verbose="0"
CONFIGURATION="Debug"
CONECTA_DIR="/c/workspace/Conecta"

while getopts 'c:d:v' flag; do
  case "${flag}" in
    c) CONFIGURATION="${OPTARG}" ;;
    d) CONECTA_DIR="${OPTARG}" ;;
    v) verbose="1" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

pushd "$CONECTA_DIR"
DLLS="Benner.Conecta.Models.Tests/bin/$CONFIGURATION/Benner.Conecta.Models.Tests.dll"
DLLS="$DLLS Benner.Conecta.Portal.Business.Tests/bin/$CONFIGURATION/Benner.Conecta.Portal.Business.Tests.dll"
DLLS="$DLLS Benner.Conecta.Portal.Tests/bin/$CONFIGURATION/Benner.Conecta.Portal.Tests.dll"
DLLS="$DLLS Benner.Conecta.Proxy.Tests/bin/$CONFIGURATION/Benner.Conecta.Proxy.Tests.dll"
DLLS="$DLLS Benner.Conecta.Portal.ViewModels.Tests/bin/$CONFIGURATION/Benner.Conecta.Portal.ViewModels.Tests.dll"
DLLS="$DLLS Benner.Conecta.Tests.Helper.Tests/bin/$CONFIGURATION/Benner.Conecta.Tests.Helper.Tests.dll"
DLLS="$DLLS Benner.Conecta.Jobs/Jobs/Benner.Conecta.Jobs.Implementations.Tests/bin/$CONFIGURATION/Benner.Conecta.Jobs.Implementations.Tests.dll"
DLLS="$DLLS Benner.Conecta.Jobs/Benner.Conecta.Jobs.Server.Tests/bin/$CONFIGURATION/Benner.Conecta.Jobs.Server.Tests.dll"
DLLS="$DLLS Benner.Conecta.RoutingService.Tests/bin/$CONFIGURATION/Benner.Conecta.RoutingService.Tests.dll"

echo "Running tests from dir: $CONECTA_DIR"
echo "Running tests with config: $CONFIGURATION"

if [[ $verbose -eq "1" ]]; then
	echo "$DLLS"
fi

runtestsfrom.sh "$DLLS"
popd