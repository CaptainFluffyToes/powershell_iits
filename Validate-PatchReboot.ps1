<#
.Synopsis
   This function will do some action if the date parameters are all correct for the current date. 
.DESCRIPTION
   This function executes a script block is all the parameters for a reboot are correct.  Parameters that are checked at the time of running: Day, Week of the month, and Time. This script can be used if you have specific parameters that dictate if a machine can be rebooted.  The parameters are required at the time of execution.
.EXAMPLE
   Validate-PatchReboot -RebootDay Friday -StartRebootTime 12 -EndRebootTime 16 -RebootDayOccurance 2 -Errorlog
#>
function Validate-PatchReboot
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateSet("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")]
        $RebootDay,

        # StartRebootTime MUST BE IN 24 HOUR CLOCK
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [int]
        [ValidateRange(0,23)]
        $StartRebootTime,

        # EndRebootTime MUST BE IN 24 HOUR CLOCK
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        [int]
        [ValidateRange(0,23)]
        $EndRebootTime,
        
        # RebootDayOccurance MUST BE AN INTEGAR
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=3)]
        [ValidateRange(1,5)]
        [int]
        $RebootDayOccurance,

        # Enable errorlog
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=4)]
        [switch]
        $ErrorLog
    )

    Begin
    {
        [array]$booboos = @()
        [int]$week = 0
        [System.DateTime]$currentdate = Get-Date
        [System.DateTime]$LastWeek = $currentdate.AddDays(-7)
        
        #figure out if it's right day of the week to reboot
        if($currentdate.dayofweek -match $RebootDay)
        {
            $booboos += "$(Get-Date) - This is the correct reboot day."
            #Figure out if it's the right day of the month to reboot
            if($LastWeek.Month -notmatch $currentdate.Month)
            {
                $week = 1
                $booboos += "$(Get-Date) - This is the first $($currentdate.DayOfWeek)."
            }
            else
            {
                $week=2
                $LastWeek = $LastWeek.AddDays(-7)
                while($LastWeek.Month -match $currentdate.Month)
                {
                    $week = ++$week
                    $LastWeek = $LastWeek.AddDays(-7)
                }
            }
            $booboos += "$(Get-Date) - Found we are in week $week of the month."
            if($week -match $RebootDayOccurance)
            {
                $booboos += "$(Get-Date) - This is the correct day of the month."
                if($StartRebootTime -lt $EndRebootTime)
                {
                    #Figure out if the time is between the start and end time window
                    if(($currentdate.TimeOfDay.Hours -ge $StartRebootTime) -and ($currentdate.TimeOfDay.Hours -le $EndRebootTime))
                    {
                        $booboos += "$(Get-Date) - The current day and time are correct given all of the parameters. Machine should be rebooted."
                        #put in here what you want to happen when everything works out correctly.
                        $RebootNow = $true
                        $RebootLater = $false
                    }
                    elseif($currentdate.TimeOfDay.Hours -le $StartRebootTime)
                    {
                        $booboos += "$(Get-Date) - The server has finished patching prior to the reboot time.  Schedule reboot for $($StartRebootTime)."
                        #Schedule reboot to happen at $StartRebootTime.
                        #Send email to SPG that reboot is scheduled.
                        $RebootLater = $true
                        $RebootNow = $false
                    }
                    else
                    {
                        $booboos += "$(Get-Date) - The correct reboot time window has been missed!"
                        $booboos += "$(Get-Date) - Send Email to SPG alerting them."
                        #Send email to SPG that this server has missed it's reboot time window!
                    }
                }
                elseif($StartRebootTime -gt $EndRebootTime)
                {
                    $booboos += "$(Get-Date) - The start time is greater than the end time which means that it is an overnight window."
                    if((($currentdate.TimeOfDay.Hours -ge $StartRebootTime) -and ($currentdate.TimeOfDay.Hours -lt 24)) -or (($currentdate.TimeOfDay.Hours -gt 0) -and ($currentdate.TimeOfDay.Hours -lt $EndRebootTime)))
                    {
                        $booboos += "$(Get-Date) - The server has finished patching during it's reboot window."
                        #Schedule reboot to happen at $StartRebootTime.
                        #Send email to SPG that reboot is scheduled.
                        $RebootLater = $false
                        $RebootNow = $true
                    }
                    else
                    {
                        $booboos += "$(Get-Date) - Couldn't figure out if this is an appropriate time to reboot."
                        #send email starting that this machine has missed it's window and needs to be scheduled.
                    }
                }
                Else
                {
                    $booboos += "$(Get-Date) - The start and the end time are identical. Enter different times and re-run."
                }
            }
            else
            {
                $booboos += "$(Get-Date) - Couldn't find the week of the month. Week is $week."
            }
        }
        else
        {
            $booboos += "$(Get-Date) - This is the wrong day of the week."
            #send email to SPG that this server has missed it's reboot day and one has to be scheduled!
        }
    }
    Process
    {
       If($RebootNow -eq $true)
       {
            #Enter code to reboot machine now and send emails to SPG
       }
       Elseif($RebootLater -eq $true)
       {
            #Enter code to reboot machine at $StartRebootTime and send emails to SPG
       }
    }
    End
    {
        if($ErrorLog)
        {
            $LogPath = "$env:windir\Temp\PatchReboot_IITS.txt"
            foreach($booboo in $booboos)
            {
                "$booboo" | Out-File -FilePath $LogPath -Force -Append
            }
        }
    }
}