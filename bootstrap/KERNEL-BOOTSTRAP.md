# KERNEL-BOOTSTRAP v1.4

> **Purpose:** A step-by-step guide for deploying a new Mosaic knowledge architecture instance for an organization. This covers everything from initial setup through first-domain operational readiness.
>
> **Prerequisites:** A Claude.ai account (Pro or Team), a Microsoft 365 environment (for Copilot), and an Azure subscription (for MCP server). Azure CLI and GitHub CLI installed locally.
>
> **Relationship to other docs:** This file bootstraps the *infrastructure*. DOMAIN-BOOTSTRAP.md bootstraps the *knowledge*. Run this first, then DOMAIN-BOOTSTRAP for each domain.

---

## 1. Overview

A Mosaic instance consists of:

```
{ORG}-instance/                     (private repo — your organization's knowledge)
├── {ORG}-INDEX.md                  (entry point — org topology, entity landscape)
├── MOSAIC-REASONING.md             (copy from Mosaic/core/ — shared reasoning kernel)
├── CLAUDE.md                       (project rules for Claude Code)
├── kernel/                         (static files loaded into agent project knowledge)
│   ├── {ORG}-DOMAIN-ROUTER.md      (routing table for all domains)
│   ├── {ORG}-TAXONOMY-QUICK.md     (classification frameworks)
│   ├── {ORG}-A2A-QUICK.md          (agent coordination protocol summary)
│   └── {ORG}-CLAUDE-BEHAVIORS.md   (Claude agent behavioral directives)
├── reference/                      (retrieval files → Azure Blob via MCP)
│   ├── {ORG}-MAINTENANCE.md        (system governance + changelog)
│   └── ... domain files ...
├── agent/                          (agent-specific files)
│   ├── {ORG}-COPILOT-BEHAVIORS.md  (Copilot behavioral directives)
│   ├── {ORG}-A2A-PROTOCOL.md       (full agent coordination protocol)
│   └── platform-config/            (platform deployment artifacts)
├── clients/                        (if applicable)
│   ├── profiles/                   (entity-instance files)
│   └── intelligence/               (discovery briefs, directories)
├── pipeline/                       (data freshness pipeline — see Phase 5)
│   ├── overlays/                   (curated human-judgment YAML)
│   ├── inputs/                     (gitignored — Phase 1 JSON snapshots)
│   └── run-logs/                   (gitignored — run summaries, enrichment queues)
├── scripts/                        (prepare_upload.ps1, utilities)
├── testing/                        (test plans + results/)
├── source-documents/               (external intake, gitignored)
├── archive/                        (historical, gitignored)
├── upload/                         (staging, gitignored)
└── memory/                         (Claude Code working files, gitignored)
```

The **{ORG}** prefix (e.g., `ACME-`, `MFG-`) namespaces all instance files. Choose a short, memorable prefix during setup.

---

## 2. Phase 1: Infrastructure Setup

### 2.1 Create the Instance Repository

```bash
mkdir {org}-instance
cd {org}-instance
git init
```

Create the directory structure:

```bash
mkdir -p kernel reference agent/platform-config clients/profiles clients/intelligence \
  maintenance/insights scripts testing/results source-documents archive upload memory
```

Add `.gitkeep` files to gitignored directories:

```bash
for dir in source-documents archive testing/results; do
  touch "$dir/.gitkeep"
done
```

### 2.2 Set Up .gitignore

```
# Source documents (external intake - not generated, not edited)
source-documents/*
!source-documents/.gitkeep

# Archive (historical reference - read-only)
archive/*
!archive/.gitkeep

# Test results (generated output)
testing/results/*
!testing/results/.gitkeep

# Upload staging (ephemeral, recreated by prepare_upload.ps1)
upload/

# Claude Code working files (session-specific)
memory/

# IDE and tool directories
.vs/
.cursor/
.claude/
```

### 2.3 Deploy the MCP Server (Azure)

The MCP server provides `get_section(file_name, section_ref)` — enabling agents to retrieve specific sections from reference files on demand, rather than loading entire files into context.

