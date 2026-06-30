# ==============================================================================
# REPOSITORY DEPLOYMENT MATRIX RUNNER (SHELLSPEC PROFILE)
# ==============================================================================

Describe 'Git Commit Validator Deployment'
    prepare_sandbox() {
        SANDBOX_DIR=$(mktemp -d)
        export SANDBOX_DIR

        cd "$SANDBOX_DIR" || exit 1

        mkdir -p .git

        mkdir -p ./deploy
        cp "$SHELLSPEC_PROJECT_ROOT/deploy/install.sh" "$SANDBOX_DIR/install.sh"

        cat "$SANDBOX_DIR/install.sh"
        cat "install.sh"
        pwd
        export _HOOK_CONTENT=$(date +%s%N)
        : > "git_calls.log"
    }

    cleanup_sandbox() {
        if [ -n "$SANDBOX_DIR" ] && [ -d "$SANDBOX_DIR" ]; then
            rm -rf "$SANDBOX_DIR"
        fi
    }

    BeforeEach 'prepare_sandbox'

    AfterEach 'cleanup_sandbox'

    Mock git
        echo "git call: $*" >> "./git_calls.log"

        case "$*" in
            *submodule*add*)
            mkdir -p .submodules/git-commit-validator-submod/hooks/
            echo "$_HOOK_CONTENT" > .submodules/git-commit-validator-submod/hooks/commit-msg
            ;;
        esac
        return 0
    End

    It 'Should invoke the installation process and deploy the hook into a repository without pre-existing hooks'
        When run script install.sh "conventional-commits"

        The output should be present
        The status should be success

        The path ".githooks" should be exist
        The path ".githooks/commit-msg" should be exist

        The contents of file "git_calls.log" should include "git call: config local.core.hooksPath .githooks"
        The contents of file "git_calls.log" should include "git call: config local.commitValidator.format conventional-commits"

        The contents of file ".githooks/commit-msg" should equal "$_HOOK_CONTENT"
    End

    Todo 'Should invoke the installation process and maintain stability when executed on a repository with a pre-installed module hook'

    Todo 'Should invoke the installation process and link the validation rules via the MANUAL hook integration strategy'

    Todo 'Should invoke the installation process and wrap the pre-existing hook via the BEFORE integration strategy to execute validation upstream'

    Todo 'Should invoke the installation process and wrap the pre-existing hook via the AFTER integration strategy to execute validation downstream'
End
