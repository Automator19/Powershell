# removing user from all groups on AD, script uses csv file for user input

# Import-CSV

$path = split-path -Parent $MyInvocation.MyCommand.Definition
$newpath = $path + ".\Groups.csv"
$csv = @()
$CSV = Import-CSV -Path $newpath

# Logs

$Timestamp = Get-date -format dd-mm-yyyy_HH:mm:ss
Start-Transcript -Path $path\$timestamp.txt. -append


foreach ( $line in $csv) {
    $groupname = $line.groupname
    $user = $line.username
    $members = Get-ADGroup -identity $groupname | Get-ADGroupMember -Recursive | Select -ExcludeProperty Name

    if ($members -contains $user) {
        write-host "$user is member of $groupname..Removing from the Group" -ForegroundColor Yellow
        Remove-ADGroupMember -Identity $groupname -Members $user
    }
    else { 
        write-host "$user is not member of $groupname !!" -ForegroundColor Green
    }
}


Stop-Transcript