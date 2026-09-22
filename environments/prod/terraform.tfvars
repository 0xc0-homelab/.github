# Data for this environment. Secrets come from the environment (TF_VAR_*), and
# bootstrap only ever from the command line.

operator_user_id = 94703619 # sergioaten

# Topics: homelab on every repo, plus one per tool the repo actually contains.
repositories = {
  ".github" = {
    description = "Organization Terraform, reusable workflows and org-wide templates"
    topics      = ["homelab", "opentofu", "github-actions"]
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
    description = "Packer, OpenTofu and Ansible for the Proxmox homelab"
    topics      = ["homelab", "proxmox", "opentofu", "packer", "ansible"]
  }
  "deployments" = {
    description = "Docker Compose per VM, and Flux manifests from phase 6"
    topics      = ["homelab", "docker-compose"]
  }
}