**Step 1: Create Azure resources**

```bash
# Resource group
az group create --name {org}-mcp --location eastus

# Storage account (lowercase, no hyphens, globally unique)
az storage account create \
  --name {org}mcpstore \
  --resource-group {org}-mcp \
  --location eastus \
  --sku Standard_LRS

# Blob container
az storage container create \
  --name reference-files \
  --account-name {org}mcpstore

# Function App (Python 3.11, Linux Consumption plan)
az functionapp create \
  --name {org}-mcp-server \
  --resource-group {org}-mcp \
  --storage-account {org}mcpstore \
  --consumption-plan-location eastus \
  --runtime python \
  --runtime-version 3.11 \
  --os-type Linux \
  --functions-version 4
```

**Step 2: Configure the connection string**

```bash
# Get the storage connection string
CONN_STR=$(az storage account show-connection-string \
  --name {org}mcpstore \
  --resource-group {org}-mcp \
  --output tsv)

# Set it as an app setting on the Function App
az functionapp config appsettings set \
  --name {org}-mcp-server \
  --resource-group {org}-mcp \
  --settings "AZURE_STORAGE_CONNECTION_STRING=$CONN_STR"
```

**Step 3: Deploy the function code**

Copy the MCP server code from `Mosaic/mcp-server/` to a deployment directory:

```bash
cp -r Mosaic/mcp-server/ {org}-mcp-deploy/
cd {org}-mcp-deploy
func azure functionapp publish {org}-mcp-server --python
```

**Step 4: Get the function key**

```bash
az functionapp keys list \
  --name {org}-mcp-server \
  --resource-group {org}-mcp \
  --output json
```

Save the function key — you'll need it when registering the MCP connector in Claude.ai.

**Step 5: Register in Claude.ai**

In your Claude.ai project settings, add a custom connector:
- **Name:** `{Org} Reference Files` (or similar)
- **Endpoint:** `https://{org}-mcp-server.azurewebsites.net/api/mcp`
- **Authentication:** Function key from Step 4

### 2.4 Set Up Copilot Studio (if using Microsoft Copilot)

Create a Copilot Studio agent with:
- **Description:** Extracted from `{ORG}-COPILOT-PLATFORM-CONFIG.md` (written in Phase 2)
- **Instructions:** Extracted from the same file (8,000 char limit)
- **Agent knowledge:** 6 kernel `.txt` files (generated by `prepare_upload.ps1`)

This step completes after the kernel files exist (Phase 2).

---

## 3. Phase 2: Kernel Construction

The kernel is the set of files loaded into every agent session. It teaches agents HOW to reason about your organization. Budget: ~200 KB for Claude.ai project knowledge, 8,000 chars for Copilot Studio instructions.

### 3.1 Copy Shared Reasoning Kernel

```bash
cp Mosaic/core/MOSAIC-REASONING.md {org}-instance/MOSAIC-REASONING.md
```

This file is company-agnostic. Never add organization-specific content to it. When Mosaic publishes updates, pull the new version.

### 3.2 Create Instance Files from Templates

Use the templates in `Mosaic/bootstrap/templates/` as starting points. Each template contains structural scaffolding with `{ORG}` placeholders and guidance comments.

**Required kernel files (6 total):**

| File | Template | Purpose |
|------|----------|---------|
| `{ORG}-INDEX.md` | `ORG-INDEX.template.md` | Entry point: org topology, entity landscape, system inventory |
| `kernel/{ORG}-DOMAIN-ROUTER.md` | `ORG-DOMAIN-ROUTER.template.md` | Routing table mapping queries to domain files |
| `kernel/{ORG}-TAXONOMY-QUICK.md` | (start empty) | Classification frameworks — populated during domain builds |
| `kernel/{ORG}-A2A-QUICK.md` | (start empty) | Agent coordination summary — populated when multi-agent is set up |
| `kernel/{ORG}-CLAUDE-BEHAVIORS.md` | `ORG-CLAUDE-BEHAVIORS.template.md` | Claude behavioral directives |
| `MOSAIC-REASONING.md` | (copied in 3.1) | Shared reasoning kernel |

