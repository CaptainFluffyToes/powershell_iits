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
function Load-PowerCLI
{
    [CmdletBinding()]
    Param
    ()
    Begin
    {
    }
    Process
    {
        if(!(Get-Module -Name VMware.VimAutomation.Core) -and (Get-Module -ListAvailable -Name VMware.VimAutomation.Core))
        {
            Import-Module -Name Vmware.VimAutomation.Core | Out-Null
        }
    }
}