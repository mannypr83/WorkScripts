Param (
	[string]$Computer = (Read-Host "Enter computer name you want to check")
)
cls
Write-Host "`nChecking Host: $Computer"
$LastBoot = (Get-WmiObject -ComputerName $Computer -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem")
$LastBootTime = $Lastboot.ConvertToDateTime($LastBoot.LastBootUpTime)
$Span = New-TimeSpan -Start $LastBootTime -End (Get-Date)
Write-Host "Uptime:  $($Span.Days) Days, $($Span.Hours) Hours, $($Span.Minutes) Minutes`n`n`n"
Read-Host "Hit [Return] Key to Exit"