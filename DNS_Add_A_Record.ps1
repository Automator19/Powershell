#Import CSV

$path = split-path -Parent $MyInvocation.MyCommand.Definition
$newpath = $path + ".\dns.csv"
$csv = @()
$CSV = Import-CSV -Path $newpath

# Logs

$timestamp = Get-Date -format yyyy.MM.dd-hh.mm.ss
Start-Transcript -Path $path\$timestamp.txt -append

foreach ($line in $csv) 
{

    $name = $line.name
    $zonename = $line.zonename
    # $RecordType = $line.recordtype
    $dnsserver = $line.dnsserver
    $ipaddress = $line.ipaddress

    Add-DnsServerResourceRecordA -Name $name -ZoneName $zonename -IPv4Address $ipaddress -Computername $dnsserver -ErrorAction Stop
    Get-DnsServerResourceRecord -computername $dnsserver -ZoneName $zonename -name $name -RRType "A"
    Get-DnsServerResourceRecord -computername $dnsserver -ZoneName $zonename -name $name -RRType "Ptr"

}