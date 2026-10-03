# Data for this environment. Secrets come from the environment (TF_VAR_*), and
# bootstrap only ever from the command line.

operator_user_id = 94703619 # sergioaten

# Topics: homelab on every repo, plus one per tool the repo actually contains.
repositories = {
  ".github" = {
    description            = "Organization Terraform, reusable workflows and org-wide templates"
    topics                 = ["homelab", "opentofu", "github-actions"]
    production_environment = true
    required_checks        = ["issue / check", "plan / tofu"]
  }
  "workspace" = {
    description = "Umbrella workspace: cross-repo rules, design and bootstrap"
    topics      = ["homelab", "claude-code", "mise"]
  }
  "claude-config" = {
    description     = "Claude Code marketplace and the homelab plugin"
    topics          = ["homelab", "claude-code"]
    required_checks = ["issue / check"]
  }
  "infrastructure" = {
    description            = "Packer, OpenTofu and Ansible for the Proxmox homelab"
    topics                 = ["homelab", "proxmox", "opentofu", "packer", "ansible"]
    production_environment = true
    required_checks        = ["issue / check", "plan / tofu"]
  }
  "gitops" = {
    description     = "ArgoCD manifests for the cluster"
    topics          = ["argocd", "homelab"]
    required_checks = ["issue / check"]
  }
  # Vault's configuration as OpenTofu: auth methods, policies, secret engines.
  # Downstream of gitops, which deploys Vault. Its CI logs in to Vault with
  # GitHub's OIDC token (JWT auth).
  "vault" = {
    description            = "OpenTofu configuration of the cluster's Vault"
    topics                 = ["homelab", "opentofu", "vault"]
    auto_init              = true
    production_environment = true
    required_checks        = ["issue / check", "plan / tofu"]
  }
  # The offby1.cc landing page, a Next.js site on the offby1 design system.
  "offby1.cc" = {
    description     = "Landing page for offby1.cc"
    topics          = ["homelab", "nextjs"]
    auto_init       = true
    required_checks = ["issue / check"]
  }
}

# The CI VMs' runners. Only the repos that plan and apply infrastructure use
# them; vault reaches the cluster's Vault from there.
runner_group = {
  name         = "homelab"
  repositories = [".github", "infrastructure", "vault"]
  # The reusable workflows that need the network, as they are on main.
  workflows = [
    "0xc0-labs/.github/.github/workflows/ansible.yml@refs/heads/main",
    "0xc0-labs/.github/.github/workflows/packer.yml@refs/heads/main",
    "0xc0-labs/.github/.github/workflows/tofu-plan.yml@refs/heads/main",
    "0xc0-labs/.github/.github/workflows/tofu-apply.yml@refs/heads/main",
  ]
}
