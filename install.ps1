# ==============================================================================
# SUBMODULE DEPLOYMENT RUNNER (POWERSHELL)
# ==============================================================================
# Usage: .\install.ps1 [-ProfileName <string>] [-HookStrategy <MANUAL|BEFORE|AFTER>]
# Example: .\install.ps1 -ProfileName conventional-commits
# ==============================================================================

param (
    [Parameter(Mandatory=$false, Position=0)]
    [string]$ProfileName = "conventional-commits",

    [Parameter(Mandatory=$false, Position=1)]
    [ValidateSet("MANUAL", "BEFORE", "AFTER")]
    [string]$HookStrategy = "BEFORE"
)

$ErrorActionPreference = "Stop"

Write-Host "[*] Initializing 'git-commit-validator-submod' infrastructure..." -ForegroundColor Cyan

# 1. Enforce validation of the active working directory context
if (-not (Test-Path -Path ".git")) {
    Write-Error "Deployment failed: Host environment is not a root Git repository.`nAction required: Execute this runner strictly from the target repository root."
    exit 1
}

# 2. Inject and synchronize the tracked Git submodule asset
Write-Host "[*] Registering and linking downstream Git submodule..." -ForegroundColor Yellow
if (-not (Test-Path -Path ".submodules/git-commit-validator-submod")) {
    git submodule add --force https://github.com/x65nchanter/git-commit-validator-submod .submodules/git-commit-validator-submod 2>$null
}
git submodule update --init --recursive -- .submodules/git-commit-validator-submod

# 3. Decouple local execution vectors via core.hooksPath mutation
Write-Host "[*] Mapping local core.hooksPath configuration to submodule directory..." -ForegroundColor Yellow
git config local.core.hooksPath ".githooks"

# 4. Apply pre-configured operational validation target profiles
Write-Host "[*] Provisioning active profile: '$ProfileName'..." -ForegroundColor Yellow
git config local.commitValidator.format $ProfileName

Write-Host "[SUCCESS] Deployment complete. The Git pipeline is now securely routed to the submodule hooks.`n" -ForegroundColor Green
