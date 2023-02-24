#Import PnP Module for Powershell
if ((Get-Module -Name PnP.PowerShell)) { Write-host "PNP Module already Installed" -F Green } else { Install-Module -Name PnP.PowerShell -scope CurrentUser }
if ((Get-Module -ListAvailable "Microsoft.Online.SharePoint.PowerShell")) { Write-Host "SharePoint Module already installed" -f Green } else { Install-Module Microsoft.Online.SharePoint.PowerShell -force }
Set-ExecutionPolicy -ExecutionPolicy bypass -Scope CurrentUser -Force

$AdminURL = "https://zzz-admin.sharepoint.com/"
$Cred = Get-Credential

# connect to sharepoint site
$ConnectURL = Connect-SPOService -Url $AdminURL -Credential $cred
   
# Get Site Collection
$Allsites = Get-SPOSite -Limit All 
Write-host (get-date)  ":Generating Storage Usage Report for All Sites" -ForegroundColor Green

$output = foreach ($Collection in $AllSites) {
    
    $URL = $collection.url

    # Grant Admin Access to Site
    Set-SPOUser -Site $collection.url -LoginName "adminuser@domain.com" -IsSiteCollectionAdmin $True | Out-Null

    # connect to sharepoint site
    $SiteURL = Connect-PnPOnline -Url $URL -Credentials $cred -ReturnConnection

     
    # List Files from Second stage Recycle bin and display total size
    # Get-PnPRecycleBinItem -SecondStage -connection $SiteURL | select Title, ItemType, Size, ItemState, DirName, deleteddate | ft -AutoSize
    $SSDeletedFileSize = Get-PnPRecycleBinItem -SecondStage -connection $SiteURL | Measure-Object -Property Size -Sum | select sum
   
    # List Files from First stage Recycle bin and display total size
    # Get-PnPRecycleBinItem -FirstStage -connection $SiteURL | select Title, ItemType, Size, ItemState, DirName, deleteddate | ft -AutoSize
    $FSDeletedFileSize = Get-PnPRecycleBinItem -FirstStage -connection $SiteURL | Measure-Object -Property Size -Sum | select sum
   
    
    #  Storage Usage (in MB)

    $SC = Get-SPOSite -Identity $URL | select StorageUsageCurrent, StorageQuota
       
    New-Object psobject -Property @{

        URL                    = $collection.url
        Total_Storage          = $($sc.StorageUsageCurrent) * 1MB / 1GB
        Storage_Quota          = $($sc.StorageQuota) * 1MB / 1GB
        FirstStage_RecycleBin  = ($FSDeletedFileSize).sum / 1GB
        SecondStage_RecycleBin = ($SSDeletedFileSize).sum / 1GB
    }

    $SiteURL = $null
} 

$output | Export-csv -NoTypeInformation C:\tmp\SPExport.csv