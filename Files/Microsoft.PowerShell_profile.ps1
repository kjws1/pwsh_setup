oh-my-posh init pwsh --config "C:\Program Files (x86)\oh-my-posh\themes\kushal.omp.json" | Invoke-Expression

if (Test-Path "C:\Program Files\Neovim\bin\nvim.exe")
{

    Set-Alias -Name vim -Value "C:\Program Files\Neovim\bin\nvim.exe"
} else
{
    Set-Alias -Name vim -Value "C:\tools\Neovim\bin\nvim.exe"
}