**Required agent files:**

| File | Template | Purpose |
|------|----------|---------|
| `agent/{ORG}-COPILOT-BEHAVIORS.md` | `ORG-COPILOT-BEHAVIORS.template.md` | Copilot behavioral directives |

**Required reference files:**

| File | Template | Purpose |
|------|----------|---------|
| `reference/{ORG}-MAINTENANCE.md` | `ORG-MAINTENANCE.template.md` | System governance, manifests, changelog |

### 3.3 Run Level 0: Organizational Discovery

Follow DOMAIN-BOOTSTRAP.md Section 2 (Level 0). This produces:
- Domain map → populates `{ORG}-INDEX.md` and `{ORG}-DOMAIN-ROUTER.md`
- System inventory → populates `{ORG}-INDEX.md`
- Entity landscape → populates `{ORG}-INDEX.md`
- Culture profile → informs `{ORG}-CLAUDE-BEHAVIORS.md` and `{ORG}-COPILOT-BEHAVIORS.md`
- Strategic context → informs domain priority order
- AI/Automation profile → informs agent architecture decisions

### 3.4 Configure the Upload Script

Copy and configure `Mosaic/scripts/prepare_upload.ps1`:

```powershell
# Update these paths for your instance:
$SharedKernelFiles = @(
    "MOSAIC-REASONING.md",
    "{ORG}-INDEX.md",
    "kernel\{ORG}-TAXONOMY-QUICK.md",
    "kernel\{ORG}-A2A-QUICK.md",
    "kernel\{ORG}-DOMAIN-ROUTER.md"
)

$ClaudeBehaviors = "kernel\{ORG}-CLAUDE-BEHAVIORS.md"
$CopilotBehaviors = "agent\{ORG}-COPILOT-BEHAVIORS.md"

# Update blob sync paths:
$blobFiles = Get-ChildItem -Path @(
    "$AgentDir\reference\*.md",
    "$AgentDir\clients\intelligence\*.md",
    "$AgentDir\clients\profiles\*.md"
) -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $blobExcludes }

# Update platform config paths:
$agentConfig = Join-Path $AgentDir "agent\platform-config\{ORG}-COPILOT-PLATFORM-CONFIG.md"
$claudeProject = Join-Path $AgentDir "agent\platform-config\{ORG}-CLAUDE-PLATFORM-CONFIG.md"
```

### 3.5 Design Pitfalls to Avoid

These patterns were discovered empirically and codified in MOSAIC-PRINCIPLES. They save significant rework:

- **No volatile data in stable text (U-011).** Never hardcode counts, sizes, or dates in narrative prose — they drift immediately. Use "count = rows in [table]" references. File sizes live in MAINTENANCE §2.1 only.
- **No operational state in QUICK files (A-007).** QUICK files condense knowledge, process, and curated views. Open items, version manifests, metrics, and other state that changes frequently belong in the full reference file, not the QUICK.
- **Format definitions in A2A protocol, not behavior files.** When multiple agents consume the same output format (Activity Snapshot, Coverage Assessment, etc.), define it once in the A2A protocol file. Behavior files get pointers + behavioral triggers.
- **No triple-coverage (U-012 Interception).** If content appears in the kernel, a QUICK file, AND a full file, the agent finds the closest copy and stops. Keep definitions in one canonical place; use pointers elsewhere.
- **Kernel earns its budget (§6.1 Kernel Epistemology).** Every line in the kernel must shape reasoning (dispositional/hermeneutical). Navigational content (lists, inventories, lookup tables) belongs in retrieval files.

For the full catalog: MOSAIC-PRINCIPLES.

### 3.6 Write CLAUDE.md (Instance Project Rules)

Create `CLAUDE.md` at the instance root. This governs Claude Code's behavior when working in your instance. Key sections:

