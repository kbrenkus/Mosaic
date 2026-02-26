# Mosaic Proposal: Multi-Agent Parallel Discovery in Domain Bootstrap

**Submitted by:** Mosaic IP (Indigenous Pact)
**Date:** 2026-02-26
**Category:** Protocol Enhancement

---

## 1. Observation

DOMAIN-BOOTSTRAP v0.6 designs Phase 2F (Data Mapping) as a single-agent activity, implicitly assuming the MCP-enabled agent (Claude Code) runs all discovery. Phase 6.7 (Multi-Agent Execution Model) addresses multi-agent coordination, but only for post-construction enrichment. During Phase B (Marketing domain bootstrap), we discovered that running discovery prompts on Copilot (enterprise search agent) in parallel with Claude Code MCP queries surfaced content that MCP alone could not reach — SharePoint documents in private sites, governance detail with DOA thresholds, vendor engagement documents with dates, and historical campaign materials with folder structure.

The protocol has no guidance for:
- Running discovery across multiple agents in parallel during Phases 1-2
- Agent-specific discovery prompt variants (MCP vs. enterprise search)
- Capturing and merging multi-agent discovery results for Phase 3 synthesis
- Documenting which agent discovered what (provenance)

## 2. Evidence

- **Query patterns:** Phase 7.1 baseline testing ran 4 shared queries on both Claude.ai and Copilot. Copilot scored 68/84 (81%) vs. Claude.ai's 110/112 (98%) with MCP — but the interesting finding was divergence in *what* each agent found. Copilot found Brand Language Style Guide V1 via SharePoint search (Claude.ai found it too, via M365 MCP, but only because MCP happened to search the right site). Copilot surfaced governance detail from SharePoint documents that no MCP query would have targeted.
- **Agent behavior:** Copilot's enterprise search operates on document proximity and keyword matching across the M365 ecosystem. Claude Code's MCP operates on structured API queries. These are orthogonal discovery methods — they find different things because they search differently.
- **Benchmark data:** On vendor landscape queries, Copilot's SharePoint-grounded response included document dates and engagement scopes. Claude Code's MCP query returned structured deal data. Neither alone captured the full picture.
- **Session examples:** During Phase B substrate audit, the system inventory (F1-1) was built from documented knowledge + Claude Code MCP probes. Post-hoc, Copilot discovery of SharePoint marketing site revealed content categories (event materials, clinic materials) not visible to MCP queries. These are Phase 2F findings that only enterprise search could surface.

## 3. Universality Assessment

| Factor | Assessment |
|--------|-----------|
| **Organization-specific?** | No — any Mosaic instance with both MCP and enterprise search agents benefits |
| **Domain-specific?** | No — applies to all domain bootstraps, not just Marketing |
| **Agent-specific?** | Multi-agent by definition — applies when instance has 2+ agents with different access |
| **Architecture-dependent?** | Partially — requires at least one enterprise search agent alongside the MCP agent |

**Universality conclusion:** Any Mosaic instance with multiple agents (the standard model) can discover more by running Foundation track discovery across all agents in parallel, not just the MCP-enabled one.

## 4. Proposed Change

**Target file(s):** `DOMAIN-BOOTSTRAP.md` — Phase 2F (Data Mapping), Phase 3 (Ontology Construction)

**Change description:**

1. **Phase 2F addition: Multi-Agent Discovery (F2-6).** After F2-1 through F2-5, add a prompt that maps which agents can reach which data sources and generates agent-specific discovery prompts. This makes the multi-agent model explicit at discovery time, not just at enrichment time (Phase 6.7).

2. **Phase 2F guidance note:** Add a note at the start of Phase 2F that Foundation track discovery can (and should) run across all available agents in parallel. The MCP agent runs F2-1 through F2-5 programmatically. Enterprise search agents run equivalent prompts targeting document-grounded content. Results converge at Phase 3.

3. **Phase 3 addition: Multi-Agent Discovery Merge.** Add a synthesis step at the start of Phase 3 that reads discovery results from all agents, flags contradictions, and produces a unified entity/data inventory before ontology construction begins.

**Draft content:**

```markdown
### F2-6: Multi-Agent Discovery Design

If the instance has multiple agents with different access patterns (e.g., MCP + enterprise
search), design parallel discovery prompts for each agent:

| Agent Type | Discovery Method | Best For |
|---|---|---|
| MCP agent (Claude Code) | Structured API queries | Entity counts, field values, relationship data, live system state |
| Enterprise search (Copilot) | Document proximity search | Governance docs, SOPs, historical materials, folder structure, file dates |
| Web research (Claude.ai) | Open web search | Competitive context, industry standards, external benchmarks |

For each non-MCP agent, adapt F2-1 through F2-5 into document-search equivalents:
- F2-1 (Entity Inventory) -> "Search [site] for all documents related to [domain]. List titles, dates, locations."
- F2-2 (Cross-System Identity) -> "Find references to [entity] across SharePoint, email, Teams. How is it described in each?"
- F2-3 (Data Flow) -> "Search for workflow documents, handoff procedures, or process diagrams related to [domain]."
- F2-4 (Data Quality) -> "What are the most recent documents for [domain]? What appears stale or outdated?"
- F2-5 (Universe Mapping) -> "Search broadly for [domain]-related content. What exists beyond the primary site?"

**Results capture:** Each agent's discovery results go to a structured capture file. Include:
- Raw response (preserve detail)
- Source prompt
- Timestamp
- Agent identifier

**Convergence at Phase 3:** The Phase 3 ontology construction step reads all agent discovery
results and:
1. Identifies entities discovered by multiple agents (cross-validation)
2. Flags contradictions (different dates, statuses, or descriptions)
3. Notes content discovered by only one agent (gap signals)
4. Produces a unified entity inventory for ontology design
```

## 5. Impact Assessment

| Dimension | Assessment |
|-----------|-----------|
| **Existing instances** | Additive — existing instances can adopt by adding discovery prompts for their non-MCP agents. No existing files require changes. |
| **New instances** | New bootstraps get richer discovery from the start. Especially valuable for domains with significant SharePoint/M365 content (Marketing, Administration, HR). |
| **Breaking changes?** | None. F2-6 is additive. Existing F2-1 through F2-5 unchanged. |
| **Reasoning quality** | Expected improvement in Phase 3 ontology quality — more complete entity inventory, fewer blind spots, earlier detection of contradictions between systems. |

## 6. Testing

- **Test queries:** Compare Phase 3 ontology quality for a domain bootstrapped with single-agent discovery (F2-1 through F2-5 only) vs. multi-agent discovery (F2-1 through F2-6). Measure: entity count, contradiction count, gap count.
- **Success criteria:** Multi-agent discovery produces at least 3 additional entities or data points not found by MCP-only discovery. At least 1 contradiction or currency issue surfaced only by enterprise search.
- **Regression risk:** Minimal. The main risk is information overload — too many discovery results making Phase 3 synthesis harder. Mitigated by structured capture format and agent provenance markers.

---

## Review Notes

*For maintainer use:*

| Field | Value |
|-------|-------|
| **Reviewed by** | Kurt Brenkus / Claude Code |
| **Review date** | 2026-02-25 |
| **Decision** | Accepted |
| **Rationale** | Phase B evidence confirmed enterprise search surfaces content MCP misses. Multi-agent discovery is standard practice, not optional. |
| **Implemented in** | DOMAIN-BOOTSTRAP v0.7 (Phase 2F note, F2-6, Phase 3.0, completion criteria) |
