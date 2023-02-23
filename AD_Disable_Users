# Scripts disables AD users and move them to different OU

#Import Active Directort Module

Import-Module ActiveDirectory

#Import CSV

$path = split-path -Parent $MyInvocation.MyCommand.Definition
$newpath = $path + ".\Users.csv"
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

  
    if ($(get-aduser $sam).enabled -eq $true)
    {
        Write-Host " User $($sam) is Enabled , Disabling Account" -ForegroundColor Yellow
        Get-ADUser -identity $line.samaccountname | Move-ADObject -Targetpath $ou
        Get-ADUser -identity $line.samaccountname | Set-ADUser -description $description
        Get-ADUser -identity $line.samaccountname | Disable-ADAccount
    } 
 
             
    else 
    {
        write-host " User $($sam) already disabled " -ForegroundColor Green
    }   

    #************************************
    #Check if Computer is in correct OU
    #************************************
   
    if ($checklocation = Get-ADUser -filter "Name -eq '$sam'" -SearchBase "OU=Users,OU=Disabled Accounts,DC=ad,DC=plc,DC=cwintra,DC=com")
    {
        write-host " User $($sam) is in the correct OU" -ForegroundColor Green
    }

    else {
        write-host "User $($sam) is in incorrect OU, Moving to Correct OU" -ForegroundColor Yellow
        Get-ADUser -identity $line.samaccountname | Move-ADObject -Targetpath $ou
    } 
 
}
    


Stop-Transcript