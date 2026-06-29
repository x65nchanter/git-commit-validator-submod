# ==============================================================================
# CONVENTIONAL COMMITS SPECIFICATION TEST SUITE (SHELLSPEC PROFILE)
# ==============================================================================

Describe 'Conventional Commits Formatting Specification Engine'
  Include "lib/formats/conventional-commits"

  Describe 'With compliant commit message formatting profiles'
    It 'validates a compliant structural header configuration without a scope block'
      When call validate_format "feat: add baritone api integration"
      The status should be success
    End

    It 'validates a compliant structural header featuring a scope block and breaking change marker'
      When call validate_format "fix(client)!: resolve severe jvm runtime memory leak"
      The status should be success
    End

    It 'validates a compliant multi-line format payload with double line-break layout decoupling'
      local message_payload="feat(core): implement look process rotation

This body block articulates the technical intent behind the adjustment
and is safely wrapped beneath the strict 72-character threshold constraint."

      When call validate_format "$message_payload"
      The status should be success
    End
  End

  Describe 'With non-compliant commit message formatting profiles'
    It 'rejects a header payload length that violates the maximum 50-character constraint boundary'
      When call validate_format "feat(client): this description string is intentionally engineered to be far too long for execution"
      The status should be failure
      The output should include "[VALIDATION ERROR] Header length exceeds constraint"
    End

    It 'rejects non-compliant uppercase characters detected within the target type prefix'
      When call validate_format "Feat(core): structural lowercase constraint violation"
      The status should be failure
      The output should include "[VALIDATION ERROR] Header syntax mismatch or uppercase chars detected in type/scope."
    End

    It 'rejects a structural formatting violation due to a forbidden trailing period character'
      When call validate_format "chore(deps): upgrade gradle compiler runtime target."
      The status should be failure
      The output should include "[VALIDATION ERROR] Header length exceeds constraint"
    End

    It 'rejects a structural layout breakdown due to missing double line-break body decoupling'
      local message_payload="fix(xvfb): remove sudo execution wrapper
This contextual body description row is improperly placed directly beneath the header."

      When call validate_format "$message_payload"
      The status should be failure
      The output should include "[VALIDATION ERROR] Structural violation: Header must be decoupled from the body via an empty line."
    End

    It 'rejects a payload configuration containing an internal body line exceeding the 72-character limit'
      local message_payload="style(core): enforce uniform indentation layouts

This row within the body payload is compliant
however this specific execution line is structurally non-compliant due to running far beyond the seventy-two character wrap boundary."

      When call validate_format "$message_payload"
      The status should be failure
      The output should include "exceeds the 72-character boundary limit"
    End
  End
End
