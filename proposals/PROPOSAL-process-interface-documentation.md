# Mosaic Proposal: Process Interface Documentation for Domain Files

**Submitted by:** Indigenous Pact (IP)
**Date:** 2026-02-25
**Category:** Methodology Pattern
**Related:** PROPOSAL-cross-cutting-file-evolution (D-8 boundary test), DOMAIN-BOOTSTRAP Phase 5

---

## 1. Observation

SOPs and process documentation describe what happens *inside* a department or domain. They are largely silent about what happens *between* domains — the handoff points where one domain's process requires input from, approval by, or output to another domain. These handoff gaps are where real organizational work stalls: confusion about what artifact to send, what to expect back, what turnaround is reasonable, and who is accountable for the transition completing.

Domain files in Mosaic already include cross-domain integration sections (bridges, routing, pointers). But these bridges are **navigational** — they tell the agent where to find related content. They don't tell the agent (or the human) **what happens at the boundary** between domains when a process crosses it.

This gap matters at three levels:
1. **For humans today:** Cross-domain processes stall because nobody owns the handoff. The marketing team emails legal for a contract review; legal puts it in their queue; marketing waits; nobody escalates because nobody is designated as the transition owner.
2. **For agents today:** An agent tracing "how do I bring on a new vendor?" can retrieve content from multiple domains but can't assemble a coherent cross-domain process because the interfaces aren't documented.
3. **For autonomous agents (future):** Action playbooks that execute multi-domain workflows need explicit interface specifications — what to hand off, what to expect back, who owns each transition. Without these, playbooks can only operate within single domains.

## 2. Evidence

### Phase B — Marketing Domain Bootstrap (IP)

During the Marketing & Communications domain bootstrap, three real-world scenarios revealed the interface gap:

**Scenario 1 — New Marketing Vendor Approval:**
Process touches Marketing (vendor evaluation), Administration/Procurement (stage-gate), Legal (contract review), Finance (payment setup), and DOA authority (IP-INDEX). Five domains, four handoff points, zero documented interfaces. Each department knows their interior steps. Nobody documents: "Marketing sends vendor evaluation package to Procurement; Procurement returns stage-gate clearance or rejection within 5 business days; Marketing initiator tracks completion."

**Scenario 2 — SOP Creation:**
Marketing drafts a new SOP (domain-specific). But creating it requires: company SOP registry assignment (cross-domain governance), legal compliance review (Legal domain), and awareness by affected departments. The SOP content is domain-owned; the SOP lifecycle is cross-domain. Without interfaces, orphan SOPs get created that no central registry knows about.

**Scenario 3 — Marketing Tool Addition:**
Marketing evaluates a tool (domain-specific). Adoption requires: security review (Technology), procurement approval (Administration), budget allocation (Finance), and systems index update (Technology). The domain owns "why this tool and how we use it." Technology owns "does it integrate safely." Procurement owns "can we buy it." Without interfaces, the tool gets adopted by marketing and nobody updates the cross-domain systems inventory.

### Connection to Existing Patterns

Process Interface Documentation is the missing link between three Phase B design decisions:

- **D-6 (SOP Cross-Linking):** SOPs reference a company-level structure. But the SOP itself only covers interior steps. Interface documentation covers the cross-domain handoffs that the SOP is silent about.
- **D-8 (Operations Decomposition):** The boundary test classifies content as domain-specific or cross-domain governance. Interface documentation adds a third category: **cross-domain process connections** — content that belongs in neither domain exclusively but describes the relationship between them.
- **D-10 (Architecture Layering):** Domain files are the information layer; action playbooks are the future action layer. Process interfaces are the **specification** that action playbooks will execute. They're the contract between the information layer ("here's what needs to happen") and the action layer ("here's how to make it happen").

## 3. Universality Assessment

| Factor | Assessment |
|--------|-----------|
| **Organization-specific?** | No. Every organization with domain-structured knowledge faces the handoff gap. |
| **Domain-specific?** | No. Every domain that touches other domains (which is all of them) has interfaces. |
| **Agent-specific?** | No. Interfaces help human processes today and enable agent automation tomorrow. |
| **Architecture-dependent?** | Partially. Requires domain files with cross-domain sections. Instances without domain structure would need to add it. |

## 4. Proposed Methodology Addition

### Addition to Phase 3: Ontology — Process Interface Mapping

