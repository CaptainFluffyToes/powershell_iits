# Check for Exchange SSL Certificates with IIS service and flag if
# any expire within 31 days.
# Exchange 2007 & 2010 (2013 untested)
# Note that some certificates may still exist in the store that have
# expired but are no longer in use.  These may flag if they have been
# left in the store
#
# OAS Computers, Australia.  http://www.oas.com.au
# Justin S. Cooksey
# Version 1.00, 10th October 2013
 
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin -ErrorAction SilentlyContinue
Add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction SilentlyContinue
 
$DaysToExpiration = 31
 
$expirationDate = (Get-Date).AddDays($DaysToExpiration)
 
[array]$exchCerts = Get-ExchangeCertificate | Where {$_.Services -match "IIS" -and $_.NotAfter -lt $expirationDate}
 
$intExit = 0
if ($exchCerts.Count -gt 0) 
{
    Write-Host "Exchange SSL Certificate Expiring in less than 31 days"
    $exchCerts | fl CertificateDomains, IsSelfSigned, Issuer, NotAfter, RootCAType, Subject, Thumbprint
    $intExit = 1001
}
else
{
    Write-Host "No Exchange SSL Certificates expiring within 31 days"
}
 
exit $intExit