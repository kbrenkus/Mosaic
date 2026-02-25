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

### §2.2 Quick File Manifest

<!-- Track QUICK files with their source file, version, and size.
     QUICK files condense knowledge, process, and curated views from their
     source files. They are NOT operational state dumps or comprehensive
     copies. See MOSAIC-PRINCIPLES A-007 (QUICK File Architecture). -->

| Quick File | Source File | Source Version | Quick Version | Size | Notes |
|------------|------------ |----------------|---------------|------|-------|
<!-- Add rows as QUICK files are created -->

### §2.3 Supporting Artifacts

<!-- Track non-kernel files: profiles, directories, test plans, etc. -->

| File | Version | Last Updated | Size | Notes |
|------|---------|-------------|------|-------|
<!-- Add rows as artifacts are created -->

---

## §3 Self-Check Protocol

Claude.ai runs this at the start of each maintenance cycle to detect version drift.

**Self-check prompt** (paste into Claude.ai):
> "Compare the version numbers in your loaded project knowledge files against the manifest in {ORG}-MAINTENANCE §2.1 (retrieve via `get_section`). Report any files where the loaded version differs from the manifest version, or where files listed in the manifest are not loaded."

**Expected output:** A table showing loaded vs. manifest versions, with flags for any mismatches.

**What triggers a mismatch:** QUICK files were regenerated but not re-uploaded, or full files were edited but the manifest wasn't updated. Both indicate the 4-layer sync problem is active.

---

## §4 Monthly Audit Protocol

The audit detects drift between source systems and reference files using MCP queries. Each audit runs in a separate Claude.ai conversation to stay within context budget.

For the learning loop architecture that processes audit findings, see MOSAIC-OPERATIONS §2 and §6.

### §4.1 CRM / Primary System Audit

**Paste this prompt into Claude.ai:**
> "Run a CRM data freshness audit. For each entity tracked in {ORG}-{DOMAIN}-QUICK:
> 1. Query the CRM for current status (stage, owner, dates)
> 2. Compare against reference file values
> 3. Report deltas using the YAML schema in {ORG}-A2A-QUICK §4.2
> Focus on: closed/won entities still marked active, owner changes, stage progressions, stale dates."

<!-- Customize the prompt for your primary CRM system (HubSpot, Salesforce, etc.) -->

**Output:** Delta report with `[DELTA]`, `[STALE]`, `[GAP]`, and `[STRUCT]` observations ready for the maintenance workflow.

### §4.2 Task/Project Management Audit

**Paste this prompt into Claude.ai:**
> "Run a task management audit. Check:
> 1. Team/project structure changes since last audit
> 2. New teams or projects not in reference files
> 3. Renamed or archived teams
> 4. Cross-reference GIDs/IDs against {ORG}-{DOMAIN} files
> Report deltas using the YAML schema in {ORG}-A2A-QUICK §4.2."

<!-- Customize for your task management tool (Asana, Jira, Linear, etc.) -->

### §4.3 Personnel & Systems Audit

**Paste this prompt into Claude.ai (or M365 Copilot for M365-specific checks):**
> "Run a personnel and systems audit. Check:
> 1. New hires / departures since last audit (M365 directory comparison)
> 2. Title/role changes
> 3. New applications or sites in the M365 environment
> 4. Compare against {ORG}-TEAMS and {ORG}-SYSTEMS reference files
> Report deltas using the YAML schema."

<!-- Additional audit prompts can be added as domains grow:
     §4.4 Document/Content Audit (quarterly)
     §4.5 Terminology Consistency (quarterly)
     §4.6 System Consistency (quarterly — Claude Code)
     §4.7 Memory & Rules Hygiene (quarterly — Claude Code)
-->

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

<!-- DESIGN RULE (MOSAIC-PRINCIPLES U-011): Never hardcode counts or sizes
     in narrative text. Use "count = [source]" references in tables. Sizes
     in the budget tracker above are the ONE canonical location for file
     sizes — don't duplicate them in DOMAIN-ROUTER or other files. -->

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

### §5G Tuning Register

Track behavioral adjustments derived from `[META]` self-observations and benchmark validation. Each tuning entry links back to the originating delta and the benchmark evidence.

| ID | Date | Source Delta | Domain | Observation | Benchmark Score | Action Taken | Status |
|----|------|-------------|--------|-------------|----------------|-------------|--------|
<!-- TUN-001 entries added as META deltas are validated and acted upon -->

**Process:** `[META]` delta arrives → Step 4I review → check benchmark scores (§5G.4) → if confirmed, create TUN entry → draft behavioral directive edit → user approves → update behavior file + Behavioral Parity Check.

