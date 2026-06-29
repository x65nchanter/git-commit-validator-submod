# ==============================================================================
# REPOSITORY DEPLOYMENT MATRIX RUNNER (SHELLSPEC PROFILE)
# ==============================================================================

Describe 'Git Commit Validator Deployment'
    Before() {
        export _HOOK_CONTENT=$(date +%s%N)
        export _EXPECTED_HOOKS_PATH=""
        export _EXPECTED_VALIDATOR_FORMAT=""
    }

    Mock git
        case "$*" in
            *submodule*add*)
            mkdir -p .submodules/git-commit-validator-submod/hooks/
            touch .submodules/git-commit-validator-submod/hooks/commit-msg
            echo "$_HOOK_CONTENT" > .submodules/git-commit-validator-submod/hooks/commit-msg
            ;;
        esac

        case "$*" in
            *config*local.core.hooksPath*)
            _EXPECTED_HOOKS_PATH=$(echo "$*" | awk '{print $NF}')
            ;;
            *config*local.commitValidator.format*)
            _EXPECTED_VALIDATOR_FORMAT=$(echo "$*" | awk '{print $NF}')
            ;;
        esac

        echo "mocked git call: $*"
        return 0
    End

    It 'Should invoke the installation process and deploy the hook into a repository without pre-existing hooks'
        When run script "install.sh" "conventional-commits"
        The status should be success
        The directory ".githooks" should be exist
        The file ".githooks/commit-msg" should be exist
        The variable _EXPECTED_HOOKS_PATH should equal ".githooks"
        The variable _EXPECTED_VALIDATOR_FORMAT should equal "conventional-commits"
        The contents of file ".githooks/commit-msg" should equal _HOOK_CONTENT
    End

    Todo 'Should invoke the installation process and maintain stability when executed on a repository with a pre-installed module hook'

    Todo 'Should invoke the installation process and link the validation rules via the MANUAL hook integration strategy'

    Todo 'Should invoke the installation process and wrap the pre-existing hook via the BEFORE integration strategy to execute validation upstream'

    Todo 'Should invoke the installation process and wrap the pre-existing hook via the AFTER integration strategy to execute validation downstream'
End
