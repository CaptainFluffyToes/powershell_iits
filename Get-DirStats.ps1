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
function Get-DirStats
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
    $report=@()
    $start_time = Get-Date
    }
    Process
    {
    Write-Output "Getting Drive Letters of the system"
    #$drives = Get-Volume | Where-Object {($_.DriveLetter -and $_.DriveType -eq "Fixed")}#
    $driveletters = get-psdrive | Where-Object {($_.Provider -match "FileSystem")}
    Write-Output "Drive letters have been acquired"
    $drive_count = $driveletters | Measure-Object
    Write-Output "Iterating through Drive letters"
    ForEach ($driveletter in $driveletters){
        Write-Output "Finding directories"
        $dirs = get-childitem $driveletter.root -Recurse -Force -ErrorAction SilentlyContinue -ErrorVariable $issue_dir | Where-Object {($_.Mode -eq "d-----") -and $_.FullName -notlike "C:\Windows*" -and $_.FullName -notlike "C:\$*"} #Find a way to use regular expressions to limit the number of \ that are in the file path to 3#
        write-output "Moving onto Sub Directories"
        ForEach ($dir in $dirs){
            $size = Get-ChildItem $dir.fullname -Recurse -Force -ErrorAction Stop -ErrorVariable $issue_size | Measure-Object -Property Length -Sum
            $Prop = @{
                    "Directory" = ($dir.fullname)
                    'Size_in_GB' = ($size.sum/1gb)
                    }
            $report += New-Object -TypeName psobject -Property $Prop                   
            Write-Output "The Size of $($dir.fullname) is $($size.sum/1GB)GB"
            }
        
        #find a way to separate the different volumes from one another in the report#
        }
    }
    End
    {
    $report | ConvertTo-Html | Out-File -FilePath "$($env:USERPROFILE)\Desktop\disk_space.htm"
    $report | Export-Csv -Path "$($env:USERPROFILE)\Desktop\disk_space.csv"
    Write-Output "This took $(((get-date).Subtract($start_time)).TotalMinutes -as [int]) minutes."    
    }
}