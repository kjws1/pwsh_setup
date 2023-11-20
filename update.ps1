. .\var.ps1
<#
$VSCodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
$GitHubProfile = "https://github.com/larpios"
$GitHubDestination = "~/GitHub"
if (-not (Test-Path -Path $GitHub_Destination))
{
  New-Item -ItemType Directory -Path $GitHub_Destination | Out-Null
}
$Repo = "$GitHub_Profile/pwsh_setup"
$ProfilePath = "$Repo/raw/main/Microsoft.PowerShell_profile.ps1"
$SettingsPath = "$Repo/raw/main/settings.json"
$SettingsDestination = (Get-ChildItem -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview*\LocalState).FullName + "\settings.json"
# Specify the destination folder for the PowerShell profile
$ProfileDestination = "$env:USERPROFILE/Documents/PowerShell"
#>
$FilesPath = "./Files/"
$FilesToGet = $VSCodeSettingsPath, $ProfilePath

foreach ($elem in $FilesToGet)
{
  Copy-Item -Path $elem -Destination $FilesToGet
}




