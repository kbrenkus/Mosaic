# Mosaic Proposal: Kernel Pruning Methodology

**Submitted by:** mosaic-ip (Indigenous Pact)
**Date:** 2026-02-27
**Category:** Structural Pattern

---

## 1. Observation

During a phenomenological self-assessment, Claude.ai reported that the densest kernel file (IP-A2A-QUICK, 19 KB) felt "navigated rather than absorbed" — procedural content consumed ambient context budget without shaping reasoning. The agent identified a clean architectural seam: signal detection is dispositional (must be ambient), while formatting schemas and worked examples are procedural (consumed at specific workflow moments). Applying this heuristic section-by-section reduced the file 39% with zero behavioral regression.

This reveals two generalizable patterns: (1) agent phenomenological feedback is actionable design data for kernel architecture, and (2) the dispositional/procedural axis is the most granular pruning heuristic for kernel content within files that have already passed the kernel eligibility gate.

## 2. Evidence

- **Before:** IP-A2A-QUICK = 362 lines, 19 KB. Agent described it as "navigated rather than absorbed."
- **After:** 221 lines, 13 KB (39% reduction). Delta schema, worked examples, routing table, and process patterns moved to retrieval. Type table, signal detection, capability matrix, system recipes retained.
- **Kernel budget:** 96 KB → 89 KB. Headroom 104 KB → 111 KB.
- **Pre-test (old kernel):** 7/10. Routing (2), recipe (2), source trust (2) perfect. Delta emission (0) and detection flow (1) lost points — zero deltas emitted across 5 queries despite accumulating delta-worthy observations.
- **Post-test (new kernel):** 8/10 (+1). Same perfect scores on routing, recipe, source trust. Detection flow improved to 2 (full §4.10 flow WITH [GAP] emission). Agent emitted 2 inline YAML deltas (Q3: lifecycle mismatch, Q4: new client gap) and showed explicit delta reasoning in Q1 — vs zero delta awareness in pre-test.
- **Key finding:** Less procedural content in kernel = better behavioral adherence. The old kernel had ~65 lines of delta formatting content (schema, examples, posting instructions). The new kernel has ~15 lines of dispositional content (type table, confidence gating) + retrieval pointer. Delta output improved despite less formatting guidance being ambient. Procedural content was "navigated" (consumed budget without shaping behavior); dispositional content drives the actual reasoning.
- **Agent phenomenological report:** "The reasoning files feel like they've become part of how I think. A2A-QUICK feels more like a reference I consult." This subjective distinction mapped precisely to the dispositional/procedural classification.

## 3. Universality Assessment

| Factor | Assessment |
|--------|-----------|
| **Organization-specific?** | No — any instance with kernel files can benefit from section-level pruning |
| **Domain-specific?** | No — applies to all kernel content (A2A, behaviors, taxonomy, index) |
| **Agent-specific?** | No — applies to any LLM-based agent with ambient context constraints |
| **Architecture-dependent?** | No — requires only the kernel/retrieval split already in MOSAIC-REASONING §6 |

**Universality conclusion:** Any Mosaic instance with kernel budget pressure can apply the dispositional/procedural heuristic to identify content that passed the eligibility gate but doesn't need to be ambient at the section level.

## 4. Proposed Change

### 4A. MOSAIC-PRINCIPLES (2 new principles)

**Target:** MOSAIC-PRINCIPLES.md §3.1 (Knowledge System Dynamics) + §3.2 (Build Methodology)

**A-0XX "Phenomenological Feedback":**
Agent self-report about kernel experience is design data, not anecdote. Distinct from Loop 4 (which captures reasoning errors). The agent's subjective experience of content as "absorbed" vs. "navigated" maps to the dispositional/procedural axis and predicts which content benefits from ambient presence vs. retrieval. Activates during: Phase 8 retroactive audits, kernel headroom reviews, post-build validation. Evidence: IP instance — A2A-QUICK "navigated not absorbed" report led to 39% kernel reduction with zero regression.

