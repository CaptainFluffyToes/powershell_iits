$smtpServer = "10.12.0.85"
$from = "Kaseya@integratedit.com"
$to = "sccit.infrastructuresupport@integratedit.com"
$subject = "Kaseya Queue Length Issues!"
$queues = Get-MsmqQueue | select QueueName, MessageCount | where {$_.MessageCount -gt "1000"} | ConvertTo-Html | Out-File c:\scripts\queues.htm
[string]$emailbody = Get-Content c:\scripts\queues.htm
if(Get-MsmqQueue | where {$_.MessageCount -gt "1000"} | select QueueName, MessageCount | sort)
    {Send-MailMessage -To $to -Subject $subject -BodyAsHtml $emailbody -SmtpServer $smtpServer -From $from}
Remove-Item c:\scripts\queues.htm