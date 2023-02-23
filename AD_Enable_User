# Script enables AD user which was disabled previously

param
(
    [Parameter(Mandatory = $true)]
    [string]$Username,

    [Parameter(Mandatory = $true)]
    [string]$INC
)

Import-Module ActiveDirectory
$sam = (Get-aduser $username).samaccountname
$checkCRQ = get-aduser $username -Properties * | select description
$Description = "Account Enabled - $INC"
$checkstatus = Get-ADUser $username | select enabled
$ou = "OU=Users,OU=Standard,DC=ad,DC=domain,DC=com"

#************************************
#Check User Account Status
#************************************

  
if (
        (($checkstatus).enabled -eq $false) -and ( ($checkCRQ).description -eq "User_Disabled")
)
{
    Write-Host "Previous Account Properties" -ForegroundColor Yellow
    Get-ADUser $sam -Properties * | fl SamAccountName, Enabled, Description, Distinguishedname
    Write-Host " User $($sam) is Disabled , Enabling User Account" -ForegroundColor Yellow
    Get-ADUser -identity $sam | Set-ADUser -description $description
    Get-ADUser -identity $sam | Enable-ADAccount
} 
 
             
else 
{
    write-host " User $($sam) already Enabled or user account was not disabled under CRQ000000 - see details below " -ForegroundColor Red
    Get-ADUser $sam -Properties * | fl SamAccountname, Enabled, Description
    Read-Host -prompt "Press Enter to Exit"
    break;
}   

#************************************
#Check if User is in correct OU
#************************************

$checklocation = Get-ADUser -filter "samaccountname -eq '$sam'" -SearchBase "OU=Users,OU=Standard,DC=ad,DC=domain,DC=com"
   
if ($checklocation -ne $null)
{
    write-host " User $($sam) is in the correct OU" -ForegroundColor Green
}

else {
    write-host "User $($sam) is in incorrect OU, Moving to Correct OU" -BackgroundColor Yellow
    Get-ADUser -identity $sam | Move-ADObject -Targetpath $ou
    sleep -Seconds 10
               

} 

Write-Host "Current Account Properties" -BackgroundColor Green
sleep -Seconds 10
Get-ADUser $sam -Properties * | fl SamAccountName, Enabled, Description, Distinguishedname
    
 
# This line is to stop PS window closing
Read-Host -prompt "Press Enter to Exit"