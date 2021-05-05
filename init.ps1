if (0 -eq (Get-Module RoyalDocument.Powershell -ListAvailable).Count) {
    Install-Module -Name RoyalDocument.PowerShell -Scope CurrentUser
}

Import-Module RoyalDocument.PowerShell
