#!/bin/bash

IISEXPRESS=/c/Program\ Files/IIS\ Express/iisexpress.exe

killiisexpress.sh

pushd /c/workspace/Conecta
build.sh -f Benner.Conecta.Portal/Benner.Conecta.Portal.csproj -p "//p:SolutionDir=C:\workspace\Conecta\\"
start bash -c "cd /c/workspace/Conecta; \"$IISEXPRESS\" \"//site:Benner.Conecta.Portal-Site\" \"//config:.vs\config\applicationhost.config\""
popd