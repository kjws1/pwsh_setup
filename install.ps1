$VSCodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
$GitHubProfile = "https://github.com/larpios"
$GitHubDestination = "$Documents/GitHub"
if (-not (Test-Path -Path $GitHubDestination))
{
  New-Item -ItemType Directory -Path $GitHubDestination | Out-Null
}
$Repo = "$GitHubProfile/pwsh_setup"
$ProfilePath = "$Repo/raw/main/Files/Microsoft.PowerShell_profile.ps1"
$SettingsPath = "$Repo/raw/main/Files/settings.json"
$SettingsDestination = (Get-ChildItem -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview*\LocalState).FullName + "\settings.json"
# Specify the destination folder for the PowerShell profile
$ProfileDestination = "$env:USERPROFILE/Documents/PowerShell"

function Install-Chocolatey
{
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}


$RepoToGet = "obsidian-vault", @{Name = "nvim-config"; Path = "$env:LOCALAPPDATA/nvim"}

# Git Config
git config --global user.name "larpios"
git config --global user.email "larpios@protonmail.com"
foreach ($elem in $RepoToGet)
{
  if ($elem.GetType() -eq "Hashtable")
  {
    git clone "$GitHubProfile/$( $elem.Name )" $elem.Path
  }
  git clone "$GitHubProfile/$elem" "$GitHubDestination/$elem"
}


$ProgramgsToGet = "bitwarden", "brave", "obsidian", "wezterm", "powershell-core", "oh-my-posh", "mingw", "obs-studio", "nerd-fonts-agave", "winget" 

# Make PowerShell Profile
$TempFile = "$env:TEMP\Microsoft.PowerShellprofile.ps1"
Invoke-WebRequest $ProfilePath -OutFile $TempFile
Copy-Item -Path $TempFile -Destination $PROFILE -Force

# Create the destination folder if it doesn't exist
if (-not (Test-Path -Path $ProfileDestination))
{
  New-Item -ItemType Directory -Path $ProfileDestination | Out-Null
}

# Copy the downloaded settings file to the PowerShell profile location
Copy-Item -Path $TempFile -Destination $ProfileDestination -Force

Remove-Item $TempFile

# Install Programs using Chocolatey
Install-Chocolatey
choco install -y @ProgramgsToGet.

$TempFile = "$env:TEMP\settings.json"
Invoke-WebRequest -Uri $Settingspath -OutFile $TempFile
Copy-Item -Path $TempFile -Destination $SettingsDestination -Force
Remove-Item -Path $TempFile

Write-Output "Done!"












