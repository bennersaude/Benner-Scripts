Param(
  [string[]]$hostNames,
  [string[]]$services
)

foreach($hostName in $hostNames) {
    foreach($service in $services) {
	Restart-Service -InputObject $(Get-Service -Computer $hostName -Name $service)
    }
}