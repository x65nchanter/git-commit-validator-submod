Describe "Git Commit Validator Windows Installer Specification" {
    BeforeAll {
        $Script:SandboxPath = Join-Path ([System.IO.Path]::GetTempPath()) "Git_Installer_Sandbox"
        if (Test-Path $Script:SandboxPath) { Remove-Item $Script:SandboxPath -Recurse -Force }
        $null = New-Item -ItemType Directory -Path (Join-Path $Script:SandboxPath ".git") -Force

        Copy-Item "$PSScriptRoot\install.ps1" -Destination $Script:SandboxPath

        function git {
            throw "Should be mocked"
        }

        $sandbox = $Script:SandboxPath

        Mock git {
            switch ($args[0]) {
                'rev-parse' {
                    return (Join-Path $sandbox ".git")
                }

                default {
                    return 0
                }
            }
        }
    }

    AfterAll {
        if ($PSScriptRoot) { Set-Location $PSScriptRoot }

        if ($Script:SandboxPath -and (Test-Path $Script:SandboxPath)) {
            Remove-Item $Script:SandboxPath -Recurse -Force
        }
    }

    It "Should invoke the installation process and deploy the hook into a repository without pre-existing hooks" {
        Push-Location $Script:SandboxPath

        { .\install.ps1 -ProfileName "conventional-commits" } | Should -Not -Throw

        Should -Invoke -CommandName 'git' -Exactly 1 -ParameterFilter {
            $args -match 'config' -and $args -match '--local' -and $args -match 'core.hooksPath'
        }
        Should -Invoke -CommandName 'git' -Exactly 1 -ParameterFilter {
            $args -match 'config' -and $args -match '--local' -and $args -match 'commitValidator.format' -and $args -match 'conventional-commits'
        }

        Pop-Location
    }

    It "Should invoke the installation process and maintain stability when executed on a repository with a pre-installed module hook" -Pending {

    }

    It "Should invoke the installation process and link the validation rules via the MANUAL hook integration strategy" -Pending {

    }

    It "Should invoke the installation process and wrap the pre-existing hook via the BEFORE integration strategy to execute validation upstream" -Pending {

    }

    It "Should invoke the installation process and wrap the pre-existing hook via the AFTER integration strategy to execute validation downstream" -Pending {

    }
}
