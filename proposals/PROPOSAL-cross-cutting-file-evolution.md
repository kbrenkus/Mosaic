# Mosaic Proposal: Cross-Cutting File Evolution During Domain Bootstrap

**Submitted by:** Indigenous Pact (IP)
**Date:** 2026-02-25
**Category:** Architecture Pattern

---

## 1. Observation

When Mosaic instances grow from a few broad reference files to domain-specific files (via DOMAIN-BOOTSTRAP), cross-cutting files — Operations, Systems, Policies, People/Teams — undergo a predictable evolution. Content placed in these broad files (because no domain existed yet) now has a natural home in a domain file. But not all content should migrate. Some content in cross-cutting files serves a **cross-domain governance function** that no single domain owns.

Without a classification principle, bootstrappers face two failure modes:

1. **Over-extraction:** Pulling governance content into the domain file, orphaning it from the cross-cutting file where it served all domains. The governance either gets silently duplicated or lost.
2. **Under-extraction:** Leaving domain-specific content in the cross-cutting file "because it touches governance," creating interception conflicts where agents find the shallow cross-cutting version instead of the richer domain version.

The complementary proposal (PROPOSAL-domain-consolidation-pruning) addresses the **mechanics** of pruning source files after extraction. This proposal addresses the **classification principle** that determines what to extract vs. what to retain — the decision that must precede pruning.

## 2. Evidence

- **Phase B scatter audit:** IP-ADMIN-OPERATIONS §2 (~239 lines, 10 subsections) was classified before Marketing domain extraction. The boundary test ("Would this content differ for a different domain?") revealed:
  - **All 10 subsections are domain-specific** — brand documents, marketing vendors, campaign planning, social media, marketing metrics. These migrate to IP-MARKETING.
  - **Cross-domain governance elements within §2** (legal review triggers, DOA references, vendor procurement process, invoice routing) are *references to* governance that originates in other sections/files. They don't live in §2 uniquely. IP-MARKETING references these frameworks at their source locations rather than routing through §2.
  - **Result:** §2 is a clean extraction — no governance residue remains. The stub is a pure cross-reference.

- **IP-SYSTEMS-QUICK §8.1 classification:** Marketing tools were documented in the cross-domain systems index because no marketing domain existed. The boundary test revealed a split: the **index function** (tool names, costs, status for "what's our full tech stack?" queries) is cross-domain and stays. The **detail function** (team roster, brand YAML, campaign docs, HubSpot governance) is domain-specific and migrates. This led to the "slim inventory row + pointer" stub pattern.

- **IP-POLICIES-QUICK §5.9 classification:** Marketing policies listed in the cross-domain policy index. Same split: policy names and status stay (index function), detailed governance moves to IP-MARKETING (domain-specific depth).

- **Predicted evolution pattern:** If a Finance domain is bootstrapped later, IP-ADMIN-OPERATIONS would face the same classification challenge. Financial operations (AP/AR processes, specific budget allocations, finance vendor relationships) would migrate. Organizational authority (DOA thresholds, general approval escalation, procurement frameworks) would stay. The boundary test provides the classification principle; without it, the bootstrapper must re-derive the principle each time.

- **Kernel eligibility audit (Phase B):** During Marketing domain bootstrap, a full audit of all 6 kernel files (92 KB / ~200 KB limit) was conducted against the epistemic type test. Result: all 6 files are correctly placed — predominantly dispositional/hermeneutical content that shapes ambient reasoning. Marketing domain confirmed as retrieval-only (ontological/navigational). The only candidate for future extraction was system query recipes (~4.5 KB, navigational) but these embed error-prevention gotchas with hermeneutical value. This audit established kernel eligibility as a standard gate for all future bootstraps — the default is "retrieval, not kernel."

## 3. Universality Assessment

| Factor | Assessment |
|--------|-----------|
| **Organization-specific?** | No. Any instance with broad reference files that pre-date domain bootstraps faces this evolution. |
| **Domain-specific?** | No. Every domain bootstrap that extracts from cross-cutting files needs content classification. |
| **Agent-specific?** | No. Affects retrieval architecture, not agent capabilities. |
| **Architecture-dependent?** | Partially. Applies to instances with cross-cutting reference files. New instances that start domain-first may not need this pattern initially. |

