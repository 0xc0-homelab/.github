# .github — organization Terraform

Manages the `0xc0-homelab` org with Terraform/OpenTofu, plus the reusable
workflows and the organization templates.

Cloned locally as `.github/`, matching the repo name.

That path is special to GitHub: it is where a repo declares its workflows,
CODEOWNERS and community health files. The workspace `.gitignore` must keep
ignoring this directory — without it, this repo's contents would be committed
into the workspace repo at exactly the path GitHub reads.

## Contents

- Org Terraform: repos, branch protection, secrets, variables, teams.
- `.github/workflows/` — reusable workflows consumed by the other repos.
- Organization templates (issue templates, PR template, CODEOWNERS).

## Hard rules

- Everything written is in English: files, file names, comments, commits,
  branches and PRs.
- Changes in this org are **rare and destructive**. No opportunistic changes:
  one PR, one intent.
- `infrastructure` and `.github`: `main` only, PR required, apply behind manual
  approval.
- `app-*`: test→prod promotion of the same digest.
- No organization secret in cleartext in the code. Reference it, never the value.
- The self-hosted runner is `vm-ci` (10.10.1.10), ephemeral. Do not register
  others.
- Never run `tofu apply` or `destroy`. Here least of all.

## Before opening a PR

Run `tofu plan` and read it line by line. A repo or a permission that exists on
GitHub but not in Terraform shows up here as a diff, and that is a finding, not
a curiosity.

## Bootstrapping new repos

A new repo is created **from here**, with Terraform, not from the web UI. It
includes its `.claude/settings.json` declaring the `0xc0-homelab` marketplace
and enabling the `homelab` plugin, so the Claude Code configuration travels
with the repo from minute zero.
