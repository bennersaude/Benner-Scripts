source "configs.sh"

alias msbuild='"$MSBUILD"'

alias gti=git
alias gbpurge='git branch --merged | grep -Ev "(\*|master|develop|staging)" | xargs -n 1 git branch -d'
alias gbpurgeextended='git branch -vv | grep -P "\[origin.*?: gone\]" | grep -oP "^\s*(hotfix|SMS)[^\s]+" | xargs -n 1 git branch -D'

alias bconecta='cd $CONECTA_DIR'
alias binfra='cd $INFRA_DIR'
alias ordenacaocsproj='powershell -NoProfile -ExecutionPolicy Bypass -File ".git\hooks\AutoFix-VisualStudioFiles.ps1"'
alias copyinfrapackages='cd $CONECTA_DIR && currentinfraversion | ./CopyLocalInfraToPackages.bat && cd -'
alias sonarconecta='pushd $CONECTA_DIR && cd Tools && cmd <<< RunSonar.bat && popd'
alias generatehtmltemplates='pushd $CONECTA_DIR && cd Benner.Conecta.Portal/assets/global/template && python convert-HtmlAngular.py && popd'
alias currentinfraversion='cat $CONECTA_DIR/Benner.Conecta.Portal/packages.config | grep -oP "Benner.Infra\"\s*version=\"[^\"]+\"" | grep -oP "[0-9][^\"]+"'

alias publishjobsrelease='echo 1 | publishhelper.sh'
alias publishjobstesterelease='echo 1 | publishhelper.sh && cd /c/inetpub/wwwroot/Jobs && sed -i '\''s/=conecta;/=conectateste;/g'\'' Web.config && sed -i '\''s/http:\/\/localhost:50659\/Conecta/http:\/\/localhost\/ConectaTeste/g'\'' Web.config && sed -i '\''s/=\"local\"/=\"loctest\"/g'\'' Web.config && cd -'
alias publishconectarelease='echo 2 | publishhelper.sh'
alias publishconectadebug='echo 2 | publishhelper.sh -d'
alias publishconectatesterelease='echo 2 | publishhelper.sh -c "LocTst.SqlS.Release" -p "C:\inetpub\wwwroot\ConectaTeste"'
alias publishconectatestedebug='echo 2 | publishhelper.sh -d -c "LocTst.SqlS.Debug" -p "C:\inetpub\wwwroot\ConectaTeste"'
alias publishapirelease='echo 4 | publishhelper.sh'
alias publishrouterelease='echo 3 | publishhelper.sh'

alias updateconectatestsfolder='pushd $CONECTA_DIR && cmd <<< "\"$MSBUILD\" Conecta-coverage.sln /t:Build /p:Configuration=Loc.SqlS.Debug /p:OutputPath=C:\ConectaDllsForTests" && cd /c/ConectaDllsForTests && sed -i '\''s/add name="BennerConecta" connectionString="Data Source=(local);Initial Catalog=conecta/add name="BennerConecta" connectionString="Data Source=(local);Initial Catalog=conectaintegrationtest/g'\'' Benner.Conecta.IntegrationTest.dll.config && popd'

alias buildinfradebug='build.sh -d "$INFRA_DIR" -f Benner.Infra.sln -p "$MSBUILD_COMMON_PARAMS //p:Configuration=Debug"'
alias buildconectadebug='build.sh -d "$CONECTA_DIR" -f "Conecta-coverage.sln" -p "$MSBUILD_COMMON_PARAMS //p:Configuration=Loc.SqlS.Debug"'
alias buildconectarelease='build.sh -d "$CONECTA_DIR" -f "Conecta-coverage.sln" -p "$MSBUILD_COMMON_PARAMS //p:Configuration=Loc.SqlS.Release"'

alias sassconecta='pushd $CONECTA_DIR && cd Benner.Conecta.Portal && ./node_modules/.bin/gulp sass && popd'

alias dockergc='docker rmi $(docker images -f "dangling=true" -q)'
alias dockerrmall='docker rm -f $(docker ps -a -q)'
