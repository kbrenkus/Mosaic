# {ORG}-MAINTENANCE — Maintenance, Synchronization & Build Playbook
**Version:** 1.0 | **Last Verified:** {DATE}
Purpose: Governs reference file currency, drift detection/resolution, and new file builds for {Organization Name}.

---

## §1 About This File

**Audience:** Claude Code (builds/edits), Claude.ai (MCP staleness detection), {Owner} (manual steps).

### The 4-Layer Sync Problem

Files go stale when source changes don't trigger updates:

|Layer|What Goes Stale|Detection|Fix|
|---|---|---|---|
|**L1 — Source systems**|CRM deals close, teams change, personnel leave|Monthly MCP audit (§4)|Audit queries, report delta|
|**L2 — Full reference files**|{ORG}-* files lag behind source|Trigger matrix (§9) + audit|Edit files from delta|
|**L3 — Quick files**|{ORG}-*-QUICK lag behind full files|Version manifest (§3)|Regenerate, user uploads|
|**L4 — Manifest itself**|Version table lags behind files|Self-check (§3)|Update after every edit|

### Tool Capabilities & Constraints

|Tool|Can Do|Cannot Do|
|---|---|---|
|**Claude.ai** (MCP)|Query live systems; `get_section`; compare manifest|Edit files; upload to knowledge|
|**Claude Code**|Read/write files; scan markers; regenerate QUICKs|Query live systems; upload|
|**User**|Upload to knowledge; approve; answer questions|—|

### When to Use This File

|Situation|Start At|
|---|---|
|"Run monthly maintenance"|§10 → §4 → §5|
|"Are my reference files current?"|§3|
|"Regenerate quick files"|§7|
|"Build a new reference file"|§8|
|"Something changed in the org"|§9|
|"Update the version manifest"|§2|

---

## §2 Version Manifest

Source of truth for file currency. Update after every edit.

### §2.1 Manifest Table

|File|Version|Last Updated|Size|Status|Quick File?|
|---|---|---|---|---|---|
|{ORG}-INDEX.md|1.0|{DATE}|{N} KB|Initial|No (loaded)|
|{ORG}-DOMAIN-ROUTER.md|1.0|{DATE}|{N} KB|Initial|No (loaded)|
|{ORG}-TAXONOMY-QUICK.md|—|—|—|Pending|No (loaded)|
|{ORG}-A2A-QUICK.md|—|—|—|Pending|No (loaded)|
|{ORG}-CLAUDE-BEHAVIORS.md|1.0|{DATE}|{N} KB|Initial|No (Claude.ai)|
|MOSAIC-REASONING.md|{VER}|{DATE}|~45 KB|Current|No (shared kernel)|
<!-- Add rows as domain files are created -->

### §2.2 Quick File Manifest

<!-- QUICK files condense knowledge/process/curated views, not state dumps. See A-007. -->

|Quick File|Source File|Source Ver|Quick Ver|Size|Notes|
|---|---|---|---|---|---|
<!-- Add rows as QUICK files are created -->

### §2.3 Supporting Artifacts

<!-- Non-kernel files: profiles, directories, test plans -->

|File|Version|Last Updated|Size|Notes|
|---|---|---|---|---|
<!-- Add rows as artifacts are created -->

---

## §3 Self-Check Protocol

Claude.ai runs at maintenance cycle start to detect version drift.

**Self-check prompt** (paste into Claude.ai):
> "Compare the version numbers in your loaded project knowledge files against the manifest in {ORG}-MAINTENANCE §2.1 (retrieve via `get_section`). Report any files where the loaded version differs from the manifest version, or where files listed in the manifest are not loaded."

**Expected output:** Loaded vs. manifest versions table with mismatch flags.

**Mismatch causes:** QUICKs regenerated but not uploaded, or files edited without manifest update.

---

## §4 Monthly Audit Protocol

Detects source-to-reference drift via MCP. Each audit in separate Claude.ai conversation (context budget). Learning loop architecture: MOSAIC-OPERATIONS §2/§6.

### §4.1 CRM / Primary System Audit

**Paste into Claude.ai:**
> "Run a CRM data freshness audit. For each entity tracked in {ORG}-{DOMAIN}-QUICK:
> 1. Query the CRM for current status (stage, owner, dates)
> 2. Compare against reference file values
> 3. Report deltas using the YAML schema in {ORG}-A2A-QUICK §4.2
> Focus on: closed/won entities still marked active, owner changes, stage progressions, stale dates."

<!-- Customize for your CRM (HubSpot, Salesforce, etc.) -->

**Output:** `[DELTA]`, `[STALE]`, `[GAP]`, `[STRUCT]` observations.

### §4.2 Task/Project Management Audit

**Paste into Claude.ai:**
> "Run a task management audit. Check:
> 1. Team/project structure changes since last audit
> 2. New teams or projects not in reference files
> 3. Renamed or archived teams
> 4. Cross-reference GIDs/IDs against {ORG}-{DOMAIN} files
> Report deltas using the YAML schema in {ORG}-A2A-QUICK §4.2."

<!-- Customize for your task tool (Asana, Jira, Linear, etc.) -->

### §4.3 Personnel & Systems Audit

**Paste into Claude.ai (or M365 Copilot):**
> "Run a personnel and systems audit. Check:
> 1. New hires / departures since last audit (M365 directory comparison)
> 2. Title/role changes
> 3. New applications or sites in M365 environment
> 4. Compare against {ORG}-TEAMS and {ORG}-SYSTEMS reference files
> Report deltas using the YAML schema."

