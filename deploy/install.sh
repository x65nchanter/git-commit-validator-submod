#!/usr/bin/env sh

# ==============================================================================
# SUBMODULE DEPLOYMENT RUNNER (SHELL)
# ==============================================================================
# Usage: ./install.sh [validation_profile]
# Example: ./install.sh conventional-commits
# ==============================================================================

set -e

echo -e "\033[36m[*] Initializing 'git-commit-validator-submod' infrastructure...\033[0m"

if [ ! -d ".git" ]; then
    echo -e "\033[31m[ERROR] Deployment failed: Host environment is not a root Git repository.\033[0m"
    echo -e "Action required: Execute this runner strictly from the target repository root.\n"
    exit 1
fi

SELECTED_PROFILE="${1:-conventional\-commits}"


echo -e "\033[33m[*] Registering and linking downstream Git submodule...\033[0m"
git submodule add --force https://github.com/x65nchanter/git-commit-validator-submod .submodules/git-commit-validator-submod 2>/dev/null || true
git submodule update --init --recursive -- .submodules/git-commit-validator-submod

if [ ! -d ".githooks" ]; then
    mkdir -p .githooks
fi

if [ -f ".submodules/git-commit-validator-submod/hooks/commit-msg" ]; then
    ln -sf .submodules/git-commit-validator-submod/hooks/commit-msg .githooks/commit-msg
fi

if [ -f ".githooks/commit-msg" ]; then
    chmod +x .githooks/commit-msg
    chmod +x .submodules/git-commit-validator-submod/formats/* 2>/dev/null || true
fi

echo -e "\033[33m[*] Mapping local core.hooksPath configuration to submodule directory...\033[0m"
git config local.core.hooksPath ".githooks"

echo -e "\033[33m[*] Provisioning active profile: '$SELECTED_PROFILE'...\033[0m"
git config local.commitValidator.format "$SELECTED_PROFILE"

echo -e "\033[32m[SUCCESS] Deployment complete. The Git pipeline is now securely routed to the submodule hooks.\033[0m\n"
