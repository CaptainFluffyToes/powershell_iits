get-help#$updates = Get-Package | Where-Object {$_.ProviderName -like  "*msu*"}
#$recent_updates = $updates| Where-Object {$_.Attributes
#$current_date = Get-Date
#$days = 30
#$recent_updates = Get-HotFix | Where-Object {$_.InstalledOn -gt $current_date.AddDays(-$days)} | Select-Object -Property HotFixId
$updates_installed = Get-Package | Where-Object {$_.CanonicalId -like "*(KB*"} | Select-Object -Property CanonicalID