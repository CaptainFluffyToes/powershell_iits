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
function Backup-VM
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Server,

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
        if(!(Get-Module -Name VMware.VimAutomation.Core) -and (Get-Module -ListAvailable -Name VMware.VimAutomation.Core))
        {
            Import-Module -Name Vmware.VimAutomation.Core | Out-Null
        }
    }
    Process
    {
    }
    End
    {
    }
}