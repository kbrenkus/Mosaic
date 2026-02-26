# {ORG}-A2A-QUICK — Agent Coordination Protocol Summary
**Version:** 1.0 | **Updated:** {DATE} | Kernel QUICK file. Source: {ORG}-A2A-PROTOCOL.md.
<!-- MANIFEST MARKER: Source={ORG}-A2A-PROTOCOL.md, Version=1.0, Updated={DATE} -->

---

## §0 Routing Header

**Covers:** Agent capabilities, delegation, format templates, delta protocol, system query patterns.
**Escalate to {ORG}-A2A-PROTOCOL** for new workflows, delegation failures, or format template design.
**Scope:** Kernel QUICK — always loaded. Condenses {ORG}-A2A-PROTOCOL.

---

## §1 Agent Capability Matrix

|Capability|Claude.ai|Claude Code|M365 Copilot|
|---|---|---|---|
|**Reference files**|`get_section` MCP|Read/write disk|Agent knowledge|
|**CRM data**|MCP|No|No|
|**Task management**|MCP|No|No|
|**M365 ecosystem**|MCP|No|Native (Outlook, SP, Teams, Cal)|
|**Web search**|Yes|Yes|Limited (Bing)|
|**File editing**|No|Yes|No|
|**Signal detection**|All loops|Loop 1 (pipeline)|M365-scoped|
|**Delta emission**|Queue + YAML|Queue + YAML|Teams channel + structured|

### Tool Capability Constraints

<!-- Update per instance during KERNEL-BOOTSTRAP Phase 5. -->

|Tool|Claude.ai|Claude Code|Copilot|
|---|---|---|---|
|`get_section` (reference retrieval)|Yes|No|No|
|CRM MCP|Yes|Yes (if configured)|No|
|Task management MCP|Yes|Yes (if configured)|No|
|Graph/M365 MCP|Yes|No|Native|

---

## §2 Routing & Delegation

Delegate only when another agent has unique access or capability.

|Scenario|Best Agent|Why|
|---|---|---|
|Org structure, strategy, clients|Claude.ai|Full reference access + reasoning|
|File edits, pipeline, batch ops|Claude Code|File system + scripting|
|Email/calendar/documents|Copilot|Native M365 access|
|Cross-system correlation|Claude.ai + Copilot|Each queries own systems, user bridges|

**Manual bridge:** User copies output between agents. No API connects sessions — minimize bridge frequency.

---

## §3 Format Templates

### Activity Snapshot

Structured footer on client answers. Produced passively; feeds Step 4E.

```markdown
---
**Activity Snapshot** ({Entity Name}, {DATE})
- **Lifecycle:** {state from reference files}
- **Live signals:** {what CRM/task/email data shows}
- **Alignment:** {match|mismatch|insufficient data}
- **Delta:** {if mismatch, what changed}
- **Source:** {which systems were queried}
---
```

### Coverage Assessment

Evaluates entity-instance file completeness during enrichment:

```markdown
---
**Coverage Assessment** ({Entity Name}, {DATE})
| Layer | Status | Gaps | Source |
|-------|--------|------|--------|
| {Layer 1 name} | {%} | {list} | {systems} |
| {Layer 2 name} | {%} | {list} | {systems} |
...
- **Overall:** {X}% coverage, {N} MCP-TBD, {N} BD-TBD
- **Recommendation:** {Track 1|Track 2|BD-only}
---
```

---

## §4 Delta Output Protocol

Learning loop architecture: MOSAIC-OPERATIONS §2-5. Operational reference below.

### §4.1 Delta Type Reference

|Type|Loop|Queue Section|When to Emit|
|---|---|---|---|
|`[DELTA]`|1|Data Corrections|Ref value contradicts live system|
|`[GAP]`|1|Data Corrections|Missing data; below coverage expectation|
|`[STRUCT]`|1|Data Corrections|Naming/format mismatch (systematic)|
|`[STALE]`|1|Data Corrections|Past freshness threshold|
|`[PATTERN]`|2|Intelligence Queue|Cross-entity/system correlation|
|`[RECIPE]`|2|Intelligence Queue|Better query method found|
|`[ONTOLOGY]`|2|Intelligence Queue|Entity doesn't fit taxonomy|
|`[CAUSAL]`|2|Intelligence Queue|Mechanism hypothesis for pattern|
|`[DOMAIN]`|3|Intelligence Queue|Recurring query class, no routing (3+)|
|`[META]`|4|Intelligence Queue|Agent self-observation with evidence|
|`[INQUIRY]`|—|Intelligence Queue|Testable hypothesis for user|

### §4.2 YAML Schema

Schema per observation (canonical: MOSAIC-OPERATIONS §3.2):

```yaml
[TYPE] Target: Brief description
---
type: delta|gap|struct|stale|pattern|recipe|ontology|causal|domain|meta|inquiry
domain: {domain name}
target_file: {ORG}-FILENAME
target_section: "N"
target_entity: EntityName|MULTIPLE
source_system: crm|tasks|email|sharepoint|web|internal
confidence: confirmed|likely|unverified
mechanism: "..."                    # required for causal only
evidence: ["what was observed"]
current_ref: "what reference says"
recommended: "what should change"
sovereignty_check: false
agent: claude-operations|copilot|claude-code
session_date: YYYY-MM-DD
---
```

### §4.3 Queue Routing

<!-- Update these GIDs during KERNEL-BOOTSTRAP Phase 5 -->

|Section|GID|Contains|
|---|---|---|
|Data Corrections|{GID}|Loop 1: `[DELTA]`, `[GAP]`, `[STRUCT]`, `[STALE]`|
|Intelligence Queue|{GID}|Loop 2/3/4 + Inquiry: all other types|

**Task name:** `[TYPE] Target: Description` | **Body:** YAML above.

### §4.4 Confidence Tiers

|Tier|Source Trust|Loop 1|Loop 2+|
|---|---|---|---|
|**confirmed**|T1-T2 (internal, govt)|Auto-apply eligible|Human review|
|**likely**|T3 (institutional)|Human approval required|Human review|
|**unverified**|T4 (web, inference)|Flag for investigation|Human review|

Full source trust hierarchy: MOSAIC-REASONING §5.4.

### §4.5 Active Inquiry Format

4-part structure for hypotheses:

1. **Hypothesis:** What might be true
2. **Evidence:** Supporting data (this session or accumulated)
3. **Question:** What you want to know
4. **Impact:** What changes if confirmed or denied

**Discipline:** Offer at natural boundaries only (task complete, conversation end, surprising pattern). Never interrupt task execution.

---

## §5 System Query Patterns

<!-- Populated via [RECIPE] deltas during maintenance cycles. -->

*No recipes yet. Populates via [RECIPE] deltas.*

---

<!-- Version history tracked in git. Manifest in {ORG}-MAINTENANCE §2. -->