```markdown
**3.X Process Interface Mapping**

During ontology construction, identify the domain's process interfaces alongside
entity types and cross-domain bridges.

For each process that crosses a domain boundary, document:

| Component | What it Answers |
|---|---|
| **What I hand off** | What artifact/information leaves this domain |
| **What I need back** | What this domain expects to receive |
| **Who owns the handoff** | Who is accountable for the transition completing |

Organize interfaces into three categories:
- **Outbound:** Processes this domain initiates that require another domain's action
- **Inbound:** Handoffs this domain receives from other domains
- **Gaps:** Known cross-domain needs where no formal process exists

Gaps are as valuable as declared interfaces — they identify where organizational
work stalls because no handoff process was defined.

Interface mapping feeds directly into:
- Phase 5 construction (§10 cross-domain section includes interface YAML)
- Future action playbook design (interfaces become playbook specifications)
- SOP governance (interfaces reveal where SOPs need cross-domain awareness)
```

### Addition to Phase 5: Construction — Interface Declaration Pattern

```markdown
**5.X Process Interface Declaration**

Every domain file's cross-domain integration section includes a YAML block
declaring process interfaces. Standard pattern:

```yaml
interfaces:
  outbound:
    - process: [process-name]
      to: [receiving domain]
      handoff: "[what leaves this domain]"
      needs_back: "[what this domain expects to receive]"
      owner: "[who tracks the transition]"
      sop_ref: [section reference for the interior process]

  inbound:
    - process: [process-name]
      from: [sending domain]
      receives: "[what this domain receives]"
      delivers: "[what this domain returns]"
      owner: "[who owns the response]"
      sop_ref: [section reference]

  gaps:
    - process: [identified-need]
      description: "[what cross-domain handoff is missing]"
      impact: "[what breaks or stalls without it]"
      proposed_owner: "[suggested owner or STEWARD-TBD]"
```

**Construction discipline:**
- Populate outbound interfaces first — these are the processes the domain
  steward knows best
- Inbound interfaces may need input from other domain stewards
- Gaps should be identified during construction but validated during
  steward review
- Interface declarations are living content — they evolve as processes
  mature and as receiving domains are bootstrapped
- When a receiving domain is bootstrapped, its inbound interfaces should
  mirror the sending domain's outbound interfaces (bidirectional
  consistency check)
```

### Addition to Phase 7: Validation — Interface Completeness

```markdown
**7.X Interface Validation**

Post-build validation should include at least one test query that requires
tracing a cross-domain process through interfaces. Example: "How do I
[process that crosses 3+ domains]?" The agent should be able to:

1. Identify which domains are involved (routing)
2. Retrieve the relevant interface declarations (documentation)
3. Present a coherent process chain including handoff artifacts and owners
   (assembly)

Score interface queries on:
- Process completeness: all domains identified
- Handoff clarity: artifacts and owners specified
- Gap awareness: missing interfaces flagged rather than assumed
```

## 5. Impact Assessment

| Dimension | Assessment |
|-----------|-----------|
| **Existing instances** | High benefit. Instances with multiple domains gain the ability to trace cross-domain processes. Even partial interface documentation (one domain at a time) adds value. |
| **New instances** | Foundational. Built into domain construction from the start, interfaces accumulate naturally as domains are added. |
| **Breaking changes?** | No. Adds content to cross-domain sections. Domains without interfaces continue to work — they just can't trace handoffs. |
| **Reasoning quality** | Significant improvement for cross-domain process queries. Transforms "here are related files" into "here is the handoff chain." |
| **Organizational value** | Extends beyond agent reasoning. Interface documentation makes invisible handoff failures visible — diagnostic value for process improvement even without agent automation. |
| **Future architecture** | Direct input to action playbooks (D-10 architecture layering). Interface specifications become the contracts that playbooks execute. Building interfaces now is an investment in future autonomous capability. |

## 6. Implementation Notes

- **First implementation:** IP Marketing domain (Phase B), IP-MARKETING §10
- **Pattern validation:** Run a cross-domain process query (e.g., "How do I bring on a new marketing vendor?") before and after interface documentation to measure improvement
- **Incremental adoption:** Interfaces can be added domain-by-domain. Even one domain with interfaces improves cross-domain queries for that domain. As more domains add interfaces, the system's ability to trace full process chains improves cumulatively.
- **Bidirectional consistency:** When Domain B is bootstrapped after Domain A, Domain B's inbound interfaces should acknowledge Domain A's outbound declarations. This prevents asymmetric documentation where one side of a handoff is documented and the other isn't.
- **Gap-to-interface graduation:** Items in the `gaps` section are candidates for process creation. When the organization defines a process for a gap, it graduates to an outbound or inbound interface with a proper SOP reference.
