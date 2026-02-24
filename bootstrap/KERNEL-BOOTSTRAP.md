# KERNEL-BOOTSTRAP v1.0

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

### 3.5 Write CLAUDE.md (Instance Project Rules)

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

With infrastructure in place and the kernel scaffolded, bootstrap your first domain using DOMAIN-BOOTSTRAP.md (Levels 1-3).

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

### 4.1 Upload and Test

After building the first domain:

1. Run `prepare_upload.ps1` to stage kernel files and sync blob
2. Upload 6 kernel `.md` files to Claude.ai project knowledge
3. Upload 6 kernel `.txt` files to Copilot agent knowledge
4. Paste platform config into Copilot Studio
5. Test 3-5 queries spanning the new domain (see DOMAIN-BOOTSTRAP.md Phase 7)

---

## 5. Phase 4: Operational Readiness

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

## 6. Reference: Three-Channel Distribution Model

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

## 7. Reference: Naming Conventions

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

## 8. Changelog

| Version | Date | Change |
|---------|------|--------|
| v1.0 | 2026-02-23 | Initial version. Covers infrastructure setup, kernel construction, first domain bootstrap, and operational readiness. |
