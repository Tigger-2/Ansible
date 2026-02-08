# WSL Setup Checklist

This file provides concise, copy-pasteable steps to set up WSL2 on a Windows laptop.

Prerequisites
- Windows 10 (2004 / build 19041+) or Windows 11
- Virtualization enabled in BIOS/UEFI
- Run PowerShell as Administrator for privileged commands

Quick automatic install (recommended on recent Windows builds)
```powershell
# Installs WSL, the default distro (Ubuntu), and sets WSL2
wsl --install

# Install a specific distro (example: Ubuntu 22.04)
wsl --install -d Ubuntu-22.04
```

Manual step-by-step (if `wsl --install` fails)
```powershell
# Enable WSL and Virtual Machine Platform, then reboot
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Restart-Computer

# After reboot, if prompted, install/update the WSL2 kernel from:
# https://aka.ms/wsl2kernel

# Set default WSL version to 2
wsl --set-default-version 2

# List available distros
wsl --list --online

# Install a distro (example)
wsl --install -d Ubuntu
```

Verify and use
```powershell
# List installed distros and WSL versions
wsl -l -v

# Launch default distro shell
wsl

# Launch a specific distro
wsl -d Ubuntu
```

Post-install (inside the Linux distro)
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential curl git
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Optional / Helpful
- Install Windows Terminal via `winget`:
```powershell
winget install --id Microsoft.WindowsTerminal -e
```
- Update WSL components later:
```powershell
wsl --update
```

Troubleshooting
- If `wsl --install` fails: run the DISM commands above, reboot, install the kernel update, then `wsl --set-default-version 2`.
- If virtualization is disabled: enable VT-x / AMD-V in BIOS/UEFI.
- For GUI support ensure you have WSLg (Windows 11 or latest WSL on Windows 10 with WSLg support).

References
- Official WSL docs: https://aka.ms/wsl
- Kernel update: https://aka.ms/wsl2kernel

---
If you want, I can tailor these commands to your exact Windows build or add a PowerShell one-liner that checks prerequisites automatically.

Tailored script for your machine
- Script added for your Windows 11 Home build: `wsl_setup_windows11.ps1`.
- To run (open an elevated PowerShell as Administrator):
```powershell
# from the repository root
powershell -ExecutionPolicy Bypass -File .\wsl_setup_windows11.ps1
```
- The script will enable required features, attempt to set WSL2 as default, and install `Ubuntu-22.04`.
- If you prefer a different distro, edit the `$desiredDistro` variable inside the script.
