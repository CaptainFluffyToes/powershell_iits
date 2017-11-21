<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Toggle-ActionCenter
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0
                   )]
        [ValidateSet("Enable","Disable")]
        [String]$Param1
    )

    Begin
    {
        $to = "msalarm@integratedit.com"
        $from = "script_genie@integatedit.com"
        $smtpserver = "outlook.office365.com"
        $regpath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
        $namedword = "DisableNotificationCenter"
        $output= "$env:temp\actioncenter_IITS.txt"
        if($Param1 -eq "Enable")
        {
            $Status = 0
        }
        Else
        {
            $Status = 1
        }
    }
    Process
    {
        try
        {
            $machineID  = $(Get-ItemProperty -Path "HKLM:\Software\WOW6432Node\Kaseya\Agent\INTTSL74824010499872" -Name MachineID -ErrorAction Stop -ErrorVariable CurrentError).MachineID
            if (!(Test-Path $regpath))
            {
                "$(Get-Date) - Registry path does not exist." | Out-File -FilePath $output -Force -Append
                New-Item -Path $regpath -Force -ErrorAction Stop -ErrorVariable CurrentError
                "$(Get-Date) - Created new key $regpath." | Out-File -FilePath $output -Force -Append
                New-ItemProperty -Path $regpath -Name $namedword -Value $Status -PropertyType DWORD -Force -ErrorAction Stop -ErrorVariable CurrentError
                "$(Get-Date) - Created new dword $namedword with value of $Param1." | Out-File -FilePath $output -Force -Append
            }
            else
            {
                 "$(Get-Date) - Registry path exists." | Out-File -FilePath $output -Force -Append
                 New-ItemProperty -Path $regpath -Name $namedword -Value $Status -PropertyType DWORD -Force -ErrorAction Stop -ErrorVariable CurrentError
                 "$(Get-Date) - Set new dword $namedword with value of $Param1." | Out-File -FilePath $output -Force -Append
            }
        }
        Catch
        {
            $CurrentError
        }
    }
    End
    {
    }
}