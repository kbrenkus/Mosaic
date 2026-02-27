# Mosaic Proposal: Organizational Boundary Reasoning

**Submitted by:** Indigenous Pact (IP)
**Date:** 2026-02-26
**Category:** Reasoning Framework

---

## 1. Observation

Agents encounter organizational structures with layered authority domains, overlapping jurisdictions, and governance entities that don't map to simple hierarchies. Current reasoning frameworks (MOSAIC-REASONING §2) handle individual authority discrimination (positional, domain, relational) and entity type classification, but lack a general framework for reasoning about **boundaries between authority domains** within complex organizations.

Three gaps surface when agents face complex institutional clients:

1. **Instrumentalities** -- entities chartered by a government or parent organization for specific functions (development authorities, commissions, service delivery arms) that have their own legal standing and contracting power but don't fit standard entity type taxonomies.
2. **Multi-level authority delegation** -- sub-entities holding independent authority alongside (not subordinate to) the parent entity's authority. Both layers operate concurrently.
3. **Functional/geographic overlap** -- when jurisdiction boundaries don't align with organizational boundaries. Two different authority chains deliver the same service in the same geography through completely different governance structures.

These patterns are not organization-specific. Any entity advising complex institutions -- federal agencies with regional offices, university systems with autonomous colleges, healthcare networks with independent medical groups, tribal governments with self-governing subdivisions -- encounters them.

## 2. Evidence

**Discovery 1 -- Internal process interfaces (D-11):**
During a domain bootstrap, we discovered that cross-cutting business functions (vendor management, compliance, content approval) create overlapping authority between departments. The solution was a three-part interface declaration: what crosses the boundary, in what direction, who owns the transition. The `gaps` section -- identifying where no process exists for a known need -- proved diagnostically more valuable than the declared interfaces themselves. Gaps reveal where real work stalls.

**Discovery 2 -- External governance complexity:**
A board-level question about a large organization with geographic subdivisions, a national health department, and a district-level development authority exposed four overlapping authority chains for a single healthcare expansion decision. The agent correctly classified the entity types involved but could not reason about: which authority chain governs the specific decision, where chains overlap, or where the interface between governance bodies is undefined. The question was literally an **undefined interface** -- the boundary between four authority domains had never been declared for this scenario.

