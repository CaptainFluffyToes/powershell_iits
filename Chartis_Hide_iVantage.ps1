$credential = get-credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $credential -Authentication Basic -AllowRedirection
Import-PSSession $Session

$objects = Get-Recipient "*@ivantagehealth.com"
foreach($object in $objects)
    {
    set-mailbox -Identity $object.Alias -HiddenFromAddressListsEnabled $true
    }
    
    