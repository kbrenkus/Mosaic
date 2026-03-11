# Mosaic — {Organization Name} Agent Project Rules

## Artifact Distribution

Three upload targets for agent files, plus two paste targets for platform config:

|Target|Files|Format|Method|
|---|---|---|---|
|Claude.ai project knowledge|6 kernel .md files|.md|Manual upload|
|Copilot agent knowledge|Same 6 kernel files|.txt (generated)|Manual upload|
|Azure Blob (MCP retrieval)|All retrieval .md files|.md|Auto-synced by script|
|Claude.ai project instructions|Extracted from {ORG}-CLAUDE-PLATFORM-CONFIG.md|.txt|Paste into UI|
|Copilot Studio description + instructions|Extracted from {ORG}-COPILOT-PLATFORM-CONFIG.md|.txt|Paste into UI|

The 6 kernel files are: 5 shared (MOSAIC-REASONING, {ORG}-INDEX, {ORG}-TAXONOMY-QUICK, {ORG}-A2A-QUICK, {ORG}-DOMAIN-ROUTER) + 1 agent-specific ({ORG}-CLAUDE-BEHAVIORS for Claude, {ORG}-COPILOT-BEHAVIORS for Copilot). .txt copies for Copilot are generated artifacts in Upload/ only — never co-located with source .md files.

<!-- If you don't use Copilot, remove the Copilot rows above and simplify to 2 targets. -->

