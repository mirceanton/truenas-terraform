# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Personal TrueNAS server configuration, managed as Infrastructure-as-Code with OpenTofu and orchestrated by
Terragrunt, deployed GitOps-style via GitHub Actions.

## Tooling

All CLI tools (opentofu, terragrunt, task, gh, glow, actionlint, yamlfmt, op, awscli, uv, node) are pinned via
[mise](https://mise.jdx.dev) — run `mise install` once before working in this repo. CI invokes commands through
`mise exec --`.

## Commands

Run via [Task](https://taskfile.dev) (`Taskfile.yaml` includes `.taskfiles/lint.yaml` as `lint` and
`.taskfiles/terragrunt.yaml` as `tg`):

- `task lint` (aliases `fix`, `all`) — runs actionlint, yamlfmt, and `terragrunt hcl format`, auto-fixing issues.
- `task lint:check` — same checks in check-only mode (no modifications); this is what CI runs.
- `task tg:plan` — `terragrunt run --all -- plan` across every unit, then renders a per-unit summary table via
  `.github/scripts/generate-comment.py` and prints it with `glow`.
- `task tg:apply` — same as above but `apply -auto-approve`.

There is no application code or test suite here — validation is linting plus `terragrunt plan`.

## Architecture

Two top-level trees implement a standard Terragrunt module/live split:

- **`terraform/`** — reusable OpenTofu modules. Modules define providers and input variables only; they contain no
  environment-specific values. `terraform/truenas` configures the
  [`deevus/truenas`](https://registry.terraform.io/providers/deevus/truenas) provider, authenticating over SSH
  (host, port, user, private key path, host key fingerprint — all passed in as variables).
- **`infrastructure/`** — Terragrunt "units": live configurations that wire a module from `terraform/` to real
  values and remote state. `infrastructure/truenas` deploys the TrueNAS apps, `infrastructure/truenas/apps/*`
  configures those apps' own APIs (Garage buckets/keys, LLDAP users/groups), and `infrastructure/1password/*`
  pushes app credentials into 1Password.

`root.hcl` is the Terragrunt root config included by every unit. It defines the remote state backend: an
S3-compatible bucket hosted on Backblaze B2 (`tfstate-truenas-terraform`). The state key is derived from each
unit's path with the `infrastructure/` prefix stripped, so state files mirror the `infrastructure/` directory
layout. Terragrunt generates `backend.tf` per unit from this config (overwriting on each run).

### Credentials

App credentials (admin passwords, API tokens, JWT secrets, etc.) are generated in `terraform/truenas` with
`random_password`/`random_id` resources — not sourced from 1Password. Only genuinely external credentials
(the TrueNAS SSH key, Backblaze/Cloudflare API tokens, the LLDAP SMTP mailbox password) still flow in via
`.env.1pass` and `TF_VAR_*` env vars. Generated credentials are exposed as outputs and flow *out* to 1Password
via the `infrastructure/1password/*` units, which use the
[`terraform-modules-1password`](https://github.com/mirceanton/terraform-modules-1password) module (same pattern
as `mikrotik-terraform`) to create/update items in a vault named after the unit's directory. Units that need a
generated credential to talk to an app's own API (e.g. `infrastructure/truenas/apps/garage` needs the Garage
admin token) consume it via a Terragrunt `dependency` block on `infrastructure/truenas`, not via an env var.

### CI/CD (`.github/workflows/`)

- **`lint.yaml`** — runs `task lint:check` on every push.
- **`terragrunt-ci.yaml`** — on PRs touching `root.hcl` or `infrastructure/**`: runs `terragrunt run --all -- plan`
  across all units and posts a per-unit summary as a PR comment.
- **`terragrunt-cd.yaml`** — on push to `main` touching the same paths: runs `terragrunt run --all -- apply
  -auto-approve` and posts a per-unit summary as a commit comment.
- **`terragrunt-drift.yaml`** — scheduled every 2 hours: runs a plan, and opens/updates a pinned GitHub issue if
  drift is detected, or closes it if not.

All three Terragrunt workflows load secrets from 1Password Connect (`OP_CONNECT_HOST`/`OP_CONNECT_TOKEN`) into the
environment before running, and use a GitHub App token (not `GITHUB_TOKEN`) to post comments/issues.

Plan/apply output parsing lives in `.github/scripts/generate-comment.py`, which extracts per-unit add/change/destroy
counts from the raw Terragrunt log and renders them through the Jinja2 template `.github/scripts/comment.j2`. The
same script backs PR comments, commit comments, and drift issues (`mode` argument: `plan`, `apply`, or `drift`).
