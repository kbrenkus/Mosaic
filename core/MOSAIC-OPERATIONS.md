# MOSAIC-OPERATIONS v1.0

> **Purpose:** Operational architecture for self-learning knowledge systems. This file defines how Mosaic instances detect drift, accumulate observations, process learning, and maintain currency — the operational counterpart to MOSAIC-REASONING (cognitive frameworks) and MOSAIC-PRINCIPLES (design principles).
>
> **Company-agnostic constraint:** Like MOSAIC-REASONING, this file contains no organization-specific content. All examples use generic placeholders ({Organization}, Acme Corporation, etc.). Instance-specific operational details (system IDs, queue GIDs, cycle cadence) belong in instance files.
>
> **Relationship to other core files:**
> - **MOSAIC-REASONING** teaches agents *how to think* (cognitive frameworks, retrieval architecture, people reasoning)
> - **MOSAIC-PRINCIPLES** teaches builders *what principles guide design* (32+ named principles with evidence)
> - **MOSAIC-OPERATIONS** teaches both *how the system learns* (learning loops, delta protocol, pipeline architecture, maintenance cycles)

---

## §1 About This File

A knowledge architecture that only answers questions is a reference library. A knowledge architecture that *learns* — detecting its own gaps, accumulating observations, processing corrections, and improving its reasoning — is an intelligence system.

This file documents the operational machinery that makes learning possible. Every pattern here was discovered empirically through live deployment and validated across multiple maintenance cycles. The patterns are company-agnostic: they describe *what* the system does to learn, not the specific systems or entities it learns about.

**Who reads this file:**
- **Instance builders** — during KERNEL-BOOTSTRAP Phase 5 (Learning Infrastructure Setup) and ongoing system design
- **Agents** — behavioral directives in instance behavior files point here for architectural reasoning
- **Maintainers** — when designing or refining maintenance cycles

---

## §2 Learning Loop Architecture

The system learns through four distinct loops operating over shared infrastructure, plus an active inquiry mode. Each loop has different detection methods, confidence requirements, and governance rules.

> *Design principle reference:* MOSAIC-PRINCIPLES A-001 (Three Learning Loops — data, reasoning, substrate), A-003 (Three Data Tiers — generated, enriched, curated), A-004 (Confidence Gating).

### §2.1 Loop 1 — Data Freshness

**What it detects:** Live system data that contradicts reference file content — deals that closed, teams that changed, personnel who departed, entities whose properties drifted.

**Detection method:** Pipeline compares live system snapshots against reference files. Agents also detect drift during normal conversations when retrieved data contradicts live MCP results.

**Delta types:** `[DELTA]` (value changed), `[GAP]` (data missing), `[STRUCT]` (structural mismatch like naming), `[STALE]` (data past freshness threshold)

**Confidence gating:** Loop 1 deltas carry confidence levels (confirmed, likely, unverified). Confirmed deltas from authoritative systems (T1 in the source trust hierarchy) can be auto-applied during pipeline runs. Likely and unverified deltas require human review.

**Governance:** The pipeline processes Loop 1 deltas in batch. Individual agents flag observations but never auto-edit reference files.

### §2.2 Loop 2 — Reasoning Improvement

**What it detects:** Patterns, better methods, ontological gaps, and causal mechanisms that would improve how the system reasons.

**Detection method:** Agents notice patterns during analytical work — cross-entity correlations, more effective query strategies, entities that don't fit existing taxonomies, and causal hypotheses about why patterns exist.

**Delta types:**
- `[PATTERN]` — Correlation observed across multiple entities or systems. Emit when you see a meaningful regularity, even from a single session. The queue accumulates observations across sessions; the maintenance review assesses durability.
- `[RECIPE]` — A more effective way to query or combine results from connected systems.
- `[ONTOLOGY]` — An entity or concept that doesn't fit existing classification frameworks.
- `[CAUSAL]` — A hypothesized mechanism explaining *why* a pattern exists, not just *that* it exists. Requires: (1) the observed pattern, (2) a specific, falsifiable mechanism, (3) evidence beyond the pattern data itself.

