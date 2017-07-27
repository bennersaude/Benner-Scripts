CONECTA_DIR="/c/workspace/Conecta"
ALTERNATIVE_CONECTA_DIR="/e/Compart/Conecta/Conecta"
INFRA_DIR="/c/workspace/Benner.Infra"

RELEASE_BRANCH='release/Sprint32'

DEFAULT_CONECTA_PORTAL_PUBLISH_PATH='C:\inetpub\wwwroot\Conecta'
DEFAULT_JOBS_PUBLISH_PATH='C:\inetpub\wwwroot\Jobs'
DEFAULT_ROUTE_PUBLISH_PATH='C:\inetpub\wwwroot\ConectaRoute'
DEFAULT_API_PUBLISH_PATH='C:\inetpub\wwwroot\ConectaApi'

# MSBUILD='/c/Program Files (x86)/MSBuild/14.0/Bin/MSBuild.exe'
MSBUILD='/c/Program Files (x86)/Microsoft Visual Studio/2017/Professional/MSBuild/15.0/Bin/MSBuild.exe'
IISEXPRESS=/c/Program\ Files/IIS\ Express/iisexpress.exe
NUNIT_EXE=/c/Program\ Files\ \(x86\)/NUnit\ 2.6.4/bin/nunit-console.exe
ASP_NET_COMPILER=/c/Windows/Microsoft.NET/Framework64/v4.0.30319/aspnet_compiler.exe


# Não alterar a não ser que saiba exatamente o que está fazendo.
nuget='./.nuget/NuGet.exe'

API_CSPROJ='Benner.Conecta.Api/Benner.Conecta.Api.csproj'
ROUTING_CSPROJ='Benner.Conecta.RoutingService/Benner.Conecta.RoutingService.csproj'
CONECTA_PORTAL_CSPROJ='Benner.Conecta.Portal/Benner.Conecta.Portal.csproj'
JOBS_CSPROJ='Benner.Conecta.Jobs/Web/Benner.Conecta.Jobs.WebApplication.csproj'

DEFAULT_RELEASE_CONFIGURATION='Loc.SqlS.Release'
DEFAULT_DEBUG_CONFIGURATION='Loc.SqlS.Debug'
DEFAULT_PUBLISH_CONFIGURATION="$DEFAULT_RELEASE_CONFIGURATION"

DEFAULT_PUBLISH_PATH="$DEFAULT_CONECTA_PORTAL_PUBLISH_PATH"

SITE_NAME='Benner.Conecta.Portal-Site'
SITE_NAME_JOBS='Benner.Conecta.Jobs.WebApplication-Site'
MSBUILD_COMMON_PARAMS='//p:BuildInParallel=true //p:WarningLevel=0 //v:m //m'
