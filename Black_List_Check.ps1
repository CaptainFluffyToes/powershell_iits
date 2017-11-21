$wc=New-Object net.webclient
        #$IP =(Invoke-WebRequest ifconfig.me/ip).Content.Trim()
        #$IP = $wc.downloadstring("http://ifconfig.me/ip") -replace "[^\d\.]"
        Try {
            $IP = $wc.downloadstring("http://checkip.dyndns.com") -replace "[^\d\.]"
        } 
        Catch {
            $IP = $wc.downloadstring("http://ifconfig.me/ip") -replace "[^\d\.]"
        }
        #$IP = "67.217.109.5"
        Write-Host "Testing Public IP: $IP"
        $reversedIP = ($IP -split '\.')[3..0] -join '.'
 
        $blacklistServers = @(
            'b.barracudacentral.org'
            'spam.rbl.msrbl.net'
            'zen.spamhaus.org'
            'bl.deadbeef.com'
            'bl.spamcannibal.org'
            'bl.spamcop.net'
            'blackholes.five-ten-sg.com'
            'bogons.cymru.com'
            'cbl.abuseat.org'
            'combined.rbl.msrbl.net'
            'db.wpbl.info'
            'dnsbl-1.uceprotect.net'
            'dnsbl-2.uceprotect.net'
            'dnsbl-3.uceprotect.net'
            'dnsbl.cyberlogic.net'
            'dnsbl.sorbs.net'
            'duinv.aupads.org'
            'dul.dnsbl.sorbs.net'
            'dyna.spamrats.com'
            'dynip.rothen.com'
            'http.dnsbl.sorbs.net'
            'images.rbl.msrbl.net'
            'ips.backscatterer.org'
            'misc.dnsbl.sorbs.net'
            'noptr.spamrats.com'
            'orvedb.aupads.org'
            'pbl.spamhaus.org'
            'phishing.rbl.msrbl.net'
            'psbl.surriel.com'
            'rbl.interserver.net'
            'relays.nether.net'
            'sbl.spamhaus.org'
            'smtp.dnsbl.sorbs.net'
            'socks.dnsbl.sorbs.net'
            'spam.dnsbl.sorbs.net'
            'spam.spamrats.com'
            't3direct.dnsbl.net.au'
            'tor.ahbl.org'
            'ubl.lashback.com'
            'ubl.unsubscore.com'
            'virus.rbl.msrbl.net'
            'web.dnsbl.sorbs.net'
            'xbl.spamhaus.org'
            'zombie.dnsbl.sorbs.net'
            'hostkarma.junkemailfilter.com'
        )
 
        $blacklistedOn = @()
 
        foreach ($server in $blacklistServers)
        {
            $fqdn = "$reversedIP.$server"
            #Write-Host "Testing Reverse: $fqdn"
            try
            {
              #Write-Host "Trying Blacklist: $server"
                $result = [System.Net.Dns]::GetHostEntry($fqdn)
             foreach ($addr in $result.AddressList) {
              $line = $Addr.IPAddressToString
             }  
            #IPAddress[] $addr = $result.AddressList;
                #$addr[$addr.Length-1].ToString();
            #Write-Host "Blacklist Result: $line"
            if ($line -eq "127.0.0.1") {
                    $blacklistedOn += $server
            }
            }
            catch { }
        }
 
        if ($blacklistedOn.Count -gt 0)
        {
            # The IP was blacklisted on one or more servers; send your email here.  $blacklistedOn is an array of the servers that returned positive results.
            Write-Host "$IP was blacklisted on one or more Lists: $($blacklistedOn -join ', ')"
            Exit 1010
        }
        else
        {
            Write-Host "$IP is not currently blacklisted on any lists checked."
            Exit 0
        } 