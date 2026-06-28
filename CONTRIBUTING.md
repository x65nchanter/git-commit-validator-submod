# Developer Contribution & Testing Guidelines

This document outlines the repository architectural layouts, testing matrix pipelines, and development standards for the `git-commit-validator-submod`.

---

## Architectural Directory Layout

The project adheres to a strict Strategy Pattern design layer. The file system structure is organized as follows:

```text
git-commit-validator-submod/
├── hooks/
│   └── commit-msg         # Intercepts the Git pipeline and routes verification.
├── formats/               # Strategy Module Directory (Validation Plugins)
│   └── conventional-commits    # Active profile plugin for Conventional Commits validation.
├── tests/                 # Test Coverage layer
│   ├── test_helper/       # Downstream submodules (e.g., Bats testing framework framework).
│   └── conventional_commits.bats  # Automated functional test matrices.
├── install.sh             # Unified Bash deployment runner (Linux / macOS).
├── install.ps1            # Unified PowerShell deployment runner (Windows).
└── run_tests.sh           # Main automated test orchestration tool.
```

---

## Testing Matrices

To ensure backward compatibility and protect runtime stability across updates, all functional changes must pass the internal automated verification suites.

### Isolated Container Verification (Recommended for Cross-Platform Dev)
To execute tests within an isolated Linux environment regardless of your host Operating System (Windows or Linux), leverage the local OCI-compliant container configuration.

Execute this pipeline sequence using **Podman** or **Docker**:

```powershell
podman run --rm -v ".:/workspace:Z" -w /workspace shellspec/shellspec --chdir /workspace spec/
```

### POSIX Native Environment (Linux / macOS)
Grant execution access and invoke the primary automated orchestrator tool natively:

```bash
chmod +x run_tests.sh
./run_tests.sh
```

### Windows Native Environment (PowerShell Prerequisites)
Before running the native Windows test suite, ensure your local environment is upgraded to **Pester v5+**. The legacy version (v3.4) bundled with Windows will reject the modern assertion syntax.

Run this update command inside your `pwsh` terminal:
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

When modifying hooks runtime files or provisioning a new verification profile plugin inside the `formats/` subdirectory, ensure strict compliance with these paradigms:

1.  **POSIX Standards:** The hooks (`hooks/commit-msg`) and formatting modules must utilize pure POSIX-compliant Bash syntax. Avoid regional or non-standard shell wrappers.
2.  **Strategy Decoupling:** Do NOT hardcode regular expressions inside the `hooks/` folder. All custom parsing layouts must be contained inside isolated strategy modules within `formats/` exposing the `validate_format` interface.
3.  **Local subshell mitigation:** When processing multi-line structures or buffers, loop using input streams or process substitutions (`while read ... done < <(command)`), instead of piping via stdout (`command | while read`), to protect return code pipeline delivery states.