**Graduation path:** `[PATTERN]` (correlation observed) → `[CAUSAL]` (mechanism hypothesized). When you observe a pattern AND can articulate why it exists, emit `[CAUSAL]` with the mechanism field. Don't wait for certainty — the mechanism captures a hypothesis for maintenance review to validate.

**Governance:** Loop 2 deltas always require human review. Reasoning and architectural changes demand semantic judgment that cannot be automated.

### §2.3 Loop 3 — Substrate Expansion

**What it detects:** Recurring query classes that have no routing or knowledge domain — signals that the architecture itself needs to grow.

**Detection method:** Agents track query classes they cannot route. The first occurrence is noise. The second is interesting. The third triggers a `[DOMAIN]` delta.

**Delta type:** `[DOMAIN]` — A class of questions that keeps arising with no domain to route it to.

**Threshold:** 3 occurrences of the same query class before emission. This prevents noise from one-off questions.

**Governance:** Domain proposals require architectural review (new files, routing entries, budget allocation). The `[DOMAIN]` delta starts the conversation; DOMAIN-BOOTSTRAP provides the methodology.

### §2.4 Loop 4 — Self-Knowledge

**What it detects:** Agent reasoning tendencies, defaults, and performance patterns — metacognition about the agent's own behavior.

**Detection method:** Agents observe their own reasoning during conversations and emit observations with specific evidence.

**Delta type:** `[META]` — A self-observation about reasoning behavior.

**Trigger categories:**
| Category | Example |
|----------|---------|
| Reasoning mode mismatch | Defaulted to data assembly when the question was strategic |
| Domain-specific difficulty | Repeatedly routed to the wrong file first for a domain |
| Confidence-evidence gap | Gave a confident answer while source data was stale |
| Retrieval path habit | Skipped a source that would have helped, and can see why |

**Governance:** Self-observations are diagnostic reports, not permission to self-correct. The critical rule: **observe and emit; the maintenance workflow validates before acting.** `[META]` deltas go through the same review process as Loop 2, with the additional step of checking benchmark scores to confirm or disconfirm the self-diagnosis.

### §2.5 Active Inquiry

Active Inquiry is a learning *mode*, not a loop. The agent forms a testable hypothesis and seeks evidence — including by asking the user.

**Delta type:** `[INQUIRY]` — A hypothesis the agent wants to test.

**4-part format:**
1. **Hypothesis:** What the agent believes might be true
2. **Evidence:** What data from this or prior sessions supports it
3. **Question:** The specific thing the agent wants to know
4. **Impact:** What would change in how the agent reasons if confirmed or denied

**Evidence bar:** "I have a specific hypothesis, with specific evidence, and the answer would change how I reason about future queries in this class."

**Bad inquiry:** "I wonder if our data is complete?" (vague, unfalsifiable, no impact statement)
**Good inquiry:** "Three active clients show declining email signals but steady deal progression — is engagement shifting to in-person channels? If so, email-based engagement scoring needs recalibration."

**Conversational discipline:** Inquiries are offered at natural boundaries — after completing the user's task, at conversation end alongside the delta batch, or when a surprising pattern emerges during retrieval. Never interrupt task execution to ask a hypothesis question.

**Governance:** If the user defers, the inquiry goes to the queue. Deferred inquiries that accumulate 3+ deferrals should be re-evaluated and closed if evidence has gone stale.

### §2.6 Loop Interaction Model

The loops are not independent — they feed each other:

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

**Processing priority:** Loop 1 deltas are processed first (data accuracy is prerequisite), then Loop 2/3/4 together (reasoning changes are higher-leverage but require data correctness).

---

## §3 Delta Architecture

Deltas are the structured observations that carry learning from detection to integration. Every observation uses a consistent schema, routes to a defined queue, and follows confidence-based governance.

### §3.1 Delta Type Taxonomy

