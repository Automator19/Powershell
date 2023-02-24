#Parameters
$TenantAdminURL = "https://zzz-admin.sharepoint.com/"

#Prequisits pnp
Install-Module -Name "PnP.PowerShell"
Register-PnPManagementShellAccess

#set context to query ALL site- for single site(input value here)
$Cred = Get-Credential
Connect-PnPOnline -Url $TenantAdminURL -Credentials $Cred

#connect to spo to ensure sufficient permissions for all sites
Connect-SPOService -url $TenantAdminURL -credential $Cred

$Allsites = Get-SPOSite -Limit All

foreach ($collection in $Allsites) {

    Set-SPOUser -Site $collection.url -LoginName "username@domain.com" -IsSiteCollectionAdmin $True
}

