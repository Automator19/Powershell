#Import CSV

$path = split-path -Parent $MyInvocation.MyCommand.Definition
$newpath = $path + ".\dns.csv"
$csv = @()
$CSV = Import-CSV -Path $newpath

# Logs

$timestamp = Get-Date -format yyyy.MM.dd-hh.mm.ss
Start-Transcript -Path $path\$timestamp.txt -append

foreach ($line in $csv) {

    $name = $line.name
    $zonename = $line.zonename
    $RecordType = $line.recordtype
    $dnsserver = $line.dnsserver
    $ipaddress = $line.ipaddress


    $checkdns = get-DnsServerResourceRecord -computername $dnsserver -ZoneName $zonename -RRType $RecordType -Name $name

    if ( $checkdns -eq $null ) { 

        write-host "DNS Record does not exist"

    }
    else 
    {

        #Remove-DnsServerResourceRecord -computername $dnsserver -ZoneName $zonename -RRType $RecordType -Name $name -RecordData $ipaddress -Confirm:$false -force
        Remove-DnsServerResourceRecord -computername $dnsserver -ZoneName $zonename -RRType $RecordType -Name $name -Confirm:$false -force
        write-host " $($Recordtpye) record for $($name) removed !!! "
   
    }

}