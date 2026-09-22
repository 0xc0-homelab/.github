locals {
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
}

module "repositories" {
  source   = "../modules/repository"
  for_each = local.repositories

  name                = each.key
  description         = each.value.description
  topics              = each.value.topics
  visibility          = "public"
  ruleset_enforcement = var.bootstrap ? "disabled" : "active"
}
