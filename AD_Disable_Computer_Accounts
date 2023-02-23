#Import Active Directort Module

Import-Module ActiveDirectory

#Import CSV

$path = split-path -Parent $MyInvocation.MyCommand.Definition
$newpath = $path + ".\Computers.csv"
$csv = @()
$CSV = Import-CSV -Path $newpath

# Logs

$timestamp = Get-Date -format yyyy.MM.dd-hh.mm.ss
Start-Transcript -Path $path\$timestamp.txt -append



foreach ($line in $csv) {

    $computer = $line.name
    $ou = $line.ou
    $description = $line.description
    $dn = $line.DistinguishedName
    $sam = $line.SamAccountName

    #************************************
    #Check if Computer Account Status
    #************************************

    if ($(get-adcomputer ($line.samaccountname)).enabled -eq $true)
    {
        Write-Host " Computer $($sam) is Enabled , Disabling Account" -ForegroundColor Yellow
        Get-ADComputer -identity $line.samaccountname | Disable-ADAccount
        Get-ADComputer -identity $line.samaccountname | Set-ADComputer -description $description
    } 
      
    else {
        write-host " Computer $($sam) already disabled " -ForegroundColor Green
    }   

    #************************************
    #Check if Computer is in correct OU
    #************************************
   
    if ($checklocation = Get-ADComputer -filter "Name -eq '$sam'" -SearchBase "OU=Computers,OU=Disabled Accounts,DC=ad,DC=plc,DC=cwintra,DC=com")
    {
        write-host " Computer $($sam) is in the correct OU" -ForegroundColor Green
    }

    else {
        write-host "Computer $($sam) is in incorrect OU, Moving to Correct OU" -ForegroundColor Yellow
        Get-ADComputer -identity $line.samaccountname | Move-ADObject -Targetpath $ou
    } 
 
}

Stop-Transcript