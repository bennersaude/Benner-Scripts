CONECTA_DIR="/c/workspace/Conecta"
ALTERNATIVE_CONECTA_DIR="/e/Compart/Conecta/Conecta"
INFRA_DIR="/c/workspace/Benner.Infra"

RELEASE_BRANCH='release/Sprint31'

# MSBUILD='/c/Program Files (x86)/MSBuild/14.0/Bin/MSBuild.exe'
MSBUILD='/c/Program Files (x86)/Microsoft Visual Studio/2017/Professional/MSBuild/15.0/Bin/MSBuild.exe'
IISEXPRESS=/c/Program\ Files/IIS\ Express/iisexpress.exe
NUNIT_EXE=/c/Program\ Files\ \(x86\)/NUnit\ 2.6.4/bin/nunit-console.exe
ASP_NET_COMPILER=/c/Windows/Microsoft.NET/Framework64/v4.0.30319/aspnet_compiler.exe

# Não alterar a não ser que saiba exatamente o que está fazendo.
nuget='./.nuget/NuGet.exe'
DEFAULT_PUBLISH_CONFIGURATION='Loc.SqlS.Release'
DEFAULT_PUBLISH_PATH='C:\inetpub\wwwroot\Conecta'
SITE_NAME='Benner.Conecta.Portal-Site'
SITE_NAME_JOBS='Benner.Conecta.Jobs.WebApplication-Site'
MSBUILD_COMMON_PARAMS='//p:BuildInParallel=true //p:WarningLevel=0 //v:m //m'