**End of every session:**
- Run prepare_upload.ps1 to stage files and sync blob: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/prepare_upload.ps1`
- Use `-SkipBlob` flag when Azure CLI is not available (e.g., travel): `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/prepare_upload.ps1 -SkipBlob`
- Remind the user to upload staged files per the checklist in {ORG}-MAINTENANCE §5F.

## MCP Server — `get_section` Tool

The Azure Function at `{org}-mcp-server.azurewebsites.net` exposes `get_section(file_name, section_ref)` as a Claude.ai custom connector. It reads `.md` files directly from Azure Blob Storage (`{org}mcpstore/reference-files`) — no `.txt` intermediary.

**Blob scope:** `reference/*.md` (excluding kernel files). Blob stores `.md` files directly. Kernel files (MOSAIC-REASONING, {ORG}-INDEX, {ORG}-DOMAIN-ROUTER, {ORG}-TAXONOMY-QUICK, {ORG}-A2A-QUICK) are uploaded to Claude.ai project knowledge only, NOT blob. `prepare_upload.ps1` auto-syncs non-kernel `.md` files to blob at session end — no separate step needed.

<!-- Add additional blob scope paths as your instance grows (e.g., clients/intelligence/*.md, clients/profiles/*.md). Update both the blob scope description above AND the glob in prepare_upload.ps1 Section 3. -->

**Three hygiene rules:**

1. **Editing existing files** — no extra steps. `prepare_upload.ps1` syncs to blob automatically.
2. **Adding a new file to `reference/`** — no extra steps. The blob sync uses a glob and picks it up automatically.
3. **Adding a file outside `reference/` that needs `get_section` access** — add it to the blob sync glob in `prepare_upload.ps1` (one line), then run the blob sync once to seed it.

**Server code changes** are only needed for behavior changes: new tools, changed parsing logic, new error format. Content changes never require a redeploy.

<!-- Update the redeploy command below with your actual paths and function app name:
```
func azure functionapp publish {org}-mcp-server --python
```
-->

## File Organization

```
{org}-instance/
├── MOSAIC-REASONING.md               (shared reasoning kernel — copy from Mosaic/core/)
├── {ORG}-INDEX.md                    (entry point)
├── CLAUDE.md                         (this file — project rules)
├── kernel/                           ({ORG}-DOMAIN-ROUTER, QUICK files, CLAUDE-BEHAVIORS)
├── reference/                        (full reference files → blob)
├── agent/                            (COPILOT-BEHAVIORS, A2A-PROTOCOL)
│   └── platform-config/              (platform deployment configs)
├── pipeline/                         (data freshness pipeline scripts + config)
│   ├── overlays/                     (curated human-judgment YAML)
│   ├── inputs/                       (.gitignored — Phase 1 JSON snapshots)
│   └── run-logs/                     (.gitignored — run summaries)
├── mcp-server/                      (Azure Function MCP server code)
├── scripts/                          (prepare_upload.ps1, utilities)
├── testing/                          (test plan + results/)
├── source-documents/                 (.gitkeep — intake folder, gitignored)
├── archive/                          (.gitkeep — historical files, gitignored)
├── upload/                           (ephemeral staging, gitignored)
└── memory/                           (Claude Code working files, gitignored)
```

<!-- Add instance-specific directories as needed (e.g., clients/profiles/ for entity-instance files, maintenance/insights/ for learning loop artifacts). Update the tree above when you do. -->

**`source-documents/` is the intake folder.** The user drops external files here (spreadsheets, data exports, CSVs) for Claude Code to read when integrating data into the reference system. Files here are inputs, not outputs — they are never edited, only read. Clean up after integration is complete and data is captured in reference files.

## Cross-Reference Convention

- Cross-references between .md files use **base filenames without extension or path** (e.g., "see {ORG}-TEAMS").
- This convention is path-agnostic — references work regardless of folder structure.
- Keep .md in: manifest markers, file paths, changelog entries, table cells naming files.
- Strip .md from: narrative cross-references.

## Date Format Standard

- **All dates with year+month+day** → `YYYY-MM-DD` (ISO 8601). Example: `2026-02-21`
- **All dates with year+month only** → `YYYY-MM`. Example: `2026-02`
- **Month names as scheduling labels** (not dates) → keep natural language. Example: "| June | quarterly audit..."
- Applies to: file headers, table cells, narrative text, changelog entries.
- Does NOT apply to: archive/, source-documents/, .claude/ memory files used only as scratch.

<!-- If your source systems use non-ISO date formats (e.g., MM/DD/YYYY from HRIS), document the exception here with the pipeline conversion plan. -->

## Kernel Architecture & Budget

After editing any file loaded into Claude.ai project knowledge or Copilot Studio agent config, update {ORG}-MAINTENANCE §5E budget table.

- Claude.ai: ~200 KB limit across project knowledge files (count = {ORG}-MAINTENANCE §5E)
- Copilot Studio: 8,000 char limit for agent config text

**Kernel architecture principles.** Three frameworks from MOSAIC-REASONING §6 are the core decision heuristics for kernel budget: kernel epistemology (§6.1 — epistemological type determines budget eligibility; dispositional and hermeneutical must be present, ontological and navigational can be retrieved), ambient context (§6.2 — content earns budget by shaping reasoning, not by being referenced), and interception (§6.3 — duplicates intercept, pointers deepen; when content exists in two places, the agent finds the closer copy and stops). Domain knowledge follows six layers (§6.6) with a two-part placement test for gradient layers. Retrieval files have a size ceiling (~40 KB), attention gradient, and query-pattern split boundaries (§4.7-§4.8). For the full catalog of 32+ named design principles with evidence, tests, and governance, see MOSAIC-PRINCIPLES.

**Kernel pruning heuristic.** When auditing kernel files for size, classify each section as dispositional (shapes reasoning before conscious application — must be ambient) or procedural (consumed at a specific workflow moment — can be retrieved). Diagnostic signal: if the agent reports content feels "navigated rather than absorbed," it's a candidate for retrieval migration. Keep type semantics and detection triggers in kernel; move formatting schemas, worked examples, and posting instructions to retrieval with a compact pointer.

**Cognitive foreground principle.** Ambient context has a finite attentional budget beyond the token budget. Lookup data (ID mapping tables, system inventories, stage mappings) doesn't just consume tokens — it actively competes with dispositional content for cognitive foreground, reducing the effectiveness of reasoning frameworks, behavioral directives, and signal detection triggers. **Three-way classification for kernel content:** (1) Dispositional — shapes all reasoning, must be ambient (reasoning frameworks, behavioral directives, signal triggers). (2) Orientation — context the agent reasons *from*, benefits from ambient but survives retrieval (domain router, structural overview). (3) Lookup/procedural — data the agent reasons *about* or consumes at a specific moment, should be retrieved (ID tables, stage mappings, worked examples, formatting schemas). **Design tradeoff:** Moving lookup data to retrieval adds latency (retrieval hops before queries) but increases investigation depth and analytical quality. We favor depth over speed: quality of intelligence output matters more than response latency for this system. **Watch for recipe ingredients:** Some lookup data (e.g., pipeline stage IDs) functions as a prerequisite for high-frequency recipes. Moving it adds retrieval cost on every query. Evaluate per-item: if the data is consumed on >50% of queries in its domain, it may belong in kernel despite being "lookup" by type.

**Kernel eligibility gate (for domain bootstraps).** When bootstrapping a new domain, the default is "retrieval, not kernel." Domain knowledge is almost always ontological (entity definitions) or navigational (routing to content) — both retrievable. The router entry in {ORG}-DOMAIN-ROUTER is typically the only kernel touch point. To earn kernel space, domain content must demonstrate dispositional value (shapes how the agent reasons about everything) or hermeneutical value (changes how the agent interprets inputs). Two-part test: (1) Does this content shape reasoning quality even when not directly referenced? (2) Would retrieval delay degrade performance in a way that changes outcomes? Both must be "yes." Re-audit trigger: kernel headroom drops below 30% of platform limit, or 3+ domains bootstrapped since last audit. See DOMAIN-BOOTSTRAP §4.10.

## File Optimization Rules

Context-efficient formatting for all reference files (.md). These patterns reduce token consumption 15-25% with zero reasoning quality loss.

**Format selection:**
- **YAML** for lookup/routing data: ID tables, stage mappings, aliases, capability matrices, troubleshooting references. YAML uses ~57% fewer tokens than equivalent markdown tables for structured data.
- **Minified markdown tables** for reasoning frameworks: authority types, entity types, routing decision trees. Strip cell padding, use minimal `|---|` separators.
- **Telegraphic prose** for procedural/routing content: remove articles, conjunctions, filler where meaning preserved. "Check approval authority table — determine if within threshold" not "The agent should check the approval authority table to determine whether the request falls within the authorized threshold."
- **Full prose** for reasoning exposition (MOSAIC-REASONING), behavioral directives, safety rules, "Do NOT" instructions, and worked examples for complex patterns.

**Whitespace:** Single blank line between sections. Never double-blank. Horizontal rules (`---`) between major sections only. No trailing whitespace.

**Tables:** Minimal separators (`|---|`). No cell padding (`|value|` not `| value |`). Exception: numeric columns where alignment aids scanning.

**Examples:** 1-2 for simple patterns. 3 max for complex/counterintuitive. Worked examples for behavioral patterns contradicting agent instinct: always include — abstract directives fail for counterintuitive behaviors (A-023/F-1b).

**Never compress:** Reasoning exposition in MOSAIC-REASONING (prose is load-bearing). Behavioral "Do NOT" / safety instructions. Data protection / sensitivity rules. Markdown headers (essential for hierarchy + `get_section` parsing).

Apply when: creating new files, editing existing files, bootstrapping new domains, regenerating QUICK files. See MOSAIC-OPERATIONS §4.7 for methodology-level documentation.

## Shared Reasoning Kernel

MOSAIC-REASONING.md is the **shared reasoning kernel** — company-agnostic frameworks (people reasoning, analytical intelligence, retrieval architecture, agent coordination, design principles) that are distributable across all Mosaic instances.

**Rules:**
- **Never add company-specific data** to MOSAIC-REASONING.md — no names, system IDs, entity lists, or worked examples referencing a specific organization. If an {ORG}-specific example is needed, use a generic equivalent.
- **Versioned independently.** MOSAIC-REASONING follows its own version track (v1.0, v1.1, etc.), not {ORG}-MAINTENANCE's version. Version bumps get a manifest row in §2.1. Change history tracked in git.
- **Instance files reference shared reasoning with pointers**, not duplicated content: "For analytical voice and reasoning frameworks, see MOSAIC-REASONING §3."
- **When editing reasoning frameworks,** prefer editing MOSAIC-REASONING (benefits all instances) over adding reasoning to {ORG}-specific files. {ORG}-specific files should contain {ORG}-specific reasoning only.

## Shared Repo Relationship

This instance repo sits alongside the shared Mosaic methodology repo:

```
{parent-dir}/
├── Mosaic/           (shared methodology, reasoning kernel, bootstrap protocols)
└── {org}-instance/   (this repo — private instance)
```

<!-- If the MCP server deployment directory is separate, add it here. -->

**Pulling reasoning kernel updates:**
1. `cd Mosaic/ && git pull` to get the latest shared repo
2. Compare `Mosaic/core/MOSAIC-REASONING.md` version with local `MOSAIC-REASONING.md`
3. If newer, copy: `cp Mosaic/core/MOSAIC-REASONING.md MOSAIC-REASONING.md`
4. Upload new version to Claude.ai project knowledge
5. Update {ORG}-MAINTENANCE §2.1 manifest with new version
6. Run 3 smoke test queries to verify no regression

**Submitting insights upstream:** When instance work reveals improvements to shared reasoning, follow the proposal process in `Mosaic/proposals/PROPOSAL-TEMPLATE.md`. Include evidence from this instance (test results, benchmark data). Proposals are reviewed and merged by Mosaic maintainers.

<!-- If you are the primary Mosaic architect / originating instance, you may apply improvements directly to the shared repo without a formal proposal. Adjust the upstream rules above accordingly. -->

**Structural learning trigger:** During instance work, structural improvements often emerge organically — file organization patterns, compression techniques, pipeline designs, cross-reference conventions, bootstrap shortcuts, maintenance workflows. When Claude Code or the user identifies a structural improvement that is company-agnostic, flag it as an upstream candidate.

**Boundary rule:** Instance-specific content (names, system IDs, entity data) never goes into Mosaic/. Shared methodology never goes only into this instance — if it's company-agnostic, it belongs in Mosaic/.

## Pipeline Operations

<!-- INSTANCE-SPECIFIC: This section documents your specific pipeline — what MCP calls to make,
     what system IDs to use, what scripts to run. Fill this in during KERNEL-BOOTSTRAP Phase 5
     (Learning Infrastructure Setup) or when building your first domain pipeline.

     Structure it as:
     1. Phase 1 — MCP Data Acquisition (Claude Code): list each MCP call with tool name,
        parameters, filters, and output file path. Include workspace GIDs, pipeline IDs,
        stage filters, and any junk-data filters.
     2. Phase 2 — Transformation (Python): the script command with date parameter.
     3. Phase 3.5 — Enrichment Queue (Python): the enrichment queue script command.
     4. Run summary presentation: what to show the user and what to skip.
     5. Phase 3 — Post-processing: what happens after review (batch CSV, delta completion, upload).

     Example from a production instance (Growth domain pipeline):

     **Running the pipeline (Phase 1 → 2 → 3.5):**

     When the user says "run pipeline" or "run maintenance":

     1. **Phase 1 — MCP Data Acquisition** (Claude Code):
        - Load CRM + task management MCP tools (deferred — must load before calling)
        - CRM deals: `search_crm_objects` — active deals, default pipeline.
          Properties: dealname, amount, dealstage, owner_id, closedate, last_modified.
          Write to `pipeline/inputs/crm-deals-YYYY-MM-DD.json`
        - Task management teams: `get_teams_for_workspace` (workspace_gid).
          Filter junk teams. Write to `pipeline/inputs/teams-YYYY-MM-DD.json`
        - Delta queue: `get_tasks` section (section_gid), incomplete only.
          Write to `pipeline/inputs/delta-queue-YYYY-MM-DD.json`
        - Set `RUN_DATE=YYYY-MM-DD` once at start and use for all filenames

     2. **Phase 2 — Transformation** (Python):
        `python pipeline/generate-{domain}-quick.py --date YYYY-MM-DD`

     3. **Phase 3.5 — Enrichment Queue** (Python):
        `python pipeline/generate_enrichment_queue.py`

     4. **Present run summary digest** and proceed to Phase 3 post-processing.

     Delete this comment block and replace with your actual pipeline specification. -->

[Pipeline not yet configured. See KERNEL-BOOTSTRAP Phase 5 for setup instructions.]

## Domain Bootstrap Workflow

When bootstrapping a new domain for this instance, follow DOMAIN-BOOTSTRAP.md (Mosaic/bootstrap/) Levels 1-3. Key integration points with this instance:

- **Phase 1F (Substrate Audit):** System inventory in {ORG}-INDEX. System connectivity classified per system (Agent-Integrated / Manual per MOSAIC-INFORMATION-GOVERNANCE §2.5).
- **Phase 2F (Data Mapping):** Run discovery across available agents in parallel. Capture results with agent provenance.
- **Phase 4 (Architecture):** Kernel budget tracked in {ORG}-MAINTENANCE §5E. Apply File Optimization Rules (above) from the start. Kernel eligibility gate (§4.10): default is retrieval-only.
- **Phase 5 (Construction):** File naming convention: {ORG}-{DOMAIN}-QUICK.md, {ORG}-{DOMAIN}.md. Router entry in {ORG}-DOMAIN-ROUTER.md. Manifest rows in {ORG}-MAINTENANCE §2.1 and §2.2. Behavioral directives in {ORG}-CLAUDE-BEHAVIORS and {ORG}-COPILOT-BEHAVIORS (parity check applies).
- **Phase 6 (Enrichment):** Pipeline specification in pipeline/ directory. Overlay YAML in pipeline/overlays/. Phase 1 MCP acquisition procedure added to this file's Pipeline Operations section.
- **Phase 7 (Validation):** Pre-build baseline and post-build comparison recorded in testing/. Use test plan scoring rubric format.

<!-- Add instance-specific integration notes as you build domains. Examples:
     - Multi-agent discovery (Phase 2F): which agents run which prompts
     - Cross-cutting file impacts (Phase 4.9): which shared files each domain touches
     - Source pruning (Phase 5.6): scatter content classification and stub depth
     - Session sequencing: which Foundation track work runs ahead of steward input -->

For retroactive audits of existing domains, follow DOMAIN-BOOTSTRAP Phase 8. Audit findings become maintenance backlog items in {ORG}-MAINTENANCE §5A.

## Git Workflow

**Session start:**
- `git pull` before any work. Claude Code checks and reminds.

**Session end:**
- After running `prepare_upload.ps1`, stage changes: `git add` specific files.
- Commit with a descriptive message. Push to remote.

**Safety rules:**
- **Never force push.** If git complains, stop and troubleshoot — don't override.
- **Merge conflicts:** Claude Code helps resolve. Never force through.
- **Instance repo:** Push freely — it's private, it's your workspace.
- **Shared repo (Mosaic):** Push only when intentionally publishing methodology updates. Never push instance-specific content.

**Deferred blob sync:** If Azure CLI is not available (e.g., travel laptop), use `prepare_upload.ps1 -SkipBlob` to stage kernel files locally. Commit and push changes to git. Blob sync runs when back at main workstation. Files in git are always the source of truth; blob catches up.

## Session Protocol

**Session start:**
1. CLAUDE.md is auto-loaded. Check MEMORY.md for current context.
2. `git pull` to sync latest changes (see Git Workflow above).
3. If resuming prior work, check the task list and recent file timestamps.
4. If the user says "run maintenance" or "run monthly sync", start with the pipeline (see Pipeline Operations), then proceed through §10.1 steps.

**During a session:**
- When editing reference files, bump the version number in the file's header. **Every version bump is a 2-part atomic operation:** (1) increment header version, (2) update {ORG}-MAINTENANCE §2.1/§2.2 manifest row. Change history is tracked in git — no separate changelog entry needed.
- **Manifest discipline:** When bumping a file version, always update {ORG}-MAINTENANCE §2.1 (and §2.2 if a QUICK file) in the same edit session. Don't defer manifest updates — this is the #1 source of system drift.
- **File structure discipline:** When creating, renaming, or moving files, update all three locations: `scripts/prepare_upload.ps1` (upload script manifest), {ORG}-MAINTENANCE §5F Upload Manifest table, and {ORG}-INDEX §Related Reference Files (if the change affects a layer or category). Then verify no cross-references broke with a grep for the old name/path.
- **New tool introduction checklist.** When a new MCP connection or service becomes available, follow this sequence in a single session:
  - **Discovery first:** (1) Fetch full API docs. (2) Build complete endpoint inventory classified: Active (use now) | Future-[Domain] (relevant later) | Not applicable. (3) **Applicability review checkpoint** — present catalog to user, get sign-off before encoding recipe file.
  - **Build recipe file:** Create `reference/{ORG}-{SERVICE}-API.md` using `Mosaic/bootstrap/templates/API-RECIPE.template.md` as the structural template. Includes: §0 routing, §1 tool routing with `tool_search`, §2 read recipes, §3 write recipes + safety classification (if write-enabled), §4 query patterns (if API has query language), §5 instance-specific mappings, §6 quirks, §7 endpoint catalog, §8 intelligence baseline (if Type B data), §9 delta feedback. For each aggregate endpoint, include the corresponding detail endpoint as an investigation depth pattern — the drill-down from account-level totals to per-entity breakdowns (A-024). Validate each active endpoint live during construction. Tag every endpoint with a validation status (`validated: YYYY-MM-DD`, `UNCONFIRMED`, `UNTESTED`, `FAILED`, `WRITE_DEFERRED`).
  - **Update 8 reference file locations** (after recipe file complete): (1) {ORG}-DOMAIN-ROUTER — `Tools:` in relevant domain entry. (2) {ORG}-{AGENT}-BEHAVIORS — §Connected Systems. (3) {ORG}-A2A-QUICK — §2.2 capability matrix row + §5.x recipe section. (4) Domain QUICK §0 — Tools declaration. (5) Domain QUICK §5 — systems YAML. (6) Domain QUICK §8A — question-type tool patterns. (7) {ORG}-SYSTEMS-QUICK §0 — system inventory row. (8) **Governance reclassification** — if the system was previously listed as Manual in {ORG}-INDEX, update it to Agent-Integrated. Then run a conflict scan: grep for the system name alongside restrictive terms (`"no agent access"`, `"human only"`, `"direct humans"`, `"Manual"`) across all .md files and resolve every hit. Watch for generic category labels (e.g., "Financial systems") that sweep in the newly-connected system alongside still-restricted systems — replace with specific system names.
  - **If write-enabled:** add §3.1 Write Safety Classification to the recipe file (field-level mechanical/data fill/interpretive/structural classification). Update {ORG}-A2A-QUICK §2.3 with a write-enabled line pointing to recipe §3.1. Behavioral write offer pattern ({ORG}-{AGENT}-BEHAVIORS §MCP Write Offers) covers all writable services generically.
  - **Verify:** grep for new tool name across all .md files — every domain that could use it should have a hit.
  - **Smoke test (3 queries after upload):** (1) Live data pull. (2) Write workflow (confirm-before-write). (3) Capability routing (A2A).
- **No static counts in prose.** Never hardcode a count (clients, profiles, teams, etc.) in narrative text. Instead, reference the definitive source: "count = rows in [table]" or "count = [metric ID]." Static counts in prose always drift. Counts belong in tables and metrics; prose points to them.
- **Design principles for reference file editing.** When editing reference files, apply the epistemic dispositions from MOSAIC-REASONING §7: curriculum not database, implicit knowledge is invisible, agent experience is design data. For the full catalog of 32+ named principles, see MOSAIC-PRINCIPLES.
- Present analysis and wait for user direction before editing files. User commentary on findings does NOT equal approval to apply changes.

**Session end:**
- Run prepare_upload.ps1 (see Artifact Distribution above). Use `-SkipBlob` if Azure CLI not available.
- Remind user to upload staged files per {ORG}-MAINTENANCE §5F checklist.
- Stage, commit, and push changes to git (see Git Workflow above).

## Analysis Checkpoint Rule

When multi-turn analysis produces refined conclusions — design decisions, scope refinements, rejected alternatives, implementation approaches — write a brief to `memory/` before starting edits. This applies to: maintenance items, new features, architecture decisions, behavioral tuning, or any work where the reasoning took significant effort to develop.

**Brief format** (file name = topic, e.g., `memory/rec-006-007-implementation.md`):
- **What to do** — the specific edits, insertion points, affected files
- **What NOT to do** — rejected approaches and why
- **Key decisions** — the reasoning that took multiple turns to reach
- **Status** — what's done, what's next

**Plan mode persistence (mandatory).** After a plan is approved in plan mode, the FIRST action — before any exploration, analysis, or edits — is to write the approved plan to `memory/` as an implementation brief. Name the brief for the work (e.g., `memory/v4.38-file-splits-plan.md`). **Do not begin implementation until the brief is written.**

The brief must include:
1. **Full scope** — every file to create, edit, rename, or delete
2. **Specific edits** — section numbers, insertion points, content to add/move/remove
3. **Cross-reference updates** — every pointer, manifest row, router entry, and upload script change needed
4. **Validation plan** — pre/post test queries, scoring rubric, and acceptance criteria (see Plan Validation Requirement below)
5. **Completion checklist** — ordered list of discrete steps, checkable as implementation progresses

This is the recovery point if context resets mid-build. If context resets, the new session reads this brief and picks up where implementation left off. Auto-compaction preserves *what happened* but loses *the refined thinking* — the brief preserves both.

Clean up briefs for completed items at session end.

## Plan Validation Requirement

Every plan that modifies reference files, restructures content, or changes agent behavior must include a validation design as part of the plan — not as an afterthought after the build. Tests designed after the build inherit the build's blind spots.

**What the validation plan must include:**
1. **Pre-test queries** (3-5 targeted queries) — run BEFORE implementation begins, scored against the rubric. These establish the baseline the build must improve on (or at minimum not regress).
2. **Scoring rubric** — dimensions (e.g., routing accuracy, content depth, gap awareness) with point scales and criteria for each score level. Define the rubric during planning so pre and post tests use identical measurement.
3. **Post-test queries** — run AFTER implementation, scored with the same rubric. May reuse pre-test queries (to measure delta) or add new queries targeting specific changes.
4. **Acceptance criteria** — what constitutes a passing result (e.g., "no regression on routing, +2 minimum on content depth, no new DNFs").
5. **Conversation budget** — how many queries per test conversation (rule of thumb: max 3 queries + 2 on-demand files per conversation to avoid context crashes).

**When this applies:**
- Multi-file edits (3+ files) — always
- File splits, merges, or restructuring — always
- Behavioral directive changes — always (extends the Agent Behavior Regression Rule)
- Single-file content additions — use judgment; skip for trivial additions

**Test design principles:**
- Design tests during planning, when you understand the *intent* of the changes. Post-hoc tests only verify what was built, not whether the build achieved its goal.
- Pre-test scores reveal the current ceiling. Post-test scores reveal whether the change helped, hurt, or was neutral.
- Group test queries by domain to stay within conversation context budget.
- Record test design in the implementation brief. Record results in `testing/` using the test log template.

## Sensitivity Rule

Four-tier model per MOSAIC-INFORMATION-GOVERNANCE:

<!-- Define your organization's tier examples below. The tier STRUCTURE is universal;
     the CONTENT EXAMPLES are instance-specific. Think about what data your organization
     handles and where it falls on the sensitivity spectrum. -->

|Tier|Name|Content Examples|Authorization|Agent File Placement|
|---|---|---|---|---|
|**1**|Internal|Org structure, client names, process descriptions, policy frameworks|All staff|Kernel, QUICK, reference, memory|
|**2**|Sensitive|Financial details, vendor pricing, engagement operational detail|Work-need test|Full reference files only (not kernel, QUICK, or memory)|
|**3**|Restricted|Tax IDs, registrations, ownership %, individual employee data|Named roles only|Full reference files with sensitivity markers; never in QUICK or kernel|
|**4**|Prohibited|Account numbers, SSNs, banking, individual PHI, attorney-client privileged|Source systems only|No agent files — source systems only|

- **Never put Tier 3+ content** in CLAUDE.md, memory files, or QUICK reference files.
- **Type overlays** (PHI, Legal-Privileged, Financial-Ownership, HR-Protected) elevate the effective tier, never reduce. See MOSAIC-INFORMATION-GOVERNANCE §3 for type definitions.
- **When editing files that contain or reference sensitive data,** verify no Tier 3+ content leaked into QUICK files, kernel files, or memory files. Patterns to watch: EINs (`XX-XXXXXXX`), SSNs, account numbers, insurance policy numbers.

## System Connectivity (Not a Sensitivity Tier)

Whether an agent has MCP/API access to a system is a binary technical fact, NOT a governance classification. Never use "Tier" vocabulary for system connectivity. Use: "Agent-Integrated" or "Manual."

- A system being Manual does NOT mean its data is Tier 4 -- it means the agent lacks technical access. Data sensitivity is classified independently.
- A system being Agent-Integrated does NOT lower the sensitivity of its data -- the agent can query, but sensitivity rules govern what it stores, displays, and persists.
- System connectivity: {ORG}-INDEX (system inventory). Data sensitivity: {ORG}-INFORMATION-GOVERNANCE.

<!-- Add your organization's stewardship posture here. Examples:
     - "Solidarity posture: cross-client learning is the purpose, not the exception."
     - "Isolation posture: client data is siloed by default; cross-client only with explicit consent."
     See MOSAIC-INFORMATION-GOVERNANCE §4 for posture definitions.

     Also add any instance-specific information governance file reference:
     - "See {ORG}-INFORMATION-GOVERNANCE for full framework."
-->

## Behavioral Parity Check

When adding or modifying a behavioral directive in any agent behavior file ({ORG}-CLAUDE-BEHAVIORS, {ORG}-COPILOT-BEHAVIORS), analyze whether the same directive applies to the other agent. If yes, add to both behavior files. If no, document why it's agent-specific in the implementation brief (e.g., tool-specific friction, platform capability differences). Default assumption: behaviors apply to both unless there's a clear architectural reason they don't.

Note: Behavioral directives go in behavior files ({ORG}-CLAUDE-BEHAVIORS, {ORG}-COPILOT-BEHAVIORS), not in {ORG}-COPILOT-PLATFORM-CONFIG (the condensed 8K Copilot Studio config that points to the behaviors file).

<!-- If you don't use Copilot, simplify this section to just Claude behavioral directives. The parity check principle still applies if you add agents in the future. -->

## Agent Behavior Regression Rule

After editing any agent behavior file ({ORG}-CLAUDE-BEHAVIORS, {ORG}-COPILOT-BEHAVIORS, {ORG}-COPILOT-PLATFORM-CONFIG, {ORG}-A2A-PROTOCOL), run a smoke test before closing the session:
- Pick 3 queries from the test plan (1 easy, 1 medium, 1 hard) relevant to the changed behavior area.
- Run them in Claude.ai (or Copilot if the edit was to Copilot files).
- If any query regresses (wrong answer, missing expected behavior), investigate before finalizing.
- Full benchmark re-run is only needed after major restructuring, not every edit.
- **Architectural migrations** (kernel evolution phases, domain additions) use the before/after validation pattern: run targeted queries before the change, deploy, run the same queries after, compare scores. Test log template and results in `testing/`.

## Memory Management

- **MEMORY.md** is always loaded into the system prompt — keep it under 150 lines.
- Use separate topic files in the memory directory for detailed notes. Link from MEMORY.md.
- **Delete superseded items** from MEMORY.md. If a system is "SUPERSEDED by X," remove the old entry.
- **Don't track file versions in MEMORY.md** — they drift. Authoritative versions are in {ORG}-MAINTENANCE §2.1.
- Prune facts that are now encoded in CLAUDE.md or in the reference files themselves.
- **`memory/` vs `archive/` boundary:** `memory/` is for active briefs with pending work — each file should have a clear next action. When a brief's work is complete, delete it (if fully captured in reference files) or move to `archive/`. `archive/` is read-only historical reference — completed briefs, one-time deliverables, retired scripts, source documents for past decisions.

## PowerShell Coding Rules

- **No em dashes or non-ASCII characters** in .ps1 files — even in comments. Use plain hyphens (`-`).
- Avoid `($var text)` patterns in double-quoted strings — PowerShell interprets `($var` as a subexpression.
- Use `-f` format operator or string concatenation for complex output strings.
