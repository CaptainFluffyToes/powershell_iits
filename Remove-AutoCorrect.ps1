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
function Remove-AutoCorrect
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
        [string]$Param1,

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
    $output= "$env:temp\disableautocorrectoutput_IITS.txt"
    $found=0
    $word = New-Object -ComObject word.application
    $word.visible = $false
    }
    Process
    {
    $entries = $word.AutoCorrect.entries
    foreach($e in $entries){ 
        if($e.name -eq $Param1){
            "$(Get-Date) - Found $Param1 in Auto Correct List." | Out-File -FilePath $output -Append
            $found=1
            $e.delete()
            "$(Get-Date) - Deleted $Param1 in Auto Correct List." | Out-File -FilePath $output -Append
        }
    }
    if($found -eq 0){
    "$(Get-Date) - Did not find $Param1 in Auto Correct List." | Out-File -FilePath $output -Append
    }
    }
    End
    {
    $word.Quit()
    $word = $null
    [gc]::collect()
    [gc]::WaitForPendingFinalizers()
    }
}