$GitHub_Profile = "https://github.com/larpios"
$GitHub_Destination = "~\GitHub"
if (-not (Test-Path -Path $GitHub_Destination)) {
    New-Item -ItemType Directory -Path $GitHub_Destination | Out-Null
}
$Repo = "$GitHub_Profile/pwsh_setup"
$Profile_path = "$Repo/raw/main/Microsoft.PowerShell_profile.ps1"
$Settings_path = "$Repo/raw/main/settings.json"
$Settings_Destination = (Get-ChildItem -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview*\LocalState).FullName + "\settings.json"

function Add-Font {
    # Define the URL of the font file
    $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Agave.zip"

    # Define the path to the downloaded file
    $fontFile = "Agave.zip"

    # Download the font file
    Invoke-WebRequest -Uri $fontUrl -OutFile $fontFile

    # Unzip the font file
    Expand-Archive -Path $fontFile -DestinationPath "."

    # Define the path to the font file
    $fontPath = "./Agave.ttf"

    # Install the font
    $shell = New-Object -ComObject Shell.Application
    $fontFolder = $shell.Namespace(0x14)
    $fontFolder.CopyHere($fontPath)

}

function Install-Chocolatey {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-Font {
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/raw/master/install.ps1" -UseBasicParsing -OutFile font.ps1
    font.ps1 Agrave
}


# Git Config
git config --global user.name "larpios"
git config --global user.email "larpios@protonmail.com"
Start-Job -ScriptBlock { git clone "$GitHub_Profile/obsidian-vault" $GitHub_Destination } 

# Make PowerShell Profile
$TempFile = "$env:TEMP\Microsoft.PowerShell_profile.ps1"
Invoke-WebRequest -Uri $profile_path -OutFile $TempFile
Copy-Item -Path $TempFile -Destination $PROFILE -Force
# Specify the destination folder for the PowerShell profile
$ProfileDestination = "$env:USERPROFILE\Documents\PowerShell"

# Create the destination folder if it doesn't exist
if (-not (Test-Path -Path $ProfileDestination)) {
    New-Item -ItemType Directory -Path $ProfileDestination | Out-Null
}

# Copy the downloaded settings file to the PowerShell profile location
Copy-Item -Path $TempFile -Destination $ProfileDestination -Force

Remove-Item $TempFile

# Install Programs using Chocolatey
Install-Chocolatey
Start-Job -ScriptBlock { choco install -y "bitwarden" } 
Start-job -ScriptBlock { choco install -y "brave" }
Start-job -ScriptBlock { choco install -y "obsidian" }
Start-job -ScriptBlock { choco install -y "oh-my-posh" }
Start-job -ScriptBlock { choco install -y "obs-studio" }
Start-Job -ScriptBlock { choco install -y "nerd-fonts-agave" } 
choco install -y "winget"

# Install Programs using winget
Start-job -ScriptBlock { winget install "Microsoft.WindowsTerminal.Preview" }
Start-job -ScriptBlock { winget install "Microsoft.PowerShell" }

$TempFile = "$env:TEMP\settings.json"
Invoke-WebRequest -Uri $Settings_path -OutFile $TempFile
Copy-Item -Path $TempFile -Destination $Settings_Destination -Force
Remove-Item -Path $TempFile


Get-Job | Wait-Job
Write-Output "Done!"