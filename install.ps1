# Assign variables
$GitHubProfile = "https://github.com/larpios"
$VSCodeSettingsDestination = "$env:APPDATA\Code\User\settings.json"
$GitHubDestination = "$Documents/GitHub"
$ProfileDestination = "$env:USERPROFILE/Documents/PowerShell"
$Repo = "$GitHubProfile/pwsh_setup"
if (-not (Test-Path -Path $GitHubDestination))
{
  New-Item -ItemType Directory -Path $GitHubDestination | Out-Null
}
if ($Host.Name -eq "ServerRemoteHost")
{
  $ProfilePath = "$Repo/raw/main/Files/Microsoft.PowerShell_profile.ps1"
} else
{
  $ProfilePath = "./Files/Microsoft.PowerShell_profile.ps1"
}

function Install-Chocolatey
{
  Set-ExecutionPolicy Bypass -Scope Process -Force;
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}


$RepoToGet = "obsidian-vault", @{Name = "nvim-config"; Path = "$env:LOCALAPPDATA/nvim"}

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


$ProgramgsToGet = "bitwarden", "brave", "obsidian", "wezterm", "powershell-core", "neovim", "oh-my-posh", "mingw", "obs-studio", "nerd-fonts-agave", "winget" 

# Make PowerShell Profile
if ($Host.Name -eq "ServerRemoteHost")
{
  $TempFile = "$env:TEMP\Microsoft.PowerShellprofile.ps1"
  Invoke-WebRequest $ProfilePath -OutFile $TempFile
  Copy-Item -Path $TempFile -Destination $PROFILE -Force
} else
{
  Copy-Item -Path $ProfilePath -Destination $PROFILE -Force
}


# Install Programs using Chocolatey
Write-Output "Installing Chocolatey..."
Install-Chocolatey
Write-Output "Successfully Installed Chocolatey!"
Write-Output "Installing programs using Chocolatey..."
choco install -y @ProgramgsToGet
Write-Output "Successfully Installed programs using Chocolatey!"

Write-Output "Done!"













