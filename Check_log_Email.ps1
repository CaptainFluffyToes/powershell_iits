$smtpServer = "10.12.0.85"
$from = "Kaseya@integratedit.com"
$to = "sccit.infrastructuresupport@integratedit.com"
$subject = "Kaseya ksubscribers_log File size above 10gb!"
$log_file = "E:\MSSQL\Logs\ksubscribers_log.ldf"
$filesize = Get-ChildItem $log_file | ForEach-Object {$_.Length / 1GB}
if($filesize -gt 10)
    {Send-MailMessage -To $to -Subject $subject -BodyAsHtml "The size of the log file is $filesize GB.  Please reach out to IITS infrastructure team to shrink file."  -SmtpServer $smtpServer -From $from}