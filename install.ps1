function Install-Chocolatey {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-Program-Choco {
    param (
        [string] $Name
    )
    choco install -y $Name
}
Set-Alias -Name "choco install -y" -Value "Install-Program-Choco"

function Install-Program-Winget {
    param (
        [string] $Id
    )
    winget install -y $Id
}
Set-Alias -Name "winget install" -Value "Install-Program-Winget"

$Repo = "https://github.com/larpios/pwsh_setup"
$Profile_path = "$Repo/raw/main/Microsoft.PowerShell_profile.ps1"
$Settings_path = "$Repo/raw/main/settings.json"
$Settings_Destination = (Get-ChildItem -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview*\LocalState).FullName + "\settings.json"

# Git Config
git config --global user.name "larpios"
git config --global user.email "larpios@protonmail.com"

Invoke-WebRequest $profile_path -OutFile $PROFILE
Install-Chocolatey
Start-Job -ScriptBlock { choco install -y "bitwarden" } 
Start-job -ScriptBlock { choco install -y "brave" }
Start-job -ScriptBlock { choco install -y "obsidian" }
Start-job -ScriptBlock { choco install -y "oh-my-posh" }
choco install -y "winget"

Start-job -ScriptBlock { winget install "Microsoft.WindowsTerminal.Preview" }
Start-job -ScriptBlock { winget install "Microsoft.PowerShell" }

$TempFile = "$env:TEMP\settings.json"
Invoke-WebRequest -Uri $Settings_path -OutFile $TempFile
Copy-Item -Path $TempFile -Destination $Settings_Destination -Force
Remove-Item -Path $TempFile