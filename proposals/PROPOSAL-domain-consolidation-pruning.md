# Mosaic Proposal: Domain Consolidation & Source Pruning in Bootstrap

**Submitted by:** Indigenous Pact (IP)
**Date:** 2026-02-25
**Category:** Protocol Enhancement

---

## 1. Observation

When bootstrapping a new domain (DOMAIN-BOOTSTRAP Phase 5), scattered domain knowledge that was previously embedded in other reference files gets consolidated into the new domain file. The protocol's Phase 1F scatter map identifies this scattered content, and Phase 4.7 Extraction Operations plans reasoning/data splits. But **Phase 5 has no step requiring the source files to be pruned** after content is consolidated into the new domain file.

This creates an interception conflict (MOSAIC-REASONING §6.3): the same marketing content now exists in both IP-ADMIN-OPERATIONS §2 and the new IP-MARKETING file. Agents find the closer (shallower) copy first and stop, missing the richer domain-specific version. The source files also carry unnecessary weight for their primary (non-domain) audiences.

## 2. Evidence

- **Scatter audit (Phase 1F):** Marketing content found across 4 non-marketing files: IP-ADMIN-OPERATIONS §2 (~239 lines), IP-SYSTEMS-QUICK §8.1-8.3 (~69 lines), IP-ADMIN-QUICK §7A (~49 lines), IP-POLICIES-QUICK §5.9 (~11 lines). Total: ~368 lines of marketing content in files primarily serving other domains.

- **Agent behavior:** When an agent retrieves IP-ADMIN-QUICK (for an admin question) and finds §7A with marketing vendor data, it may answer a marketing follow-up from the shallow §7A table rather than retrieving the richer IP-MARKETING file. The interception principle means the first-found copy terminates search.

- **Baseline evidence (Phase B):** Pre-build baseline showed Claude.ai scoring 110/112 (98%) on marketing queries when MCP was active. The concern is not whether agents CAN find marketing content, but whether they find the RIGHT (most complete) version when multiple copies exist.

- **File size impact:** Pruning ~368 lines across 4 files, replaced by ~22 lines of cross-reference stubs. Net reduction of ~346 lines from non-marketing files, improving their focus and reducing token load for non-marketing queries.

- **Bidirectional routing need:** Cross-domain index files (systems inventory, policy index) serve a dual audience. Someone asking "what's our full tech stack?" needs to see marketing tools alongside all other systems — but not the 69 lines of marketing-specific governance, brand YAML, and campaign docs. The stub pattern must preserve slim inventory rows for index scanning while routing to the domain file for depth. Conversely, someone in the marketing domain file asking about system architecture needs a route back to the systems index. This bidirectional pattern emerged from real use-case analysis during Phase B bootstrap.

## 3. Universality Assessment

| Factor | Assessment |
|--------|-----------|
| **Organization-specific?** | No. Any instance with pre-existing reference files will have domain knowledge scattered across files. |
| **Domain-specific?** | No. Applies to any new domain bootstrapped where content existed in other files first. |
| **Agent-specific?** | No. Both Claude and Copilot are subject to interception conflicts. |
| **Architecture-dependent?** | No. Applies to any retrieval architecture with multiple files. |

**Universality conclusion:** Every domain bootstrap that consolidates scattered content must prune source files to prevent interception conflicts and maintain system clarity. This is a structural requirement of the retrieval architecture, not an instance-specific need.

## 4. Proposed Change

**Target file(s):** DOMAIN-BOOTSTRAP.md Phase 5

**Change description:** Add a new subsection **5.6 Domain Consolidation & Source Pruning** to Phase 5: Artifact Construction. This step occurs after the domain files are built (5.1-5.5) and before router/manifest updates.

**Draft content:**

