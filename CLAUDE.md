# Mosaic — Shared Methodology Rules

## About This Repository

This is the **shared Mosaic methodology repository** — company-agnostic frameworks, bootstrap protocols, templates, and tools. It does NOT contain any organization-specific data.

**Key constraint:** No organization-specific content belongs in this repo. No names, system IDs, entity lists, EINs, or worked examples referencing a specific organization. All examples use generic placeholders ({ORG}, Acme Corporation, etc.).

## File Organization

```
Mosaic/
├── core/                MOSAIC-REASONING.md, MOSAIC-OPERATIONS.md, MOSAIC-PRINCIPLES.md
├── bootstrap/           KERNEL-BOOTSTRAP.md, DOMAIN-BOOTSTRAP.md
│   └── templates/       ORG-*.template.md, CLAUDE.md.template, pipeline/
├── mcp-server/          Azure Function code (function_app.py, requirements.txt, host.json)
├── scripts/             Generic prepare_upload.ps1 template
├── proposals/           PROPOSAL-TEMPLATE.md
├── upgrades/            Published upgrade instructions (versioned)
├── docs/                architecture.md, getting-started.md, upgrade-guide.md
├── README.md
└── CLAUDE.md            (this file)
```

## Editing Rules

### Core Files (core/)
- **MOSAIC-REASONING.md** — Shared reasoning kernel (cognitive frameworks).
- **MOSAIC-OPERATIONS.md** — Shared operational architecture (learning loops, delta protocol, pipeline, maintenance).
- **MOSAIC-PRINCIPLES.md** — Design principles catalog (builder reference).

**Editing rules for all core files:**
- Changes here affect every instance that updates.
- **Never add company-specific content.** No names, system IDs, entity lists.
- **Version independently.** Bump the version in the file header (v1.0, v1.1, etc.).
- **Test before publishing.** Changes should be validated in at least one live instance before committing.
- Use generic examples. If a concrete example would help, use placeholders like "Acme Corporation" or "{Organization}".

### Bootstrap Protocols (bootstrap/)
- KERNEL-BOOTSTRAP.md and DOMAIN-BOOTSTRAP.md are the core methodology documents.
- Templates in bootstrap/templates/ use {ORG} placeholders throughout.
- Changes here should be tested by bootstrapping a domain in a live instance.

### MCP Server (mcp-server/)
- This is a reference copy for distribution. Instance deployments live in their own directories.
- The function code is generic — it reads from whatever blob container is configured.
- Changes here should be tested against a live Azure deployment before committing.

### Scripts (scripts/)
- Generic templates with {ORG} placeholders.
- Instance-specific configuration happens in the instance repo, not here.

### Proposals (proposals/)
- PROPOSAL-TEMPLATE.md defines the format for instance feedback upstream.
- Accepted proposals become changes to core files or new upgrade instructions.
- **Valid proposal categories:** Reasoning frameworks, architecture patterns, protocol enhancements, design principles, tool improvements, and **structural patterns** (file organization, compression techniques, pipeline designs, cross-reference conventions, maintenance workflows). Structural patterns discovered during instance work are first-class upstream contributions — they benefit every instance even though they aren't methodology changes per se.

### Upgrades (upgrades/)
- Each published upgrade gets a dated markdown file explaining what changed and how instances should update.
- Format: `YYYY-MM-DD-description.md` (e.g., `2026-03-15-reasoning-v1.4-upgrade.md`)

## Cross-Reference Convention

- Cross-references between .md files use **base filenames without extension or path**.
- Template files use {ORG} prefix convention: `{ORG}-INDEX`, `{ORG}-DOMAIN-ROUTER`, etc.

## Content Safety

Before every commit, verify no organization-specific content leaked in:
- No personal names (except generic examples)
- No system IDs, API keys, or connection strings
- No organization names (except as generic examples like "Acme")
- No EINs, account numbers, or sensitive data

## Session Protocol

**Before committing:** Verify all new content is company-agnostic. Run a grep for known organization-specific terms if unsure.
