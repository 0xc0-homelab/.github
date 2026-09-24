# 0xc0-homelab

A single-operator homelab on a Hetzner dedicated server, built and run
entirely as code. Nothing is configured by hand, nothing reaches `main`
without a pull request, and nothing is applied without a human approving it.

**Current phase: 1 (Base)**

## What it is

One Proxmox VE node on a Hetzner dedicated server, until a second node
arrives in phase 5. The host is the router and the firewall for six zones —
management, CI, platform, edge, workloads and data. Alongside Proxmox it runs
only the base services: a reverse proxy, the object store holding the
infrastructure state, and the backup server, which ships to off-site storage.

- **Public traffic** enters through a Cloudflare Tunnel into the edge zone,
  where open-appsec and NGINX route it to the workloads.
- **Admin access** goes through Cloudflare Access and WARP into the management
  zone, never through the edge.
- **Between zones**, everything not explicitly allowed is denied. The allowed
  flows live in one normative matrix, and the firewall is generated from it.

The full picture, with diagrams, is in the
[architecture document](https://github.com/0xc0-homelab/infrastructure/blob/main/docs/architecture.md).

## How it is built

Templates come from official cloud images, and Packer bakes the few that need
more. OpenTofu creates the VMs, the network and the
firewall, and Ansible configures them. Secrets are encrypted with SOPS and age,
moving to Vault in phase 3. CI runs on GitHub Actions; every apply waits for
the operator's approval.

## Repositories

| Repo | What it holds |
|------|---------------|
| [`.github`](https://github.com/0xc0-homelab/.github) | Organization Terraform, reusable workflows, this page |
| [`workspace`](https://github.com/0xc0-homelab/workspace) | Cross-repo rules, the design, the bootstrap |
| [`infrastructure`](https://github.com/0xc0-homelab/infrastructure) | Packer, OpenTofu and Ansible — and the [zone design](https://github.com/0xc0-homelab/infrastructure/blob/main/docs/zones.md) |
| [`deployments`](https://github.com/0xc0-homelab/deployments) | Docker Compose per VM; ArgoCD from phase 6 |
| [`claude-config`](https://github.com/0xc0-homelab/claude-config) | Claude Code plugin: agents, skills and guardrail hooks |

## Phases

| | Phase | Delivers |
|---|---|---|
| 1 | Base | Proxmox, SDN zones with NAT, images, admin access and the edge |
| 2 | Core | Applications, data, CI, and backups with a timed restore |
| 3 | Platform | Monitoring with alerts, Vault |
| 4 | Resilience | An external cloud VM and uptime checks |
| 5 | HA | A second node, replication, SDN across both nodes |
| 6 | Kubernetes | RKE2 and ArgoCD |

A phase is not done until what it promises has been tested. For phase 2 that
means a restore, timed and written down.

## Principles

- **Everything as code.** OpenTofu is always written as modules; tools are
  pinned per repo with mise.
- **One source of truth per concern.** The design is closed in
  [`docs/design.md`](https://github.com/0xc0-homelab/workspace/blob/main/docs/design.md);
  the network in the infrastructure code, `terraform.tfvars`; the state of work on the
  [project board](https://github.com/orgs/0xc0-homelab/projects/1).
- **A human applies.** Automation plans; the operator approves.
