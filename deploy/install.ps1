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
$GIT_DIR = (git rev-parse --absolute-git-dir)

Write-Host "[*] Initializing 'git-commit-validator-submod' infrastructure..." -ForegroundColor Cyan

if (-not (Test-Path -Path $GIT_DIR)) {
    Write-Error "Deployment failed: Host environment is not a root Git repository.`nAction required: Execute this runner strictly from the target repository root."
    exit 1
}

Write-Host "[*] Registering and linking downstream Git submodule..." -ForegroundColor Yellow
if (-not (Test-Path -Path "$GIT_DIR/modules/git-commit-validator-submod")) {
    git submodule add --force https://github.com/x65nchanter/git-commit-validator-submod $GIT_DIR/modules/git-commit-validator-submod 2>$null
}
git submodule update --init --recursive -- $GIT_DIR/modules/git-commit-validator-submod

if (Test-Path -Path "$GIT_DIR/modules/git-commit-validator-submod/hooks/commit-msg") {
    New-Item -ItemType SymbolicLink -Path "$GIT_DIR/hooks/commit-msg" -Target "$GIT_DIR/modules/git-commit-validator-submod/bin/hooks/commit-msg" -Force
}

Write-Host "[*] Mapping local core.hooksPath configuration to submodule directory..." -ForegroundColor Yellow

git config local.core.hooksPath "$GIT_DIR/hooks"

Write-Host "[*] Provisioning active profile: '$ProfileName'..." -ForegroundColor Yellow
git config local.commitValidator.format $ProfileName

Write-Host "[SUCCESS] Deployment complete. The Git pipeline is now securely routed to the submodule hooks.`n" -ForegroundColor Green
