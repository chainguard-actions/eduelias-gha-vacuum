# Hardening Report: eduelias--gha-vacuum/v0.0.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `ff50f15e4b79bfbf764dafdfd2579175a6ea9771`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **eduelias--gha-vacuum/v0.0.1** was hardened automatically. 4 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The 'Install Vacuum' step downloads and pipes a remote shell script directly to `sh` without first saving it to disk: `curl -fsSL https://quobix.com/scripts/install_vacuum.sh | sh`. If the remote URL is compromised or the connection is intercepted, arbitrary code will execute on the runner with no opportunity to inspect the script.

Locations:

- `action.yaml:11`

### script-injection (severity: high)

The 'Run OpenAPI Linter' step interpolates the attacker-controlled input `${{ inputs.cmd }}` directly inside a `run:` shell block. Any caller can supply arbitrary shell commands via the `cmd` input, leading to full remote code execution on the runner. The input must be assigned to an environment variable and referenced as `$ENV_VAR` instead.

Locations:

- `action.yaml:14`

### suspicious-run-content (severity: high)

Sub-check: obfuscated-exec. The 'Install Vacuum' step pipes the output of a remote URL directly to a shell interpreter (`curl -fsSL https://quobix.com/scripts/install_vacuum.sh | sh`), matching the pattern `curl ... | sh`. This is a common technique used to hide and execute malicious payloads fetched from an attacker-controlled or compromised server.

Locations:

- `action.yaml:11`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cmd }}" appears directly in run: block of step "Run OpenAPI Linter"; move to env: map

Locations:

- `action.yml:16`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, suspicious-run-content, script-injection, static-inline-injection

**Notes:**

Fixed action.yaml with two changes: (1) Replaced `curl -fsSL https://quobix.com/scripts/install_vacuum.sh | sh` with a download-then-execute pattern that saves the script to /tmp/install_vacuum.sh, runs it, then deletes it — eliminating the curl-pipe-to-shell anti-pattern. (2) Moved `${{ inputs.cmd }}` from the run: block into an env: variable (VACUUM_CMD: ${{ inputs.cmd }}) and referenced it as $VACUUM_CMD in the shell script, preventing script injection via attacker-controlled input.

