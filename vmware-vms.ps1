#Clear-Host
. $PSScriptRoot\init.ps1
$documents=[Environment]::GetFolderPath("MyDocuments")
Remove-Variable Servers -ErrorAction SilentlyContinue

$Servers=Import-Csv $PSScriptRoot\vmnetinfo.csv

# Create a RoyalStore in memory
$royalStore = New-RoyalStore -UserName ($env:USERDOMAIN + '\' + $env:USERNAME)

#create a RoyalDocument in memory
$documentName = "VMWare-VMs"
$documentPath = Join-Path -Path $documents -ChildPath ('\' + $documentName + '.rtsz')
$royalDocument = New-RoyalDocument -Store $royalStore -Name $documentName -FileName $documentPath

$Servers=$Servers|Sort-Object -Property OS
# Handle vms that do not report an OS
$Groups=$Servers|Select-Object -Property OS -Unique -ExpandProperty OS | Where-Object {$true -eq $_.OS }

Foreach ($GroupName in $Groups) {
    $RoyalFolder = New-RoyalObject -Type RoyalFolder -Folder $royalDocument -Name "$GroupName" -Description "$GroupName"
    $RFolderMembers=$Servers|Where-Object {$_.OS -eq $GroupName}
    if ($GroupName -like '*windows*') {$ConnType='RoyalRDSConnection'}
    else {$connType='RoyalSSHConnection'}
    Foreach ($GroupComputer in $RFolderMembers) {
        $GroupComputer
        $RDSConnection = New-RoyalObject -Type $ConnType -Folder $RoyalFolder -Name $GroupComputer.Name -Description $GroupComputer.IPv4
        $RDSConnection | Set-RoyalObjectValue -Property URI -Value $GroupComputer.IPv4 | Out-Null
        $RDSConnection | Set-RoyalObjectValue -Property CredentialFromParent -Value $true | Out-Null
    }
}

# Write to disk
Out-RoyalDocument -Document $royalDocument
