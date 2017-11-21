
<#
.Synopsis
   This function will gather the appropriate logs for CyberArk components installed
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-Logs
{
    [CmdletBinding()]
    Param
    (
        [switch]$ErrorLog
    )

    Begin
    {
        $booboos += "$(Get-Date) - Finding any CyberArk services on the computer."
        [array]$Services = Get-Service | Where-Object ($_.displayname -match "Cyber") -or ($_.displayname -match "Private")
        if($Services)
        {
            $booboos += "$(Get-Date) - Found services : $($Services.displayname | Out-String)."
        }
        else
        {
            $booboos += "$(Get-Date) - Couldn't find any CyberArk services on this machine."
        }
    }
    Process
    {
    }
    End
    {
        if(!$ErrorLog)
        {
            $LogPath = "$env:windir\Temp\GetLogsErrors.txt"
            foreach($booboo in $booboos)
            {
                "$booboo" | Out-File -FilePath $LogPath -Force -Append
            }
        }
    }
}