**Universality conclusion:** Any Mosaic instance that grew organically (broad files first, domains later) will face cross-cutting file evolution. This pattern provides the classification principle that complements the consolidation/pruning proposal's mechanics.

## 4. Proposed Change

**Target file(s):** DOMAIN-BOOTSTRAP.md — Phase 1F (Substrate Audit) and Phase 4 (Architecture)

**Change description:** Add content classification to Phase 1F scatter audit, and an architecture principle for cross-cutting file evolution to Phase 4.

**Draft content:**

### Addition to Phase 1F: Scatter Content Classification

```markdown
**1F.4 Scatter Content Classification**

For each scattered section identified in 1F.1-1F.3, classify using the boundary test:

| Category | Test: "Would this differ for a different domain?" | Bootstrap Treatment |
|---|---|---|
| Domain-specific | Yes | Migrates to domain file. Source gets stub (per Phase 5.6). |
| Cross-domain governance | No | Stays in source file. Domain file references it at source. |
| Mixed | Elements of both | Split: domain-specific procedure migrates, governance framework stays. Domain file references the framework directly. |

The boundary test prevents both over-extraction (orphaning governance) and
under-extraction (leaving domain content in cross-cutting files).

Example classifications:
- Marketing vendor list in Operations §2 → domain-specific (migrates)
- Marketing approval workflow steps → domain-specific (migrates)
- Legal review trigger "required for claims/disclaimers" → cross-domain governance
  (reference to legal function; domain file references legal directly, not through
  the operations section)
- General approval escalation "director → COO → CEO" → cross-domain governance
  (stays in Operations)
- Marketing tools in Systems index → mixed (slim inventory row stays for index
  scanning, tool detail migrates to domain file)
```

### Addition to Phase 4: Cross-Cutting File Evolution Pattern

```markdown
**4.X Cross-Cutting File Evolution**

Cross-cutting files (Operations, Systems, Policies, People/Teams) undergo a
predictable evolution as domains are bootstrapped:

**Before domains:** Cross-cutting files hold both governance frameworks and
domain-specific detail together — because no domain files exist yet.

**During bootstrap:** Phase 1F scatter audit classifies content using the boundary
test. Domain-specific content migrates to the new domain file. Cross-domain
governance stays. The source file gets thinner but more focused.

**After multiple bootstraps:** Cross-cutting files evolve into governance hubs —
holding only what no single domain owns:

- Operations → organizational authority, escalation frameworks, cross-domain routing
- Systems → system-level architecture, integration patterns, cross-domain inventory
- Policies → governance frameworks, compliance obligations, cross-domain policy index
- People/Teams → organizational structure, reporting lines, cross-domain role routing

This is a healthy thinning, not a hollowing out. Each file gets more focused on
its unique value — the governance and index functions that span all domains.

**Guard rails:**
- **No governance orphaning:** When extracting, verify that cross-domain governance
  elements are either (a) retained in the source file or (b) already documented
  elsewhere and only referenced from the scattered section. If (b), the domain file
  should reference the original source directly.
- **Bidirectional routing:** Cross-cutting files route to domains for depth. Domain
  files route back to cross-cutting files for governance and breadth.
- **Index preservation:** Cross-cutting files that serve as indexes (systems,
  policies, people) retain slim inventory entries for cross-domain scanning. Pure
  operations files need only cross-reference stubs.
- **Evolution awareness:** Each bootstrap should note the cumulative impact on
  cross-cutting files. If a cross-cutting file has had 3+ domains extracted from it,
  consider whether the remaining content should be restructured as a governance hub.
- **Kernel eligibility gate:** Every new domain must pass the kernel eligibility
  test before construction. Domain knowledge is almost always ontological (entity
  definitions) or navigational (routing to content) — both retrievable. The default
  answer is "retrieval, not kernel." Kernel space is earned only by demonstrating
  dispositional value (shapes how the agent reasons about everything) or hermeneutical
  value (changes how the agent interprets inputs). The router entry is typically the
  only kernel touch point for a new domain. This gate prevents kernel bloat as domains
  accumulate and preserves headroom for content that genuinely improves ambient
  reasoning quality.
```

