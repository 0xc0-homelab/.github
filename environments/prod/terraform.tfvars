# Data for this environment. Secrets come from the environment (TF_VAR_*), and
# bootstrap only ever from the command line.

operator_user_id = 94703619 # sergioaten

repositories = {
  ".github" = {
    description = "Organization Terraform, reusable workflows and org-wide templates"
    topics      = ["terraform", "opentofu", "github-actions"]
  }
  "workspace" = {
    description = "Umbrella workspace: cross-repo rules, design and bootstrap"
    topics      = ["homelab"]
  }
  "claude-config" = {
    description = "Claude Code marketplace and the homelab plugin"
    topics      = ["claude-code", "homelab"]
  }
  "infrastructure" = {
    description = "Packer, OpenTofu and Ansible for the Proxmox homelab"
    topics      = ["proxmox", "opentofu", "packer", "ansible", "homelab"]
  }
  "deployments" = {
    description = "Docker Compose per VM, and Flux manifests from phase 6"
    topics      = ["docker-compose", "homelab"]
  }
}