### §5G.4 Benchmark Scores

<!-- Track domain-level benchmark scores over time.
     Scores from the 20-25 query test plan, grouped by domain.
     Update after each benchmark run. -->

| Domain | Last Score | Date | Trend | Notes |
|--------|-----------|------|-------|-------|
<!-- Populated after first benchmark run -->

### §5H Pipeline Run Summary Template

Each pipeline run produces a summary in `pipeline/run-logs/run-summary-YYYY-MM-DD.md`. Present the digest (not the full summary) to the user:

**Digest format:**
- **Headline stats:** entities matched, records matched, pipeline value, delta count
- **Action items only:** unmatched records, overlay changes, batch update CSV count, enrichment queue highlights
- **Enrichment recommendation:** #1 candidate (entity, lifecycle, gap count, track) + ask: "Enrich now, pick a different one, or skip?"
- **Link to full details** in `pipeline/run-logs/`

---

## §6 System Architecture

<!-- Document the file distribution architecture -->

---

## §7 Quick File Regeneration

<!-- Define the process for regenerating QUICK files from full files.
     For QUICK file architecture principles (what earns QUICK budget vs.
     what belongs in the full file), see MOSAIC-PRINCIPLES A-007. -->

---

## §8 Build Playbook

<!-- Reference DOMAIN-BOOTSTRAP.md for domain builds.
     For the full catalog of design principles governing builds, see
     MOSAIC-PRINCIPLES. Key principles for this phase: A-007 (QUICK File
     Architecture), A-008 (Atomic Multi-File Operations), A-009 (Progressive
     Entity Promotion), U-011 (Volatile Data in Stable Text Creates Drift). -->

For new domain construction, follow DOMAIN-BOOTSTRAP.md. This section covers {ORG}-specific build conventions.

---

## §9 Trigger Matrix

Events that trigger file updates, organized by learning loop. For the loop architecture, see MOSAIC-OPERATIONS §2.

### Loop 1 — Data Events

| Event | Delta Type | Affected Files | Action |
|-------|-----------|---------------|--------|
| New employee hired | `[DELTA]` | {ORG}-TEAMS, {ORG}-TEAMS-HRIS | Add to roster, update headcount |
| Employee departed | `[DELTA]` | {ORG}-TEAMS, {ORG}-TEAMS-HRIS | Update status, check routing impact |
| New client/entity signed | `[DELTA]` | {ORG}-CLIENTS, entity profile | Create profile, add to directory |
| Record closed/completed | `[DELTA]` | Domain QUICK file | Update status in reference |
| Record date past due | `[STALE]` | Entity profile, QUICK file | Flag for review |
| Entity coverage below threshold | `[GAP]` | Entity profile | Queue enrichment |
| Naming/format inconsistency | `[STRUCT]` | Affected reference files | Standardize naming |
<!-- Add rows for org-specific data events -->

### Loop 2+ — Reasoning & Architecture Events

| Event | Delta Type | Affected Files | Action |
|-------|-----------|---------------|--------|
| Cross-entity pattern confirmed | `[PATTERN]` | Domain reference or MOSAIC-REASONING | Draft reasoning update |
| Better query method validated | `[RECIPE]` | {ORG}-A2A-QUICK §5 | Add/update recipe |
| Entity doesn't fit taxonomy | `[ONTOLOGY]` | {ORG}-TAXONOMY | Draft taxonomy update |
| Causal mechanism validated | `[CAUSAL]` | Target reference file | Document mechanism |
| Query class needs new domain (3+) | `[DOMAIN]` | {ORG}-DOMAIN-ROUTER | Draft domain proposal |
| Agent self-observation confirmed | `[META]` | Behavior files | Draft behavioral edit (parity) |
| Inquiry answered | Varies | Depends on finding | Route to appropriate loop |

---

## §10 Full Sync Workflow

The minimum-manual-steps process for keeping everything current. For the maintenance cycle architecture, see MOSAIC-OPERATIONS §6.

### §10.1 Monthly Sync Cycle

