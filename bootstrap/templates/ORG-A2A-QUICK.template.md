# {ORG}-A2A-QUICK.md
## {Organization Name} — Agent Coordination Protocol Summary

**Version:** 1.0
**Last Updated:** {DATE}
**Purpose:** Operational protocol summary for multi-agent coordination. Loaded as kernel file in all agent sessions.

<!-- MANIFEST MARKER: Source={ORG}-A2A-PROTOCOL.md, Version=1.0, Updated={DATE} -->

---

## §0 Routing Header

**What this file covers:** Agent capabilities, delegation rules, format templates, delta output protocol, and system query patterns.

**When to escalate to full protocol:** {ORG}-A2A-PROTOCOL has the complete coordination architecture, delegation reasoning, and cross-system correlation methodology. Escalate when:
- Building new cross-agent workflows
- Diagnosing delegation failures
- Designing new format templates

**File scope:** This is a kernel QUICK file — always loaded, always available. It condenses the operational essentials from {ORG}-A2A-PROTOCOL.

---

## §1 Agent Capability Matrix

| Capability | Claude.ai | Claude Code | M365 Copilot |
|-----------|-----------|-------------|--------------|
| **Reference files** | Read via `get_section` (MCP) | Read/write on disk | Read from agent knowledge |
| **CRM data** | Query via MCP | No direct access | No direct access |
| **Task management** | Query via MCP | No direct access | No direct access |
| **M365 ecosystem** | Query via MCP | No direct access | Native access (Outlook, SharePoint, Teams, Calendar) |
| **Web search** | Yes (tool) | Yes (tool) | Limited (Bing) |
| **File editing** | No | Yes | No |
| **Signal detection** | Yes (all loops) | Yes (Loop 1 via pipeline) | Yes (M365-scoped) |
| **Delta emission** | Yes (queue + YAML) | Yes (queue + YAML) | Yes (Teams channel + structured) |

### Tool Capability Constraints

<!-- Document which MCP tools are available per agent context.
     This varies by instance — update during KERNEL-BOOTSTRAP Phase 5. -->

| Tool | Claude.ai | Claude Code | Copilot |
|------|-----------|-------------|---------|
| `get_section` (reference retrieval) | Yes | No | No |
| CRM MCP | Yes | Yes (if configured) | No |
| Task management MCP | Yes | Yes (if configured) | No |
| Graph/M365 MCP | Yes | No | Native |

---

## §2 Routing & Delegation

**Default routing:** Most questions go to the agent the user is already talking to. Delegate only when another agent has unique access or capability.

| Scenario | Best Agent | Why |
|----------|-----------|-----|
| Questions about org structure, strategy, clients | Claude.ai | Full reference file access + analytical reasoning |
| File edits, pipeline runs, batch operations | Claude Code | File system access + scripting |
| Email/calendar/document questions | Copilot | Native M365 access |
| Cross-system correlation | Claude.ai + Copilot | Each queries their accessible systems, user bridges results |

**The manual bridge:** When insights from one agent context need to reach another, the user copies the output. This is an irreducible manual step — no API connects agent sessions. Design workflows that minimize bridge frequency.

---

## §3 Format Templates

### Activity Snapshot

A structured footer appended to client-specific answers. Agents produce these passively during normal work — they accumulate over time and feed into maintenance cycle Step 4E.

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

Used during enrichment to evaluate entity-instance file completeness:

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

For the learning loop architecture and design rationale, see MOSAIC-OPERATIONS §2-5. This section provides the operational reference that agents use during conversations.

### §4.1 Delta Type Reference

| Type | Loop | Queue Section | When to Emit |
|------|------|---------------|-------------|
| `[DELTA]` | 1 | Data Corrections | Reference file value contradicts live system |
| `[GAP]` | 1 | Data Corrections | Data missing; below tier coverage expectation |
| `[STRUCT]` | 1 | Data Corrections | Naming/format mismatch (systematic, not one-off) |
| `[STALE]` | 1 | Data Corrections | Data past freshness threshold |
| `[PATTERN]` | 2 | Intelligence Queue | Cross-entity/system correlation observed |
| `[RECIPE]` | 2 | Intelligence Queue | Better query method discovered |
| `[ONTOLOGY]` | 2 | Intelligence Queue | Entity doesn't fit taxonomy |
| `[CAUSAL]` | 2 | Intelligence Queue | Mechanism hypothesis for a pattern |
| `[DOMAIN]` | 3 | Intelligence Queue | Recurring query class, no routing (3+ occurrences) |
| `[META]` | 4 | Intelligence Queue | Agent self-observation with specific evidence |
| `[INQUIRY]` | — | Intelligence Queue | Testable hypothesis for user validation |

### §4.2 YAML Schema

Present each observation using this schema (canonical definition: MOSAIC-OPERATIONS §3.2):

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

| Section | GID | Contains |
|---------|-----|----------|
| Data Corrections | {GID} | Loop 1: `[DELTA]`, `[GAP]`, `[STRUCT]`, `[STALE]` |
| Intelligence Queue | {GID} | Loop 2/3/4 + Inquiry: all other types |

**Task name:** `[TYPE] Target: Description`
**Task body:** The YAML front matter above.

### §4.4 Confidence Tiers

| Tier | Source Trust | Loop 1 | Loop 2+ |
|------|-------------|--------|---------|
| **confirmed** | T1-T2 (internal systems, government) | Pipeline may auto-apply | Human review |
| **likely** | T3 (institutional sources) | Human approval required | Human review |
| **unverified** | T4 (web, inference) | Flag for investigation | Human review |

For the full source trust hierarchy, see MOSAIC-REASONING §5.4.

### §4.5 Active Inquiry Format

When offering a hypothesis to the user, use this 4-part structure:

1. **Hypothesis:** What you believe might be true
2. **Evidence:** What data supports it (this session or accumulated)
3. **Question:** The specific thing you want to know
4. **Impact:** What changes in your reasoning if confirmed or denied

**Conversational discipline:** Offer at natural boundaries — after completing the user's task, at conversation end, or when a surprising pattern emerges. Never interrupt task execution.

---

## §5 System Query Patterns

<!-- Discovered recipes are added here as the system learns.
     Each recipe documents: what to query, in what order, what to expect.
     Populated organically through [RECIPE] deltas during maintenance cycles. -->

*No recipes documented yet. This section populates as the system discovers effective query patterns.*

---

## Changelog

<!-- All changes tracked in {ORG}-MAINTENANCE consolidated changelog. -->

| Version | Date | Change |
|---------|------|--------|
| 1.0 | {DATE} | Initial version from KERNEL-BOOTSTRAP Phase 2 + Phase 5. |
