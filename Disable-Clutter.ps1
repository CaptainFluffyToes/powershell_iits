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
function Disable-Clutter
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
        $Param2,
        [Switch]$ErrorLog,
        [String]$LogFile = 'c:\errorlog.txt',
        $output = "$env:USERPROFILE\desktop\ClutterStats_$(get-date -f yyyyMMdd).csv"
    )

    Begin
    {
    $credential = get-credential
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $credential -Authentication Basic -AllowRedirection
    Import-PSSession $Session -AllowClobber | Out-Null
    }
    Process
    {
    $users = Get-Mailbox
    $report = @()
    $entry = 1 
    foreach ($user in $users)
        {
        try
            {
            $clutter = Get-Clutter -Identity $user.userprincipalname -erroraction silentlycontinue -errorvariable +currenterror
            if($clutter.isEnabled -eq "True")
                {
                $clutter_after = Set-Clutter -Identity $user.userprincipalname -Enable $false -erroraction silentlycontinue -errorvariable +currenterror
                Write-Output "Clutter setting for $($user.DisplayName) has been changed to FALSE. Number $($entry) out of $($users.count)."
                }
            else
                {
                Write-output "Clutter setting for $($user.DisplayName) has not been changed. Number $($entry) out of $($users.count)."
                }
            $Prop=[ordered]@{
                        'User'=$user.DisplayName
                        'Clutter Setting Before'=$clutter.IsEnabled
                        'Clutter Setting After'=$clutter_after.isenabled
                         }
            }
        catch
            {
        $report += New-Object -TypeName psobject -Property $Prop
        $entry = ++$entry
        }
    }
    End
    {

    $report | Export-Csv -Path $output -Force
    Write-Output "Closing powershell sessions: $(Get-PSSession)"
    Get-PSSession | Remove-PSSession
    }
}