# Create multiple security groups using csv file 
Import-Module ActiveDirectory 
#Import CSV 
$path = Split-Path -parent $MyInvocation.MyCommand.Definition  
$newpath = $path + "\groups.csv" 
$csv = @() 
$csv = Import-Csv -Path $newpath 
 
#Get Domain Base 
$searchbase = Get-ADDomain | ForEach { $_.DistinguishedName } 
 
#Loop through all items in the CSV 
ForEach ($item In $csv) { 
    #Check if the OU exists 
    $check = [ADSI]::Exists("LDAP://$($item.GroupLocation),$($searchbase)") 
   
    If ($check -eq $True) { 
        Try { 
            #Check if the Group already exists 
            $exists = Get-ADGroup $item.GroupName   
            Write-Host "Group $($item.GroupName) alread exists! Group creation skipped!" -ForegroundColor Red
        } 
        Catch { 
            #Create the group if it doesn't exist 
            $create = New-ADGroup -Name $item.GroupName -GroupScope $item.GroupType -Path ($($item.GroupLocation) + "," + $($searchbase)) 
            Write-Host "Group $($item.GroupName) created!" -ForegroundColor Yellow
        } 
    } 
    Else { 
        Write-Host "Target OU can't be found! Group creation skipped!" -ForegroundColor Red
    } 
}