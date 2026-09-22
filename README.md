# .github

Organization Terraform for `0xc0-homelab`, the reusable workflows every repo
calls, and the org-wide templates.

What the homelab itself is lives in [`profile/README.md`](profile/README.md),
which GitHub shows on the organization page.

```
profile/README.md          the org page: what the project is, current phase
modules/repository/        every repo is created through this module
environments/prod/         root: calls the module, owns the production env
scripts/tofu               runs tofu on an environment, secrets decrypted in env
secrets/tofu.sops.yaml     SOPS-encrypted, to the operator and this repo's CI key
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

One secret per repo: **`SOPS_AGE_KEY`**, that repo's CI age key. Everything
else a root needs — provider credentials, the RustFS state keys — lives in the
repo's `secrets/tofu.sops.yaml`, encrypted to the operator and to that CI key.
The workflows decrypt it with `sops exec-env` and mask every decrypted value in
the logs. Override the path with the `secrets-file` input.

A repo whose applies run from CI needs `production_environment = true` in
`environments/prod/terraform.tfvars`: that creates the approval-gated
environment the apply workflow waits on.

## Bootstrap

This repo creates every repo in the org, itself included, so the first run
cannot come from CI. The order matters:

1. **First apply, rulesets disabled.** With them active, `main` could not
   receive its initial push.
   `scripts/tofu prod apply -var bootstrap=true`
2. **Push the existing history** of the five local repos to their new remotes.
3. **Give the repo its CI key**: generate an age key, add its public half to
   `.sops.yaml`, run `sops updatekeys`, and store the private half as the
   `SOPS_AGE_KEY` Actions secret. Never write it to disk.
4. **Second apply, rulesets active.** `scripts/tofu prod apply`
   From here on, every change goes through a PR and `org-apply`.

## Concurrency

Several PRs can plan, and several merges can apply, against the same state.

- **Plans**: one at a time per PR and root. A newer push replaces a plan that
  has not started; a running plan is never cancelled, because killing tofu
  mid-run can leave the lock behind.
- **Applies**: queued per root, oldest first, never cancelled once running. If
  a third merge arrives while one apply runs and another waits, the waiting one
  is dropped — `main` is linear, so the newest commit already contains it.
- **Every apply re-plans** against the live state. The plan posted on a PR is
  for review; it is never what gets applied.
- **Locks are waited for**, not failed on: 5 minutes for plans and local runs,
  10 for CI applies.
- **Stale PR plans** — PR B planned before PR A merged — are stopped by the
  ruleset requiring branches to be up to date. That only applies once the plan
  check is required.

## Secrets

Committed, encrypted. The repos are public, so the ciphertext is public too;
that is standard SOPS practice, and the answer to a leaked key is rotating the
secrets it protects, which would be needed anyway. Each repo's CI key decrypts
only that repo's files. From phase 2 the CI key lives on `vm-ci` and the
Actions secret goes away.

## State

RustFS at `https://s3.0xc0.cc`, bucket `tfstate`, locked with a lockfile.
Every root in the org has its own key; roots never share a state.