| Type | Loop | Section | Description | Threshold |
|------|------|---------|-------------|-----------|
| `[DELTA]` | 1 | Data Corrections | Value in reference file contradicts live system | Any confirmed discrepancy |
| `[GAP]` | 1 | Data Corrections | Data missing from reference file | Below tier coverage expectation |
| `[STRUCT]` | 1 | Data Corrections | Structural mismatch (naming, format, organization) | Systematic, not one-off |
| `[STALE]` | 1 | Data Corrections | Data past freshness threshold | Instance-defined (e.g., >3 months) |
| `[PATTERN]` | 2 | Intelligence Queue | Cross-entity or cross-system correlation | Observed across 2+ entities/systems |
| `[RECIPE]` | 2 | Intelligence Queue | More effective query or combination method | Demonstrably better than existing |
| `[ONTOLOGY]` | 2 | Intelligence Queue | Entity doesn't fit existing taxonomy | Unresolvable with current categories |
| `[CAUSAL]` | 2 | Intelligence Queue | Mechanism hypothesis for an observed pattern | Pattern + specific mechanism + evidence |
| `[DOMAIN]` | 3 | Intelligence Queue | Query class with no routing or domain | 3+ occurrences of same class |
| `[META]` | 4 | Intelligence Queue | Agent self-observation about reasoning | Specific evidence, not vague impression |
| `[INQUIRY]` | — | Intelligence Queue | Testable hypothesis for user validation | Evidence bar met (see §2.5) |

### §3.2 Delta YAML Schema

Every delta uses this schema. The canonical definition lives here; operational templates in instance A2A files reference this section.

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
- `confidence` follows the source trust hierarchy in MOSAIC-REASONING §5.4
- `mechanism` is only populated for `[CAUSAL]` type — it's the specific, falsifiable hypothesis
- `sovereignty_check` is instance-defined; some organizations may have data governance requirements for specific entity types

### §3.3 Queue Infrastructure

The delta queue uses a task tracking tool (e.g., Asana) with two sections in a shared project:

| Section | Contains | Processing |
|---------|----------|------------|
| **Data Corrections** | Loop 1 types: `[DELTA]`, `[GAP]`, `[STRUCT]`, `[STALE]` | Pipeline batch + manual review |
| **Intelligence Queue** | Loop 2/3/4 + Inquiry: `[PATTERN]`, `[RECIPE]`, `[ONTOLOGY]`, `[CAUSAL]`, `[DOMAIN]`, `[META]`, `[INQUIRY]` | Maintenance review only |

**Why two sections:** Data corrections are higher-volume, lower-risk, and partially automatable. Intelligence observations are lower-volume, higher-leverage, and always require human judgment. Separating them prevents high-volume data corrections from burying strategic insights.

### §3.4 Routing Rules

Agents route deltas to sections based on type:
- Loop 1 types → Data Corrections
- All other types → Intelligence Queue

**Task naming convention:** `[TYPE] Target: Description`
- Example: `[STALE] Acme Corp: Deal close date 8 months overdue`
- Example: `[PATTERN] MULTIPLE: Engagement expansion follows trust-building services`

**Task body:** The YAML front matter from §3.2.

### §3.5 Confidence Gating

| Level | Meaning | Loop 1 Treatment | Loop 2+ Treatment |
|-------|---------|-------------------|---------------------|
| **confirmed** | Authoritative source (T1/T2), directly verified | Pipeline may auto-apply | Informational only — human reviews |
| **likely** | Good evidence but not directly verified | Present for human approval | Informational only — human reviews |
| **unverified** | Weak evidence or inference | Flag for investigation | Informational only — human reviews |

**Critical rule:** Loop 2+ deltas are never auto-applied regardless of confidence level. Reasoning changes always require human semantic judgment.

---

## §4 Pipeline Architecture

The pipeline is a hybrid pattern that bridges the gap between MCP-accessible live systems and deterministic file transformation. It enables automated data freshness (Loop 1) while preserving human judgment through the overlay layer.

