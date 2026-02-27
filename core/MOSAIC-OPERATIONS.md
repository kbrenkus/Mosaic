# MOSAIC-OPERATIONS v1.4

> **Purpose:** Operational architecture for self-learning knowledge systems — how instances detect drift, accumulate observations, process learning, and maintain currency.
> **Scope:** Company-agnostic. All examples use generic placeholders. Instance-specific operational details belong in instance files.
> **Relationship:** MOSAIC-REASONING = how to think. MOSAIC-PRINCIPLES = design principles. MOSAIC-OPERATIONS = how the system learns.

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

**Confidence gating:** Confirmed deltas from authoritative sources (T1) can be auto-applied during pipeline runs. Likely and unverified require human review.

**Governance:** Pipeline processes Loop 1 deltas in batch. Individual agents flag observations but never auto-edit reference files.

### §2.2 Loop 2 — Reasoning Improvement

**What it detects:** Patterns, better methods, ontological gaps, and causal mechanisms that improve system reasoning.

**Detection method:** Agents notice patterns during analytical work — cross-entity correlations, better query strategies, taxonomy misfits, causal hypotheses.

**Delta types:**
- `[PATTERN]` — Correlation across multiple entities or systems. Emit when you see meaningful regularity, even from one session. Queue accumulates across sessions; maintenance assesses durability.
- `[RECIPE]` — More effective way to query or combine results from connected systems.
- `[ONTOLOGY]` — Entity or concept that doesn't fit existing classification frameworks.
- `[CAUSAL]` — Hypothesized mechanism explaining *why* a pattern exists. Requires: (1) observed pattern, (2) specific falsifiable mechanism, (3) evidence beyond pattern data.

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
agent: claude-operations|copilot|claude-code
session_date: YYYY-MM-DD
---
```

**Field notes:**
- `target_section` uses bare section numbers matching `get_section()` syntax (e.g., "3", "2.1")
- `confidence` follows source trust hierarchy in MOSAIC-REASONING §5.4
- `mechanism` only populated for `[CAUSAL]` type — the specific, falsifiable hypothesis
- `sovereignty_check` is instance-defined; some organizations may have data governance requirements

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
|**confirmed**|Authoritative source (T1/T2), directly verified|Pipeline may auto-apply|Informational — human reviews|
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

## Changelog

|Version|Date|Change|
|---|---|---|
|v1.2|2026-02-25|Added §4.7 File Optimization Patterns — methodology-level documentation of format selection, token efficiency research, lookup-vs-reasoning distinction.|
|v1.1|2026-02-25|Context compression: table minification, telegraphic prose for procedural content, whitespace normalization. ~17% reduction. All section headers and code blocks preserved.|
|v1.0|2026-02-24|Initial version. Learning loops, delta architecture, pipeline pattern, signal convergence, maintenance cycle, testing methodology — ported from operational deployment as company-agnostic patterns.|
