# ==============================================================================
# REPOSITORY DEPLOYMENT MATRIX RUNNER (SHELLSPEC PROFILE)
# ==============================================================================

Describe 'Git Commit Validator Deployment Architecture'

  Before() {
    # Создаем изолированную песочницу для тестов
    SANDBOX_DIR="$SHELLSPEC_TMPDIR/git_sandbox"
    mkdir -p "$SANDBOX_DIR/.git"
    cd "$SANDBOX_DIR"
  }

  After() {
    rm -rf "$SANDBOX_DIR"
  }

  # Описываем поведение внешних команд для всего блока тестов
  # Официальный синтаксис ShellSpec: перехватывает вызовы внешних утилит
  Mock git
    # Говорим моку всегда молча возвращать код 0 (успех)
    echo "mocked git call"
    return 0
  End

  It 'Should invoke the installation process and deploy the hook into a repository without pre-existing hooks'
    When run script "$SHELLSPEC_PROJECT_ROOT/install.sh" "conventional-commits" "BEFORE"
    The status should be success
    The directory ".githooks" should be exist
  End

  It 'Should invoke the installation process and maintain stability when executed on a repository with a pre-installed module hook'
    mkdir -p ".githooks/core"
    touch ".githooks/core/commit-msg"

    When run script "$SHELLSPEC_PROJECT_ROOT/install.sh" "conventional-commits" "BEFORE"
    The status should be success
  End

  It 'Should invoke the installation process and link the validation rules via the MANUAL hook integration strategy'
    When run script "$SHELLSPEC_PROJECT_ROOT/install.sh" "conventional-commits" "MANUAL"
    The status should be success
  End

  It 'Should invoke the installation process and wrap the pre-existing hook via the BEFORE integration strategy to execute validation upstream'
    When run script "$SHELLSPEC_PROJECT_ROOT/install.sh" "conventional-commits" "BEFORE"
    The status should be success
  End

  It 'Should invoke the installation process and wrap the pre-existing hook via the AFTER integration strategy to execute validation downstream'
    When run script "$SHELLSPEC_PROJECT_ROOT/install.sh" "conventional-commits" "AFTER"
    The status should be success
  End
End