> *Design principle reference:* MOSAIC-PRINCIPLES A-002 (Reference Files Are Views, Not Sources of Truth), A-005 (Four-Layer Sync Problem).

### §4.1 Phase 1 — MCP Data Acquisition

An agent with MCP access (typically Claude Code) queries live systems and writes JSON snapshots:

```
Agent → MCP tools → Live systems (CRM, task management, calendar, etc.)
                  ↓
         JSON snapshots → pipeline/inputs/YYYY-MM-DD.json
```

**Why JSON snapshots?** MCP tools are only accessible from specific agent contexts. The JSON bridge lets deterministic Python scripts process the data without needing MCP access themselves.

**Schema convention:** Each snapshot wraps its array in a named object: `{"deals": [...]}`, `{"teams": [...]}`, `{"tasks": [...]}`. This makes files self-documenting and prevents ambiguity.

### §4.2 Phase 2 — Transformation

A Python script reads the snapshots, merges with curated overlays and lookup tables, and regenerates reference file sections:

```
JSON snapshots + Overlay YAML + Lookup tables
                  ↓
         Python transformation script
                  ↓
Updated QUICK file section + Run summary + Update CSV
```

**Key design decisions:**
- The script is **deterministic and reproducible** — same inputs produce same outputs
- It **regenerates sections**, not entire files — preserving routing headers (§0) and manually-curated content
- It produces a **run summary** documenting what changed, what matched, what didn't
- It generates a **batch update CSV** for changes that need to be pushed back to source systems

### §4.3 Phase 3.5 — Enrichment Queue

A second script scans all entity-instance files (profiles, directories) for completeness gaps:

```
Profile files → Scan for gap markers (MCP-TBD, BD-TBD, etc.)
                  ↓
Prioritized CSV + Ready-to-paste enrichment prompts
```

**Track classification:**
| Track | Criteria | Method |
|-------|----------|--------|
| **Track 2** | >12 gaps | Claude Code MCP enrichment (high-value, complex) |
| **Track 1** | <=12 gaps | Claude.ai web research (manageable scope) |
| **BD-only** | Gaps require human knowledge | Route to relationship owner |
| **Missing** | No profile exists | Create from template if lifecycle warrants |

### §4.4 Phase 3 — Post-Processing

After the pipeline run:
1. Review the run summary — unmatched entities, overlay changes, data anomalies
2. Process the batch update CSV (push corrections back to source systems)
3. Mark consumed delta tasks complete in the queue
4. Run the upload script to sync files to blob storage
5. Present enrichment recommendation — the #1 candidate from the queue

### §4.5 The Overlay Pattern

The overlay is a curated YAML file containing human-judgment fields that cannot be auto-derived from live systems:

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

**Why overlays exist:** Some fields reflect human judgment (lifecycle state, strategic flags, tier assignments) that no system query can determine. The overlay is the **curated foundation layer** — it represents decisions, not data.

**Overlay governance:** Only humans edit overlays. The pipeline reads them but never writes them. Lifecycle changes, tier adjustments, and strategic flags are human decisions captured here.

### §4.6 Integration Patterns

Two patterns for how deltas become reference file changes:

**Pattern A — Regeneration (for tables and rosters):**
The pipeline regenerates entire sections from live data + overlay. Used for QUICK file data sections where surgical edits would be fragile. Every pipeline run produces a fresh, accurate section.

**Pattern B — Surgical Integration (for narrative content):**
Claude Code opens the target file, navigates to the target section, compares delta evidence against current content, and presents a proposed edit for approval. Used for entity-instance files (profiles, directories) where section-level updates are precise and safe.

**When to use which:**
| Content Type | Pattern | Rationale |
|-------------|---------|-----------|
| Data tables, rosters, directory listings | A (Regeneration) | Accumulating micro-edits is fragile; fresh data is reliable |
| Narrative profiles, engagement history | B (Surgical) | Full regeneration would destroy curated narrative; surgical is precise |
| Routing headers, framework sections | Neither | These are curated content, not data-driven. Edit manually. |

---

