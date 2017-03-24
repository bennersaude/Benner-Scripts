CONECTA_DIR='/c/workspace/Conecta'
INFRA_DIR='/c/workspace/Benner.Infra'
ALTERNATIVE_CONECTA_DIR='/e/Compart/Conecta/Conecta'
MSBUILD='C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe'
MSBUILD15='C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe'
IISEXPRESS='C:\Program Files\IIS Express\iisexpress.exe'
NUGET_RESTORE='./.nuget/NuGet.exe restore'
RELEASE_BRANCH='release/Sprint29'

alias nuget='./.nuget/NuGet.exe'
alias msbuild='/c/Program\ Files\ \(x86\)/MSBuild/14.0/Bin/MSBuild.exe'
alias msbuild15='/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2017/Professional/MSBuild/15.0/Bin/MSBuild.exe'

function startiisexpress() {
	cmd <<< "\"$IISEXPRESS\" /site:Benner.Conecta.Portal-Site /config:.vs\\config\\applicationhost.config"
}

alias gti=git
alias bconecta='cd $CONECTA_DIR'
alias binfra='cd $INFRA_DIR'
alias gbpurge='git branch --merged | grep -Ev "(\*|master|develop|staging)" | xargs -n 1 git branch -d'

alias copyinfrapackages='cd $CONECTA_DIR && currentinfraversion | ./CopyLocalInfraToPackages.bat && cd -'
alias sonarconecta='pushd $CONECTA_DIR && cd Tools && cmd <<< RunSonar.bat && popd'
alias currentinfraversion='cat $CONECTA_DIR/Benner.Conecta.Portal/packages.config | grep -oP "Benner.Infra\"\s*version=\"[^\"]+\"" | grep -oP "[0-9][^\"]+"'

alias publishjobsrelease='publish.sh -d "$CONECTA_DIR" -f "Benner.Conecta.Jobs/Web/Benner.Conecta.Jobs.WebApplication.csproj" -c "Release" -p "C:\inetpub\wwwroot\Jobs"'
alias publishconectarelease='publish.sh -d "$CONECTA_DIR" -f "Benner.Conecta.Portal/Benner.Conecta.Portal.csproj" -c "Loc.SqlS.Release"'
alias publishconectadebug='publish.sh -d "$CONECTA_DIR" -f "Benner.Conecta.Portal/Benner.Conecta.Portal.csproj" -c "Loc.SqlS.Debug"'
alias publishconectatesterelease='publish.sh -d "$CONECTA_DIR" -f "Benner.Conecta.Portal/Benner.Conecta.Portal.csproj" -c "LocTst.SqlS.Release" -p "C:\inetpub\wwwroot\ConectaTeste"'
alias publishconectatestedebug='publish.sh -d "$CONECTA_DIR" -f "Benner.Conecta.Portal/Benner.Conecta.Portal.csproj" -c "LocTst.SqlS.Debug" -p "C:\inetpub\wwwroot\ConectaTeste"'

alias updateconectatestsfolder='pushd $CONECTA_DIR && cmd <<< "\"$MSBUILD\" Conecta-coverage.sln /t:Build /p:Configuration=Loc.SqlS.Debug /p:OutputPath=C:\ConectaDllsForTests" && cd /c/ConectaDllsForTests && sed -i '\''s/add name="BennerConecta" connectionString="Data Source=(local);Initial Catalog=conecta/add name="BennerConecta" connectionString="Data Source=(local);Initial Catalog=conectaintegrationtest/g'\'' Benner.Conecta.IntegrationTest.dll.config && popd'

alias buildinfradebug='build.sh -d "$INFRA_DIR" -f Benner.Infra.sln -p "//p:Configuration=Debug"'
alias buildconectadebug='build.sh -d "$CONECTA_DIR" -f "Conecta-coverage.sln" -p "//p:Configuration=Loc.SqlS.Debug"'
alias buildconectarelease='build.sh -d "$CONECTA_DIR" -f "Conecta-coverage.sln" -p "//p:Configuration=Loc.SqlS.Release"'