```
Step 1: Claude.ai Self-Check (§3)
  -> New conversation - paste self-check prompt
  -> Compare loaded knowledge versions to manifest
  -> Report staleness

Step 2a: Pipeline Run (Claude Code)
  -> Claude Code runs pipeline per CLAUDE.md Pipeline Operations procedure
  -> Phase 1: MCP acquisition (live system snapshots -> JSON)
  -> Phase 2: Python transformation (snapshots + overlay -> regenerated sections)
  -> Phase 3.5: Enrichment queue generation (gap detection -> prioritized CSV + prompts)
  -> Phase 3: Review summary, process batch CSV, mark deltas complete
  -> Outputs feed into Steps 4I-4J below

Step 2b: System Audit (§4.2)
  -> New conversation - paste §4.2 prompt
  -> Produces delta report: structural changes, broken references

Step 2c: Personnel & Systems Audit (§4.3)
  -> New conversation - paste §4.3 prompt (or Copilot)
  -> Produces delta report: new hires/departures, system changes

Step 3: User Transfer
  -> Copy delta reports from Claude.ai conversations
  -> Paste into Claude Code conversation
  (This is the manual bridge between agent contexts)

Step 4: Claude Code Applies Loop 1 Deltas (§5)
  -> Edit affected full reference files
  -> Update manifest (§2)
  -> Flag any quick files needing regeneration

Step 4A: Recommendations Review (§5A)
  -> Re-scan files for markers and known issues
  -> Compare to previous cycle
  -> Present resolvable items for this session

Step 4I: Loop 2/3/4 Delta Review (Monthly)
  -> Pull Intelligence Queue items from task tracking tool
  -> Review each by type (see MOSAIC-OPERATIONS §6.2):
    * [PATTERN]: Assess durability, draft proposed edit
    * [RECIPE]: Assess vs existing recipes, draft edit
    * [ONTOLOGY]: Assess against taxonomy, draft update
    * [CAUSAL]: Validate mechanism (specific? falsifiable? evidence?)
    * [DOMAIN]: Check 3-occurrence threshold
    * [META]: Check benchmark scores, run targeted tests
    * [INQUIRY]: Assess relevance, present to user
  -> Critical rule: present and draft, never auto-apply
  -> Mark reviewed items complete after disposition

Step 4J: Entity Profile Delta Integration (Loop 1 - Surgical)
  -> Pull Loop 1 items targeting entity profiles
  -> For each delta, execute Read-Compare-Present-Write:
    1. READ: Open target file, navigate to section
    2. COMPARE: Match delta evidence against current content
    3. PRESENT: Show current + proposed change + evidence
    4. WRITE (after approval only): Apply edit
  -> Confidence-based presentation order:
    - confirmed + factual -> quick approval
    - likely + engagement data -> present with evidence
    - unverified + strategic -> flag for investigation
  -> After all deltas: bump version, update manifest, sync blob

Step 5: Claude Code Regenerates Quick Files (§7)
  -> Regenerate stale quick files
  -> Update manifest markers
  -> Update budget tracking (§5E)

Step 6: User Uploads Quick Files
  -> Upload regenerated quick files to Claude.ai project knowledge
  -> Upload .txt versions to Copilot agent knowledge
  -> Check §5E budget tracker - total under ~200 KB
  (This is THE irreducible manual step)

Step 7: Verification
  -> New Claude.ai conversation - run self-check (§3)
  -> Confirm loaded knowledge matches manifest
  -> Report: all current or remaining gaps
```

### §10.2 Maintenance Checklist

Use this checklist to track progress through the monthly cycle:

- [ ] Step 1: Self-check complete, staleness reported
- [ ] Step 2a: Pipeline run complete, run summary reviewed
- [ ] Step 2b: System audit complete
- [ ] Step 2c: Personnel audit complete
- [ ] Step 3: Delta reports transferred to Claude Code
- [ ] Step 4: Loop 1 deltas applied
- [ ] Step 4I: Loop 2/3/4 deltas reviewed
- [ ] Step 4J: Entity profile deltas integrated
- [ ] Step 5: Quick files regenerated
- [ ] Step 6: User uploaded files to platforms
- [ ] Step 7: Verification self-check passed
- [ ] Enrichment decision made (enrich now / defer / skip)
- [ ] Git commit and push

### §10.3 Emergency Sync Protocol

For urgent changes that can't wait for the monthly cycle:

1. Apply the change directly to affected reference files
2. Update manifest (§2) — the 3-part atomic operation still applies
3. Run `prepare_upload.ps1` to sync blob
4. Upload affected kernel files if changed
5. Add changelog entry
6. The next monthly cycle will detect and reconcile any ripple effects

---

## Consolidated Changelog

All file changes across the instance are logged here. Individual files do NOT have their own changelogs.

| Date | File | Version | Change |
|------|------|---------|--------|
| {DATE} | {ORG}-INDEX.md | 1.0 | Initial version from Level 0 organizational discovery. |
| {DATE} | {ORG}-MAINTENANCE.md | 1.0 | Initial maintenance playbook. |
<!-- Add entries chronologically as changes are made -->
