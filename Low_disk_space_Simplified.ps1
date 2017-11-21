<#
$Drive_issues = Get-Volume | Where-Object {(($_.SizeRemaining/$_.size) -lt '0.1') -and ($_.DriveType -eq "Fixed") -and ($_.DriveLetter) -and ($_.SizeRemaining -lt 60)}
$a = New-Object -ComObject wscript.shell;
if($Drive_issues)
    {$a.popup("$Drive_issues is low on disk space!",0,"Test Message",1)}
#>
$drives = Get-Volume | Where-Object {($_.size -gt 1) -and (($_.SizeRemaining/$_.Size) -gt '0.1') -and <#($_.DriveType -eq "Fixed") -and#> ($_.DriveLetter) -and ($_.SizeRemaining -gt 60)}
$count = $drives.Count
Do{
    