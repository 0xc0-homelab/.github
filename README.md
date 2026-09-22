# .github

Organization Terraform for `0xc0-homelab`, the reusable workflows every repo
calls, and the org-wide templates.

```
modules/repository/        every repo is created through this module
org/                       root: calls the module, owns the production env
scripts/tofu               runs tofu against org/ with secrets decrypted in env
secrets/tofu.sops.yaml     SOPS-encrypted, gitignored (this repo is public)
.github/workflows/
  tofu-plan.yml            reusable: fmt, validate, plan, comment on the PR
  tofu-apply.yml           reusable: apply inside an approval-gated environment
  org-plan.yml             this repo: plan org/ on every PR
  org-apply.yml            this repo: apply org/ after merge, once approved
```

## Running it locally

Tools come from `mise.toml`. Secrets never touch disk in plaintext:
`scripts/tofu` decrypts them into the environment for one command.

```
scripts/tofu init
scripts/tofu plan
```

## Using the reusable workflows from another repo

```yaml
jobs:
  plan:
    uses: 0xc0-homelab/.github/.github/workflows/tofu-plan.yml@main
    with:
      working-directory: <root>
    secrets: inherit
```

Required secrets: `GH_APP_ID`, `GH_APP_INSTALLATION_ID`, `GH_APP_PRIVATE_KEY`,
`TF_STATE_ACCESS_KEY`, `TF_STATE_SECRET_KEY`.

## Bootstrap

This repo creates every repo in the org, itself included, so the first run
cannot come from CI. The order matters:

1. **First apply, rulesets disabled.** With them active, `main` could not
   receive its initial push.
   `scripts/tofu apply -var bootstrap=true`
2. **Push the existing history** of the five local repos to their new remotes.
3. **Set the Actions secrets** on this repo, from `secrets/tofu.sops.yaml`.
4. **Second apply, rulesets active.** `scripts/tofu apply`
   From here on, every change goes through a PR and `org-apply`.

## State

RustFS at `https://s3.0xc0.cc`, bucket `tfstate`, key
`homelab/github-org.tfstate`, locked with a lockfile. Every OpenTofu root in
the org gets its own key under `homelab/`; roots never share a state.
