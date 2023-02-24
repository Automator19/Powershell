### **Powershell/CMD One/Two/Three Liners**

- #### Search for a string in a log file
   `select-string -path "C:\Windows\System32\LogFiles\SMTPSVC1\*" -pattern "enter-string-here"`

- #### Delete files older than 7 days
```
set-location C:\inetpub\mailroot\Badmail
foreach ($File in get-childitem) {
   if ($File.LastWriteTime -lt (Get-Date).AddDays(-7)) {
      del $File}}
``` 
- #### Read IIS log files in real time
   `Get-Content "D:\IISLogs\W3SVC1\u_extend9_x.log" -tail 5 -wait | select-string "xyz.abc"`

- #### Check which site Computer belongs to
   `Locally : NLTEST /dsgetsite`
   `Remotely: NLTEST /DSADDRESSTOSITE:10.194.132.50`

- #### Check open port
   `Test-NetConnection -ComputerName "10.196.143.115" -port "4904" -InformationLevel "Detailed"`

- #### Check open port (.net way)
   `New-Object System.Net.Sockets.TCPClient -Argument "10.196.143.115","4904"`

- #### Search for CNAME record for a single machine (for A record change RRType parameter value)
   ```
   Get-DnsServerResourceRecord -ZoneName "domain" -ComputerName "dnsservername" -RRType "CName" | select HostName,RecordType,Timestamp,TimeToLive,@{Name='RecordData';  Expression={$_.RecordData.HostNameAlias.ToString()}} | Where {$_.RecordData -match "hostname"}
   ```

- #### List PTR records
   `Get-DnsServerResourceRecord -ZoneName "196.10.in-addr.arpa" -ComputerName "DNSServer"`

- #### Display DNS cache 
   `ipconfig /displaydns` 

- #### Add static route
   `route -p ADD 148.185.75.160 MASK 255.255.255.224 192.168.1.254 `

- #### Delete static route
   `route -p delete 148.185.75.160`

- #### Set IP address
```
   netsh interface ipv4 show interfaces 
   netsh interface ipv4 set address name="PROD" source=static address=x.x.x.x mask=x.x.x.x gateway=x.x.x.x 
   netsh interface ipv4 add dnsserver name="PROD" address=x.x.x.x index=1
```
- #### Change interface matrix
   `get-interface | Set-Interface -Interfaceindex 2 -interfacemetric 30`

- #### force ad replication (pull request , run this command from DC which is out of sync to pull changes)
   `repadmin /syncall /AeD ( A=All Partitions , e=Enterprise( Cross Site ) , D=Identify servers by distinguished name )`

- #### force ad replication (push request)
   `repadmin /syncall /APeD (P=Push)`

- #### vlookup from another sheet
   `=VLOOKUP(A2,Sheet2!$A$1:$W$10,2,FALSE)`




