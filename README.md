# .github

Organization Terraform for `0xc0-homelab`, the reusable workflows every repo
calls, and the org-wide templates.

```
modules/repository/        every repo is created through this module
environments/prod/         root: calls the module, owns the production env
scripts/tofu               runs tofu on an environment, secrets decrypted in env
secrets/tofu.sops.yaml     SOPS-encrypted, gitignored (this repo is public)
.github/workflows/
  tofu-plan.yml            reusable: fmt, validate, plan, comment on the PR
  tofu-apply.yml           reusable: apply inside an approval-gated environment
  org-plan.yml             this repo: plan environments/prod on every PR
  org-apply.yml            this repo: apply it after merge, once approved
```

## Conventions

The layout follows Google's Terraform best practices, and is the same in every
repo that holds OpenTofu:

```
modules/<name>/            resources: main.tf, variables.tf, outputs.tf, README
environments/<env>/        root: backend.tf, main.tf, terraform.tfvars
```

- A root only calls modules. A resource sits in a root only when it belongs to
  no reusable concept.
- State key: `homelab/<repo>/<environment>.tfstate`. Here,
  `homelab/.github/prod.tfstate`.
- A resource that is the only one of its type is named `main`.
- Root values go in `terraform.tfvars`. Secrets come from the environment.
  `bootstrap` is the one exception: command line only, never committed.
- The inputs/outputs section of a module README is generated:
  `mise run docs`.

## Running it locally

Tools come from `mise.toml`. Secrets never touch disk in plaintext:
`scripts/tofu` decrypts them into the environment for one command.

```
scripts/tofu prod init
scripts/tofu prod plan
```

## Using the reusable workflows from another repo

```yaml
jobs:
  plan:
    uses: 0xc0-homelab/.github/.github/workflows/tofu-plan.yml@main
    with:
      working-directory: environments/prod
    secrets: inherit
```

Required secrets: `GH_APP_ID`, `GH_APP_INSTALLATION_ID`, `GH_APP_PRIVATE_KEY`,
`TF_STATE_ACCESS_KEY`, `TF_STATE_SECRET_KEY`.

## Bootstrap

This repo creates every repo in the org, itself included, so the first run
cannot come from CI. The order matters:

1. **First apply, rulesets disabled.** With them active, `main` could not
   receive its initial push.
   `scripts/tofu prod apply -var bootstrap=true`
2. **Push the existing history** of the five local repos to their new remotes.
3. **Set the Actions secrets** on this repo, from `secrets/tofu.sops.yaml`.
4. **Second apply, rulesets active.** `scripts/tofu prod apply`
   From here on, every change goes through a PR and `org-apply`.

## State

RustFS at `https://s3.0xc0.cc`, bucket `tfstate`, locked with a lockfile.
Every root in the org has its own key; roots never share a state.
