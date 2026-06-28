#!/usr/bin/env sh

# ==============================================================================
# SUBMODULE DEPLOYMENT RUNNER
# ==============================================================================
# Usage: ./install.sh [validation_profile]
# Example: ./install.sh conventional-commits
# ==============================================================================

set -e

echo -e "\033[36m[*] Initializing 'git-commit-validator-submod' infrastructure...\033[0m"

# 1. Enforce validation of the active working directory context
if [ ! -d ".git" ]; then
    echo -e "\033[31m[ERROR] Deployment failed: Host environment is not a root Git repository.\033[0m"
    echo -e "Action required: Execute this runner strictly from the target repository root.\n"
    exit 1
fi

# 2. Extract input payload or execute fallback assignment
SELECTED_PROFILE="${1:-conventional\-commits}"

# 3. Inject and synchronize the tracked Git submodule asset
echo -e "\033[33m[*] Registering and linking downstream Git submodule...\033[0m"
git submodule add --force https://github.com/x65nchanter/git-commit-validator-submod .githooks 2>/dev/null || true
git submodule update --init --recursive -- .githooks

# 4. Decouple local execution vectors via core.hooksPath mutation
echo -e "\033[33m[*] Mapping local core.hooksPath configuration to submodule directory...\033[0m"
git config local.core.hooksPath ".githooks"

# 5. Enforce target filesystem runtime execution permissions
if [ -f ".githooks/core/commit-msg" ]; then
    chmod +x .githooks/core/commit-msg
    chmod +x .githooks/formats/* 2>/dev/null || true
fi

# 6. Apply pre-configured operational validation target profiles
echo -e "\033[33m[*] Provisioning active profile: '$SELECTED_PROFILE'...\033[0m"
git config local.commitValidator.format "$SELECTED_PROFILE"

echo -e "\033[32m[SUCCESS] Deployment complete. The Git pipeline is now securely routed to the submodule hooks.\033[0m\n"