<!-- Additional: §4.4 Content (quarterly), §4.5 Terminology, §4.6 System Consistency, §4.7 Memory Hygiene -->

---

## §5 Claude Code Actions

### §5A Recommendations Log

<!-- Open maintenance recommendations -->

|ID|Date|Category|Description|Status|
|---|---|---|---|---|
<!-- Recommendations added as discovered -->

### §5E Budget Tracker

|File|Proj Knowledge?|Blob?|Copilot?|Size|
|---|---|---|---|---|
|MOSAIC-REASONING.md|Yes|No|Yes (.txt)|~45 KB|
|{ORG}-INDEX.md|Yes|No|Yes (.txt)|{N} KB|
<!-- Add all kernel and retrieval files -->

**Total kernel budget:** {N} KB / ~200 KB

<!-- DESIGN RULE (U-011): Sizes above are ONE canonical location. Don't duplicate in DOMAIN-ROUTER. -->

### §5F Upload Procedure

3 upload + 2 paste targets:

|Target|Files|Format|Method|
|---|---|---|---|
|Claude.ai knowledge|6 kernel files|.md|Manual upload|
|Copilot knowledge|Same 6 kernel files|.txt|Manual upload|
|Azure Blob (MCP)|All retrieval files|.md|prepare_upload.ps1|
|Claude.ai instructions|{ORG}-CLAUDE-PLATFORM-CONFIG|.txt|Paste into UI|
|Copilot instructions|{ORG}-COPILOT-PLATFORM-CONFIG|.txt|Paste into UI|

**End-of-session:** (1) `prepare_upload.ps1` (2) Upload kernel if changed (3) Paste config if changed (4) Git commit+push

### §5G Tuning Register

Behavioral adjustments from `[META]` self-observations and benchmark validation.

|ID|Date|Source Delta|Domain|Observation|Score|Action|Status|
|---|---|---|---|---|---|---|---|
<!-- TUN-001 entries added as META deltas validated -->

**Process:** `[META]` → 4I review → benchmarks (§5G.4) → TUN entry → draft edit → approve → behavior file + Parity Check.

### §5G.4 Benchmark Scores

<!-- Domain scores from 20-25 query test plan. Update after each run. -->

|Domain|Last Score|Date|Trend|Notes|
|---|---|---|---|---|
<!-- Populated after first benchmark run -->

### §5H Pipeline Run Summary Template

Summary in `pipeline/run-logs/run-summary-YYYY-MM-DD.md`. Present digest only:

- **Headlines:** entities/records matched, pipeline value, delta count
- **Actions:** unmatched records, overlay changes, batch CSV, enrichment highlights
- **Enrichment:** #1 candidate + "Enrich now, pick different, or skip?"
- **Details:** `pipeline/run-logs/`

---

## §6 System Architecture

<!-- Document file distribution architecture -->

---

## §7 Quick File Regeneration

<!-- QUICK regeneration process. Architecture: MOSAIC-PRINCIPLES A-007. -->

---

## §8 Build Playbook

<!-- Key principles: A-007, A-008, A-009, U-011. Full catalog: MOSAIC-PRINCIPLES. -->

New domain construction: follow DOMAIN-BOOTSTRAP.md. This section covers {ORG}-specific conventions.

---

## §9 Trigger Matrix

Events triggering file updates by loop. Architecture: MOSAIC-OPERATIONS §2.

### Loop 1 — Data Events

|Event|Delta Type|Affected Files|Action|
|---|---|---|---|
|Employee hired|`[DELTA]`|{ORG}-TEAMS, -HRIS|Add to roster|
|Employee departed|`[DELTA]`|{ORG}-TEAMS, -HRIS|Update status, check routing|
|Client/entity signed|`[DELTA]`|{ORG}-CLIENTS, profile|Create profile|
|Record closed|`[DELTA]`|Domain QUICK|Update status|
|Record date past due|`[STALE]`|Profile, QUICK|Flag for review|
|Coverage below threshold|`[GAP]`|Profile|Queue enrichment|
|Naming inconsistency|`[STRUCT]`|Affected files|Standardize|
<!-- Add rows for org-specific data events -->

### Loop 2+ — Reasoning & Architecture Events

|Event|Delta Type|Affected Files|Action|
|---|---|---|---|
|Pattern confirmed|`[PATTERN]`|Domain ref or MOSAIC-REASONING|Draft update|
|Query method validated|`[RECIPE]`|{ORG}-A2A-QUICK §5|Add/update recipe|
|Entity doesn't fit taxonomy|`[ONTOLOGY]`|{ORG}-TAXONOMY|Draft update|
|Causal mechanism validated|`[CAUSAL]`|Target reference file|Document mechanism|
|New domain needed (3+)|`[DOMAIN]`|{ORG}-DOMAIN-ROUTER|Draft proposal|
|Self-observation confirmed|`[META]`|Behavior files|Draft edit (parity)|
|Inquiry answered|Varies|Depends on finding|Route to loop|

---

## §10 Full Sync Workflow

Minimum-manual-steps process. Architecture: MOSAIC-OPERATIONS §6.

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

For urgent changes that can't wait for monthly cycle: apply change to affected files, update manifest (§2, 2-part atomic op), run `prepare_upload.ps1`, upload kernel files if changed, commit to git. Next monthly cycle detects ripple effects.

---

## Change Log

**Change history is tracked in git.** See `git log` in the instance repository.