- **Artifact Distribution** — the 3 upload targets (Claude.ai .md, Copilot .txt, Azure Blob) and the prepare_upload.ps1 workflow
- **MCP Server** — endpoint URL, function key, hygiene rules
- **File Organization** — your directory tree
- **Cross-Reference Convention** — base filenames without extension
- **Kernel Architecture & Budget** — the ~200 KB budget, reasoning-vs-data test
- **Session Protocol** — start/end checklist, version bump rules
- **Sensitivity Rule** — data classification tiers

Use the existing CLAUDE.md from an established Mosaic instance as a reference for structure and conventions.

---

## 4. Phase 3: First Domain Bootstrap

With infrastructure in place and the kernel scaffolded, bootstrap your first domain using DOMAIN-BOOTSTRAP.md (Levels 1-3). Keep MOSAIC-PRINCIPLES open as a build companion — it encodes the lessons from previous deployments.

**Choose your first domain wisely.** Pick a domain that:
- Has a willing, engaged steward
- Has enough complexity to test the architecture (not trivial)
- Has data in systems the agents can access
- Delivers visible value quickly (builds organizational buy-in)

The first domain build will:
1. Populate `{ORG}-DOMAIN-ROUTER.md` with the first routing entries
2. Create domain reference files in `reference/`
3. Potentially create entity-instance files in `clients/` or similar
4. Populate `{ORG}-TAXONOMY-QUICK.md` with the first classification frameworks
5. Test the full pipeline: kernel → retrieval → MCP → agent response

### 4.1 Apply File Optimization Rules

Before uploading domain files, apply the File Optimization Rules from CLAUDE.md to all new files. Key checks:
- Lookup/routing tables → YAML format (IDs, mappings, aliases)
- All markdown tables → minified (no cell padding, `|---|` separators)
- Procedural prose → telegraphic (remove articles, filler)
- Reasoning exposition, safety rules, worked examples → full prose (never compress)
- Whitespace → single blank lines, HRs between major sections only

This ensures new domains start lean. See MOSAIC-OPERATIONS §4.7 for the methodology-level rationale.

**Why this matters at bootstrap time:** Files created during the initial build set the token budget baseline for the entire domain. Optimization applied later requires re-uploading to project knowledge, re-syncing to blob, re-testing for regressions, and updating manifests — a compression retrofit cycle that costs more than getting format right at construction.

Key format decisions at construction time:
- YAML for lookup/routing data (~57% fewer tokens than equivalent markdown tables)
- Minified markdown tables for reasoning frameworks (no cell padding, minimal separators)
- Telegraphic prose for procedural content (remove articles, conjunctions, filler where meaning is preserved)
- Full prose for reasoning exposition, behavioral directives, and safety instructions

See DOMAIN-BOOTSTRAP Phase 5 for construction-level compression guidance.

### 4.2 Upload and Test

After building the first domain:

1. Run `prepare_upload.ps1` to stage kernel files and sync blob
2. Upload 6 kernel `.md` files to Claude.ai project knowledge
3. Upload 6 kernel `.txt` files to Copilot agent knowledge
4. Paste platform config into Copilot Studio
5. Test 3-5 queries spanning the new domain (see DOMAIN-BOOTSTRAP.md Phase 7)

---

## 5. Phase 4: Git & Session Workflow

### 5.1 Commit and Push

```bash
cd {org}-instance
git add .
git commit -m "Initial kernel: Level 0 + first domain"
gh repo create {org}-instance --private --source=. --remote=origin --push
```

### 5.2 Establish Session Workflow

Every work session follows this pattern:

1. **Start:** `git pull` (get latest changes)
2. **Work:** Edit files, bump versions, update manifests
3. **End:** Run `prepare_upload.ps1`, commit, push, remind user to upload

### 5.3 Plan Next Domains

Use the domain map from Level 0 and strategic priorities to plan the next domain builds. Each follows DOMAIN-BOOTSTRAP.md independently.

---

## 6. Phase 5: Learning Infrastructure Setup

> *With the first domain operational, set up the self-learning machinery that keeps the system current and improves its reasoning over time. This phase activates the patterns described in MOSAIC-OPERATIONS.*
>
> **Prerequisite:** Phase 3 complete (at least one domain operational with files in blob and kernel uploaded). The learning infrastructure needs data to learn from.

