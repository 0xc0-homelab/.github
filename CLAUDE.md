# .github — organization Terraform

Manages the `0xc0-homelab` org with Terraform/OpenTofu, plus the reusable
workflows.

Cloned locally as `.github/`, matching the repo name.

That path is special to GitHub: it is where a repo declares its workflows,
CODEOWNERS and community health files. The workspace `.gitignore` must keep
ignoring this directory — without it, this repo's contents would be committed
into the workspace repo at exactly the path GitHub reads.

## Contents

- `modules/repository/` — the only way a repo is created. Squash-only, the
  default-branch ruleset and secret scanning are baked in there.
- `modules/runner-group/` — the org runner group for the self-hosted runners
  on `vm-ci`, restricted to the repos and workflows that need them.
- `environments/prod/` — the root. Calls the repository module once per repo
  and the runner-group module once. The `production` Actions environment every
  apply waits on lives in the repository module, opted into per repo
  (`production_environment`). State key `homelab/.github/prod.tfstate`.
- `.github/workflows/` — `tofu-plan` and `tofu-apply` are reusable and called
  by the other repos; `org-plan` and `org-apply` run them for this repo.
  `pr-issue` is reusable and fails a PR that links no issue; `issue` runs it
  for this repo.

Layout and naming conventions are in `README.md`, section Conventions. The
bootstrap order is there too. Do not improvise it: the org's first apply runs
with `-var bootstrap=true`, or `main` cannot take its first push.

## Outside Terraform, deliberately

The org project board (Projects v2) is not supported by the GitHub provider,
so it is created and configured by hand. It is an exception, not drift.

## Visibility

This repo is **public**, deliberately. The org profile README only shows from
a public `.github`.

The consequence is that the org Terraform and the reusable workflows are
readable by anyone. No secret value ever goes in here — only references.

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
- No work without an issue on the org project board. The PR links it
  (`Closes #N` / `Refs owner/repo#N`) or the `issue` check fails. See the
  workspace `CLAUDE.md`, section Tracking.
- Never keep a saved plan file: it contains the App private key in plaintext.
- OpenTofu is always written as modules, laid out as `modules/<name>/` and
  `environments/<env>/`. A root only calls modules; a resource sits in a root
  only when it belongs to no reusable concept.

## Before opening a PR

Run `scripts/tofu prod plan` and read it line by line. A repo or a permission that exists on
GitHub but not in Terraform shows up here as a diff, and that is a finding, not
a curiosity.

## Bootstrapping new repos

A new repo is created **from here**, with Terraform, not from the web UI. See
`README.md`, section Adding a repo.

The module creates no files in the repo. The `homelab` Claude Code plugin is
installed per machine, from the workspace:

```
claude plugin install homelab@0xc0-homelab --scope project
```

Enabling it in settings does not install it.
