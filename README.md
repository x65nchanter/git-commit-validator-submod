# git-commit-validator-submod

A lightweight, language-agnostic, and cross-platform Git hook designed to enforce the **Conventional Commits** (or any other in future) specification across heterogeneous development environments.

Works natively with any codebase (**Rust**, **C# Unity**, **Java**, **Go**, **C++**, **Python**) and runs seamlessly on **Windows**, **Linux**, and **macOS** with zero external dependencies.

---

## 🏗️ Architecture (Wire-Installation)

This validator is deployed as a native Git submodule. The one-time installation script decouples the environment by reconfiguring the local `core.hooksPath` of the host repository to point directly to the submodule's directory. 

### Key Benefits:
*   **No Runtime Dependencies:** Completely independent of package managers (such as `npm/husky` or `python/pre-commit`).
*   **Deterministic Workflows:** Hook updates occur strictly on-demand when a developer manually triggers `git submodule update`. Zero hidden background network requests.

---

## 🚀 One-Line Installation

Execute the appropriate command in your terminal **strictly from the root directory** of your target Git repository:

### On Windows (PowerShell / pwsh):
```powershell
irm https://githubusercontent.com | iex
```

### On Linux / macOS (Bash):
```bash
curl -sSL https://githubusercontent.com | bash
```

---

## 🛠️ On-Demand Updates

To update the hook rules to the latest revision within your active project, fetch the remote submodule updates manually via standard Git tracking:

```bash
git submodule update --remote --merge
```
The host repository will instantly start executing the newly pulled hook rules.

---

## 📄 License

This repository is licensed under **The Unlicense**. All source code is dedicated to the public domain. It can be copied, modified, published, used, compiled, or distributed by anyone for any purpose, commercial or non-commercial, by any means.