### 6.1 Set Up Task Tracking Project

Create a project in your task management tool (e.g., Asana) with two sections:

| Section | Purpose | Delta Types |
|---------|---------|-------------|
| **Data Corrections** | Loop 1 data freshness deltas | `[DELTA]`, `[GAP]`, `[STRUCT]`, `[STALE]` |
| **Intelligence Queue** | Loop 2/3/4 reasoning & architecture deltas | `[PATTERN]`, `[RECIPE]`, `[ONTOLOGY]`, `[CAUSAL]`, `[DOMAIN]`, `[META]`, `[INQUIRY]` |

Record the section GIDs/IDs in your instance's `{ORG}-A2A-QUICK.md` §4.3 (Queue Routing table).

**Why two sections:** Data corrections are higher-volume and partially automatable. Intelligence observations are strategic and always require human judgment. Separating them prevents data noise from burying insights.

### 6.2 Configure Delta Queue

Update the delta queue references in your instance files:

1. **{ORG}-A2A-QUICK §4.3** — Set section GIDs/IDs for Data Corrections and Intelligence Queue
2. **{ORG}-CLAUDE-BEHAVIORS** — The Signal Awareness section references these sections for delta routing
3. **{ORG}-COPILOT-BEHAVIORS** — Same references for Copilot

**Task naming convention:** `[TYPE] Target: Description` (e.g., `[STALE] Acme Corp: Deal date 8 months overdue`)

**Task body:** YAML front matter using the schema in {ORG}-A2A-QUICK §4.2.

### 6.3 Set Up Pipeline Directory

```bash
cd {org}-instance

# Copy pipeline templates
cp -r Mosaic/bootstrap/templates/pipeline/ pipeline/

# Rename template files
mv pipeline/generate-domain-quick.py.template pipeline/generate-{domain}-quick.py
mv pipeline/generate_enrichment_queue.py.template pipeline/generate_enrichment_queue.py

# Create gitignored directories
mkdir -p pipeline/inputs pipeline/run-logs
echo "*" > pipeline/inputs/.gitignore
echo "!.gitignore" >> pipeline/inputs/.gitignore
echo "*" > pipeline/run-logs/.gitignore
echo "!.gitignore" >> pipeline/run-logs/.gitignore
```

**Configure the pipeline for your instance:**

