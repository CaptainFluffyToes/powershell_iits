<#
#This script is to find out how many messages have been sent and received for each user in Office 365
#>
$credential = get-credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $credential -Authentication Basic -AllowRedirection
Import-PSSession $Session

[int]$days_past = -(Read-Host -Prompt 'Enter the number of days in the past to gather reports. Up to a max of 30 days')
$date = get-date
$file_path_csv = "$env:USERPROFILE\desktop\Email_stats_$(get-date -f yyyyMMdd).csv"
$report = @()
$entry = 1
$recipients = Get-Recipient -RecipientTypeDetails UserMailBox -RecipientType UserMailBox
$start_time = Get-Date
foreach ($recipient in $recipients)
    {
    Write-Output "Currently working on $recipient.  Number $entry of $(($recipients | measure-object).Count) total. $(($entry/$(($recipients | measure-object).Count))*100 -as [int])% Complete"
    $messages_received = Get-MessageTrace -RecipientAddress $recipient.PrimarySMTPAddress -StartDate $date.AddDays($days_past) -EndDate $date | Measure-Object
    $messages_sent = Get-MessageTrace -SenderAddress $recipient.PrimarySMTPAddress -StartDate $date.AddDays($days_past) -EndDate $date | Measure-Object
    $Prop=[ordered]@{
                'Display Name'=$recipient.DisplayName
                'Start Date'=$date.AddDays($days_past)
                'End Date'=$date
                'Messages Received'=$messages_received.Count
                'Messages Sent'=$messages_sent.Count
                'Total Messages'=($messages_received.Count + $messages_sent.Count)
            }
    $report += New-Object -TypeName psobject -Property $Prop
    $entry = ++$entry
    }
$report | Export-Csv -Path $file_path_csv

$smtpServer = "outlook.office365.com"
$from = "Scripts@integratedit.com"
$to = "dkhan@integratedit.com"
$subject = "Script finished in $(((get-date).Subtract($start_time)).TotalMinutes -as [int]) minutes!"
Send-MailMessage -To $to -Subject $subject -BodyAsHtml "$($report | ConvertTo-Html)" -Credential $credential -SmtpServer $smtpServer -UseSsl -From $from -Attachments $file_path_csv 
Remove-Item -Path $file_path_csv