param (
    [Parameter(Mandatory = $true)][string]$csprojFile,
    [Parameter(Mandatory = $true)][string]$fromTISS,
    [Parameter(Mandatory = $true)][string]$toTISS

    # [string]$csprojFile = "C:\workspace\Conecta\Benner.Conecta.Portal.Business.Tests\Benner.Conecta.Portal.Business.Tests.csproj",
    # [string]$fromTISS = "30301",
    # [string]$toTISS = "30302"
)

$xml = ([xml](Get-Content $csprojFile))

$xml.Project.ItemGroup | ForEach-Object {
    $parentNode = $_
    $parentNode.None | Where-Object {$_.Include -like "*$fromTISS*"} | ForEach-Object {
        $cloned = $_.Clone()
        $cloned.Include = $cloned.Include -replace $fromTISS, $toTISS
        try {
            $cloned.Link = $cloned.Link -replace $fromTISS, $toTISS
        } catch {}

        $parentNode.AppendChild($cloned)
        $xml.Save($csprojFile)
    }

    $parentNode.Compile | Where-Object {$_.Include -like "*$fromTISS*"} | ForEach-Object {
        $cloned = $_.Clone()
        $cloned.Include = $cloned.Include -replace $fromTISS, $toTISS
        try {
            $cloned.Link = $cloned.Link -replace $fromTISS, $toTISS
        } catch {}

        $parentNode.AppendChild($cloned)
        $xml.Save($csprojFile)
    }

    $parentNode.Content | Where-Object {$_.Include -like "*$fromTISS*"} | ForEach-Object {
        $cloned = $_.Clone()
        $cloned.Include = $cloned.Include -replace $fromTISS, $toTISS
        try {
            $cloned.Link = $cloned.Link -replace $fromTISS, $toTISS
        } catch {}

        $parentNode.AppendChild($cloned)
        $xml.Save($csprojFile)
    }
}