**A-0XX "Navigation vs. Absorption Test":**
When an agent reports content feels navigated (consulted at point of use) rather than absorbed (internalized, shaping all reasoning), the content is a retrieval candidate. Inverse of the ambient context principle (§6.2). Test: would the agent's reasoning quality change if this content were absent at the start of the conversation? If no, it can be retrieved. If yes, it must be ambient. Evidence: same as above.

### 4B. MOSAIC-REASONING §6.1 (subsection addition)

**Target:** MOSAIC-REASONING.md §6.1, after the kernel epistemology table.

**Draft content:**
```
**Pruning heuristic.** Within kernel files, classify sections along the dispositional
axis: detection triggers, type semantics, and capability awareness are dispositional
(ambient). Formatting schemas, worked examples, posting instructions, and
troubleshooting guides are procedural (retrieve at moment of use). Replace procedural
sections with compact retrieval pointers — typically 2-3 lines naming the retrieval
target and trigger condition. The two-part kernel eligibility gate (§4.10 in
DOMAIN-BOOTSTRAP) determines whether a FILE earns kernel space. This heuristic
determines whether SECTIONS within an eligible file need to be ambient.
```

### 4C. DOMAIN-BOOTSTRAP Phase 8 (audit methodology addition)

**Target:** DOMAIN-BOOTSTRAP.md Phase 8 (Retroactive Audit)

Add section-level kernel audit methodology:
1. For each kernel file: enumerate sections, classify each as dispositional/procedural/redundant
2. Redundant = dissolve (content exists canonically elsewhere per §6.3)
3. Procedural = move to retrieval with pointer (identify retrieval home by consumption moment)
4. Dispositional = keep, but check for compression opportunities
5. Optional: solicit agent phenomenological feedback on kernel files ("Which files feel navigated vs. absorbed?")
6. Run pre/post behavioral test to validate no regression

### 4D. MOSAIC-OPERATIONS §6 (maintenance cycle extension)

**Target:** MOSAIC-OPERATIONS.md §6 (Maintenance Cycle Architecture)

Add kernel density review to quarterly audit cycle:
- Trigger: kernel headroom < 30%, or agent reports navigation-heavy experience, or 3+ domain bootstraps since last review
- Methodology: section-level audit per Phase 8 methodology above
- Output: pruning brief documenting dispositional/procedural classification and retrieval destinations

## 5. Impact Assessment

| Dimension | Assessment |
|-----------|-----------|
| **Existing instances** | Can apply immediately — audit their kernel files using the heuristic. No breaking changes. |
| **New instances** | Domain bootstraps include kernel audit as part of Phase 8. Better kernel hygiene from the start. |
| **Breaking changes?** | None. Purely additive methodology. |
| **Reasoning quality** | Neutral to positive — agent reports "breathing room" after procedural content moves to retrieval. More kernel headroom for future domain additions. |

## 6. Testing

- **Test queries:** Instance-specific (each kernel has different content). The methodology produces its own test plan — pre/post queries targeting the moved content.
- **Success criteria:** Post-test scores >= pre-test scores on all dimensions. Agent subjective experience of kernel density improves (less "navigation," more "absorption").
- **Regression risk:** If retrieval pointers are insufficient, agents may forget to retrieve procedural content at the right moment. Mitigation: keep a compact kernel pointer (2-3 lines) that triggers retrieval at the workflow moment.

---

## Review Notes

*For maintainer use:*

| Field | Value |
|-------|-------|
| **Reviewed by** | mosaic-ip maintainer |
| **Review date** | 2026-02-27 |
| **Decision** | Accepted |
| **Rationale** | Validated by pre/post testing: 7/10 → 8/10, zero regression. Delta emission improved despite less formatting content in kernel. Methodology is organization-agnostic and architecture-independent. |
| **Implemented in** | MOSAIC-PRINCIPLES v1.3, MOSAIC-REASONING v1.8, DOMAIN-BOOTSTRAP v0.8, MOSAIC-OPERATIONS v1.3 |