**The convergence:** These two discoveries -- one internal (departmental handoffs), one external (governance authority chains) -- share identical structure:
1. Identify the functional units (departments / governance bodies)
2. Map what crosses boundaries between them (handoffs / authority chains)
3. Assign directionality and ownership (who initiates, who's accountable)
4. Identify gaps where the interface is undefined (where decisions stall)

The reasoning pattern is the same at both scales. This suggests a general cognitive framework, not a domain-specific fix.

- **Query patterns:** Board-level questions about governance complexity in large organizations; engagement scoping questions involving multi-layered authority; entity classification questions where entities don't fit established types.
- **Agent behavior:** Agents perform well on entity type classification but cannot reason about authority relationships between entities, or about organizations where multiple authority chains deliver the same service.
- **Session examples:** Agent correctly identified an entity as a "governmental department, not a THO" but could not reason about the four overlapping authority chains involved in a healthcare expansion decision, or suggest which chain should be investigated first.

## 3. Universality Assessment

|Factor|Assessment|
|---|---|
|**Organization-specific?**|No -- authority layering appears in tribal governments, federal agencies, university systems, healthcare networks, corporate conglomerates|
|**Domain-specific?**|No -- applies to any domain involving complex institutional clients or partners|
|**Agent-specific?**|No -- both Claude and Copilot encounter these patterns when reasoning about complex organizations|
|**Architecture-dependent?**|No -- requires reasoning frameworks, not specific system integrations|

**Universality conclusion:** Any Mosaic instance advising or operating within complex institutions benefits from structured reasoning about organizational authority boundaries. The pattern is both company-agnostic and context-agnostic.

## 4. Proposed Change

**Target file(s):** MOSAIC-REASONING.md -- new subsection within §2 (People Reasoning Framework), likely §2.9 "Organizational Boundary Reasoning"

**Change description:**

Add a reasoning framework for organizational authority boundaries. The framework provides four cognitive operations that agents apply when encountering complex organizational structures:

1. **Authority domain identification** -- What are the distinct authority domains within the organization? Don't assume single-locus authority. Probe for geographic subdivisions, functional departments, chartered instrumentalities, and delegated entities.

2. **Boundary mapping** -- Where do authority domains overlap, nest, or conflict? Classify boundary types:
   - *Hierarchical:* parent-child delegation (authority flows down, accountability flows up)
   - *Functional:* chartered entities with specific scope (authority defined by charter/compact, not geography)
   - *Geographic:* jurisdictional boundaries (authority defined by territory, may overlap with functional authority)
   - *Temporal:* authority that changes based on phase, trigger, or transition (interim governance, pilot programs, phased handoffs)

3. **Interface declaration** -- For each boundary crossing, identify: what crosses the boundary (decisions, services, funding, oversight), in what direction (who initiates, who receives), and who owns the transition completing. This follows the three-part interface pattern: handoff artifact, expected return, transition owner.

4. **Gap detection** -- Where is authority ambiguous, unclaimed, or in conflict? Undefined interfaces are diagnostically valuable -- they reveal where decisions stall, not because a process failed, but because no process was defined for the boundary crossing. Flag gaps explicitly rather than assuming authority flows cleanly.

**Draft content:**

```markdown
### 2.9 Organizational Boundary Reasoning

Complex organizations have layered authority -- geographic subdivisions, functional departments,
chartered instrumentalities, delegated entities. Don't assume single-locus authority.

**Four operations when reasoning about organizational boundaries:**

1. **Identify authority domains.** What distinct authority units exist? Probe for:
   geographic subdivisions, functional departments, chartered instrumentalities
   (development authorities, commissions, service delivery arms), delegated entities.

2. **Map boundaries.** Where do domains overlap, nest, or conflict?
   - Hierarchical: parent-child delegation (authority down, accountability up)
   - Functional: chartered scope (authority defined by charter, not geography)
   - Geographic: jurisdictional territory (may overlap with functional authority)
   - Temporal: phase-dependent authority (interim, pilot, transition)

3. **Declare interfaces.** For each boundary crossing:
   what crosses (decisions, services, funding, oversight),
   direction (who initiates, who receives),
   ownership (who is accountable for the transition completing).

4. **Detect gaps.** Where is authority ambiguous, unclaimed, or in conflict?
   Undefined interfaces reveal where decisions stall -- not because a process failed,
   but because no process was defined for the boundary crossing.
   Flag gaps explicitly; don't assume clean authority flow.

When an entity doesn't fit established type taxonomies, this often signals an
instrumentality or delegated entity operating at a boundary between authority domains.
Apply boundary reasoning before forcing a classification.
```

**Relationship to existing content:**
- §2.1 (Authority Types) teaches authority discrimination for individuals; this extends it to organizational units
- §2.5 (Ownership Disambiguation) tracks ownership types that change independently; this addresses ownership across organizational boundaries
- §2.6 (Routing Reasoning) handles routing within known structures; this handles reasoning when structures are ambiguous or layered
- Complementary to PROPOSAL-process-interface-documentation (deferred) -- that covers inter-domain process boundaries within a knowledge system; this covers organizational authority boundaries in the real world

## 5. Impact Assessment

|Dimension|Assessment|
|---|---|
|**Existing instances**|Moderate benefit -- provides a framework for complex institutional client reasoning. No breaking changes. Instances can adopt immediately.|
|**New instances**|Foundation for any instance serving complex institutions. Especially valuable for instances in healthcare, government, education, or tribal services.|
|**Breaking changes?**|None -- purely additive. New subsection in §2, no modifications to existing content.|
|**Reasoning quality**|Improves agent handling of governance complexity, authority layering, instrumentality classification, and undefined boundary detection. Reduces false confidence when authority is ambiguous.|

## 6. Testing

- **Test queries:**
  1. "A large organization has geographic subdivisions, a national health department, and a district-level development authority. How should I reason about which authority chain governs a healthcare expansion decision?"
  2. "An entity has its own contracts and budget but is chartered by a parent government. How should I classify it?"
  3. "When two different authority chains deliver the same service in the same geography, how do I determine which one to engage?"

- **Success criteria:** Agent applies structured boundary reasoning (identify domains, map boundaries, detect gaps) rather than forcing entity classification or assuming single authority. Agent flags undefined interfaces explicitly rather than guessing.

- **Regression risk:** Low. The framework is additive -- new subsection in §2, no modifications to existing authority type reasoning (§2.1) or entity type reasoning (§6.4). Smoke test: verify §2.1 authority discrimination still works correctly after adding §2.9.

---

## Review Notes

*For maintainer use:*

|Field|Value|
|---|---|
|**Reviewed by**||
|**Review date**||
|**Decision**|{Accepted / Modified / Deferred / Rejected}|
|**Rationale**||
|**Implemented in**||
