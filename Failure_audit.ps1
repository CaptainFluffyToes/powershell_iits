#529 - Logon Failure: Unknown user name or bad password
#530 - Logon Failure: Account logon time restriction violation
#531 - Logon Failure: Account currently disabled
#532 - Logon Failure: The specified user account has expired
#533 - Logon Failure: User not allowed to logon at this computer
#534 - Logon Failure: The user has not been granted the requested logon type at this machine
#535 - Logon Failure: The specified account's password has expired
#537 - Logon Failure: An unexpected error occurred during logon
#539 - Logon Failure: Account locked out
#644 - User Account Locked Out
#4624 - An account was successfully logged on
#4625 - An account failed to log on
#4649 - A replay attack was detected
#4740 - A user account was locked out
#5378 - The requested credentials delegation was disallowed by policy
 
 
$log_path = $env:temp + "\"
$computer = gc env:computername
$result = "alert.log"
write-host $log_path 
try
{
get-eventlog  -LogName Security -After (get-date).adddays(-1) -EntryType 'FailureAudit'| ?{($_.eventid -eq "529") -or ($_.eventid -eq "4625") } | select machinename,eventid,@{n='AccountName';e={$_.ReplacementStrings[1]}},message |Out-File -FilePath ($log_path + $result) -encoding ASCII -append -Width 1000
if (Test-Path ($log_path + $result))
{
Write-Host "Success Message"
Exit 0
 } else 
 {
 Write-Host "Success Message" 
 Write-Host "Multiple failed log-on"
 Exit 0 
 }
} catch 
{
Write-Host "Error Message"
Exit 1001
}