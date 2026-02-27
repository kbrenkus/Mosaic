# Mosaic Proposal: Cognitive Foreground Principle

**Submitted by:** mosaic-ip (Indigenous Pact)
**Date:** 2026-02-27
**Category:** Design Principle

---

## 1. Observation

During Kernel Slim Round 2, Claude.ai reported that lookup data (ID mapping tables, system inventories, stage mappings) doesn't just sit inert in the kernel — it actively competes with dispositional content for "cognitive foreground." This refines the Round 1 finding (A-019/A-020: navigated content wastes tokens) with a mechanism: navigated content creates attentional interference with content that shapes reasoning.

The agent's key framing: "There's a difference between having knowledge and being shaped by knowledge. The more we clear lookup data from the kernel, the more the dispositional content can do its actual job of shaping reasoning rather than competing for attention with tables."

This suggests a three-way classification that refines the two-way dispositional/procedural cut from Round 1:
1. **Dispositional** — shapes all reasoning, must be ambient (reasoning frameworks, behavioral directives, signal triggers)
2. **Orientation** — context the agent reasons *from*, benefits from ambient but survives retrieval (domain router, structural overview)
3. **Lookup/procedural** — data the agent reasons *about* or consumes at a specific moment, should be retrieved (ID tables, stage mappings, worked examples)

## 2. Evidence

- **Before:** IP-INDEX contained 3 lookup tables (pipeline stages, connected systems inventory, SharePoint site map). IP-A2A-QUICK §5.7 contained 5 cross-system synthesis recipes.
- **After:** Lookup tables replaced with compact pointers to retrieval destinations. ~32 lines removed, ~13 lines added. Net savings ~1.7 KB.
- **Pre-test (old kernel):** 17/18 across 3 queries (Q1 cross-system synthesis 5/6, Q2 service line classification 6/6, Q3 system routing 6/6).
- **Post-test (new kernel):** 17/18 (identical total, zero regression). Same dimension scores.
- **Behavioral shift:** +46% tool calls (10.3 avg → 15 avg per query), +50% unique analytical observations. Agent channeled freed cognitive budget into deeper investigation — more retrieval hops, more systems queried, more cross-system connections identified.
- **Key finding:** The token savings were modest (~1.7 KB), but the behavioral improvement was substantial. The improvement is disproportionate to the byte savings, suggesting the mechanism is attentional competition, not just token budget.
- **Depth-over-speed tradeoff:** Post-test responses took longer (more retrieval hops for data that was previously ambient). The agent used the freed attention for deeper investigation rather than faster responses.
- **Recipe ingredients observation:** Pipeline stage IDs (moved from IP-INDEX) required an extra retrieval hop on Q2 (service line classification). This data is consumed on most pipeline queries — it sits at the boundary between "lookup data" and "recipe ingredient."

## 3. Universality Assessment

| Factor | Assessment |
|--------|-----------|
| **Organization-specific?** | No — any instance with kernel files containing lookup tables can benefit |
| **Domain-specific?** | No — applies to all kernel content across all domains |
| **Agent-specific?** | No — applies to any LLM-based agent with ambient context constraints |
| **Architecture-dependent?** | No — requires only the kernel/retrieval split already in MOSAIC-REASONING §6 |

**Universality conclusion:** Any Mosaic instance can apply the three-way classification and cognitive foreground principle during kernel density reviews. The mechanism (attentional competition) is a property of LLM ambient context processing, not a property of any specific deployment.

## 4. Proposed Change

### 4A. MOSAIC-PRINCIPLES — New principle A-021

**Target:** MOSAIC-PRINCIPLES.md §3.1 (Knowledge System Dynamics), after A-020

A-021 "Cognitive Foreground" documenting: the attentional competition mechanism, three-way classification (dispositional/orientation/lookup-procedural), depth-over-speed tradeoff, and recipe ingredients guard rail (>50% query frequency threshold).

### 4B. MOSAIC-REASONING §6.1 — Cognitive foreground extension

**Target:** MOSAIC-REASONING.md §6.1, after the pruning heuristic paragraph

Extend with: three-way classification, depth-over-speed tradeoff, recipe ingredients watch. Cross-reference A-021.

### 4C. DOMAIN-BOOTSTRAP Phase 8 — Three-way classification + recipe ingredients

**Target:** DOMAIN-BOOTSTRAP.md Phase 8, section-level kernel audit steps

Update step 2 classification to three-way (add orientation layer). Add new step for recipe ingredients check (>50% frequency threshold).

### 4D. MOSAIC-OPERATIONS §6.6 — Methodology update

**Target:** MOSAIC-OPERATIONS.md §6.6

Update methodology description to reference three-way classification and recipe ingredients guard rail.

## 5. Impact Assessment

| Dimension | Assessment |
|-----------|-----------|
| **Existing instances** | Can apply immediately — use three-way classification during next kernel density review. No breaking changes. |
| **New instances** | Domain bootstraps include the refined classification from the start. Better kernel content decisions during Phase 4. |
| **Breaking changes?** | None. Refines existing two-way classification — adds a middle layer (orientation) and a guard rail (recipe ingredients). |
| **Reasoning quality** | Neutral to positive — instances that apply the three-way classification during kernel reviews should see improved reasoning depth without score regression. |

## 6. Testing

- **Test queries:** Instance-specific (each kernel has different lookup content). The methodology produces its own test plan — pre/post queries targeting the moved content.
- **Success criteria:** Post-test scores >= pre-test on all dimensions. Investigation depth increases (measured by tool calls, unique analytical observations). No regression on any dimension.
- **Regression risk:** Moving recipe-ingredient data may add unacceptable retrieval latency for high-frequency queries. Mitigation: the >50% frequency threshold identifies content that should stay despite being lookup by type.

---

## Review Notes

*For maintainer use:*

| Field | Value |
|-------|-------|
| **Reviewed by** | mosaic-ip maintainer |
| **Review date** | 2026-02-27 |
| **Decision** | Accepted |
| **Rationale** | Validated by pre/post testing: 17/18 → 17/18, zero regression, +46% tool calls, +50% analytical observations. Extends proven A-019/A-020 methodology with mechanism (attentional competition) and refined classification (three-way). Recipe ingredients guard rail prevents over-pruning. |
| **Implemented in** | MOSAIC-PRINCIPLES v1.4, MOSAIC-REASONING v1.9, DOMAIN-BOOTSTRAP v0.9, MOSAIC-OPERATIONS v1.4 |
