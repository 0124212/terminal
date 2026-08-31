#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Full terminal rice setup - installs apps + deploys configs
.DESCRIPTION
    Installs all required apps via winget/scoop, then copies dotfiles.
    Run as administrator for full access.
.EXAMPLE
    .\install.ps1
#>

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Terminal Rice Setup" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan

# ============================================================
# SECTION 1: Install Apps
# ============================================================

function Install-Winget {
    param([string]$Id, [string]$Name)
    Write-Host "  Installing $Name..." -ForegroundColor Yellow
    winget install --id $Id --accept-source-agreements --accept-package-agreements -e 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  $Name installed" -ForegroundColor Green
    } else {
        Write-Host "  $Name failed or already installed" -ForegroundColor DarkYellow
    }
}

function Install-Scoop {
    param([string]$Name)
    Write-Host "  Installing $Name via scoop..." -ForegroundColor Yellow
    scoop install $Name 2>$null
}

# --- Core Tools ---
Write-Host "`n[1/5] Core Tools" -ForegroundColor Magenta
Install-Winget "JanDeDobbeleer.OhMyPosh" "Oh My Posh"
Install-Winget "Starship.Starship" "Starship"
Install-Winget "Fastfetch-cli.Fastfetch" "Fastfetch"
Install-Winget "sxyazi.yazi" "Yazi"
Install-Winget "karlstav.cava" "Cava"
Install-Winget "Notepad++.Notepad++" "Notepad++"
Install-Winget "WinsiderSS.SystemInformer" "System Informer"

# --- Window Manager ---
Write-Host "`n[2/5] Window Manager" -ForegroundColor Magenta
Install-Winget "glzr-io.glazewm" "GlazeWM"

# --- Browsers ---
Write-Host "`n[3/5] Browsers" -ForegroundColor Magenta
Install-Winget "LibreWolf.LibreWolf" "LibreWolf"

# --- Communication ---
Write-Host "`n[4/5] Communication" -ForegroundColor Magenta
Install-Winget "Element.Element" "Element (Matrix)"
Install-Winget "Telegram.TelegramDesktop" "Telegram"

# --- Utilities ---
Write-Host "`n[5/5] Utilities" -ForegroundColor Magenta
Install-Winget "Parsec.Parsec" "Parsec"
Install-Winget "Surfshark.Surfshark" "Surfshark"

# --- Tacky Borders (manual download) ---
$tackyUrl = "https://github.com/niceDev0908/tacky-borders/releases/latest/download/tacky-borders.exe"
$tackyDir = "$env:USERPROFILE\tacky-borders"
if (-not (Test-Path "$tackyDir\tacky-borders.exe")) {
    Write-Host "  Downloading Tacky Borders..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $tackyDir -Force | Out-Null
    try {
        Invoke-WebRequest -Uri $tackyUrl -OutFile "$tackyDir\tacky-borders.exe" -UseBasicParsing
        Write-Host "  Tacky Borders downloaded" -ForegroundColor Green
    } catch {
        Write-Host "  Tacky Borders download failed - get it from https://github.com/niceDev0908/tacky-borders" -ForegroundColor Red
    }
}

# --- Scoop apps ---
Write-Host "`n[Scoop]" -ForegroundColor Magenta
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "  Installing scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    irm get.scoop.sh | iex
}
Install-Scoop "winfetch"

# ============================================================
# SECTION 2: Deploy Configs
# ============================================================

function Copy-Config {
    param([string]$Source, [string]$Dest)
    $destDir = Split-Path -Parent $Dest
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    if (Test-Path $Dest) {
        Write-Host "  Backing up $Dest -> $Dest.bak" -ForegroundColor Yellow
        Rename-Item $Dest "$Dest.bak" -Force
    }
    Copy-Item $Source $Dest -Force
    Write-Host "  Installed $Dest" -ForegroundColor Green
}

Write-Host "`n[Config] Windows Terminal" -ForegroundColor Magenta
$wtDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (Test-Path $wtDir) {
    Copy-Config "$repoRoot\windows-terminal\settings.json" "$wtDir\settings.json"
} else {
    Write-Host "  Windows Terminal not found, skipping" -ForegroundColor Yellow
}

Write-Host "`n[Config] Oh My Posh" -ForegroundColor Magenta
Copy-Config "$repoRoot\oh-my-posh\catppuccin_mocha.omp.json" "$env:USERPROFILE\.config\oh-my-posh\themes\catppuccin_mocha.omp.json"