1. **Overlay YAML** — Create `pipeline/overlays/{ORG}-{DOMAIN}-OVERLAY.yaml`. The overlay is the curated human-judgment layer: fields that represent strategic decisions (lifecycle, tier, classification) rather than system data. The pipeline merges live system data ONTO the overlay's curated judgments — overlay provides stability, live data provides currency.

   Minimum schema: `canonical_name` (full official name), `lifecycle_state` (strategic relationship phase), `entity_type` (classification from domain taxonomy), `tier` (coverage depth priority).

   Optional but commonly needed: `strategic_notes` (freeform human context), `verify` (list of fields with conflicting signals), cross-system identity overrides (`asana_team_gid`, etc. for entities that can't be matched by name), `name_aliases` (additional name variants for fuzzy matching against system records).

   See MOSAIC-OPERATIONS §4.5 for the overlay pattern methodology. See overlays/README.md in the template directory for full schema documentation and examples.
2. **Lookup tables** — Create stage mapping and owner mapping YAML files for your CRM/system
3. **Pipeline script** — Customize `generate-{domain}-quick.py`:
   - Update file paths and overlay references
   - Implement `load_overlay()` and `load_lookup_tables()`
   - Implement `match_entities()` with your entity-matching logic
   - Implement `generate_quick_section()` with your section format
4. **Enrichment queue** — Customize `generate_enrichment_queue.py`:
   - Update `PROFILES_DIR` path
   - Update `GAP_MARKERS` with your instance's gap marker patterns
   - Update `LIFECYCLE_TIERS` mapping
5. **CLAUDE.md** — Add your specific Phase 1 MCP calls to the Pipeline Operations section

#### 6.3.1 Pipeline Design Lessons (from production deployments)

Patterns validated through production use:

**~78% of pipeline logic is universal.** The generate-domain-quick.py template's universal portions — overlay loading, JSON snapshot parsing, name normalization, section rewriting, run summary generation, batch CSV output — work across domains without modification. Domain-specific customizations concentrate in: lifecycle state ordering, entity-matching heuristics, junk-data filtering patterns, table column definitions, and profile path resolution. The 6 `CUSTOMIZE` functions in the template isolate these decision points.

**Overlay schema should be generous.** Start with more fields than you think you need: canonical_name, lifecycle_state, tier, entity_type, strategic_notes, and verify flags as a minimum. Optional fields that consistently prove essential in production: cross-system GID overrides (for entities that can't be matched by name), name aliases (for fuzzy matching against system records with variant spellings), profile filename overrides (for entities whose short names don't map cleanly to file naming conventions).

**Name normalization is critical.** Smart quotes (U+2019), encoding artifacts (mojibake: `\u00e2\u20ac\u2122`), case differences, leading/trailing whitespace, and punctuation variations (hyphens, apostrophes, periods) all appear in real MCP data. The template's `normalize_name()` function handles common cases; extend it for your domain's specific patterns. Test with real data early — name matching failures are the #1 source of "unmatched entity" false positives.

**Enrichment queue threshold is a starting point.** The Track 1/Track 2 boundary (default: 12 gap markers) worked for a ~40-entity client domain. Adjust the threshold after your first production run: if most entities land in Track 2, the threshold is too low. If almost none do, it's too high. The goal is ~20-30% of entities in Track 2 per cycle.

**Auto-delete previous run inputs.** Configure the pipeline to clean up the previous run's input files and enrichment outputs before writing new ones. This prevents confusion about which snapshot is current and avoids accumulating stale data in the pipeline directory.

### 6.4 Configure Maintenance Cycle

In `{ORG}-MAINTENANCE.md`:

1. **§4 Monthly Audit Protocol** — Customize the audit prompts for your connected systems
2. **§9 Trigger Matrix** — Add organization-specific trigger events
3. **§10 Full Sync Workflow** — Set your cycle frequency (monthly default) and customize steps for your agent/system configuration

**Cycle frequency decision:**
- **Monthly** (default) — good starting point for most instances
- **Biweekly** — for data-heavy instances with many live system connections
- **6 weeks** — for stable instances with slow-changing data

### 6.5 Wire Signal Awareness

Review the signal trigger tables in your behavior files and customize thresholds:

1. **{ORG}-CLAUDE-BEHAVIORS** — Loop 1 thresholds (staleness periods, coverage percentages) should match your organizational expectations
2. **{ORG}-COPILOT-BEHAVIORS** — Same thresholds adapted for M365-scoped detection
3. **Both files** — Verify trigger discipline rules make sense for your domain complexity

**Start conservative:** Set thresholds loose (emit fewer deltas) and tighten as you learn what signal quality looks like for your instance. The queue accumulates — better to start clean than noisy.

### 6.6 Set Up Memory Management

```bash
# Create MEMORY.md template
cat > memory/MEMORY.md << 'EOF'
# {Organization Name} -- Claude Code Memory

## Active Work
<!-- Current session context, task status, pending items -->

## Key Patterns
### File Locations
- Instance repo: {path to instance repo}
- Shared Mosaic repo: {path to shared repo}

## Completed (reference only)
<!-- Move items here when work is done -->
EOF
```

**Memory conventions:**
- **MEMORY.md** — Always loaded, under 150 lines. Current status + key patterns.
- **memory/*.md** — Topic files for detailed briefs. Named by topic, not date.
- **archive/** — Completed briefs, retired scripts. Read-only historical reference.
- The `memory/` directory is gitignored. Only the instance owner sees it.

### 6.7 Validate Learning Infrastructure

Run through each piece to verify it works:

1. **Delta queue test:** Manually create a test task in each section using the YAML schema. Verify it appears correctly in your task tracking tool.
2. **Pipeline test:** Run the pipeline with sample data (even if just 2-3 test records). Verify:
   - Phase 1 JSON snapshots write correctly
   - Phase 2 script runs without errors (even with placeholder logic)
   - Phase 3.5 enrichment queue generates a CSV
3. **Signal awareness test:** In a Claude.ai conversation, verify the agent mentions signal detection at conversation end (even if no deltas are emitted, the behavior should be present).
4. **Memory test:** Verify MEMORY.md loads in Claude Code sessions.

**Expected timeline:** 1-2 sessions to fully configure. The pipeline will be functional after entity matching and section generation are implemented.

---

## 7. Reference: Three-Channel Distribution Model

> *Understanding where files go is essential for maintaining the system.*

Understanding where files go is essential for maintaining the system:

| Channel | What | Format | How | Who Reads |
|---------|------|--------|-----|-----------|
| **Claude.ai project knowledge** | 6 kernel files | .md | Manual upload after edits | Claude (on every query) |
| **Copilot agent knowledge** | Same 6 kernel files | .txt (generated) | Manual upload after edits | Copilot (on every query) |
| **Azure Blob (MCP)** | All retrieval files | .md | Auto-synced by script | Both agents (on demand via get_section) |

**Kernel files** teach reasoning patterns the agent needs on every query. They earn their static budget.

**Retrieval files** provide data the agent looks up for specific queries. They live in blob and are loaded on demand via the `get_section` MCP tool.

The test: *Does this file teach a pattern the agent needs on every query, or provide data the agent looks up for specific queries?*

---

## 8. Reference: Naming Conventions

| Pattern | Example | Purpose |
|---------|---------|---------|
| `{ORG}-{DOMAIN}.md` | `ACME-TEAMS.md` | Full domain reference file |
| `{ORG}-{DOMAIN}-QUICK.md` | `ACME-TEAMS-QUICK.md` | Session-level index (20% data, 80% of queries) |
| `{ORG}-{DOMAIN}-{SUBDOMAIN}.md` | `ACME-SYSTEMS-CRM.md` | Domain subsystem file |
| `{ORG}-INDEX.md` | `ACME-INDEX.md` | Instance entry point |
| `{ORG}-DOMAIN-ROUTER.md` | `ACME-DOMAIN-ROUTER.md` | Query routing table |
| `{ORG}-CLAUDE-BEHAVIORS.md` | `ACME-CLAUDE-BEHAVIORS.md` | Claude behavioral directives |
| `{ORG}-COPILOT-BEHAVIORS.md` | `ACME-COPILOT-BEHAVIORS.md` | Copilot behavioral directives |
| `{ORG}-MAINTENANCE.md` | `ACME-MAINTENANCE.md` | System governance + changelog |
| `MOSAIC-REASONING.md` | (no prefix) | Shared reasoning kernel |

---

## 9. Changelog

| Version | Date | Change |
|---------|------|--------|
| v1.4 | 2026-02-26 | Expanded Phase 5 pipeline setup: added §6.3.1 pipeline design lessons from production (78% universal logic, overlay schema, name normalization, enrichment threshold, auto-deletion). Expanded overlay YAML guidance in §6.3 (minimum + optional schema, MOSAIC-OPERATIONS cross-reference). Expanded §4.1 context compression rationale (bootstrap-time importance, key format decisions, cross-references). |
| v1.3 | 2026-02-25 | Added §4.1 File Optimization checkpoint in Phase 3 — apply CLAUDE.md optimization rules before uploading domain files. |
| v1.2 | 2026-02-25 | Added Phase 5: Learning Infrastructure Setup (delta queue, pipeline, signal awareness, memory management). Renumbered Phase 4 to "Git & Session Workflow." Added pipeline/ to directory tree. MOSAIC-OPERATIONS reference throughout. |
| v1.1 | 2026-02-24 | Added §3.5 Design Pitfalls (empirical anti-patterns from first deployment), MOSAIC-PRINCIPLES reference in Phase 3. |
| v1.0 | 2026-02-23 | Initial version. Covers infrastructure setup, kernel construction, first domain bootstrap, and operational readiness. |
