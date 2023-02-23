[array] $services = @('service1', 'service2', 'service3', 'service4')

foreach ($svc in $services) {

    $service = Get-Service $svc
    $smtpserver = "smtp.domain.com"
    $recipient = "user@domain.com"
    $sender = "$($env:computername)@domain.com"
    $subject = "$($service.name) failed to start on $($env:computername)"
    # $body       =  
    $port = "587"
    $password = get-content "c:\script\password.txt" | ConvertTo-SecureString
    $Credential = New-Object System.Management.Automation.PSCredential("AKIAY5FLA6ZTGHZGO64P", $password)

    try {
        if ($service.Status -eq "stopped") {
            write-host "Starting $($service.Name )"
            start-service $service.Name -ErrorAction stop
        }
    }
    catch {
            
        write-host $_;
        write-host "Failed to start the service"
        Send-MailMessage -To $recipient -From $sender -Subject $subject -Body "$_" -SmtpServer $smtpserver -Port $port -usessl -credential $Credential
    }

}
