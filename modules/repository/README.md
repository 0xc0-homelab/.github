# repository

Creates an org repository with the org-wide rules baked in, so no repo can be
created without them:

- Squash merge only, PR title as the commit title, branch deleted on merge.
- A ruleset on the default branch: PR required, no force push, no deletion,
  linear history.
- Secret scanning and push protection on public repos.
- `archive_on_destroy`: removing a repo from the root archives it.

| Input                    | Default    | Notes                                    |
|--------------------------|------------|------------------------------------------|
| `name`                   | —          |                                          |
| `description`            | —          |                                          |
| `visibility`             | `public`   | Rulesets need public on the Free plan.   |
| `topics`                 | `[]`       |                                          |
| `ruleset_enforcement`    | `active`   | `disabled` only during bootstrap.        |
| `required_status_checks` | `[]`       | Only checks that run on every PR.        |
