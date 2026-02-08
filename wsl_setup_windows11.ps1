<#
Tailored WSL setup script for Windows 11 Home (build 26200) - drop-in ready.
Run this PowerShell script as Administrator.
#>

function Ensure-Elevated {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host "Not running as Administrator. Relaunching elevated..." -ForegroundColor Yellow
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = "powershell"
        $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
        $psi.Verb = "runas"
        try {
            [System.Diagnostics.Process]::Start($psi) | Out-Null
        } catch {
            Write-Error "Elevation cancelled or failed. Re-run this script as Administrator."
        }
        exit
    }
}

Ensure-Elevated

Write-Host "Detecting OS and build..." -ForegroundColor Cyan
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "Detected: $($os.Caption)  Version: $($os.Version)  Build: $($os.BuildNumber)" -ForegroundColor Green

Write-Host "Enabling required Windows features (WSL + VirtualMachinePlatform)..." -ForegroundColor Cyan
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Write-Host "Attempting to set WSL default version to 2..." -ForegroundColor Cyan
try {
    wsl --set-default-version 2 2>$null
} catch {
    Write-Warning "Could not set default WSL version using 'wsl --set-default-version 2'. If this fails, ensure you have the WSL kernel installed: https://aka.ms/wsl2kernel"
}

# Preferred distro to install
$desiredDistro = 'Ubuntu-22.04'

Write-Host "Checking for existing WSL distros..." -ForegroundColor Cyan
try {
    $installed = wsl -l -v 2>$null
} catch {
    $installed = $null
}

if ($installed -and $installed -match $desiredDistro) {
    Write-Host "$desiredDistro already installed." -ForegroundColor Green
} else {
    Write-Host "Installing $desiredDistro..." -ForegroundColor Cyan
    try {
        wsl --install -d $desiredDistro
    } catch {
        Write-Warning "Automatic install failed. You can install manually with: wsl --install -d $desiredDistro or from the Microsoft Store." 
    }
}

Write-Host "Setup steps completed. You may need to reboot if features were just enabled." -ForegroundColor Green
Write-Host "To list installed distros: wsl -l -v" -ForegroundColor Yellow
Write-Host "To open the distro shell: wsl -d $desiredDistro" -ForegroundColor Yellow
Write-Host "If you need the WSL kernel installer: https://aka.ms/wsl2kernel" -ForegroundColor Yellow

exit 0
