# Assign variables
$BraveSyncCode = "flower fabric copper fence solution obvious zebra proof van salute chronic senior crazy note regret door mean soldier such rather you harvest dress head "
$GitHubProfile = "https://github.com/larpios"
$VSCodeSettingsDestination = "$env:APPDATA\Code\User\settings.json"
$GitHubDestination = "$Home/Desktop/GitHub"
$Repo = "$GitHubProfile/pwsh_setup"
$FilesPath = "$Repo/raw/main/Files"


$ProfileItem = @{
  Name = "Microsoft.PowerShell_profile.ps1"
  Path = "$FilesPath/$ProfileName"
}

$WeztermItem = @{
  Name = ".wezterm.lua"
  Path = "$FilesPath/$WeztermName"
}

$RepoToGet = "obsidian-vault", @{Name = "nvim-config"; Path = "$env:LOCALAPPDATA/nvim"}

$ProgramgsToGet = "brave", "bitwarden", "obsidian", "wezterm", "powershell-core", "neovim", "oh-my-posh", "mingw", "obs-studio", "nerd-fonts-agave", "ueli", "ripgrep", "lazygit", "winget"

function Install-Chocolatey
{
  Set-ExecutionPolicy Bypass -Scope Process -Force;
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-Programs
{
  # Install Programs using Chocolatey
  Write-Output "Installing Chocolatey..."
  Install-Chocolatey
  Write-Output "Successfully Installed Chocolatey!"
  Write-Output "Installing programs using Chocolatey..."
  choco install -y @ProgramgsToGet
  Write-Output "Successfully Installed programs using Chocolatey!"

}

function Setup-Git
{
  # if git is not installed, install git using chocolatey
  if (-not(Get-Command "git" -ErrorAction SilentlyContinue))
  {
    Write-Error "git is not installed."
    Write-Output "Install git"
    choco install -y git
  }
  Write-Output "Setting up Git..."

  # git config
  git config --global user.name "larpios"
  git config --global user.email "larpios@protonmail.com"

  # git clone 
  New-Item -ItemType Directory -Path $GitHubDestination | Out-Null
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

}


# Make PowerShell Profile
New-Item $PROFILE -Force
Invoke-WebRequest $ProfileItem.Path -OutFile $ProfileItem.Name | Copy-Item -Destination $PROFILE -Force

# Put brave sync code
$BraveSyncCode > $Home/Desktop/brave.txt
Write-Output "Brave Sync Code is made on Desktop"

Install-Programs

Setup-Git


# Wezterm Config
Invoke-WebRequest $WeztermPath -OutFile $WeztermName | Copy-Item -Destination $Home -Force
Write-Output "Wezterm Config file is made"


Write-Output "Done!"

