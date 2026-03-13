# MOSAIC-OPERATIONS v1.9

> **Purpose:** Operational architecture for self-learning knowledge systems — how instances detect drift, accumulate observations, process learning, and maintain currency.
> **Scope:** Company-agnostic. All examples use generic placeholders. Instance-specific operational details belong in instance files.
> **Relationship:** MOSAIC-REASONING = how to think. MOSAIC-PRINCIPLES = design principles. MOSAIC-OPERATIONS = how the system learns.
> **Charter:** Single authority for content placement decisions (which zone, which file, which format). Consumed during both construction (via DOMAIN-BOOTSTRAP pointer) and ongoing maintenance. For zone definitions, see MOSAIC-REASONING §6.7. For construction sequencing, see DOMAIN-BOOTSTRAP.

---

## §1 About This File

Documents the operational machinery that makes learning possible: loops, delta protocol, pipeline, maintenance cycles. Every pattern was discovered empirically through live deployment and validated across multiple cycles. Patterns are company-agnostic.

**Who reads this file:** Instance builders (KERNEL-BOOTSTRAP Phase 5), agents (behavioral directives reference here), maintainers (cycle design).

---

## §2 Learning Loop Architecture

The system learns through four distinct loops over shared infrastructure, plus active inquiry. Each loop has different detection methods, confidence requirements, and governance rules.

> *Design principle reference:* MOSAIC-PRINCIPLES A-001 (Three Learning Loops — data, reasoning, substrate), A-003 (Three Data Tiers — generated, enriched, curated), A-004 (Confidence Gating).

### §2.1 Loop 1 — Data Freshness

**What it detects:** Live system data contradicting reference file content — closed deals, changed teams, departed personnel, drifted properties.

**Detection method:** Pipeline compares live snapshots against reference files. Agents detect drift when retrieved data contradicts live MCP results.

**Delta types:** `[DELTA]` (value changed), `[GAP]` (data missing), `[STRUCT]` (structural mismatch like naming), `[STALE]` (data past freshness threshold)

**Confidence gating:** Confirmed deltas from authoritative sources (TL1) can be auto-applied during pipeline runs. Likely and unverified require human review.

**Governance:** Pipeline processes Loop 1 deltas in batch. Individual agents flag observations but never auto-edit reference files.

### §2.2 Loop 2 — Reasoning Improvement

**What it detects:** Patterns, better methods, ontological gaps, and causal mechanisms that improve system reasoning.

**Detection method:** Agents notice patterns during analytical work — cross-entity correlations, better query strategies, taxonomy misfits, causal hypotheses.

**Delta types:**
- `[PATTERN]` — Correlation across multiple entities or systems. Emit when you see meaningful regularity, even from one session. Queue accumulates across sessions; maintenance assesses durability.
- `[RECIPE]` — More effective way to query or combine results from connected systems.
- `[ONTOLOGY]` — Entity or concept that doesn't fit existing classification frameworks.
- `[CAUSAL]` — Hypothesized mechanism explaining *why* a pattern exists. Requires: (1) observed pattern, (2) specific falsifiable mechanism, (3) evidence beyond pattern data.
- `[FRAMEWORK]` — Expert shares interpretive knowledge during conversation: evaluation criteria, governance rules, contextual reasoning, anti-patterns. Targets interpretive zone — definitions and frameworks that shape HOW data is read. Requires steward validation before integration (unlike other Loop 2 types that undergo human review, `[FRAMEWORK]` deltas are steward-specific because they modify the interpretive lens for an entire domain).

**Graduation path:** `[PATTERN]` → `[CAUSAL]`. When you observe a pattern AND can articulate why, emit `[CAUSAL]` with the mechanism field. Don't wait for certainty.

**Governance:** Loop 2 deltas always require human review. Reasoning changes demand semantic judgment that cannot be automated.

### §2.3 Loop 3 — Substrate Expansion

**What it detects:** Recurring query classes with no routing or knowledge domain — signals the architecture needs to grow.

**Detection method:** Agents track unroutable query classes. First occurrence is noise; second is interesting; third triggers `[DOMAIN]` delta.

**Delta type:** `[DOMAIN]` — Query class that keeps arising with no domain to route to.

**Threshold:** 3 occurrences before emission. Prevents noise from one-off questions.

**Governance:** Domain proposals require architectural review (new files, routing entries, budget). `[DOMAIN]` starts the conversation; DOMAIN-BOOTSTRAP provides methodology.

### §2.4 Loop 4 — Self-Knowledge

**What it detects:** Agent reasoning tendencies, defaults, performance patterns — metacognition about agent behavior.

**Detection method:** Agents observe their own reasoning during conversations and emit observations with specific evidence.

**Delta type:** `[META]` — Self-observation about reasoning behavior.

**Trigger categories:**
|Category|Example|
|---|---|
|Reasoning mode mismatch|Defaulted to data assembly when the question was strategic|
|Domain-specific difficulty|Repeatedly routed to wrong file first for a domain|
|Confidence-evidence gap|Gave confident answer while source data was stale|
|Retrieval path habit|Skipped a source that would have helped, and can see why|

**Governance:** Self-observations are diagnostic reports, not permission to self-correct. **Observe and emit; maintenance validates before acting.** `[META]` deltas go through the same review as Loop 2, with additional benchmark score check to confirm or disconfirm the self-diagnosis.

### §2.5 Active Inquiry

Active Inquiry is a learning *mode*, not a loop. Agent forms a testable hypothesis and seeks evidence — including by asking the user.

**Delta type:** `[INQUIRY]` — Hypothesis the agent wants to test.

**4-part format:**
1. **Hypothesis:** What the agent believes might be true
2. **Evidence:** What data from this or prior sessions supports it
3. **Question:** The specific thing the agent wants to know
4. **Impact:** What would change in reasoning if confirmed or denied

**Evidence bar:** "I have a specific hypothesis, with specific evidence, and the answer would change how I reason about future queries in this class."

**Bad inquiry:** "I wonder if our data is complete?" (vague, unfalsifiable, no impact)
**Good inquiry:** "Three active clients show declining email signals but steady deal progression — is engagement shifting to in-person channels? If so, email-based engagement scoring needs recalibration."

**Conversational discipline:** Inquiries offered at natural boundaries — after completing the user's task, at conversation end with the delta batch, or when a surprising pattern emerges. Never interrupt task execution.

**Governance:** If user defers, inquiry goes to queue. After 3+ deferrals, re-evaluate and close if evidence has gone stale.

### §2.6 Loop Interaction Model

The loops feed each other:

```
Loop 1 (Data) ←→ Loop 2 (Reasoning)
  Data deltas reveal patterns;
  Patterns reveal data to check

Loop 2 (Reasoning) → Loop 3 (Substrate)
  Accumulated patterns may reveal
  a missing domain

Loop 4 (Self-Knowledge) → Loop 2 (Reasoning)
  Self-observations about reasoning
  may reveal needed reasoning improvements

Active Inquiry → Any Loop
  Inquiry results route to the
  appropriate loop based on finding type
```

**Processing priority:** Loop 1 first (data accuracy is prerequisite), then Loop 2/3/4 together (reasoning changes are higher-leverage but require data correctness).

---

## §3 Delta Architecture

Deltas are structured observations carrying learning from detection to integration. Every observation uses a consistent schema, routes to a defined queue, and follows confidence-based governance.

### §3.1 Delta Type Taxonomy

|Type|Loop|Section|Description|Threshold|
|---|---|---|---|---|
|`[DELTA]`|1|Data Corrections|Value contradicts live system|Any confirmed discrepancy|
|`[GAP]`|1|Data Corrections|Data missing from reference file|Below tier coverage expectation|
|`[STRUCT]`|1|Data Corrections|Structural mismatch (naming, format)|Systematic, not one-off|
|`[STALE]`|1|Data Corrections|Data past freshness threshold|Instance-defined (e.g., >3 months)|
|`[PATTERN]`|2|Intelligence Queue|Cross-entity or cross-system correlation|Observed across 2+ entities/systems|
|`[RECIPE]`|2|Intelligence Queue|More effective query/combination method|Demonstrably better than existing|
|`[ONTOLOGY]`|2|Intelligence Queue|Entity doesn't fit existing taxonomy|Unresolvable with current categories|
|`[CAUSAL]`|2|Intelligence Queue|Mechanism hypothesis for observed pattern|Pattern + mechanism + evidence|
|`[FRAMEWORK]`|2|Intelligence Queue|Expert interpretive knowledge (evaluation criteria, governance rules, anti-patterns)|Expert shares during conversation; steward validates|
|`[DOMAIN]`|3|Intelligence Queue|Query class with no routing or domain|3+ occurrences of same class|
|`[META]`|4|Intelligence Queue|Agent self-observation about reasoning|Specific evidence, not vague impression|
|`[INQUIRY]`|—|Intelligence Queue|Testable hypothesis for user validation|Evidence bar met (see §2.5)|

