# Mosaic

**A knowledge architecture for multi-agent organizational intelligence.**

Mosaic is a methodology and toolkit for building AI agent systems that understand your organization deeply. It combines a shared reasoning kernel (how agents think) with instance-specific knowledge (what agents know about your organization) to create durable, maintainable intelligence infrastructure.

## What Mosaic Does

- **Teaches agents to reason**, not just retrieve. Frameworks for people reasoning, analytical intelligence, source trust, and cross-domain synthesis.
- **Scales across domains.** A repeatable bootstrap protocol for adding knowledge domains (teams, clients, systems, policies, etc.) one at a time.
- **Supports multiple agents.** Claude.ai, Microsoft Copilot, and Claude Code each access the same knowledge through different channels, coordinated by a shared protocol.
- **Stays current.** A maintenance architecture that detects drift between source systems and reference files, with defined audit cadences and trigger matrices.

## Architecture

Mosaic uses a **Core + Retrieval** pattern:

- **Static kernel** (~200 KB) loaded into every agent session: reasoning frameworks, behavioral directives, classification taxonomies, routing logic, and an organizational index.
- **Dynamic retrieval** via MCP (Model Context Protocol): domain-specific reference files stored in Azure Blob, retrieved section-by-section on demand using `get_section(file_name, section_ref)`.

This split means agents have reasoning patterns available on every query while accessing detailed domain data only when needed.

## Repository Structure

```
Mosaic/                          (this repo — shared methodology)
├── core/                        MOSAIC-REASONING.md (shared reasoning kernel)
├── bootstrap/                   KERNEL-BOOTSTRAP.md, DOMAIN-BOOTSTRAP.md, templates/
├── mcp-server/                  Azure Function for get_section retrieval
├── scripts/                     Generic prepare_upload.ps1 template
├── proposals/                   PROPOSAL-TEMPLATE.md (instance feedback upstream)
├── upgrades/                    Published kernel/architecture upgrade instructions
├── docs/                        Architecture, getting started, upgrade guide
├── README.md                    (this file)
└── CLAUDE.md                    Methodology-level Claude Code rules
```

Each organization creates a **private instance repository** alongside this shared repo:

```
{org}-instance/                  (private — your organization's knowledge)
├── {ORG}-INDEX.md               Entry point
├── MOSAIC-REASONING.md          Copy from core/ (updated on pull)
├── kernel/                      Static kernel files
├── reference/                   Domain files (synced to Azure Blob)
├── agent/                       Behavioral directives + platform config
├── clients/                     Entity profiles + intelligence
├── scripts/                     Instance-configured upload scripts
└── ...
```

## Getting Started

1. **Read** `docs/architecture.md` to understand the Core + Retrieval pattern
2. **Follow** `bootstrap/KERNEL-BOOTSTRAP.md` to set up infrastructure and create your first kernel
3. **Bootstrap domains** using `bootstrap/DOMAIN-BOOTSTRAP.md` for each knowledge area
4. **Maintain** using the patterns in your instance's `{ORG}-MAINTENANCE.md`

## Sharing Model

Mosaic instances are **independent deployments**. Each organization:

- Clones this repo for the shared methodology and reasoning kernel
- Creates their own private instance repo for organization-specific knowledge
- Copies `MOSAIC-REASONING.md` into their instance (not a symlink)
- Pulls updates from this repo when new reasoning kernel versions are published
- Submits improvements upstream via proposals (see `proposals/PROPOSAL-TEMPLATE.md`)

Instances never share organization-specific data. The shared repo contains only company-agnostic methodology.

## Key Concepts

| Concept | Description |
|---------|-------------|
| **Kernel** | Static files loaded into every agent session (~200 KB budget). Teaches reasoning patterns. |
| **Retrieval** | Domain files in Azure Blob, accessed via `get_section` MCP tool. Provides data on demand. |
| **QUICK files** | Session-level indexes (20% of data, 80% of queries). First retrieval step for any domain. |
| **Domain Bootstrap** | Repeatable protocol for adding a knowledge domain. Foundation (what exists) + Freedom (how experts think). |
| **Three-channel distribution** | Kernel files go to Claude.ai (.md), Copilot (.txt), and blob (retrieval .md). |
| **Behavioral parity** | Directives apply to all agents unless there's a clear architectural reason they don't. |

## License

MIT