## §5 Signal-to-Delta Convergence

### §5.1 The Core Insight

Agents already detect signals during normal work — stale data, patterns, missing entities, self-observations about their own reasoning. The innovation is not in detection; it's in **mapping existing signal detection to structured output**.

**Before:** Agent detects signal → mentions it conversationally → hope someone acts on it → observation lost when conversation ends.

**After:** Agent detects signal → emits structured delta → queue accumulates → maintenance cycle reviews in batch → findings encoded in reference files → future agents benefit.

The agent's cognitive processes don't change. The *output channel* changes. Existing signal awareness thresholds become delta trigger conditions.

### §5.2 Trigger Discipline

Not every observation is worth a delta. The test: **"Would this change what a reference file says, how a query recipe works, or how the agent reasons?"**

- If yes → emit a delta
- If no → it's conversational context, mention it in the response but don't create a task

**Per-loop guidance:**
- **Loop 1:** Emit when live data contradicts reference data or data is missing/stale
- **Loop 2:** Emit `[PATTERN]` when a meaningful correlation appears. Don't suppress because you've "only seen it once" — the queue provides persistence across sessions
- **Loop 3:** Wait for 3 occurrences before emitting `[DOMAIN]`
- **Loop 4:** Emit only with specific evidence, not vague impressions ("I queried the wrong system first" not "I could be better")
- **Active Inquiry:** Evidence bar must be met (see §2.5)

### §5.3 Conversation-End Batch Protocol

At conversation end, agents present accumulated observations as a structured batch:

