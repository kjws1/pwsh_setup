# Assign variables
$BraveSyncCode = "flower fabric copper fence solution obvious zebra proof van salute chronic senior crazy note regret door mean soldier such rather you harvest dress head "
$GitHubProfile = "https://github.com/larpios"
$VSCodeSettingsDestination = "$env:APPDATA\Code\User\settings.json"
$GitHubDestination = "$Home/Desktop/GitHub"
$ProfileDestination = "$env:USERPROFILE/Documents/PowerShell"
$Repo = "$GitHubProfile/pwsh_setup"
$FilesPath = "$Repo/raw/main/Files"

if (-not (Test-Path -Path $GitHubDestination))
{
  New-Item -ItemType Directory -Path $GitHubDestination | Out-Null
}

$ProfilePath = "$FilesPath/Microsoft.PowerShell_profile.ps1"
$WeztermPath = "$FilesPath/.wezterm.lua"

function Install-Chocolatey
{
  Set-ExecutionPolicy Bypass -Scope Process -Force;
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}


$RepoToGet = "obsidian-vault", @{Name = "nvim-config"; Path = "$env:LOCALAPPDATA/nvim"}

$ProgramgsToGet = "brave", "bitwarden", "obsidian", "wezterm", "powershell-core", "neovim", "oh-my-posh", "mingw", "obs-studio", "nerd-fonts-agave", "winget", "ueli", "ripgrep", "lazygit"

# Make PowerShell Profile
New-Item $PROFILE -Force
Copy-Item -Path $ProfilePath -Destination $PROFILE -Force

# Put brave sync code
$BraveSyncCode > $Home/Desktop/brave.txt
Write-Output "Brave Sync Code is made on Desktop"

# Install Programs using Chocolatey
Write-Output "Installing Chocolatey..."
Install-Chocolatey
Write-Output "Successfully Installed Chocolatey!"
Write-Output "Installing programs using Chocolatey..."
choco install -y @ProgramgsToGet
Write-Output "Successfully Installed programs using Chocolatey!"

# Wezterm Config

Copy-Item $WeztermPath $Home/
Write-Output "Wezterm Config file is made"

# Git Config
Write-Output "Setting up Git..."
git config --global user.name "larpios"
git config --global user.email "larpios@protonmail.com"
foreach ($elem in $RepoToGet)
{
  if ($elem.GetType().Name -eq "Hashtable")
  {
    git clone "$GitHubProfile/$( $elem.Name )" $elem.Path
  } else
  {
    git clone "$GitHubProfile/$elem" "$GitHubDestination/$elem"
  }
}
Write-Output "Successfully set up Git!"

Write-Output "Done!"
