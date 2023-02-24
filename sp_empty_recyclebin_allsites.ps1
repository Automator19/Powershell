#########################################################################
# SCRIPT WILL EMPTY RECYCLE BIN FROM ALL RI SITE COLLECTIONS - BE CAREFUL
##########################################################################

#Import PnP Module for Powershell
if (!(Get-Module -Name PnP.PowerShell)) { Write-host "PNP Module already Installed" } else { Install-Module -Name PnP.PowerShell -scope CurrentUser }
if (!(Get-Module -name Microsoft.Online.SharePoint.PowerShell )) { Write-Host "SharePoint Module already installed" } else { Install-Module -Name Microsoft.Online.SharePoint.PowerShell -force -scope CurrentUser }
Set-ExecutionPolicy -ExecutionPolicy bypass -Scope CurrentUser -Force

$AdminURL = "https://zzz-admin.sharepoint.com/"
$Cred = Get-Credential

# connect to sharepoint site
$ConnectURL = Connect-SPOService -Url $AdminURL -Credential $cred
   
# Get Site Collection
$Allsites = Get-SPOSite -Limit All | select -first 1 

foreach ($Collection in $AllSites) {
     
    $URL = $collection.url
    # connect to sharepoint site
    $SiteURL = Connect-PnPOnline -Url $URL -Credentials $cred -ReturnConnection
    
    # List Files from Second stage Recycle bin and display total size
    # Get-PnPRecycleBinItem -SecondStage -connection $SiteURL | select Title, ItemType, Size, ItemState, DirName, deleteddate | ft -AutoSize
    $SSDeletedFileSize = Get-PnPRecycleBinItem -SecondStage -connection $SiteURL | Measure-Object -Property Size -Sum | select sum
    $SSDeletedFileSizebytes = ($SSDeletedFileSize).sum
    $SSDeletedFileSizeGB = ($SSDeletedFileSize).sum / 1GB
    
    
    # List Files from First stage Recycle bin and display total size
    # Get-PnPRecycleBinItem -FirstStage -connection $SiteURL | select Title, ItemType, Size, ItemState, DirName, deleteddate | ft -AutoSize
    $FSDeletedFileSize = Get-PnPRecycleBinItem -FirstStage -connection $SiteURL | Measure-Object -Property Size -Sum | select sum
    $FSDeletedFileSizebytes = ($FSDeletedFileSize).sum
    $FSDeletedFileSizeGB = ($FSDeletedFileSize).sum / 1GB
	
    # Delete files from First and Second Stage Recycle Bin
    # Clear-PnPRecycleBinItem -All -connection $SiteURL -force

    # Delete files from second stage recycle bin
    #Clear-PnPRecycleBinItem -secondstageonly -connection $SiteURL -all -force
    
} 