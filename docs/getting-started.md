# Getting Started with Mosaic

## Prerequisites

- **Claude.ai** account (Pro or Team plan) — for the primary AI agent
- **Azure subscription** — for the MCP server (Azure Function + Blob Storage)
- **Azure CLI** installed locally — for deployment and blob sync
- **GitHub CLI** (`gh`) installed — for repository management
- **Claude Code** — for managing instance files (optional but recommended)
- **Microsoft 365** (optional) — for Copilot agent integration

## Quick Start

### 1. Clone the shared repo

```bash
git clone https://github.com/{owner}/Mosaic.git
```

### 2. Follow the Kernel Bootstrap

Open `bootstrap/KERNEL-BOOTSTRAP.md` and work through it sequentially:

- **Phase 1:** Infrastructure setup (Azure resources, MCP server, repository)
- **Phase 2:** Kernel construction (copy reasoning, create instance files from templates)
- **Phase 3:** First domain bootstrap (using DOMAIN-BOOTSTRAP.md)
- **Phase 4:** Operational readiness (git workflow, session patterns)

### 3. Bootstrap additional domains

Each new domain follows `bootstrap/DOMAIN-BOOTSTRAP.md`:

- **Level 0:** Organizational Discovery (run once, first time only)
- **Level 1:** Domain Bootstrap (Foundation + Freedom tracks)
- **Level 2:** Architecture Design (kernel vs. retrieval split)
- **Level 3:** Enrichment Design (maintenance and population)

### 4. Maintain

Use your instance's `{ORG}-MAINTENANCE.md` to:
- Run monthly audits
- Detect and fix drift between source systems and reference files
- Regenerate QUICK files after full-file updates
- Track version currency across all files

## Key Files to Read First

| File | What You'll Learn |
|------|-------------------|
| `docs/architecture.md` | The Core + Retrieval pattern and three-channel distribution |
| `core/MOSAIC-REASONING.md` | The shared reasoning frameworks (people, analysis, retrieval, coordination) |
| `bootstrap/KERNEL-BOOTSTRAP.md` | Step-by-step infrastructure and kernel setup |
| `bootstrap/DOMAIN-BOOTSTRAP.md` | How to bootstrap a knowledge domain (Foundation + Freedom) |

## Updating the Shared Reasoning Kernel

When a new version of MOSAIC-REASONING.md is published:

1. Pull the latest from the shared Mosaic repo
2. Copy `core/MOSAIC-REASONING.md` to your instance repo root
3. Upload the new version to Claude.ai project knowledge and Copilot agent knowledge
4. Run 2-3 smoke test queries to verify no regressions
5. Update your instance's `{ORG}-MAINTENANCE.md` manifest

## Submitting Improvements

If you discover a pattern, framework, or protocol improvement that would benefit other instances:

1. Fill out `proposals/PROPOSAL-TEMPLATE.md`
2. Submit as a pull request to the shared Mosaic repo
3. Include evidence from your instance (test results, benchmark data)
4. Maintainers review, test, and merge if accepted
