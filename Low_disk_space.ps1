#Get-Volume | Where-Object {$_.DriveLetter -and $_.DriveType -eq 'Fixed'} | Select-Object -Property DriveLetter, SizeRemaining, Size, @{Label='Percentage Used';E={"{0:N2}" -f (($_.Sizeremaining/$_.size)*100)}}
$vol_info = Get-Volume | Where-Object {$_.DriveLetter} | Select-Object -Property DriveLetter, SizeRemaining, Size, @{Name='PercentageFree';Expression={"{0:N2}" -f (($_.Sizeremaining/$_.size)*100)}}
$driveletter = $vol_info.DriveLetter;
$drive_count = $vol_info.DriveLetter.Count;
$percent_free = $vol_info | ForEach-Object {$_.PercentageFree};
$size_rem = $vol_info | ForEach-Object {$_.SizeRemaining / 1GB};
$a = New-Object -ComObject wscript.shell;
Do{
    if ($percent_free -lt 100)
       {$a.popup("$driveletter is low on disk space! $percent%",0,"Test Message",1)}
    $drive_count = ($drive_count) - 1
   }
Until ($drive_count -eq 0)
