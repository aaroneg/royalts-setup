Clear-Host
. $PSScriptRoot\init.ps1
$documents=[Environment]::GetFolderPath("MyDocuments")
Remove-Variable Servers -ErrorAction SilentlyContinue
# Get AD Computer objects for servers. Select some properties that aren't normally there|Select only the properties we want to see|Sort the object list by server name.
$Servers=Get-ADComputer -Filter 'OperatingSystem -like "*Server*"' -Properties Name,Description,OperatingSystem,DNSHostname|Select-Object Name,Description,OperatingSystem,DNSHostname|Sort-Object -Property Name
# $Servers|Sort-Object -Property OperatingSystem

# Create a RoyalStore in memory
$royalStore = New-RoyalStore -UserName ($env:USERDOMAIN + '\' + $env:USERNAME)

#create a RoyalDocument in memory
$documentName = "WindowsConnections"
$documentPath = Join-Path -Path $documents -ChildPath ('\' + $documentName + '.rtsz')
$royalDocument = New-RoyalDocument -Store $royalStore -Name $documentName -FileName $documentPath

$Servers=$Servers|Sort-Object -Property OperatingSystem
$Groups=$Servers|Select-Object -Property OperatingSystem -Unique -ExpandProperty OperatingSystem

Foreach ($GroupName in $Groups) {
    $RoyalFolder = New-RoyalObject -Type RoyalFolder -Folder $royalDocument -Name "$GroupName" -Description "$GroupName"

    $RFolderMembers=$Servers|Where-Object {$_.OperatingSystem -eq $GroupName}
    Foreach ($GroupComputer in $RFolderMembers) {
        $RDSConnection = New-RoyalObject -Type RoyalRDSConnection -Folder $RoyalFolder -Name $GroupComputer.Name -Description $GroupComputer.DNSHostname
        $RDSConnection | Set-RoyalObjectValue -Property URI -Value $GroupComputer.DNSHostname | Out-Null
        $RDSConnection | Set-RoyalObjectValue -Property CredentialFromParent -Value $true | Out-Null
    }
}

# Write to disk
Out-RoyalDocument -Document $royalDocument
