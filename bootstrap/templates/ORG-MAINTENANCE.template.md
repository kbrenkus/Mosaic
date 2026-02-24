# {ORG}-MAINTENANCE.md
## {Organization Name} — Maintenance, Synchronization & Build Playbook

**Version:** 1.0
**Created:** {DATE}
**Last Verified:** {DATE}
**Owner:** {Owner Name} / {Team}
**Classification:** Internal — Agent Reference File

---

## §1 About This File

This file governs how reference files stay current, how agents detect and resolve drift between source systems and reference files, and how new reference files are built from scratch.

**Primary audience:** Claude Code (builds/edits files), Claude.ai (reads via MCP for staleness detection), {Owner} (executes the irreducible manual steps).

### The 4-Layer Sync Problem

Reference files go stale because data changes in source systems but nothing triggers an update automatically. There are four layers where staleness can accumulate:

| Layer | What Goes Stale | Detection Method | Fix |
|-------|----------------|------------------|-----|
| **L1 — Source systems** | CRM deals close, teams change, personnel leave | Monthly MCP audit (§4) | Agent runs audit queries, reports delta |
| **L2 — Full reference files** | {ORG}-* files in Azure Blob lag behind source | Trigger matrix (§9) + monthly audit | Claude Code edits files based on delta |
| **L3 — Quick files** | {ORG}-*-QUICK files in project knowledge lag behind full files | Version manifest comparison (§3) | Claude Code regenerates, user uploads |
| **L4 — Manifest itself** | This file's version table lags behind actual files | Self-check protocol (§3) | Update manifest after every file edit |

### Tool Capabilities & Constraints

| Tool | Can Do | Cannot Do |
|------|--------|-----------|
| **Claude.ai** (via MCP) | Query live systems; retrieve reference file sections via `get_section`; compare manifest from loaded project knowledge | Edit files on disk; upload to project knowledge |
| **Claude Code** | Read/write all files on disk; scan markers; regenerate quick files | Query live systems (no MCP); upload to project knowledge |
| **User** | Upload files to project knowledge; approve changes; answer open questions | — |

### When to Use This File

| Situation | Start At |
|-----------|----------|
| "Run monthly maintenance" | §10 (full sync workflow) → §4 (audit) → §5 (Claude Code actions) |
| "Are my reference files current?" | §3 (self-check protocol) |
| "Regenerate quick files" | §7 (quick file regeneration) |
| "Build a new reference file" | §8 (build playbook) |
| "Something changed in the org" | §9 (trigger matrix) |
| "Update the version manifest" | §2 (manifest table + protocol) |

---

## §2 Version Manifest

This is the single source of truth for file currency. Every time a reference file is edited, its row here must be updated.

### §2.1 Manifest Table

| File | Version | Last Updated | Size | Status | Quick File? |
|------|---------|-------------|------|--------|-------------|
| {ORG}-INDEX.md | 1.0 | {DATE} | {N} KB | Initial | No (always loaded) |
| {ORG}-DOMAIN-ROUTER.md | 1.0 | {DATE} | {N} KB | Initial | No (always loaded) |
| {ORG}-TAXONOMY-QUICK.md | — | — | — | Pending first domain | No (always loaded) |
| {ORG}-A2A-QUICK.md | — | — | — | Pending multi-agent setup | No (always loaded) |
| {ORG}-CLAUDE-BEHAVIORS.md | 1.0 | {DATE} | {N} KB | Initial | No (Claude.ai only) |
| MOSAIC-REASONING.md | {VER} | {DATE} | ~45 KB | Current | No (always loaded — shared reasoning kernel) |
<!-- Add rows as domain files are created -->

### §2.2 Supporting Artifacts

<!-- Track non-kernel files: profiles, directories, test plans, etc. -->

| File | Version | Last Updated | Size | Notes |
|------|---------|-------------|------|-------|
<!-- Add rows as artifacts are created -->

---

## §3 Self-Check Protocol

<!-- Define how agents verify manifest accuracy -->

---

## §4 Monthly Audit Protocol

<!-- Define the monthly staleness detection process -->

---

## §5 Claude Code Actions

### §5A Recommendations Log

<!-- Track open maintenance recommendations -->

| ID | Date | Category | Description | Status |
|----|------|----------|-------------|--------|
<!-- Recommendations added as discovered -->

### §5E Budget Tracker

| File | In Project Knowledge? | In Blob? | In Copilot Knowledge? | Size |
|------|----------------------|----------|----------------------|------|
| MOSAIC-REASONING.md | Yes | No | Yes (.txt) | ~45 KB |
| {ORG}-INDEX.md | Yes | No | Yes (.txt) | {N} KB |
<!-- Add all kernel and retrieval files -->

**Total kernel budget used:** {N} KB / ~200 KB

### §5F Upload Procedure

Three upload targets, plus two paste targets:

| Target | Files | Format | Method |
|--------|-------|--------|--------|
| Claude.ai project knowledge | 6 kernel files | .md | Manual upload |
| Copilot agent knowledge | Same 6 kernel files | .txt (generated) | Manual upload |
| Azure Blob (MCP retrieval) | All retrieval files | .md | Auto-synced by prepare_upload.ps1 |
| Claude.ai project instructions | From {ORG}-CLAUDE-PLATFORM-CONFIG.md | .txt | Paste into UI |
| Copilot Studio instructions | From {ORG}-COPILOT-PLATFORM-CONFIG.md | .txt | Paste into UI |

**End-of-session checklist:**
1. Run `prepare_upload.ps1` (stages files, syncs blob)
2. Upload kernel files to Claude.ai and Copilot if changed
3. Paste platform config if changed
4. Commit and push to git

---

## §6 System Architecture

<!-- Document the file distribution architecture -->

---

## §7 Quick File Regeneration

<!-- Define the process for regenerating QUICK files from full files -->

---

## §8 Build Playbook

<!-- Reference DOMAIN-BOOTSTRAP.md for domain builds -->

For new domain construction, follow DOMAIN-BOOTSTRAP.md. This section covers {ORG}-specific build conventions.

---

## §9 Trigger Matrix

<!-- Define events that trigger file updates -->

| Event | Affected Files | Action |
|-------|---------------|--------|
| New employee hired | {ORG}-TEAMS, {ORG}-TEAMS-HRIS | Add to roster, update headcount |
| Employee departed | {ORG}-TEAMS, {ORG}-TEAMS-HRIS | Update status, check routing impact |
| New client signed | {ORG}-CLIENTS, entity profile | Create profile, add to directory |
<!-- Add rows for org-specific trigger events -->

---

## §10 Full Sync Workflow

<!-- Define the complete monthly maintenance workflow -->

---

## Consolidated Changelog

All file changes across the instance are logged here. Individual files do NOT have their own changelogs.

| Date | File | Version | Change |
|------|------|---------|--------|
| {DATE} | {ORG}-INDEX.md | 1.0 | Initial version from Level 0 organizational discovery. |
| {DATE} | {ORG}-MAINTENANCE.md | 1.0 | Initial maintenance playbook. |
<!-- Add entries chronologically as changes are made -->
