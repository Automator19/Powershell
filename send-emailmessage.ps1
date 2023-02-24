$smtpserver = "email-smtp.eu-west-1.amazonaws.com"
$recipient  = "user@domain.com"
$from       = "user@domain.com"
$subject    = "Test-Subject"
$body       = "Test-Message"
$port       = "587"
$password   = get-content "c:\scripts\password.txt" | ConvertTo-SecureString
$Credential = New-Object System.Management.Automation.PSCredential("username",$password)
        
Send-MailMessage -To $recipient -From $from  -Subject $subject -Body $body -SmtpServer $smtpserver -Port $port -usessl -credential $Credential

<# To hide the password you will have to run below commands save encrypted password into a text file. Just like Task Scheduler, this method will encrypt using the Windows Data Protection API, which also means we fall into the same limitations of only being able to access the password file with one account and only on the same device that created the password file. The user login credentials are essentially the “key” to the password file. However, this method allows us to save multiple passwords and reference them in our script.
(get-credential).password | ConvertFrom-SecureString | set-content "C:\script\password.txt"
Ref: https://www.altaro.com/msp-dojo/encrypt-password-powershell/ #>
