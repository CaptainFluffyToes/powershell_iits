"{0:N2} Mbit/sec" -f ((10/(Measure-Command {Invoke-WebRequest 'http://client.akamai.com/install/test-objects/10MB.bin'|Out-Null}).TotalSeconds)*8)
