## Conventional Commits

A standardized formatting layout designed to enforce structural consistency across repository history.

## Message Structure

\<type\>(\<scope\>): <short description in the imperative mood>

[Optional detailed body explaining the contextual reasoning "why" and "what for"]

[Optional footer mapping to issue trackers or exposing breaking changes]

## Standard Commit Types (\<type\>)

| Type | Intended Use Case | Production Example |
|---|---|---|
| feat | Introduces new functionality or feature components | feat(client): add baritone api integration |
| fix | Patches a bug, defect, or critical execution error | fix(supervisor): remove sudo from xvfb execution |
| chore | Updates to dependencies, Gradle tooling, build tools, or configurations | chore(gradle): add babbaj repo to settings.gradle.kts |
| docs | Modifies documentation artifacts or README manifests exclusively | docs(readme): document websocket json api formats |
| style | Code formatting, structural indentation, or semi-colon adjustments (zero logic shift) | style(core): reformat websocket handler indentation |
| refactor | Code structural alterations that neither fix a defect nor introduce a feature | refactor(network): optimize netty channel write flushing |
| perf | Performance tuning modifications designed to optimize runtime execution speeds | perf(network): replace heavy string operations with static byte buffers |
| test | Adds missing test suites, automated unit-testing matrices, or refactors assertions | test(core): add websocket endpoint payload structure validation test |
| build | Changes affecting the root compilation layer, external tooling, or layout tasks | build(gradle): upgrade kotlin toolchain compiler target to jvm 21 |
| ci | Modifications to CI/CD pipelines, container runtime orchestrations, or deploy scripts | ci(podman): fix volume mounting path for windows host |

## Directives

1. **Imperative Mood in Headers.**
   * Use action verbs: `add`, `fix`, `remove`, `change`.
   * Avoid past tenses or continuous forms: `added`, `fixes`, `removed`, `changing`.
   * *Rationale:* The header string must logically complete the phrase: *"If applied, this commit will [action required]... add baritone API"*.
2. **50-Character Header Constraint.** Keep descriptions precise, high-density, and omit trailing periods.
3. **Double Line-Break Body Decoupling.** Separate the message header from the body with an empty line. The body text must articulate the technical **intent and motivation** behind the alteration, rather than the raw implementation layer. Enforce a strict **72-character limit per line** within the body block.
4. **Lower-Case Convention.** The commit type and scope prefix components must be written exclusively in lower-case formats (e.g., `feat(client): ...`).

### Example of Valid Commit:

```text
chore(client): add baritone dependency and fix look commands

- Downloaded baritone-api-fabric-1.11.2.jar into local libs folder.
- Configured babbaj maven repository for automatic nether-pathfinder resolve.
- Removed strict supervisor user privileges preventing xvfb from starting.
- Added raw baritone look command support to websocket route handler.

See also: #12
```

*Note: If the format is violated, the Git commit process will be blocked immediately, and a colorized corrective hint will be printed to the console.*

---
