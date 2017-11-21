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
function Report-Clutter
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Param1,

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
    $credential = get-credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $credential -Authentication Basic -AllowRedirection
    Import-PSSession $Session -AllowClobber | Out-Null
    }
    Process
    {
    $output = "C:\Users\Darren Khan\Desktop\clutter.csv"
    $users = Get-Mailbox
    $report = @()
    $entry = 1 
    foreach ($user in $users)
        {
        $clutter = Get-Clutter -Identity $user.userprincipalname
        Write-Output "$($user.displayname) has $($clutter.isenabled) for Clutter setting.  Number $($entry) out of $($users.count)."
        $Prop=[ordered]@{
                    'Display Name'=$user.DisplayName
                    'Clutter Setting'=$clutter.IsEnabled
                     }
        $report += New-Object -TypeName psobject -Property $Prop
        $entry = ++$entry
        }
    }
    End
    {
    $report | Export-Csv -Path $output
    Get-PSSession | Remove-PSSession
    }
}