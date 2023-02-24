#Parameters
param
(
    [Parameter(Mandatory = $true)]
    [string]$URL,
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.PSCredential]$cred
)

#Logs
$path = Split-Path -Parent $MyInvocation.MyCommand.Definition
$timestamp = Get-Date -format yyyy.MM.dd-hh.mm.ss
Start-Transcript -Path $path\Logs\$timestamp.txt -append

#Import PnP Module for Powershell
if (!(Get-Module -Name PnP.PowerShell)) { Write-host "Module already Installed" } else { Install-Module -Name PnP.PowerShell -scope CurrentUser }
Set-ExecutionPolicy -ExecutionPolicy bypass -Scope CurrentUser -Force

# connect to sharepoint site
$SiteURL = Connect-PnPOnline -Url $URL -Credentials $cred -ReturnConnection
Write-host "Connected to $($URL)" -ForegroundColor Green

# List Files from Second stage Recycle bin and display total size
Get-PnPRecycleBinItem -SecondStage -connection $SiteURL | select Title, ItemType, Size, ItemState, DirName, deleteddate | ft -AutoSize
$DeletedFileSize = Get-PnPRecycleBinItem -SecondStage -connection $SiteURL | Measure-Object -Property Size -Sum | select sum
$DeletedFileSizebytes = ($DeletedFileSize).sum
$DeletedFileSizeGB = ($DeletedFileSize).sum / 1GB
Write-host "SecondStage Recyclebin size (Bytes) = $($DeletedFileSizebytes) for $($URL)" -ForegroundColor Yellow
Write-host "SecondStage Recyclebin size (GB) = $($DeletedFileSizeGB) for $($URL)" -ForegroundColor Yellow

# Delete files from second stage recycle bin
Clear-PnPRecycleBinItem -secondstageonly -connection $SiteURL -all -force

#Disconnect from sharepoint site
$SiteURL = $null

Stop-Transcript