# Upgrade Guide

## How Mosaic Updates Work

The shared Mosaic repo publishes updates in two forms:

1. **Reasoning kernel updates** — New versions of `core/MOSAIC-REASONING.md` with improved or new reasoning frameworks
2. **Architecture upgrades** — Changes to bootstrap protocols, templates, MCP server code, or methodology documented in `upgrades/`

Instances pull updates at their own pace. There is no forced upgrade — the shared repo is a resource, not a dependency.

## Upgrading the Reasoning Kernel

When `core/MOSAIC-REASONING.md` gets a new version:

### Before Upgrading

1. Note the current version in your instance (`MOSAIC-REASONING.md` header)
2. Read the changelog in the new version to understand what changed
3. Run 3 baseline queries from your test plan and record scores

### Performing the Upgrade

```bash
# Pull latest shared repo
cd Mosaic/
git pull

# Copy new reasoning kernel to your instance
cp core/MOSAIC-REASONING.md ../your-instance/MOSAIC-REASONING.md
```

### After Upgrading

1. Upload the new `MOSAIC-REASONING.md` to Claude.ai project knowledge
2. Generate and upload the new `.txt` version to Copilot agent knowledge
3. Run the same 3 queries from before and compare scores
4. Update your instance's `{ORG}-MAINTENANCE.md` manifest with the new version
5. Commit and push your instance repo

### If Something Breaks

- Check whether new reasoning frameworks conflict with your behavioral directives
- Temporarily revert to the previous version while investigating
- Report the issue via a proposal (see `proposals/PROPOSAL-TEMPLATE.md`)

## Architecture Upgrades

Architecture changes are documented in `upgrades/` with dated files:

```
upgrades/
├── 2026-03-15-reasoning-v1.4.md
├── 2026-04-01-mcp-server-v2.md
└── ...
```

Each upgrade file includes:

- **What changed** — description of the modification
- **Why** — the problem it solves
- **Instance impact** — what you need to do in your instance
- **Step-by-step instructions** — specific edits, file updates, and verification steps
- **Rollback instructions** — how to undo if something goes wrong

Read the upgrade file carefully before applying. Some upgrades are optional improvements; others fix issues that affect all instances.

## Version Compatibility

| Shared Component | Instance Component | Compatibility |
|-----------------|-------------------|---------------|
| MOSAIC-REASONING.md v1.x | Any instance kernel | Forward-compatible (new versions add, don't break) |
| DOMAIN-BOOTSTRAP.md | Instance domain files | Reference only (protocol doesn't affect deployed files) |
| MCP server code | Instance Azure deployment | Check upgrade notes (API changes may require redeployment) |
| Templates | Instance files | Reference only (templates are starting points, not dependencies) |

## Checking for Updates

```bash
cd Mosaic/
git pull
git log --oneline -10
```

Review recent commits to see if any affect files you care about. The `upgrades/` directory is the authoritative source for changes that require instance action.
