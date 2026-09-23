# Data for this environment. Secrets come from the environment (TF_VAR_*), and
# bootstrap only ever from the command line.

operator_user_id = 94703619 # sergioaten

# Topics: homelab on every repo, plus one per tool the repo actually contains.
repositories = {
  ".github" = {
    description            = "Organization Terraform, reusable workflows and org-wide templates"
    topics                 = ["homelab", "opentofu", "github-actions"]
    production_environment = true
  }
  "workspace" = {
    description = "Umbrella workspace: cross-repo rules, design and bootstrap"
    topics      = ["homelab", "claude-code", "mise"]
  }
  "claude-config" = {
    description = "Claude Code marketplace and the homelab plugin"
    topics      = ["homelab", "claude-code"]
  }
  "infrastructure" = {
    description            = "Packer, OpenTofu and Ansible for the Proxmox homelab"
    topics                 = ["homelab", "proxmox", "opentofu", "packer", "ansible"]
    production_environment = true
  }
  "deployments" = {
    description = "Docker Compose per VM, and ArgoCD manifests from phase 6"
    topics      = ["docker-compose", "homelab"]
  }
}

# vm-ci's runners. Only the repos that plan and apply infrastructure use them.
runner_group = {
  name         = "homelab"
  repositories = [".github", "infrastructure"]
  # The reusable tofu workflows and the Packer builds, as they are on main.
  workflows = [
    "0xc0-homelab/.github/.github/workflows/tofu-plan.yml@refs/heads/main",
    "0xc0-homelab/.github/.github/workflows/tofu-apply.yml@refs/heads/main",
    "0xc0-homelab/infrastructure/.github/workflows/packer.yml@refs/heads/main",
  ]
}
