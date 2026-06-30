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

### Project Verification
Verify the core validator functionality and rule specifications. On POSIX-compliant systems, invoke the primary automated orchestrator natively:
```bash
shellspec
```

To ensure consistency across diverse host environments, leverage an OCI-compliant container to execute the verification suite in an isolated Linux workspace:
```powershell
podman run --rm -v ".:/src:Z" shellspec/shellspec
```

### Shell Deployment Verification
Validate the integrity of the deployment scripts and lifecycle workflows. Execute the verification suite natively via:
```bash
shellspec deploy/
```

Alternatively, perform validation within a containerized environment to simulate deployment behavior:
```powershell
podman run --rm -v ".:/src:Z" shellspec deploy/
```

### PowerShell Deployment Verification
Verify the Windows installer specifications and deployment logic. Invoke the Pester test suite natively:
```powershell
Invoke-Pester ./deploy/install.Tests.ps1
```

Alternatively, perform validation within a containerized environment to simulate deployment behavior:
```powershell
podman run --rm -v ".:/src:Z" -w /src mcr.microsoft.com/powershell:latest pwsh -Command "Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser; Import-Module Pester -Force; Invoke-Pester -Path ./deploy/install.Tests.ps1 -Output Detailed"
```

---

## Development Engineering Directives

When modifying hooks runtime files or provisioning a new verification profile plugin inside the `lib/formats/` subdirectory, ensure strict compliance with these paradigms:

1.  **POSIX Standards:** The hooks (`bin/hooks/commit-msg`) and formatting modules must utilize pure POSIX-compliant Bash syntax. Avoid regional or non-standard shell wrappers.
2.  **Strategy Decoupling:** Do NOT hardcode regular expressions inside the `bin/hooks/` folder. All custom parsing layouts must be contained inside isolated strategy modules within `lib/formats/` exposing the `validate_format` interface.
3.  **Local subshell mitigation:** When processing multi-line structures or buffers, loop using input streams or process substitutions (`while read ... done < <(command)`), instead of piping via stdout (`command | while read`), to protect return code pipeline delivery states.
