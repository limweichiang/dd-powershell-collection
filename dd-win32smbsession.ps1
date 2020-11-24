function dogstatsd($metric) {
    $udpClient = New-Object System.Net.Sockets.UdpClient
    $udpClient.Connect('127.0.0.1', '8125')
    $encodedData=[System.Text.Encoding]::ASCII.GetBytes($metric)
    $bytesSent=$udpClient.Send($encodedData,$encodedData.Length)
    $udpClient.Close()
}

for(;;){
    $tags = "|#env:test" # Datadog tag, update as required
    $smbsession = Get-SmbSession | measure
    $metric = "smb.sessions:" + $smbsession.Count + "|g" + $tags
    Write-Output $metric
    dogstatsd($metric)
    Start-Sleep -s 15
}