Write-Host "`n[Config] Starship" -ForegroundColor Magenta
Copy-Config "$repoRoot\starship\starship.toml" "$env:USERPROFILE\.config\starship.toml"

Write-Host "`n[Config] Yazi" -ForegroundColor Magenta
Copy-Config "$repoRoot\yazi\theme.toml" "$env:USERPROFILE\.config\yazi\theme.toml"
Copy-Config "$repoRoot\yazi\yazi.toml" "$env:USERPROFILE\.config\yazi\yazi.toml"

Write-Host "`n[Config] Cava" -ForegroundColor Magenta
Copy-Config "$repoRoot\cava\config" "$env:USERPROFILE\.config\cava\config"
Copy-Config "$repoRoot\cava\themes\solarized_dark" "$env:USERPROFILE\.config\cava\themes\solarized_dark"
Copy-Config "$repoRoot\cava\themes\tricolor" "$env:USERPROFILE\.config\cava\themes\tricolor"

Write-Host "`n[Config] Fastfetch" -ForegroundColor Magenta
Copy-Config "$repoRoot\fastfetch\config.jsonc" "$env:USERPROFILE\.config\fastfetch\config.jsonc"
Copy-Config "$repoRoot\fastfetch\logo.txt" "$env:USERPROFILE\.config\fastfetch\logo.txt"

Write-Host "`n[Config] Winfetch" -ForegroundColor Magenta
Copy-Config "$repoRoot\winfetch\config.ps1" "$env:USERPROFILE\.config\winfetch\config.ps1"

Write-Host "`n[Config] GlazeWM" -ForegroundColor Magenta
Copy-Config "$repoRoot\glazewm\config.yaml" "$env:USERPROFILE\.glzr\glazewm\config.yaml"

Write-Host "`n[Config] Zebar" -ForegroundColor Magenta
Copy-Config "$repoRoot\zebar\settings.json" "$env:USERPROFILE\.glzr\zebar\settings.json"

Write-Host "`n[Config] Tacky Borders" -ForegroundColor Magenta
Copy-Config "$repoRoot\tacky-borders\config.yaml" "$env:USERPROFILE\.config\tacky-borders\config.yaml"

# ============================================================
# SECTION 3: Shell Profile
# ============================================================

Write-Host "`n[Shell] Configuring PowerShell profile" -ForegroundColor Magenta
$profilePath = $PROFILE
$profileDir = Split-Path -Parent $profilePath
New-Item -ItemType Directory -Path $profileDir -Force | Out-Null

$profileContent = @'
# Oh My Posh
oh-my-posh init pwsh --config "$env:USERPROFILE\.config\oh-my-posh\themes\catppuccin_mocha.omp.json" | Invoke-Expression

# Starship (uncomment to use instead of oh-my-posh)
# Invoke-Expression (&starship init powershell)

# Yazi cd on quit
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content $tmp
    Remove-Item $tmp
    if ($cwd -and $cwd -ne $PWD.Path) {
        Set-Location $cwd
    }
}

# Aliases
Set-Alias -Name ff -Value fastfetch
Set-Alias -Name wf -Value winfetch
Set-Alias -Name cat -Value bat
Set-Alias -Name grep -Value rg
Set-Alias -Name ls -Value eza
'@

if (Test-Path $profilePath) {
    Write-Host "  Backing up $profilePath -> $profilePath.bak" -ForegroundColor Yellow
    Rename-Item $profilePath "$profilePath.bak" -Force
}
Set-Content -Path $profilePath -Value $profileContent -Force
Write-Host "  PowerShell profile configured" -ForegroundColor Green

# ============================================================
# Done
# ============================================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Setup complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Restart your terminal to apply changes." -ForegroundColor Cyan
Write-Host ""
Write-Host "Optional manual steps:" -ForegroundColor Yellow
Write-Host "  1. Set Oh My Posh theme: oh-my-posh config export --output ~/.config/oh-my-posh/themes/catppuccin_mocha.omp.json" -ForegroundColor Gray
Write-Host "  2. Clone Zebar paix widget: git clone https://github.com/niceDev0908/paix ~/.glzr/zebar/paix" -ForegroundColor Gray
Write-Host "  3. Install JetBrainsMono Nerd Font from https://www.nerdfonts.com/" -ForegroundColor Gray
Write-Host "  4. Launch GlazeWM + Tacky Borders on startup" -ForegroundColor Gray