### Addition to Phase 4: Kernel Eligibility Gate

```markdown
**4.Y Kernel Eligibility Gate**

Before constructing domain files, answer: "Does this domain need kernel space?"

**Default answer: No.** Domain knowledge is almost always ontological (defines
entities) or navigational (routes to content). Both are retrievable. The router
entry in the domain routing manifest is typically the only kernel touch point.

**The test (MOSAIC-REASONING §6.1):**

| Epistemic Type | Kernel? | Example |
|---|---|---|
| Dispositional (shapes HOW the agent reasons about everything) | Yes | Sovereignty rules, analytical voice, signal detection |
| Hermeneutical (changes how the agent interprets inputs) | Yes | Entity type definitions, naming aliases, source trust hierarchy |
| Ontological (defines what entities exist) | No — retrieve | Client lists, vendor tables, campaign inventories |
| Navigational (helps find information) | No — retrieve | System recipes, folder paths, document indexes |

**Two-part placement test for ambiguous cases:**
1. Does this content shape reasoning quality even when not directly referenced?
2. Would retrieval delay degrade agent performance in a way that changes outcomes?

Both must be "yes" for kernel placement. Content that fails either test goes to
retrieval.

**Periodic kernel health audit:** When bootstrapping a new domain, audit the
existing kernel against the same test. Content that was kernel-eligible when added
may have been superseded by domain files or reasoning improvements. Kernel budget
is finite — every KB matters for ambient reasoning quality.

**Re-audit trigger:** Kernel headroom drops below 30% of platform limit, or 3+
domains have been bootstrapped since the last audit.
```

## 5. Impact Assessment

| Dimension | Assessment |
|-----------|-----------|
| **Existing instances** | Moderate benefit. Provides vocabulary and methodology for the evolution pattern already happening organically. Enables retroactive classification and cleanup. |
| **New instances** | Preventive. Instances that start with broad files will have a principled way to decompose them as domains are added. |
| **Breaking changes?** | No. Adds a classification step and architecture pattern. Instances that skip it continue with current behavior. |
| **Reasoning quality** | Improved. Agents find governance in governance files and domain content in domain files. Cross-domain queries resolve from cross-cutting files. Domain queries resolve from domain files. No interception conflicts from misplaced content. |

## 6. Testing

- **Test queries (cross-domain governance):** After extraction, run queries that target governance: "Who can approve a $50K purchase?" or "What's the general escalation path?" These should resolve from the cross-cutting file, not the domain file.
- **Test queries (domain-specific):** "What are our marketing vendors?" should resolve from the domain file, not the cross-cutting file's stub.
- **Test queries (index scanning):** "What's our full tech stack?" should still show marketing tools in the systems index (slim row), then route to the domain file for depth.
- **Success criteria:** Cross-domain governance queries → cross-cutting file. Domain queries → domain file. Index queries → cross-cutting file slim rows + routing to domain. No orphaned governance. No duplicated content.
- **Regression risk:** Over-extraction if boundary test is applied too aggressively (everything classified as "domain-specific"). Mitigated by the governance retention guard rail and the explicit classification step.

---

## Review Notes

*For maintainer use:*

| Field | Value |
|-------|-------|
| **Reviewed by** | Kurt Brenkus / Claude Code |
| **Review date** | 2026-02-25 |
| **Decision** | Accepted |
| **Rationale** | Boundary test and kernel eligibility gate are essential architecture decisions. Phase B Marketing domain validated the classification principle against 4 cross-cutting files. |
| **Implemented in** | DOMAIN-BOOTSTRAP v0.7 (F1-3, Phase 4.9, Phase 4.10, completion criteria). Kernel eligibility gate also mirrored to instance CLAUDE.md. |
