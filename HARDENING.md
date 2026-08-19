<!-- markdownlint-disable -->

# Hardening Report: eduelias--gha-vacuum/v0.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **eduelias--gha-vacuum/v0.0.1** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The 'Install Vacuum' step pipes a remote script directly to a shell interpreter: `curl -fsSL https://quobix.com/scripts/install_vacuum.sh | sh > /dev/null`. This pattern executes whatever content is served at that URL without any integrity verification, making the action vulnerable to supply-chain attacks if the remote host or URL is compromised.

Locations:

- `action.yaml:12`

### script-injection (severity: high)

Rule (a) violation: The 'Run OpenAPI Linter' step interpolates the caller-controlled input `${{ inputs.cmd }}` directly inside a `run:` shell command block. Because YAML template substitution happens before the shell sees the string, an attacker can supply a value containing shell metacharacters (`;`, `&&`, `|`, `$(...)`, etc.) to execute arbitrary commands on the runner. The input must never be interpolated directly; instead it should be passed via an `env:` variable and then double-quoted in the script.

Locations:

- `action.yaml:15`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cmd }}" appears directly in run: block of step "Run OpenAPI Linter"; move to env: map

Locations:

- `action.yml:16`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, script-injection, static-inline-injection

**Notes:**

Fixed action.yaml with two changes: (1) unsafe-shell: replaced `curl ... | sh` with downloading the install script to a mktemp file, executing it, then removing it — no more piping from the internet directly to a shell; (2) script-injection/static-inline-injection: moved `${{ inputs.cmd }}` out of the run: block into an env: variable (INPUT_CMD), then tokenized it with xargs into a bash array (to handle quoted sub-commands correctly) and expanded the array — this prevents shell metacharacter injection while preserving correct argument splitting for the vacuum command.

