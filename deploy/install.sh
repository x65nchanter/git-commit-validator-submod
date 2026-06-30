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
GIT_DIR=$(git rev-parse --absolute-git-dir)

echo -e "\033[33m[*] Registering and linking downstream Git submodule...\033[0m"
git submodule add --force https://github.com/x65nchanter/git-commit-validator-submod $GIT_DIR/modules/git-commit-validator-submod 2>/dev/null || true
git submodule update --init --recursive -- $GIT_DIR/modules/git-commit-validator-submod


if [ ! -d "$GIT_DIR/hooks" ]; then
    mkdir -p $GIT_DIR/hooks
fi

if [ -f "$GIT_DIR/modules/git-commit-validator-submod/hooks/commit-msg" ]; then
    ln -sf $GIT_DIR/modules/git-commit-validator-submod/hooks/commit-msg $GIT_DIR/hooks/commit-msg
fi


if [ -f "$GIT_DIR/hooks/commit-msg" ]; then
    chmod +x $GIT_DIR/hooks/commit-msg
    chmod +x $GIT_DIR/modules/git-commit-validator-submod/formats/* 2>/dev/null || true
fi

echo -e "\033[33m[*] Mapping local core.hooksPath configuration to submodule directory...\033[0m"
git config --local core.hooksPath "$GIT_DIR/hooks"

echo -e "\033[33m[*] Provisioning active profile: '$SELECTED_PROFILE'...\033[0m"
git config --local commitValidator.format "$SELECTED_PROFILE"

echo -e "\033[32m[SUCCESS] Deployment complete. The Git pipeline is now securely routed to the submodule hooks.\033[0m\n"