1. **Accumulate** observations during the conversation (don't interrupt workflow)
2. **Present** at conversation end as YAML delta blocks (one per observation, using the schema in §3.2)
3. **Post** each block as a task in the delta queue (appropriate section per §3.4)
4. **Fallback:** If queue posting fails, the YAML blocks in the response serve as paste-ready backup — never silently drop observations

**What qualifies:** Structural, ontological, data quality, reasoning, and self-observations. NOT routine factual context that was part of answering the question.

### §5.4 Behavioral Integration

Signal awareness directives are wired into agent behavior files through:

1. **Trigger tables** — Instance-specific thresholds for each delta type (e.g., ">3 months past close date = `[STALE]`")
2. **Trigger discipline rules** — The per-loop guidance from §5.2, adapted to organizational context
3. **Batch protocol** — YAML format, queue routing, fallback behavior
4. **Confidence tagging** — Source trust hierarchy reference

See the behavior file templates for the specific directive structure. The instance customizes thresholds and adds domain-specific triggers during KERNEL-BOOTSTRAP Phase 5.

---

## §6 Maintenance Cycle Architecture

The maintenance cycle is the systematic review process that converts accumulated learning into reference file improvements. It runs at a regular cadence (monthly by default) and integrates all four learning loops.

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

The most strategic step in the cycle. Pull Intelligence Queue items and review each by type:

| Type | Review Process |
|------|---------------|
| `[PATTERN]` | Assess durability. Where does it belong? Shared reasoning (MOSAIC-REASONING) if cross-instance, query recipe if operational, domain file if specific. Draft proposed edit. |
| `[RECIPE]` | Assess whether it improves an existing recipe or warrants a new one. Draft edit. |
| `[ONTOLOGY]` | Assess against current taxonomy. Draft taxonomy update if gap confirmed. |
| `[CAUSAL]` | Validate mechanism: Is it specific and falsifiable? Does evidence support it beyond the original pattern? Are alternative explanations addressed? If validated, document alongside or superseding the originating pattern. |
| `[DOMAIN]` | Check 3-occurrence threshold. If met, draft domain proposal. If not, leave in queue. |
| `[META]` | Check benchmark scores for empirical confirmation. Run targeted test queries. If confirmed, draft behavioral directive edit (apply behavioral parity check). If disconfirmed, note as unconfirmed. |
| `[INQUIRY]` | Assess relevance (evidence may be stale). Present to user: answer now or defer. If answered, route result to appropriate loop. After 3 deferrals, re-evaluate. |

**Critical rule:** Present and draft, never auto-apply. Reasoning changes require human semantic judgment.

### §6.3 Surgical Integration

For entity-instance file deltas (Pattern B), follow the Read-Compare-Present-Write protocol:

1. **READ:** Open target file, navigate to target section
2. **COMPARE:** Match delta's `current_ref` against actual content
   - Exact match → present proposed edit
   - Semantic match (content changed but structure intact) → present with drift note
   - Structural drift (section reorganized/missing) → reject, flag for manual review
3. **PRESENT:** Show current content, delta evidence, and proposed edit
4. **WRITE** (after approval only): Apply edit

**Confidence-based ordering:**
- Confirmed + factual data → present for quick approval
- Likely + engagement data → present with evidence chain
- Unverified + strategic data → flag for investigation, do not auto-present

### §6.4 Enrichment Decision

After the pipeline identifies enrichment candidates, the cycle includes a decision point:

- **Track 2** (high gap count): Schedule in-session MCP enrichment or defer to next session
- **Track 1** (manageable gap count): Generate prompts for web research session
- **BD-only**: Route to human relationship owners
- **Missing profiles**: Create from template if entity lifecycle warrants investment

The enrichment queue output names the #1 candidate with rationale. The user decides: enrich now, pick a different one, or skip.

### §6.5 Cycle Frequency

**Default:** Monthly. This balances freshness with overhead.

**Tunable parameters:**
- Data-heavy instances (many live system connections) may benefit from biweekly Loop 1 processing
- Stable instances may extend to 6-week cycles
- The pipeline (Steps 2a) can run independently of the full cycle when rapid data refresh is needed

---

## §7 Testing & Validation Architecture

### §7.1 Pre-Test → Build → Post-Test Pattern

Every significant change to the knowledge architecture follows this validation sequence:

1. **Pre-test:** Run 3-5 targeted queries BEFORE implementation. Score against the rubric. This establishes the baseline.
2. **Build:** Implement the changes.
3. **Post-test:** Run the SAME queries AFTER implementation. Score with the same rubric. Compare.
4. **Accept/Reject:** No regressions allowed. Improvements expected on targeted dimensions.

**Why pre-test matters:** Post-hoc tests only verify what was built, not whether the build achieved its *intent*. Pre-test scores reveal the current ceiling. Post-test scores reveal whether you raised it.

### §7.2 Scoring Rubric Design

Define dimensions and scales during planning (not after the build):

| Dimension | What It Measures | Example Scale |
|-----------|-----------------|---------------|
| Accuracy | Factual correctness of response | 0-4 (wrong → partially correct → correct → correct with nuance) |
| Completeness | Coverage of relevant information | 0-4 (missing → partial → adequate → comprehensive) |
| Confidence Calibration | Appropriate uncertainty signaling | 0-2 (overconfident → calibrated) |
| Retrieval Efficiency | Found the answer without unnecessary calls | 0-2 (excessive retrieval → efficient) |

Instance-specific dimensions can be added (e.g., sensitivity compliance, tribal sovereignty).

### §7.3 Regression Detection

After editing agent behavior files, run a smoke test:
- Pick 3 queries from the test plan (1 easy, 1 medium, 1 hard) relevant to the changed behavior area
- Run them in the appropriate agent platform
- If any query regresses, investigate before finalizing

Full benchmark re-runs are only needed after major restructuring.

### §7.4 Benchmark Tracking

Maintain a 20-25 query benchmark spanning all operational domains. Track scores over time to identify systemic trends. Benchmark scores serve as the empirical check on `[META]` self-observations — when an agent reports a weakness, the benchmark score for that domain either confirms or disconfirms the diagnosis.

---

## Changelog

| Version | Date | Change |
|---------|------|--------|
| v1.0 | 2026-02-24 | Initial version. Learning loops, delta architecture, pipeline pattern, signal convergence, maintenance cycle, and testing methodology — all ported from operational deployment as company-agnostic patterns. |
