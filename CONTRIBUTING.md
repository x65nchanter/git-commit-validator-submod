# Developer Contribution & Testing Guidelines

This document outlines the repository architectural layouts, testing matrix pipelines, and development standards for the `git-commit-validator-submod`.

---

## Architectural Directory Layout

The project adheres to a strict Strategy Pattern design layer. The file system structure is organized as follows:

```text
git-commit-validator-submod/
├── bin/                     # Executable tools and scripts
├── deploy/                 # Deployment scripts and test suites
│   ├── install.sh          # Unified Bash deployment runner (Linux / macOS)
│   ├── install.Tests.ps1   # Unified PowerShell deployment runner (Windows)
│   └── install_spec.sh     # ShellSpec test suite for deployment
├── docs/                    # Documentation
├── lib/                     # Shared libraries and utility functions
├── spec/                   # Tool logic test suites
│   ├── spec_helper.sh      # Shared test helpers
│   └── ...                 # Tool-specific logic tests
├── .github/                # CI/CD workflows
└── .shellspec              # ShellSpec global configuration
```

---

## Testing Matrices

To ensure backward compatibility and protect runtime stability across updates, all functional changes must pass the internal automated verification suites.

### Isolated Container Verification (Recommended for Cross-Platform Dev)
To execute tests within an isolated Linux environment regardless of your host Operating System (Windows or Linux), leverage the local OCI-compliant container configuration.

Execute this pipeline sequence using **Podman** or **Docker**:

```powershell
podman run --rm -v ".:/workspace:Z" -w /workspace shellspec/shellspec
```

### POSIX Native Environment (Linux / macOS)
Grant execution access and invoke the primary automated orchestrator tool natively:

```bash
shellspec
```

### Windows Native Environment (PowerShell Prerequisites)
Before running the native Windows test suite, ensure your local environment is upgraded to **Pester v5+**. The legacy version (v3.4) bundled with Windows will reject the modern assertion syntax.

Update Pester to v5 version:
```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser
```

Once updated, trigger the test suite specification matrix:
```powershell
# Re-importing ensures the freshly installed user module takes precedence
Import-Module Pester -Force
Invoke-Pester ./install.Tests.ps1
```

---

## Development Engineering Directives

When modifying hooks runtime files or provisioning a new verification profile plugin inside the `lib/formats/` subdirectory, ensure strict compliance with these paradigms:

1.  **POSIX Standards:** The hooks (`bin/.githooks/commit-msg`) and formatting modules must utilize pure POSIX-compliant Bash syntax. Avoid regional or non-standard shell wrappers.
2.  **Strategy Decoupling:** Do NOT hardcode regular expressions inside the `bin/.githooks/` folder. All custom parsing layouts must be contained inside isolated strategy modules within `lib/formats/` exposing the `validate_format` interface.
3.  **Local subshell mitigation:** When processing multi-line structures or buffers, loop using input streams or process substitutions (`while read ... done < <(command)`), instead of piping via stdout (`command | while read`), to protect return code pipeline delivery states.