### §3.2 Delta YAML Schema

Every delta uses this schema. Canonical definition lives here; operational templates in instance A2A files reference this section.

```yaml
# Task name: [TYPE] Target: Brief description
---
type: delta|gap|struct|stale|pattern|recipe|ontology|causal|domain|meta|inquiry
domain: {domain name}
target_file: {ORG}-FILENAME
target_section: "N"           # bare section ref matching get_section() syntax
target_entity: EntityName|MULTIPLE
source_system: crm|tasks|email|sharepoint|web|internal
confidence: confirmed|likely|unverified    # required for Loop 1; informational for Loop 2+
mechanism: "..."              # required for type: causal — the hypothesized why
evidence: ["what was observed"]
current_ref: "what the reference file currently says"
recommended: "what should change"
sovereignty_check: false      # set true if applicable to your instance's data governance
sensitivity_tier: 1|2|3       # tier of the data being observed; Tier 4 content never generates deltas
agent: claude-operations|copilot|claude-code
session_date: YYYY-MM-DD
---
```

**Field notes:**
- `target_section` uses bare section numbers matching `get_section()` syntax (e.g., "3", "2.1")
- `confidence` follows source trust hierarchy in MOSAIC-REASONING §5.4
- `mechanism` only populated for `[CAUSAL]` type — the specific, falsifiable hypothesis
- `sovereignty_check` is instance-defined; some organizations may have data governance requirements
- `sensitivity_tier` indicates the tier of data being observed (per MOSAIC-INFORMATION-GOVERNANCE §2). Tier 4 content never generates deltas (it should not exist in agent-accessible systems). sovereignty_check and sensitivity_tier are orthogonal — both can apply to the same delta

### §3.3 Queue Infrastructure

Delta queue uses a task tracking tool (e.g., Asana) with two sections:

|Section|Contains|Processing|
|---|---|---|
|**Data Corrections**|Loop 1: `[DELTA]`, `[GAP]`, `[STRUCT]`, `[STALE]`|Pipeline batch + manual review|
|**Intelligence Queue**|Loop 2/3/4 + Inquiry: `[PATTERN]`, `[RECIPE]`, `[ONTOLOGY]`, `[CAUSAL]`, `[DOMAIN]`, `[META]`, `[INQUIRY]`|Maintenance review only|

**Why two sections:** Data corrections are high-volume, lower-risk, partially automatable. Intelligence observations are low-volume, high-leverage, always require human judgment. Separation prevents data corrections from burying strategic insights.

### §3.4 Routing Rules

Agents route deltas by type: Loop 1 → Data Corrections, all others → Intelligence Queue.

**Task naming:** `[TYPE] Target: Description`
- Example: `[STALE] Acme Corp: Deal close date 8 months overdue`
- Example: `[PATTERN] MULTIPLE: Engagement expansion follows trust-building services`

**Task body:** YAML front matter from §3.2.

### §3.5 Confidence Gating

|Level|Meaning|Loop 1 Treatment|Loop 2+ Treatment|
|---|---|---|---|
|**confirmed**|Authoritative source (TL1/TL2), directly verified|Pipeline may auto-apply|Informational — human reviews|
|**likely**|Good evidence, not directly verified|Present for human approval|Informational — human reviews|
|**unverified**|Weak evidence or inference|Flag for investigation|Informational — human reviews|

**Critical rule:** Loop 2+ deltas are never auto-applied regardless of confidence. Reasoning changes always require human semantic judgment.

---

## §4 Pipeline Architecture

Hybrid pattern bridging MCP-accessible live systems and deterministic file transformation. Enables automated data freshness (Loop 1) while preserving human judgment through the overlay layer.

> *Design principle reference:* MOSAIC-PRINCIPLES A-002 (Reference Files Are Views, Not Sources of Truth), A-005 (Four-Layer Sync Problem).

### §4.1 Phase 1 — MCP Data Acquisition

Agent with MCP access queries live systems and writes JSON snapshots:

```
Agent → MCP tools → Live systems (CRM, task management, calendar, etc.)
                  ↓
         JSON snapshots → pipeline/inputs/YYYY-MM-DD.json
```

**Why JSON snapshots?** MCP tools are only accessible from specific agent contexts. JSON bridge lets deterministic Python scripts process data without MCP access.

**Schema convention:** Each snapshot wraps its array in a named object: `{"deals": [...]}`, `{"teams": [...]}`, `{"tasks": [...]}`. Self-documenting, prevents ambiguity.

### §4.2 Phase 2 — Transformation

Python script reads snapshots, merges with curated overlays and lookup tables, regenerates reference file sections:

```
JSON snapshots + Overlay YAML + Lookup tables
                  ↓
         Python transformation script
                  ↓
Updated QUICK file section + Run summary + Update CSV
```

**Key design decisions:**
- Deterministic and reproducible — same inputs produce same outputs
- Regenerates sections, not entire files — preserves routing headers (§0) and manually-curated content
- Produces run summary + batch update CSV for source system corrections

### §4.3 Phase 3.5 — Enrichment Queue

Second script scans entity-instance files for completeness gaps:

```
Profile files → Scan for gap markers (MCP-TBD, BD-TBD, etc.)
                  ↓
Prioritized CSV + Ready-to-paste enrichment prompts
```

**Track classification:**
|Track|Criteria|Method|
|---|---|---|
|**Track 2**|>12 gaps|Claude Code MCP enrichment (high-value, complex)|
|**Track 1**|<=12 gaps|Claude.ai web research (manageable scope)|
|**BD-only**|Gaps require human knowledge|Route to relationship owner|
|**Missing**|No profile exists|Create from template if lifecycle warrants|

### §4.4 Phase 3 — Post-Processing

After pipeline run:
1. Review run summary — unmatched entities, overlay changes, anomalies
2. Process batch update CSV (push corrections to source systems)
3. Mark consumed delta tasks complete in queue
4. Run upload script to sync files to blob
5. Present enrichment recommendation — #1 candidate from queue

### §4.5 The Overlay Pattern

Curated YAML containing human-judgment fields not auto-derivable from live systems:

```yaml
# Example overlay entry
AcmeCorp:
  display_name: "Acme Corporation"
  short_name: "Acme"
  lifecycle: "active"
  tier: 2
  owner: "Jane Smith"
  flags: ["target-account", "strategic"]
  notes: "Expansion opportunity in Q3"
```

**Why overlays exist:** Some fields reflect human judgment (lifecycle, strategic flags, tier) that no system query can determine. The overlay is the curated foundation layer — it represents decisions, not data.

**Overlay governance:** Only humans edit overlays. Pipeline reads but never writes. Lifecycle changes, tier adjustments, and strategic flags are human decisions captured here.

### §4.6 Integration Patterns

Two patterns for how deltas become reference file changes:

**Pattern A — Regeneration (tables and rosters):** Pipeline regenerates entire sections from live data + overlay. Used for QUICK file data sections where surgical edits would be fragile.

**Pattern B — Surgical Integration (narrative content):** Claude Code opens target file, navigates to target section, compares delta evidence against current content, presents proposed edit for approval. Used for entity-instance files where section-level updates are precise.

**When to use which:**
|Content Type|Pattern|Rationale|
|---|---|---|
|Data tables, rosters, directories|A (Regeneration)|Accumulating micro-edits is fragile; fresh data is reliable|
|Narrative profiles, engagement history|B (Surgical)|Full regeneration destroys curated narrative; surgical is precise|
|Routing headers, framework sections|Neither|Curated content, not data-driven. Edit manually.|

### §4.7 File Optimization Patterns

Context window is shared between kernel + retrieval + conversation. Every KB saved in file formatting = more conversation headroom. Research-backed patterns that reduce file size 15-25% with zero reasoning quality loss:

**Format choice depends on content type:**
|Content Type|Optimal Format|Why|
|---|---|---|
|Lookup data (IDs, mappings, aliases)|YAML|~57% fewer tokens than markdown tables for structured key-value data|
|Reasoning frameworks (authority types, decision trees)|Minified markdown tables|Tables preserve visual structure agents use for reasoning; strip padding only|
|Procedural/routing content|Telegraphic prose|Articles and conjunctions add tokens without adding comprehension|
|Reasoning exposition, safety rules, behavioral directives|Full prose|Prose is load-bearing — compression destroys reasoning nuance|
|Worked examples for complex patterns|Preserve verbatim|Examples teach semantics; proven essential by behavioral testing|

**The lookup-vs-reasoning distinction** is the key design decision. Lookup tables are queried for specific values — YAML is more token-efficient and equally parseable. Reasoning tables are read holistically to understand a framework — visual table structure aids comprehension.

**Operational rules** (format selection, whitespace, table padding, example counts) are codified in instance CLAUDE.md under "File Optimization Rules." Apply during: new file creation, existing file edits, domain bootstrapping, QUICK file regeneration.

### §4.8 Content Placement Framework

Single authority for "where does this content go?" — consumed during both construction (DOMAIN-BOOTSTRAP Phase 5) and maintenance (cycle processing). Zone definitions: MOSAIC-REASONING §6.7.

#### Zone Litmus Tests

Four tests classify content by refresh mechanism. Apply to every piece of content entering or being audited in reference files.

**Interpretive:** "Would a fresh agent, given APIs and structural metadata but NO domain files, know how to interpret this data correctly?" If no → Interpretive zone. Content shapes HOW data is read. Examples: contract models, lifecycle definitions, evaluation criteria, elimination rules, anti-patterns.

**Curated:** "Could a fresh agent reconstruct this output in a single query session, given interpretive frameworks + API access?" If no → Curated zone. Content encodes accumulated judgment across multiple conversations, pipeline runs, and expert interactions. Examples: lifecycle assignments, data quality diagnostics, coverage gap analysis.

**Structural:** "Is this metadata needed to CONSTRUCT a query, but not present IN the query results?" If yes → Structural zone. Configuration that enables query construction. Examples: realm IDs, property names, entity pairings, pipeline stage mappings.

**Live:** "Is this a number, record, or status from a source system that changes continuously?" If yes → Live zone. Never store. Write a recipe in the API recipe file instead.

**Hardest boundary: curated vs stale.** Curated state is the output of APPLYING interpretive frameworks to live data — it cannot be reconstructed in one session. Stale data is a raw number copied from a source system that decays from the moment written. If a fresh agent with API access and interpretive frameworks could reconstruct the content in one session, it's stale data masquerading as curated state. Replace with a query recipe.

#### Scatter Classification

When domain content is found scattered across cross-domain files (discovered during DOMAIN-BOOTSTRAP Phase 1F-3 or maintenance audits), classify each scattered section:

|Classification|Boundary Test|Action|
|---|---|---|
|**Domain-specific**|"Would this differ for a different domain?" → YES|Migrates to domain file; source gets stub|
|**Cross-domain governance**|"Would this differ for a different domain?" → NO|Stays in source file; domain file references it|
|**Mixed**|Contains both domain-specific and governance content|Split: domain-specific migrates, governance stays|

#### Stub Depth

When migrating domain-specific content, the source file needs a stub. Stub depth depends on the source file's purpose:

|Source File Type|Stub Pattern|Rationale|
|---|---|---|
|Operations / deep reference|Pure cross-reference (section pointers only)|Domain file replaces entirely|
|Cross-domain index (systems, policies, people)|Slim inventory row (names/status) + pointer to domain|Preserves "at a glance" scanning for index audience|
|Routing / admin QUICK|Pure cross-reference|Domain QUICK replaces this routing|

**Test:** "Does someone scanning THIS file (not the domain) need to see anything, or just know where to go?" Index files → skeleton rows; non-index → pure stubs.

#### Bidirectional Routing Validation

When creating any cross-reference:
- Verify the return reference exists (domain file → source, source → domain)
- Never leave a navigation hole — always replace pruned content with a stub
- Route, don't summarize — stubs point to domain file sections, don't re-summarize content
- After any pruning or migration, grep for the old location to verify no broken references

#### Zone + Epistemological Layer Interaction

Zones (how it refreshes) and epistemological layers (what type, MOSAIC-REASONING §6.6) are orthogonal. Both apply simultaneously:

|Epistemological Layer|Typical Zone|Exception|
|---|---|---|
|Reasoning frameworks|Interpretive|—|
|Routing topology|Structural|—|
|Cross-system identity|Structural|—|
|Entity index|Curated OR Structural|Curated if pipeline-maintained, Structural if static|
|Relationship topology|Curated OR Interpretive|Curated if maintained, Interpretive if governance|
|Entity detail|Curated OR Live|Curated if enriched, Live if API-queryable|

**Graduation dynamic.** Content can shift both axes simultaneously. When a classification framework evolves from "labels I look up" to "patterns I reason from," it shifts epistemological type (ontological → hermeneutical) AND zone (curated/structural → interpretive). The two frameworks reinforce the same recommendation from different angles.

---

## §5 Signal-to-Delta Convergence

### §5.1 The Core Insight

Agents already detect signals during normal work. The innovation is **mapping existing signal detection to structured output**.

**Before:** Agent detects signal → mentions conversationally → observation lost when conversation ends.
**After:** Agent detects signal → emits structured delta → queue accumulates → maintenance reviews → findings encoded → future agents benefit.

Cognitive processes don't change. The *output channel* changes.

### §5.2 Trigger Discipline

Not every observation is worth a delta. Test: **"Would this change what a reference file says, how a recipe works, or how the agent reasons?"** Yes → emit. No → conversational context only.

**Per-loop guidance:**
- **Loop 1:** Emit when live data contradicts reference data or data is missing/stale
- **Loop 2:** Emit `[PATTERN]` when meaningful correlation appears. Don't suppress for single-session — queue provides cross-session persistence
- **Loop 3:** Wait for 3 occurrences before `[DOMAIN]`
- **Loop 4:** Emit only with specific evidence ("I queried the wrong system first" not "I could be better")
- **Active Inquiry:** Evidence bar must be met (see §2.5)

### §5.3 Conversation-End Batch Protocol

At conversation end, agents present accumulated observations as structured batch:

1. **Accumulate** during conversation (don't interrupt workflow)
2. **Present** at end as YAML delta blocks (schema §3.2)
3. **Post** each block to delta queue (section per §3.4)
4. **Fallback:** If posting fails, YAML blocks in response serve as paste-ready backup — never silently drop observations

**What qualifies:** Structural, ontological, data quality, reasoning, and self-observations. NOT routine factual context from answering the question.

### §5.4 Behavioral Integration

Signal awareness directives wired into agent behavior files through:

1. **Trigger tables** — Instance-specific thresholds for each delta type
2. **Trigger discipline rules** — Per-loop guidance from §5.2, adapted to organizational context
3. **Batch protocol** — YAML format, queue routing, fallback behavior
4. **Confidence tagging** — Source trust hierarchy reference

Instance customizes thresholds and adds domain-specific triggers during KERNEL-BOOTSTRAP Phase 5.

### §5.5 Write-Back as Learning

Write-back to source systems isn't just data cleaning — it closes the learning loop.

```
Live API Data → Curated Zone (apply interpretive frameworks)
     ^                              |
     |                    Anomaly Detection
     |                    (missing data, stale values, inconsistencies)
     |                              v
     +-------- Write-Back <-- Approved Corrections
```

**The virtuous cycle:** Each maintenance cycle (1) improves source system data quality, (2) reduces future curation effort as fewer anomalies remain, (3) frees attention for deeper analytical patterns, (4) makes API-first more viable as source data becomes more trustworthy.

**Safety classification for write-backs:** Write-backs from anomaly detection are typically mechanical (auto-approvable) or data fill (human review). Write-backs from cycle learning insights are typically interpretive (route through steward calibration per §6.8). Instance recipe files define the four-level classification per service.

**Tracking:** Each cycle should record corrections made, trending toward decreasing correction volume over time. Rising correction volume signals either source system degradation or interpretive framework drift — both are §6.7 cycle-over-cycle signals.

---

## §6 Maintenance Cycle Architecture

Systematic review process converting accumulated learning into reference file improvements. Runs at regular cadence (monthly default), integrates all four loops.

### §6.1 Cycle Structure

```
Step 1: Self-check (verify manifest accuracy)
    ↓
Step 2a: Pipeline run (Phase 1 → 2 → 3.5)
Step 2b-c: System audits (task management, personnel, systems)
    ↓
Step 3: User transfer (bridge between agent contexts if needed)
    ↓
Step 4: Apply Loop 1 deltas (data corrections)
Step 4I: Review Loop 2/3/4 deltas (reasoning/architecture/meta)
Step 4J: Surgical integration (entity-instance profile updates)
    ↓
Step 5: Regenerate QUICK files
    ↓
Step 6: User uploads to agent platforms
    ↓
Step 7: Verification (re-run self-check to confirm currency)
```

### §6.2 Loop 2/3/4 Delta Review

Most strategic step. Pull Intelligence Queue items and review by type:

|Type|Review Process|
|---|---|
|`[PATTERN]`|Assess durability. Placement: shared reasoning if cross-instance, query recipe if operational, domain file if specific. Draft edit.|
|`[RECIPE]`|Assess improvement over existing or need for new recipe. Draft edit.|
|`[ONTOLOGY]`|Assess against current taxonomy. Draft update if gap confirmed.|
|`[CAUSAL]`|Validate mechanism: specific, falsifiable, evidence beyond original pattern, alternative explanations addressed. If validated, document alongside/superseding originating pattern.|
|`[DOMAIN]`|Check 3-occurrence threshold. If met, draft domain proposal. If not, leave in queue.|
|`[META]`|Check benchmark scores for empirical confirmation. Run targeted test queries. If confirmed, draft behavioral directive edit (parity check). If disconfirmed, note as unconfirmed.|
|`[INQUIRY]`|Assess relevance (evidence may be stale). Present to user: answer or defer. If answered, route to appropriate loop. After 3 deferrals, re-evaluate.|

**Critical rule:** Present and draft, never auto-apply. Reasoning changes require human semantic judgment.

### §6.3 Surgical Integration

For entity-instance file deltas (Pattern B), Read-Compare-Present-Write protocol:

1. **READ:** Open target file, navigate to target section
2. **COMPARE:** Match delta's `current_ref` against actual content. Exact match → present edit. Semantic match → present with drift note. Structural drift → reject, flag for manual review.
3. **PRESENT:** Show current content, delta evidence, proposed edit
4. **WRITE** (after approval only): Apply edit

**Confidence-based ordering:** Confirmed+factual → quick approval. Likely+engagement → present with evidence chain. Unverified+strategic → flag for investigation, do not auto-present.

### §6.4 Enrichment Decision

After pipeline identifies enrichment candidates:

- **Track 2** (high gaps): Schedule in-session MCP enrichment or defer
- **Track 1** (manageable gaps): Generate prompts for web research session
- **BD-only**: Route to human relationship owners
- **Missing profiles**: Create from template if lifecycle warrants

Enrichment queue names #1 candidate with rationale. User decides: enrich now, pick different, or skip.

### §6.5 Cycle Frequency

**Default:** Monthly. Balances freshness with overhead. Data-heavy instances may benefit from biweekly Loop 1 processing. Stable instances may extend to 6 weeks. Pipeline (Step 2a) can run independently when rapid data refresh is needed.

### §6.6 Kernel Density Review

Periodic audit of kernel file content density and budget utilization. Not part of the regular maintenance cycle — triggered by conditions:

**Triggers:**
- Kernel headroom drops below 30% of platform limit
- Agent reports navigation-heavy kernel experience (see MOSAIC-PRINCIPLES A-019)
- 3+ domain bootstraps since last review (cumulative kernel growth)

**Methodology:** Section-level audit per DOMAIN-BOOTSTRAP Phase 8 supplement. Classify each section using the three-way classification: dispositional (ambient), orientation (retrieval-tolerant), or lookup/procedural (retrieve). Check for recipe ingredients — lookup data consumed on >50% of domain queries may stay in kernel. Move lookup/procedural content to retrieval with pointers. Dissolve redundant content. Validate with pre/post behavioral testing. See MOSAIC-PRINCIPLES A-021.

**Output:** Pruning brief documenting dispositional/procedural classification per section, retrieval destinations for moved content, and pre/post test results.

### §6.7 Cycle-Over-Cycle Learning

Individual maintenance cycles detect point-in-time drift. Cycle-over-cycle comparison detects systemic patterns invisible in any single run.

**Four comparison patterns:**

1. **Drift detection:** Which entities changed lifecycle stage, deal owner, or coverage status? Track counts per category. Rising counts in specific categories signal systemic change (not just data maintenance).

2. **Data quality trending:** Unmatched deals, missing contacts, stale deal stages — track count and trend per cycle. If write-backs are working (§5.5), these should decrease over time. Persistent or rising counts signal source system issues or incomplete write-back coverage.

3. **Framework stability test:** Do interpretive frameworks still produce clean classifications? Signals of interpretive zone stress: increasing edge cases requiring manual override, growing "unclassifiable" markers, recurring steward corrections of the same type. **This is the bridge to Speed 3** — framework instability triggers steward calibration (§6.8).

4. **Anomaly surfacing:** Patterns visible only across multiple cycles — seasonal clustering, recurring changes, variance trends that cancel out in single-cycle view.

**Implementation:** Pipeline run summary gains a "Cycle Insights" section comparing to previous run. This is a methodology pattern — pipeline script changes implement it per instance.

### §6.8 Steward Calibration Protocol

Turns the steward interview from a one-time bootstrap event into continuous calibration. Domain expertise evolves; the knowledge system should evolve with it.

**Default cadence:** Quarterly per domain. Adjust by domain maturity — new domains may need monthly calibration; stable domains may extend to semi-annual.

**Trigger:** Framework stability test failures from §6.7 can trigger ad-hoc steward review independent of cadence.

**Quarterly review agenda (per domain):**

1. Present accumulated `[FRAMEWORK]` deltas since last review. Steward validates, modifies, or rejects each.
2. Present cycle learning patterns — drift trends, data quality trajectory, framework stress signals from §6.7.
3. Steward provides updated interpretive context (business changes, strategy shifts, organizational evolution).
4. Agent proposes interpretive zone edits based on validated deltas + steward input. Steward approves.
5. Updated frameworks feed into next pipeline cycle, closing the loop.

**Governance:** Steward decisions are authoritative for interpretive zone content. The agent proposes; the steward disposes. This is the mechanism that prevents interpretive drift — expert judgment shapes the frameworks, not accumulated automation.

---

## §7 Testing & Validation Architecture

### §7.1 Pre-Test → Build → Post-Test Pattern

Every significant change follows this validation sequence:

1. **Pre-test:** Run 3-5 targeted queries BEFORE implementation, score against rubric. Establishes baseline.
2. **Build:** Implement changes.
3. **Post-test:** Run SAME queries AFTER implementation, same rubric. Compare.
4. **Accept/Reject:** No regressions allowed. Improvements expected on targeted dimensions.

**Why pre-test matters:** Post-hoc tests verify what was built, not whether it achieved its *intent*. Pre-test reveals current ceiling; post-test reveals whether you raised it.

### §7.2 Scoring Rubric Design

Define dimensions and scales during planning, not after build:

|Dimension|What It Measures|Example Scale|
|---|---|---|
|Accuracy|Factual correctness|0-4 (wrong → correct with nuance)|
|Completeness|Coverage of relevant information|0-4 (missing → comprehensive)|
|Confidence Calibration|Appropriate uncertainty signaling|0-2 (overconfident → calibrated)|
|Retrieval Efficiency|Found answer without unnecessary calls|0-2 (excessive → efficient)|

Instance-specific dimensions can be added (e.g., sensitivity compliance, tribal sovereignty).

### §7.3 Regression Detection

After editing agent behavior files, smoke test: pick 3 queries from test plan (easy, medium, hard) relevant to changed behavior. Run in appropriate platform. If any regresses, investigate before finalizing. Full benchmark re-runs only after major restructuring.

### §7.4 Benchmark Tracking

Maintain 20-25 query benchmark spanning all operational domains. Track scores over time to identify systemic trends. Benchmark scores serve as empirical check on `[META]` self-observations — when an agent reports weakness, the benchmark score confirms or disconfirms.

---

## §8 Self-Check Protocol

Self-check makes agents self-aware of staleness in loaded project knowledge. Run when starting new conversations or when accuracy matters.

### §8.1 Self-Check Recipe

**Step 1 — Read the manifest.** The compact maintenance file (`{ORG}-MAINTENANCE-QUICK` or equivalent) is loaded into agent project knowledge. Read the manifest tables (§2.1/§2.2) from the loaded file.

**Step 2 — Inventory loaded knowledge.** List all reference files currently in project knowledge. For each QUICK file, extract the manifest marker:
```
Look for: <!-- {ORG}-MANIFEST: [filename] | v[version] | [date] -->
```

**Step 3 — Compare:**

|Check|How|Stale If|
|---|---|---|
|QUICK file version|Marker version vs manifest §2.2|Marker < manifest|
|QUICK file date|Marker date vs manifest §2.2|Marker < manifest|
|Source file version|Manifest §2.2 source version vs §2.1|Source updated since QUICK generated|

**Note:** The manifest is only as current as the last upload. If suspected stale, ask the user to confirm current versions from files on disk.

**Step 4 — Report:**
```
## Knowledge Freshness Report

| File | Loaded Version | Current Version | Status |
|------|---------------|----------------|--------|
| {ORG}-SYSTEMS-QUICK.md | v1.0 (YYYY-MM-DD) | v1.0 (YYYY-MM-DD) | ✅ Current |
| ... | ... | ... | ... |

**Action needed:** [None / List stale files and recommended actions]
```

### §8.2 When to Run

- Start of any conversation modifying reference files
- Before answering questions where data accuracy is critical
- When user asks "are my files current?" or similar
- After user reports uploading new files

---

## §9 Audit Architecture

Systematic audit methodology split across multiple conversations and agents. Each audit type has a defined cadence, agent context, and output format.

### §9.1 Multi-Conversation Protocol

**Why split?** MCP tool results (deal lists, team rosters) are extremely verbose. Running all audit types in one conversation exhausts context before finishing. Split into independent conversations by scope.

|Conversation Type|Agent Context|Context Load|Frequency|
|---|---|---|---|
|**Source system audits** (CRM, task mgmt, personnel)|MCP-capable agent|Heavy|Monthly|
|**Enterprise search drift**|MCP or enterprise search agent|Medium|Quarterly|
|**Terminology consistency**|Enterprise search agent (Copilot)|Light|Quarterly|
|**System consistency**|Editing agent (Claude Code)|Medium (parallel agents)|Quarterly|
|**Memory & rules hygiene**|Editing agent (Claude Code)|Light|Quarterly|

**Workflow:** Separate conversations per audit type → each produces delta report → bring all reports to editing agent for integration.

**Key design decision:** Audits produce delta reports, not direct edits. The editing agent receives consolidated deltas and applies them in a controlled session.

### §9.2 Enterprise Search Drift Audit (Quarterly)

**Purpose:** Compare what's discoverable in enterprise search against what reference files document. Catches undocumented SOPs, rogue folder locations, missing references.

**Methodology (3 parts):**

1. **Entity document coverage:** For top active entities, search for documents. Report: expected locations, unexpected locations, unreferenced documents.
2. **Process/SOP discovery:** Search for "SOP," "policy," "process," "workflow." Compare against documented processes. Flag undocumented items.
3. **Site/location discovery:** Search for all sites/locations. Compare against known inventory. Flag undocumented items.

**Output format:**
```
## Delta: Enterprise Search Drift — [date]
### Document Drift
- [Entity]: [N] docs expected, [N] unexpected
  Unexpected: [path — doc name]
### Undocumented SOPs/Policies
- [Document name] at [path] — not in reference
### Undocumented Sites
- [Site name] at [URL] — not in inventory
### Reference File Actions
- [list of files needing update, or "none"]
```

**Cadence:** Quarterly, or after major organizational changes (new sites, service lines, reorgs). Promote to monthly only if prior checks found significant gaps.

### §9.3 Terminology Audit (Quarterly)

**Purpose:** Detect legacy terminology still in use in recent documents. Uses enterprise search to scan recent documents against a known legacy-to-current term mapping.

**Methodology:**
1. Maintain a legacy term mapping table in the instance terminology file.
2. Search recent documents (last 90 days) for each legacy term.
3. Report: document count per term, most recent usage date, whether current term co-occurs.
4. Flag potential NEW terminology shifts not yet captured.

**Output format:**
```
## Terminology Consistency — [date]
### Known Legacy Terms
- "[legacy]": [N] docs, most recent [date], current also present: [yes/no]
### Potential New Shifts
- "[term A]" vs "[term B]": [N] docs each, pattern suggests [desc]
### No Issues
- [terms with zero legacy usage]
```

**Cadence:** Same as enterprise search drift. Also run ad-hoc when terminology changes suspected.

**Maintenance:** Update legacy term table whenever instance taxonomy adds new entries.

### §9.4 System Consistency Audit (Quarterly)

**Purpose:** Check internal consistency of the reference file system — cross-references, version alignment, agent instruction coherence, convention compliance, architecture integrity.

**14 dimensions, grouped for parallel execution:**

**Structural checks:**

|Dimension|What to Verify|
|---|---|
|**Cross-reference integrity**|Every inter-file reference resolves to existing file and section|
|**QUICK vs full consistency**|QUICK versions, data, summaries match full counterparts; no version inversions|
|**Maintenance system integrity**|Manifest matches actual file headers; markers standardized; triggers cross-referenced|
|**Version tracking**|File header versions match manifest rows. No undocumented edits.|
|**Orphan detection**|Every .md file referenced from at least one other file. Flag zero-inbound files.|

**Content checks:**

|Dimension|What to Verify|
|---|---|
|**Agent instruction alignment**|A2A protocol, agent instructions agree on capabilities, routing, formats|
|**Terminology & duplication**|Legacy terms not leaking into active files; no unintentional content duplication|
|**Static value detection**|No hardcoded counts in prose. Counts should reference source table or metric.|
|**Sensitivity leak check**|No data above allowed tier in QUICK files, memory, or agent files. Severity: Critical.|
|**Freshness decay**|Files not modified in >60 days flagged for review (exclude policy files)|
|**Data freshness annotation audit**|"Data freshness" notes accurately describe current refresh method and cadence|
|**Recipe-retrieval efficiency**|Kernel recipes give enough guidance to produce precise results from retrieved data|

**Architecture checks:**

|Dimension|What to Verify|
|---|---|
|**Domain routing accuracy**|Router lists correct domains, triggers, files, blob names. Every domain has blob file. Triggers match content. No orphan blobs.|
|**Retrieval path verification**|Each domain file accessible via `get_section`. Silent failures = silent knowledge loss. Test at least one per domain.|
|**Kernel-retrieval boundary**|Every kernel file teaches reasoning, not just stores data. No retrieval data in kernel. Guardrail content answerable without retrieval.|

**How to run:** Ask the editing agent to "run a system consistency audit." Groups dimensions into 5-6 parallel agents, synthesizes findings, presents prioritized fix list.

**Output:** Prioritized findings with severity (Critical/High/Medium/Low), affected files, recommended fixes. Apply after user approval.

### §9.5 Memory & Rules Audit (Quarterly)

**Purpose:** Maintain the editing agent's memory system and project rules governing session behavior.

|Check|What to Verify|
|---|---|
|**Memory index line count**|Under target limit (MEMORY.md has hard truncation)|
|**Stale facts**|Items contradicting current file contents or superseded|
|**Duplication with project rules**|Rules in both MEMORY.md and CLAUDE.md (should be in CLAUDE.md only)|
|**Topic file currency**|Completion tracking in topic files matches actual state|
|**Project rules completeness**|All operational rules that should persist are captured|

**How to run:** "Run a memory and rules hygiene audit." Reads all memory files and project rules, cross-checks for staleness, duplication, completeness.

**Output:** Proposed changes to memory (prune/compress), project rules (add missing rules), topic files (update tracking). Apply after approval.

### §9.6 Delta Combination Protocol

After running audit conversations (monthly + quarterly when applicable), bring delta reports to the editing agent:

1. Copy all delta reports
2. Paste together with instruction: "Apply these maintenance deltas to the reference files"
3. Editing agent applies to full files, updates manifest, flags QUICK files for regeneration

**Tip:** Skip conversations with no changes. Audit conversations are independent — run as many or as few as needed.

### §9.7 Architectural Change Validation Protocol

**When to run:** Before and after any change modifying kernel-retrieval boundary, adding/removing kernel files, creating new retrieval domains, or rewriting behavioral directives.

**Why it exists:** Architectural changes cause silent knowledge regression — the agent answers differently but doesn't know it lost something. BEFORE/AFTER catches regressions no single-point test can.

**Protocol:**

1. **Design test.** Write 10 targeted queries. Mix kernel-only and retrieval queries. Include 2+ boundary queries (content that moved).

2. **Define scoring.** Standard rubric (1-4 per dimension, 12 per query, 120 total):

   |Dimension|4 (Excellent)|3 (Good)|2 (Partial)|1 (Poor)|
   |---|---|---|---|---|
   |**Accuracy**|Correct, cites right source|Correct, weak citation|Partially correct|Wrong|
   |**Completeness**|Full answer with context|Core answer, missing context|Incomplete|Barely addresses|
   |**Routing**|Correct source path|Right answer, suboptimal path|Retrieved when kernel sufficient or vice versa|Wrong path, wrong answer|

3. **Run BEFORE.** Pre-change deployment. Score and record.

4. **Deploy the change.**

5. **Run AFTER.** Fresh conversation, same queries, same rubric.

6. **Compare and decide:**

   |Result|Action|
   |---|---|
   |AFTER >= BEFORE, no query regresses 3+ points|**PASS**|
   |AFTER < BEFORE by 1-3 points, regression is retrieval overhead|**PASS WITH NOTES**|
   |AFTER < BEFORE by 4+ points, or any query regresses 3+|**INVESTIGATE**|
   |Kernel-only queries require retrieval in AFTER|**FAIL**|

---

## §10 Claude Code Maintenance Workflow

What the editing agent (Claude Code or equivalent) does when asked to "run maintenance" or update reference files.

### §10.1 Pre-Flight Checks

Before editing any file:

1. **Read maintenance file** — confirm current manifest versions
2. **Scan for markers** — count remaining `[MCP-TBD]`, `[USER-INPUT-TBD]`, `[PROCESS-TBD]` markers across all files
3. **Check for pending delta** — has the user provided a delta report?

### §10.2 Marker Scan Recipe

```
Grep all {ORG}-* files for:
  [MCP-TBD]
  [USER-INPUT-TBD]
  [PROCESS-TBD]

Report format:
  File | Marker Type | Count | Sections
```

Maintain a current marker inventory table in the instance maintenance file.

### §10.3 Actions Table

|Action|What Agent Does|What Agent Cannot Do|
|---|---|---|
|Edit reference file|Read → apply delta → update manifest → save|Query source systems for live data|
|Regenerate QUICK file|Read full → condense per §13 rules → write QUICK → update marker|Upload to agent platform|
|Scan markers|Grep all files → report counts|Resolve [MCP-TBD] markers (needs MCP agent)|
|Update manifest|Edit manifest tables → update version/date/size|Verify against live source systems|
|Cross-reference check|Grep for section references → verify targets exist|Validate external system IDs|
|Build new file|Follow §14 playbook → Phase A skeleton|Fill data requiring MCP access (Phase B/C)|

### §10.4 Post-Edit Checklist

After every file edit:
- [ ] Updated manifest row
- [ ] If QUICK source changed: flagged for regeneration
- [ ] If QUICK regenerated: updated manifest marker in QUICK header
- [ ] Cross-references still valid (section names unchanged, or updated if renamed)
- [ ] Changes committed to git

### §10.5 File Health Analysis

During each maintenance cycle, analyze reference files for optimization opportunities.

**Analysis protocol (run after applying deltas):**

1. **Size check** — file sizes vs budget limits. Flag approaching limits.
2. **Duplication scan** — content in multiple files. Cross-reference should replace duplication.
3. **Stale content detection** — outdated dates, completed transitions, resolved issues.
4. **Density analysis** — high word count / low information density sections. Propose condensation.
5. **Orphan detection** — cross-references to sections or files that no longer exist.

**Optimization rules:**

|Rule|Action|Guardrail|
|---|---|---|
|**Deduplicate**|Replace with cross-reference to canonical source|Never remove the ONLY copy of a fact|
|**Condense prose**|Convert narrative to table or bullets|Preserve all factual content|
|**Prune stale**|Remove resolved issues, completed transitions|Verify captured elsewhere before removing|
|**Merge related**|Combine small sections on same topic|Keep headers for navigation|
|**Split oversized**|If file >20% over budget, propose split|Never split without user approval|

**Report format:**
```
File Health Report (YYYY-MM-DD):

Size:     {ORG}-SYSTEMS-QUICK X KB / Y KB limit (status)
          {ORG}-ADMIN-QUICK   X KB / Y KB limit (status)

Optimize: N opportunities found
  1. [file §section]: [description]
     → [action], save ~X KB
  ...

Total recoverable: ~X KB
Recommend: Apply optimizations? (y/n)
```

**Critical rule:** Never apply optimizations automatically. Present analysis and get user approval. Risk of accidental knowledge loss outweighs efficiency gain.

---

## §11 Operational Trackers

Methodologies for tracking open items, recommendations, and metrics across reference files. Instance-specific tables (actual items, actual values) stay in instance maintenance files.

### §11.1 Open Items Rules

All open items across all reference files tracked centrally. Replaces the need to grep across files to understand system health.

**Counting rules:**
- Every `[USER-INPUT-TBD]`, `[PROCESS-TBD]`, `[MCP-TBD]` marker = 1 open item
- Every entry in a "Known Issues" section = 1 open item
- Every entry in a policy gaps section = 1 open item
- Legitimate organizational vacancies do NOT count — real states, not file defects

**Aging:**
- Each item has "First logged" date. Items >90 days flagged for priority review.
- Items attempted 2+ times without resolution → escalate or reconsider approach.

**Health metric:** `Open Items Score = total open items / total indexed facts`. Lower is better. Track month-over-month.

### §11.2 Assignment Framework

The editing agent should reason about who can resolve each open item using the instance people/teams routing:

|Item Type|Likely Resolver Category|Reasoning|
|---|---|---|
|Revenue/financial figures|CFO / CEO|Financial data is executive-held|
|Vendor scope/contracts|Technology/IT lead|Vendor relationship owner|
|Clinical processes|Compliance / Care Operations|Clinical domain ownership|
|Legal/compliance|General Counsel|Legal domain ownership|
|System configuration|System admin|System admin access|
|CRM data quality|BD / CRM operations|CRM ownership|
|Process definitions|Owning team lead per routing|Route to workflow owner|
|Policy gaps|Department head per policy table|Policy owners define new policies|

### §11.3 Resolution Protocol

During each maintenance cycle:

1. **Refresh tracker** — re-scan all files for markers, known issues, policy gaps
2. **Compare to previous cycle** — report resolved, added, aging
3. **Present resolvable items** — group by likely resolver, prioritize by age and risk:
   ```
   "I found X open items. Y are resolvable in this session:

   For YOU to answer now (N items):
   - Q1: [question] ([file §section], logged [date])
   - Q2: ...

   For [PERSON] to address (N items):
   - [action item] ([file §section], logged [date])
   - ..."
   ```
4. **Resolve user-answerable items** — update files immediately, close items
5. **Generate delegation list** — for items needing other resolvers:
   ```
   "Items for [Person] (N):
   1. [action]
   2. [action]"
   ```
6. **Update tracker** — mark resolved, update attempt count for unresolved

### §11.4 Recommendations Lifecycle

Agent recommendations (Insight Cards, structural observations) are captured in a designated channel and triaged during maintenance.

**Status lifecycle:**
```
Pending → Reviewed → Resolved    (handled during maintenance)
                   → Promoted    (needs distributed work → task created)
                   → Deferred    (valid but not actionable now; re-review every 90 days)
```

**Collection & review protocol (during maintenance cycle):**

1. **Collect** — copy posts from recommendations channel since last maintenance date
2. **Parse** — assign sequential IDs (REC-###), add to tracker as Pending
3. **Review** each item: valid? duplicate of existing open item? scope?
4. **User decides:** Resolve / Promote / Defer / Merge
5. **Update table** — set status and resolution

**Structured task import format (for promoting to task management):**
```
--- TASK ---
Project: Agent Recommendations
Task Name: [REC-###] [1-line summary]
Assignee: [from people/teams routing]
Due Date: [end of current month or user-specified]
Description:
  Observation: [text]
  Evidence: [from original]
  Recommended Action: [what should change]
  Priority: [High / Medium / Low]
  Scope: [affected files/systems]
Tags: agent-recommendation, [type-kebab-case]
--- END ---
```

### §11.5 Metrics Architecture

Volatile business metrics referenced across multiple files. The metrics register is the single authoritative source for each metric's current value, data source, and refresh method.

**Purpose:** Centralize volatile metrics so they can be refreshed in one place and propagated to all files that display them.

**Schema:**

|Field|Description|
|---|---|
|**ID**|`MET-###` — sequential, never reused|
|**Category**|`org` · `pipeline` · `financial` · `infrastructure` · `compliance` · `strategic`|
|**Metric**|What is measured|
|**Value**|Current value. `[TBD]` for unresolved.|
|**As-Of**|Date last verified (YYYY-MM-DD)|
|**Source**|System of record or person|
|**Refresh**|`manual` · `mcp/[system]` · `datalake` [FUTURE]|
|**Cadence**|`monthly` · `quarterly` · `annual` · `event-driven`|
|**Query Hint**|For manual: who to ask. For MCP: tool + filter. For future: `[FUTURE]`.|
|**References**|Files displaying this metric (comma-separated base filenames)|

**Conventions:**
- `[FUTURE]` marks metrics awaiting automation. Skip automated refresh during maintenance.
- `[TBD]` values presented to user with suggested resolver during first processing cycle.
- Derived metrics list components in Query Hint.

**Refresh protocol (during maintenance):**

1. **Extract from deltas** — pipeline and audit reports contain metric values
2. **Compare to register** — for MCP-refreshable metrics, compare delta vs current
3. **Update changed metrics** — Value + As-Of in register AND all References files
4. **Present manual metrics** due this cycle with Query Hint
5. **Report:** `Metrics Register: N refreshed, M unchanged, K need user input, J are [TBD].`

**Propagation rule:** Update register first, then every file in References column. Register is always most current.

**Adding new metrics:**
1. Assign next MET-### ID (never reuse)
2. Set Refresh field when automation arrives
3. Replace `[FUTURE]` in Query Hint with actual query pattern
4. Add value to all References files
5. Add to index business metrics summary if top-level

---

## §12 Agent Tuning & Coordination

### §12.1 Why Tuning Is Different

|Activity|Changes what?|Success metric|
|---|---|---|
|**Maintenance**|Data values|Accuracy — facts match source systems|
|**Build**|File structure/content|Coverage — knowledge exists that didn't before|
|**Structural improvement**|Architecture/organization|Accessibility — knowledge is findable and parseable|
|**Tuning**|Agent behavior/framing|Effectiveness — agents reason better with existing knowledge|

**Key properties:**
- **Measurable** — has before/after scores. Maintenance produces completeness, not performance deltas.
- **Iterative and non-obvious** — can't deduce optimal directives from first principles. Discovery requires observing real-world agent behavior, diagnosing failure modes, designing targeted fixes.
- **Cross-agent** — every tuning insight potentially applies to both agents. Parity gaps are themselves tuning items.

### §12.2 Detection Channels

|Channel|How it works|
|---|---|
|**User observation**|User notices suboptimal output where knowledge exists|
|**Benchmark / smoke test**|Measured performance gap on specific query types|
|**Agent self-observation**|Agent flags its own reasoning struggle in a response|
|**Cross-agent comparison**|One agent handles something well that the other doesn't|
|**Maintenance audit**|Behavioral issues surface alongside data issues during audits|

**Intake path:** Observations enter recommendations tracker (§11.4) with Type = "Behavioral Tuning." Resolved items flow to tuning register.

### §12.3 Best Practices

1. **Diagnose before prescribing.** Measure at query level. Identify the specific failure pattern before writing a directive.
2. **One directive, one failure mode.** Each tuning edit addresses one diagnosed pattern. Bundling makes attribution impossible.
3. **Parity check across agents.** Every insight evaluated for both agents. Default: applies to both. Exception: document why agent-specific.
4. **Smoke test after every edit.** 3 queries from test plan. Verify improvement without degrading others.
5. **Log the principle.** Generalizable insights transfer to new agents and contexts — more valuable than specific directives.
6. **Frame as current state.** Tuning directives describe current behavior, not permanent rules. Agent capabilities evolve; directives are revisitable.

### §12.4 Multi-Agent Coordination

**Correction routing (non-editing agents):**

When a user tells a non-editing agent (e.g., Copilot) that reference file information is outdated:

1. **Acknowledge** — note the correction
2. **Capture** — which file, section, what's wrong, correct value
3. **Route** — direct user to forward to maintainers
4. **Do not edit** — non-editing agents never modify reference files

**File distribution architecture:**

Agent files distribute through multiple channels. All source files are `.md` in the project directory.

|Channel|Files|Method|
|---|---|---|
|**Agent platform knowledge**|Kernel files (reasoning, index, routing, behaviors)|Manual upload|
|**Blob storage (MCP retrieval)**|All non-kernel `.md` files|Auto-synced by script|
|**Agent-specific behaviors**|Each agent gets its own behavior file|Upload to respective platform|

**Access model:**
- **Primary agent (Claude.ai):** Kernel as project knowledge + retrieval via `get_section` from blob
- **Secondary agent (Copilot):** Kernel as agent knowledge + same retrieval backend
- **Editing agent (Claude Code):** Reads all files from local directory

---

## §13 QUICK File Regeneration

QUICK files are condensed versions of full reference files, optimized for agent platform knowledge size limits.

### §13.1 Condensation Rules

When regenerating a QUICK file from source:

1. **Keep:** Lookup tables (IDs, mappings), query recipes, gotchas, routing tables, approval matrices
2. **Keep:** Cross-references to full file sections
3. **Drop:** Prose explanations, background context, methodology notes, build history
4. **Drop:** Transition notes (keep only "last updated" in header)
5. **Drop:** Unresolved markers — only include resolved content
6. **Compress:** Large tables → top rows + summary count; multi-paragraph → bullets
7. **Header:** Version, date, source file reference, manifest marker
8. **Footer pointer:** "For full details, read [source file]"

### §13.2 Regeneration Steps

1. Read full source file
2. Apply condensation rules (§13.1)
3. Write QUICK file
4. Add/update manifest marker: `<!-- {ORG}-MANIFEST: [filename] | v[version] | [date] -->`
5. Update manifest table (version, date, size)
6. Sync any platform-specific copies (e.g., `.txt` for Copilot)
7. Tell user to upload after session

### §13.3 Budget Tracking

Maintain a budget tracking table in the instance maintenance file:

|File|Current Size|Budget Limit|Headroom|
|---|---|---|---|
|{ORG}-INDEX.md|X KB|—|—|
|{ORG}-SYSTEMS-QUICK.md|X KB|Y KB|Z KB|
|...|...|...|...|
|**Total**|**X KB**|**~Y KB**|**~Z KB**|

Individual file limits are approximate — the hard constraint is total platform knowledge size.

**Note:** Individual files no longer carry changelogs. All change history consolidated in maintenance file changelog. Version headers provide bidirectional link to manifest.

---

## §14 Build Playbook

Reusable template for building new reference files.

### §14.1 Phase Overview

|Phase|Name|Who|What|When|
|---|---|---|---|---|
|**Phase A**|Skeleton|Editing agent|Extract from existing files + user docs → skeleton with markers|Always first|
|**Phase 0**|Discovery|User + enterprise search agent|Structured prompts against document stores → discover → integrate|When file has heavy process/policy content|
|**Phase B**|User Enrichment|User + editing agent|Answer `[USER-INPUT-TBD]` questions → integrate → resolve markers|After Phase A/0|
|**Phase C**|MCP Enrichment|MCP-capable agent|Run `[MCP-TBD]` queries against live systems → fill markers|After Phase B, when MCP data needed|
|**Phase D**|QUICK File|Editing agent|Condense full file → QUICK per §13 → user uploads|After content stabilizes|

### §14.2 Phase A Template (Skeleton Build)

```
1. Identify source files:
   - Other {ORG}-* reference files (cross-references)
   - User-provided documents (org charts, policy docs, spreadsheets)
   - Existing document store content (if accessible)

2. Create file with standard header (§14.5)

3. Build section skeleton:
   - Extract known facts → populate directly
   - Mark unknowns:
     [MCP-TBD: description] — needs live system query
     [USER-INPUT-TBD: question] — needs human answer
     [PROCESS-TBD: description] — needs process documentation

4. Cross-reference other files by section name (never duplicate)

5. Count markers → report to user:
   "Phase A complete: X sections, Y [MCP-TBD], Z [USER-INPUT-TBD], W [PROCESS-TBD]"
```

### §14.3 Phase 0 Template (Discovery)

```
1. Identify sections with high [USER-INPUT-TBD] / [PROCESS-TBD] density

2. Write discovery prompts (structured format):
   "Search [document store] for documents related to [topic].
    For each document found, provide:
    - Document name and location
    - Brief summary of content
    - Key details relevant to [specific question]
    Format as a numbered list."

3. User runs prompts → pastes results

4. Integrate findings:
   - Resolve markers where discovery found definitive answers
   - Upgrade markers to specific questions based on discovered documents
   - Note source documents for traceability
```

### §14.4 Phase B Template (User Enrichment)

```
1. Compile all remaining [USER-INPUT-TBD] markers

2. Group questions by:
   - Person who can answer (use people/teams routing)
   - Topic area (for efficient batch questions)

3. Present questions to user with context:
   "Q1 (for [Person], re: [Section]):
    Current state: [what we know from Phase A/0]
    Question: [specific question]
    Options: [if applicable]"

4. Integrate answers → resolve markers → update marker count

5. Report: "Phase B complete: X of Y questions answered, Z markers remaining"
```

### §14.5 Standard File Header Template

```markdown
# {ORG}-[NAME].md
## [Organization] — [Full Title]

**Version:** [X.Y]
**Created:** [YYYY-MM-DD]
**Last Verified:** [YYYY-MM-DD]
**Owner:** [Maintainer / Team]
**Classification:** Internal — Agent Reference File

---
```

QUICK file header adds manifest marker and source pointer:
```markdown
<!-- {ORG}-MANIFEST: {ORG}-[NAME]-QUICK.md | v[X.Y] | [YYYY-MM-DD] -->
# {ORG}-[NAME]-QUICK.md
## [Organization] — [Short Title] Quick Reference

**Version:** [X.Y] (condensed from {ORG}-[NAME].md v[X.Y])
**Created:** [YYYY-MM-DD]
**Owner:** [Maintainer / Team]
**Classification:** Internal — Agent Reference File

**This is the condensed version.** For full details, read {ORG}-[NAME]
```

---

## §15 Trigger Architecture

Not everything needs a monthly audit. Some events should trigger immediate updates.

### §15.1 Trigger Matrix Framework

Trigger matrices define events requiring reference file updates outside the regular maintenance cycle.

**Standard trigger categories:**

|Category|Example Triggers|Typical Priority|
|---|---|---|
|**Client/entity lifecycle**|New client signed, engagement modality changed, lifecycle state changed|High-Medium|
|**Personnel**|Leadership change, org restructure, new hire, departure|High-Low (by seniority)|
|**Systems**|New app procured, system decommissioned, new sites|Medium-Low|
|**Governance**|Policy updated, naming convention changed, compliance change|Medium|
|**Architecture**|Reference file restructured, domain added, behavioral edit|Medium|
|**Data quality**|Significant metric shift (>20%), agent recommendation flagging error|Medium|
|**Agent behavior**|Behavior file edited, behavioral issue observed|Medium|
|**Intelligence pipeline**|New entity profile trigger, signal staleness detected|Medium-Low|

**Instance implementation:** Each instance builds a specific trigger matrix mapping events to affected files, priority levels, and actions. The matrix lives in the instance maintenance file.

### §15.2 Priority Definitions

|Priority|Timing|Rationale|
|---|---|---|
|**High**|Within 1 business day|Affects routing accuracy — wrong answers if stale|
|**Medium**|Within 1 week or next maintenance cycle|Affects completeness but not routing|
|**Low**|Next monthly audit|Informational only — no routing impact|

---

## §16 Sync Cycle Framework

The minimum-manual-steps process for keeping everything current.

### §16.1 Monthly Cycle Framework

The generic sync cycle follows this structure. Instance-specific substeps (enrichment procedures, scan cadences, profile assessments) are defined in the instance maintenance file.

```
Step 1: Self-check (§8)
  → Verify manifest accuracy, report staleness

Step 2: Data acquisition audits
  Step 2a: Pipeline run (§6.1 Steps 2a)
    → Automated data acquisition + transformation
  Step 2b-c: Source system audits
    → Separate conversations per audit type → delta reports
  Step 2d-g (Quarterly): Extended audits
    → Search drift, terminology, system consistency, memory hygiene

Step 3: User transfer
  → Manual bridge between agent contexts (copy delta reports)

Step 4: Editing agent applies deltas
  → Edit affected reference files, update manifest
  Step 4A: Refresh open items tracker (§11.1-§11.3)
  Step 4B: Run file health analysis (§10.5)
  Step 4C: Review recommendations inbox (§11.4)
  Step 4D: Refresh metrics register (§11.5)
  [Instance-specific substeps: enrichment, scans, profile assessments, delta review]

Step 5: Regenerate QUICK files (§13)
  → Regenerate stale QUICK files, update markers

Step 6: User uploads to agent platforms
  → Upload QUICK files + any changed kernel files
  (THE irreducible manual step — no API for platform knowledge upload)

Step 7: Verification
  → Re-run self-check (§8) to confirm currency
```

**Estimated time:** 15-30 min for light months, 45-60 min for heavy months. Each audit conversation takes 2-5 minutes.

**Skip what you don't need:** If nothing changed in an area, skip that conversation. Pipeline and audit conversations are independent.

### §16.2 Emergency Protocol

For high-priority triggers (§15.1) that can't wait for monthly cycle:

1. **Identify scope** — which files affected? (use trigger matrix)
2. **Targeted audit** — run only relevant audit recipe(s)
3. **Targeted edit** — update only affected sections
4. **QUICK regen** — only if affected file has a QUICK file
5. **Upload** — user uploads regenerated QUICK file(s)
6. **Update manifest** — bump version, update date

### §16.3 Sync Architecture Diagram

```
             SOURCE SYSTEMS
  CRM      Task Mgmt    Email/Docs
     |          |          |
     +----------+----------+
                |
          [MCP Agent]         ← reads source systems, produces delta report
                |
                v
         [Delta Report]
                |
          [User copies]       ← manual transfer (copy-paste to editing agent)
                |
                v
         [Editing Agent]      ← writes full files, regenerates QUICK files
                |
       +--------+--------+--------+
       |                  |        |
  Retrieval files    Kernel .md   Platform copies
  ({ORG}-*.md)       (N files)    (generated)
       |                  |        |
  [upload script]   [User uploads]  ← THE irreducible manual step
       |                  |        |
       v                  v        v
  Blob Storage     Primary Agent  Secondary Agent
  (MCP retrieval)  (project       (agent
                   knowledge)     knowledge)
       |                  |        |
       +--------+---------+--------+
                |
         [Maintenance File]  ← version manifest enables self-check loop
         (version manifest)
```

---

## Changelog

|Version|Date|Change|
|---|---|---|
|v1.9|2026-03-13|Phase 5 Maintenance Methodology Extraction. +§8 Self-Check Protocol. +§9 Audit Architecture (multi-conversation protocol, search drift, terminology, system consistency, memory hygiene, delta combination, architectural validation). +§10 Claude Code Maintenance Workflow (pre-flight, marker scan, actions, post-edit, file health). +§11 Operational Trackers (open items, assignment, resolution, recommendations lifecycle, metrics architecture). +§12 Agent Tuning & Coordination (tuning methodology, detection channels, best practices, multi-agent coordination). +§13 QUICK File Regeneration (condensation rules, steps, budget tracking). +§14 Build Playbook (5 phases, templates, standard headers). +§15 Trigger Architecture (matrix framework, priority definitions). +§16 Sync Cycle Framework (monthly cycle, emergency protocol, architecture diagram).|
|v1.8|2026-03-12|Phase 2 Data Residency Zones. +§3.1 `[FRAMEWORK]` delta type (Loop 2, steward-validated). +§4.8 Content Placement Framework (single authority: zone litmus tests, scatter classification, stub depth, routing validation, zone-layer interaction). +§5.5 Write-Back as Learning (virtuous cycle, safety classification). +§6.7 Cycle-Over-Cycle Learning (drift, quality trending, framework stability, anomaly surfacing). +§6.8 Steward Calibration Protocol (quarterly review, `[FRAMEWORK]` delta processing).|
|v1.2|2026-02-25|Added §4.7 File Optimization Patterns — methodology-level documentation of format selection, token efficiency research, lookup-vs-reasoning distinction.|
|v1.1|2026-02-25|Context compression: table minification, telegraphic prose for procedural content, whitespace normalization. ~17% reduction. All section headers and code blocks preserved.|
|v1.0|2026-02-24|Initial version. Learning loops, delta architecture, pipeline pattern, signal convergence, maintenance cycle, testing methodology — ported from operational deployment as company-agnostic patterns.|