```markdown
**5.6 Domain Consolidation & Source Pruning**

When a new domain consolidates content that was previously scattered across other files
(identified in Phase 1F scatter map), the source files must be pruned to prevent
interception conflicts and improve system clarity.

*Why this matters:* The interception principle (MOSAIC-REASONING §6.3) means agents find
the closer copy and stop. If marketing content exists in both IP-ADMIN-OPERATIONS §2 and
IP-MARKETING, agents may find the shallow admin version first and miss the enriched domain
version. Pruning eliminates the conflict.

**Procedure:**

1. **Pre-prune safety scan:** Grep for all cross-references to sections being pruned.
   Document every file that points to the pruned content.

2. **Classify each source section** using the stub depth table:

   | Source File Type | Stub Pattern | Rationale |
   |---|---|---|
   | Operations / deep reference | Pure cross-reference (section pointers only) | Domain file replaces this entirely |
   | Cross-domain index (systems, policies, people) | Slim inventory row (names/costs/status) + pointer to domain file | Preserves "at a glance" scanning for the index file's primary audience |
   | Routing / admin QUICK | Pure cross-reference | Domain QUICK file replaces this routing function |

   The key question: "Does someone scanning THIS file (not the domain) need to see
   anything, or just know where to go?" Index files need skeleton rows; non-index files
   need pure stubs.

3. **Apply bidirectional routing:** When a domain file and a cross-domain index both
   reference the same content (e.g., system inventory), both files should point to each
   other. The index routes to the domain file for depth ("see IP-MARKETING §5 for full
   marketing systems detail"). The domain file routes back to the index for breadth
   ("for system-level architecture and non-marketing systems, see IP-SYSTEMS"). This
   prevents navigation dead-ends regardless of which file the agent finds first.

4. **Guard rails:**
   - Never leave a navigation hole — always replace pruned content with a stub
   - Preserve index scanning — cross-domain index files keep slim entries for "at a
     glance" queries, not just pointers
   - Route, don't summarize — stubs point to domain file sections, don't re-summarize
   - Bidirectional references — domain files route back to cross-domain indexes
   - Version every pruned file (bump version, manifest, changelog)
   - Grep after pruning — verify no broken cross-references remain

5. **Update cross-references:** Any file that previously pointed to the pruned section
   must be updated to point to the new domain file equivalent.

**Completion criteria:**
- [ ] All Phase 1F scatter map sources have been pruned or deliberately retained with rationale
- [ ] Stub depth matches source file type (index files have slim rows, non-index files have pure stubs)
- [ ] Bidirectional routing established between domain files and cross-domain indexes
- [ ] Cross-reference stubs work (no navigation holes)
- [ ] No broken cross-references across the system
- [ ] Each pruned file has a version bump, manifest update, and changelog entry
- [ ] Source files are measurably smaller (token count reduced)
```

## 5. Impact Assessment

| Dimension | Assessment |
|-----------|-----------|
| **Existing instances** | Minimal. Instances that already bootstrapped domains may have unconsolidated scatter — this provides methodology to clean up retroactively. |
| **New instances** | Direct benefit. All future domain bootstraps include consolidation pruning as a standard step. |
| **Breaking changes?** | No. This adds a step; it doesn't change existing steps. Instances that skip it just have the current behavior (scatter remains). |
| **Reasoning quality** | Improved routing accuracy. Agents find the richest version of domain content on the first retrieval. Source files become clearer for their primary audiences. |

## 6. Testing

- **Test queries:** After pruning, run domain queries that previously triggered scatter (e.g., "what are our marketing vendors?" should route to IP-MARKETING, not IP-ADMIN-QUICK §7A). Run non-domain queries against pruned files to verify stubs route correctly.
- **Success criteria:** Domain queries retrieve from the domain file (not scattered source). Non-domain queries still navigate through the source file's stub to the domain file. No broken cross-references. Source files measurably smaller.
- **Regression risk:** Broken cross-references if pre-prune grep is incomplete. Mitigated by post-prune grep verification.

---

## Review Notes

*For maintainer use:*

| Field | Value |
|-------|-------|
| **Reviewed by** | |
| **Review date** | |
| **Decision** | {Accepted / Modified / Deferred / Rejected} |
| **Rationale** | |
| **Implemented in** | {Version, if accepted} |
