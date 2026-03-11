# MOSAIC-INFORMATION-GOVERNANCE — Shared Information Governance Framework

**Version:** 1.2

---

## 1. About This File

Company-agnostic information governance framework for Mosaic knowledge systems. Defines tier architecture, type overlays, stewardship model, inter-agent access control, and classification lifecycle. Any Mosaic instance can adopt this framework and create an instance-specific application document (ORG-INFORMATION-GOVERNANCE).

**Audiences:**
- **Instance builders** — apply during domain bootstraps (DOMAIN-BOOTSTRAP Phase 3.5 + 4.6)
- **Security/compliance reviewers** — unified policy document for the entire knowledge architecture
- **Maintainers** — reference during classification audits, tier boundary reviews, incident response

**Not loaded into agent kernel.** This is a builder and compliance reference (~25 KB). Agents receive tier definitions and stewardship reasoning through MOSAIC-REASONING §2.2 (dispositional) and instance behavior files (operational rules). This file provides the full rationale, industry alignment, and implementation guidance that those compact kernel entries compress.

**Instance application pattern:** Create `ORG-INFORMATION-GOVERNANCE.md` in instance `reference/` directory. Map organization-specific data types to the shared tier structure. Define organization-specific stewardship obligations and inter-agent boundaries. The shared framework defines WHAT tiers mean; the instance document defines WHAT DATA goes in each tier.

---

## 2. Tier Architecture

### 2.1 Four-Tier Model

Four tiers balance granularity (enough to differentiate handling) with adoptability (few enough to classify consistently). Research confirms: 3 tiers collapse under pressure (everything becomes "medium"); 5+ tiers reduce consistent classification.

```yaml
tiers:
  1:
    name: Internal
    description: Broadly available inside the organization
    human_access: All authenticated staff
    agent_access: All agents including future external/client agents
    control_expectations:
      - Authentication required
      - Standard audit logging
      - No external sharing without approval
    examples: Org structure, team info, process descriptions, policy frameworks, client names/states, websites
  2:
    name: Sensitive
    description: Limited audience; material harm if disclosed inappropriately
    human_access: Role-based, manager approval for cross-domain sharing
    agent_access: Instance agents only; excluded from QUICK files and ambient context
    control_expectations:
      - Encryption at rest and in transit
      - Access logging with review cadence
      - Role-based access (not just authentication)
      - Excluded from agent kernel and QUICK files
    examples: P&L details, budget amounts, vendor contract values, intercompany rates, engagement operational detail
  3:
    name: Restricted
    description: Need-to-know; regulatory or legal consequences if mishandled
    human_access: Explicit authorization, full audit trail
    agent_access: Instance agents with behavioral gate (human review of output before delivery); external agents blocked
    control_expectations:
      - Need-to-know access with explicit authorization
      - Full audit trails (who accessed, when, why)
      - Human review of agent outputs before delivery
      - Behavioral gates on agent queries
      - Quarterly access reviews
    examples: State registrations, ownership percentages, distributions, K-1s, insurance details, UEI/CAGE codes
  4:
    name: Prohibited
    description: Must never exist in any agent knowledge base, retrieval system, or persistent memory
    human_access: Source systems only; break-glass procedures for emergency access
    agent_access: No agent access ever — hard exclusion
    control_expectations:
      - Hard exclusion from all agent systems
      - Data stays in source systems only
      - Pattern detection for accidental inclusion
      - No agent retrieval, summarization, or reference
    examples: Account numbers, SSNs, banking details, clinical records (PHI), individual salary/performance, attorney-client privileged communications
```

**Industry alignment:** NIST SP 800-60 uses a three-axis impact model (confidentiality, integrity, availability) with Low/Moderate/High; ISO 27001 Annex A 5.12 requires classification schemes without prescribing tier count; SOC 2 Trust Service Criteria map controls to confidentiality levels. The four-tier model aligns with enterprise consensus (Internal/Sensitive/Confidential/Restricted is the most common corporate scheme) while adding the agent-specific access dimension that traditional frameworks lack.

### 2.2 Tier Assignment Principles

1. **Default to lowest applicable tier.** Information starts at Tier 1 and gets elevated only when a specific harm vector justifies it. Over-classification reduces adoption and creates access friction that degrades system utility.
2. **Per-field, not per-file.** A single file may contain Tier 1 process descriptions alongside Tier 2 financial details. Classification applies to data elements, not containers. File-level classification is a shorthand when all content shares a tier.
3. **Domain-specific classification.** Domain owners classify their content using the shared tier definitions. The framework defines what tiers MEAN (controls, access); domains determine what DATA occupies each tier. See §10 (Federated Classification Model).
4. **Elevation-only for types.** Information type overlays (§3) can elevate the effective tier but never reduce it. PHI is always at least Tier 3 regardless of how mundane the specific data element seems.
5. **Temporal sensitivity.** Classifications change over time. Pre-announcement restructuring plans (Tier 2) become Tier 1 post-announcement. Compliance findings (Tier 3 pre-remediation) may become Tier 1 post-remediation. See §7 (Classification Lifecycle).

### 2.3 Agent Access Rules per Tier

Agent access is an architectural dimension that traditional information governance frameworks lack. In a multi-agent knowledge system, "who can see this" includes both human roles AND agent identities.

```yaml
agent_access_rules:
  tier_1:
    kernel_files: Allowed (structural/routing content)
    quick_files: Allowed
    full_reference: Allowed
    agent_memory: Allowed
    external_agents: Allowed
  tier_2:
    kernel_files: Never (excluded from ambient context)
    quick_files: Never
    full_reference: Allowed (retrieval only)
    agent_memory: Never
    external_agents: Blocked
  tier_3:
    kernel_files: Never
    quick_files: Never
    full_reference: Allowed with behavioral gate
    agent_memory: Never
    external_agents: Blocked
    additional: Human review of agent output before delivery
  tier_4:
    kernel_files: Never
    quick_files: Never
    full_reference: Never
    agent_memory: Never
    external_agents: Blocked
    additional: Hard exclusion — data stays in source systems only
```

### 2.4 Authorization

Classification and authorization are independent dimensions. Classification is a property of the information — it follows the data regardless of who handles it. Authorization is a property of the person's role and work-need — it determines who may access information at each tier.

Both must be evaluated. An agent first classifies (what tier?) then authorizes (is this person authorized for that tier?).

```yaml
authorization_model:
  tier_1:
    authorization: All authenticated staff
    agent_behavior: Share freely
  tier_2:
    authorization: Work-need test — legitimate work connection, not department-siloed
    agent_behavior: Surface when the person's role or question implies work-need. Err toward enabling. The test is "does this question imply a work connection?" not "is this person in the right department?"
  tier_3:
    authorization: Named role-holders with legal or fiduciary operating authority (instance-defined)
    agent_behavior: Check who is asking. If authorized, provide. If not, direct to the appropriate person.
  tier_4:
    authorization: System-level access controls only
    agent_behavior: Never through agent systems regardless of requester
```

Instance governance files define the specific named role-holders for Tier 3 and any organization-specific work-need guidance for Tier 2.

---

## 3. Information Type Overlays

### 3.1 Types Are Orthogonal to Tiers

Information types represent regulatory, legal, or contractual regimes that cross-cut the tier structure. A data element has both a tier (1-4) AND one or more types. Both apply simultaneously.

Types determine **handling obligations** — what you must do with the data regardless of tier. Tiers determine **access controls** — who can see it. A Tier 1 data point can still carry sovereignty handling obligations. A Tier 2 financial detail that is also PHI carries both financial access controls AND HIPAA handling requirements.

```yaml
information_types:
  PHI:
    regulatory_driver: HIPAA, 42 CFR Part 2
    authorized_use: TPO (Treatment, Payment, Operations) under BAA. PHI flows through healthcare operations under BAA/TPO - this is normal and necessary. Agent exclusion is a system-level boundary, not a prohibition on organizational PHI use.
    special_handling:
      - Minimum necessary standard
      - Breach notification obligations
      - Separate from non-HIPAA systems
      - 42 CFR Part 2 stricter than base HIPAA for substance use
    minimum_effective_tier: 3
    agent_rule: No agent storage or retrieval of individual PHI. Aggregate health metrics only with de-identification.

  Legal_Privileged:
    regulatory_driver: Attorney-client privilege, work product doctrine
    special_handling:
      - Exposure = irreversible privilege waiver
      - No summarization or paraphrasing by agents
      - Legal review required before any disclosure
      - Privilege extends to drafts, notes, communications with counsel
    minimum_effective_tier: 4
    agent_rule: Always Tier 4 for agents regardless of underlying business sensitivity. Route legal queries to counsel, never search reference files.

  Financial_Ownership:
    regulatory_driver: Corporate law, tax law, fiduciary duty
    special_handling:
      - Owner-level access only for distributions, K-1s, capital structure
      - No cross-entity aggregation without authorization
      - Tax ID handling per IRS Publication 1075
    minimum_effective_tier: 2 (operations), 3 (ownership/distributions)
    agent_rule: Operational financials in full reference files. Ownership structure in restricted sections with behavioral gate.

  HR_Protected:
    regulatory_driver: Employment law, ADA, FMLA, Title VII
    special_handling:
      - Privacy-by-default (individual data never in agent files)
      - Aggregate reporting only in agent systems
      - Medical accommodations, investigations, disciplinary records = Tier 4
      - Source system access via MCP with role-based auth
    minimum_effective_tier: 2 (philosophy/bands), 4 (individual data)
    agent_rule: Queries about individuals route to source system MCP. Aggregate queries answered from reference files.

  Sovereign:
    regulatory_driver: Tribal sovereignty, contractual terms (PSA/MSA), CARE/OCAP principles
    special_handling:
      - Per-entity isolation default
      - Consent-gated cross-boundary operations
      - Stewardship model (see SS4), not ownership model
      - Bidirectional flow controls
      - Retention terms per contractual agreement
    minimum_effective_tier: Varies (sovereignty is orthogonal to tier)
    agent_rule: Per-entity isolation. Never aggregate or compare across sovereign entities without explicit consent. See SS4 for full stewardship model.
```

### 3.2 Type-Tier Interaction

**Types elevate, never reduce.** When a type overlay imposes a higher minimum tier than the base classification, the type wins. When multiple types apply, use the highest minimum.

**Compound types:** Data can carry multiple types simultaneously. A tribal health clinic's billing data is both PHI and Sovereign — it carries HIPAA handling AND sovereignty isolation. Apply both type overlays; the more restrictive rule governs any conflict.

**Type detection triggers:** Instance behavior files should include detection patterns for each active type. When an agent encounters data matching a type pattern (e.g., individual health information, legal communications, ownership percentages), the type overlay activates automatically. Types are not opt-in — they are triggered by the nature of the data.

---

## 4. Data Stewardship Model

### 4.1 Ownership vs. Custodial Stewardship

Not all data an organization handles is data it owns. The stewardship model distinguishes two fundamentally different relationships:

**Owned data:** The organization generated it, controls it, classifies it, and determines access. Default: classify by tier and manage through standard access controls. Most organizational data falls here — financial records, operational metrics, strategic plans, team structures.

**Stewarded data:** The organization holds it under contractual, regulatory, or sovereign terms on behalf of another entity. The data belongs to that entity. The organization's access comes from its custodial role, not from ownership. Custodial data carries obligations that owned data does not:

- **Isolation default:** Stewarded data from different entities is isolated by default. Cross-entity operations require explicit consent, not just the absence of prohibition.
- **Retention terms:** When the custodial relationship ends (contract expiration, PSA termination), data obligations follow the agreement terms — return, destroy, or retain per contract.
- **Classification floor:** The entity's terms set a minimum classification that the custodian cannot lower. A Tier 1 data element under stewardship may carry Tier 2 handling obligations.
- **Methodology boundary:** The custodian's analytical methodology and reasoning frameworks are its own. The data those methods are applied to belongs to the entity. Lessons about HOW to analyze are transferable; the specific data and patterns revealed by analysis are not.

This distinction changes the agent's reasoning posture. For owned data, the question is "what tier is this?" For stewarded data, the question is "what tier is this AND what does the stewardship agreement require?" The stewardship terms may be more restrictive than the tier alone would suggest.

### 4.2 Sovereignty Stewardship

Sovereign entities — tribal nations, government bodies, or any entity whose legal authority supersedes the custodian's internal policies — own their data under terms that cannot be overridden by the custodian's classification choices.

**What sovereignty means for data governance:**
- Each sovereign entity is an independent peer, not a "client" in CRM terms
- Per-entity data isolation is the architectural default, not a policy choice
- The sovereign entity's consent governs cross-boundary operations
- The custodian's internal sensitivity tiers apply to the custodian's handling, but the sovereign entity's terms set the floor

**What sovereignty governs:**

```yaml
sovereignty_operations:
  aggregation:
    rule: Custodian can aggregate its OWN numbers (e.g., "our revenue from sovereign clients = $X")
    boundary: Cannot aggregate in ways that reveal entity-specific patterns without consent
    test: "Does this aggregation reveal information about a specific entity that the entity has not consented to share?"

  pattern_transfer:
    rule: Methodology lessons transferable (company-agnostic). Entity-specific data is sovereign.
    boundary: General analytical methods can inform work with other entities. Specific data, relationship patterns, operational details cannot.
    test: "Am I transferring a method or transferring data?"

  retention:
    rule: Stewardship terms govern post-relationship data handling
    boundary: Return, destroy, or retain per agreement. Default if unspecified = return or destroy.

  consent:
    rule: Cross-entity operations require explicit consent. Default is isolation.
    boundary: Regional consortiums, shared initiatives with consent can open specific boundaries.
    test: "Is there documented consent for this specific cross-entity operation?"

  bidirectional_flow:
    rule: Entity data does not flow outward without authorization. Custodian internal data does not flow inward to entity-facing agents.
    boundary: Both directions are controlled. Sovereignty is not just about outbound data.

  comparison:
    rule: Never use one entity's data to benchmark, inform strategy for, or evaluate another entity.
    boundary: Each relationship is independent. Comparison violates the per-entity isolation default.
```

**CARE Principles reference:** Collective Benefit, Authority to Control, Responsibility, Ethics — the international framework for indigenous data governance. OCAP Principles (Ownership, Control, Access, Possession) provide additional specificity for First Nations data sovereignty contexts.

### 4.3 Stewardship as Reasoning Posture

Stewardship is dispositional — it shapes how the agent reasons about data before evaluating any specific query. The agent should approach stewarded data with this understanding:

1. **"I hold this data on behalf of [entity]."** Access comes from the custodial relationship, not from ownership. The agent's right to process this data is derived, not inherent.
2. **"What I do with this data is constrained by both tier AND stewardship terms."** Tier classification governs the custodian's internal handling. Stewardship terms add obligations the tier alone would not impose.
3. **"Cross-entity operations require explicit consent."** The default is isolation — not the absence of a prohibition, but the presence of a boundary. Consent opens specific boundaries; it does not remove the default.
4. **"Methodology is mine; data is the entity's."** The agent's analytical frameworks, reasoning patterns, and query strategies belong to the system. The data those frameworks are applied to belongs to the entity. This distinction allows learning from work without transferring data.

These four statements are kernel-eligible: they are dispositional (shape reasoning before conscious application), not procedural (consumed at a specific moment). Instance behavior files carry compressed versions. The full rationale here explains WHY the posture matters.

### 4.4 Cross-Boundary Operations

**Default: isolation.** Stewarded data from Entity A and Entity B are separate unless an authorized exception applies.

**Authorized exceptions (require documented consent):**
- Regional consortiums where participating entities have agreed to shared data
- Joint health initiatives with explicit data-sharing agreements
- Aggregate reporting where individual entity data is not identifiable
- Emergency response scenarios with appropriate authority

**Methodology vs. data boundary:**
- **Transferable:** "We learned that early-stage engagements benefit from X approach" — this is methodology
- **Not transferable:** "Entity A's engagement showed X pattern in their Y metric" — this is entity data
- **Gray zone:** "In our experience, organizations of this type tend to..." — acceptable if the insight is genuinely generalized, not a thin disguise for one entity's data

---

## 5. Inter-Agent Access Control

### 5.1 Multi-Agent Data Flow Principles

In systems with multiple agents (different platforms, different audiences, or different organizational affiliates), data flow must satisfy two independent gates:

1. **Capability routing:** Which agent CAN perform this task? (Native access to required systems, tools, data sources)
2. **Sensitivity routing:** Which agent SHOULD see this data? (Tier classification, stewardship boundaries, type overlays)

Both must pass. An agent may be capable of answering a query but not authorized to access the data required. A CRM-connected agent CAN retrieve client data but SHOULD NOT if the requesting agent serves a different organization and the data is Tier 2+.

This extends MOSAIC-REASONING §5.2 (delegation reasoning). Capability routing asks "who can do this?" Sensitivity routing asks "who should see this data?" Traditional routing considers only capability. Governance-aware routing considers both.

### 5.2 Agent Access Architecture

```yaml
agent_access_architecture:
  internal_operations_agent:
    description: Primary instance agent (e.g., Claude.ai project)
    tier_access: [1, 2, 3]
    tier_3_gate: Behavioral gate — human review before delivery
    stewardship: Full stewardship reasoning (see SS4.3)
    notes: Highest-trust agent. Full reference file access.

  internal_code_agent:
    description: Development/maintenance agent (e.g., Claude Code)
    tier_access: [1, 2, 3]
    tier_3_gate: CLAUDE.md rules (never put Tier 3+ in certain files)
    stewardship: File-level rules in CLAUDE.md
    notes: Full disk access. Rules enforced by behavioral directives + file structure.

  internal_search_agent:
    description: Enterprise search agent (e.g., Copilot)
    tier_access: [1, 2]
    tier_2_source: M365 native (SharePoint permissions govern access)
    stewardship: M365 permission model + behavioral directives
    notes: M365 permissions provide structural enforcement for Tier 2.

  external_client_agent:
    description: Agent serving an affiliate, subsidiary, or client organization
    tier_access: [1]
    stewardship: Blocked from parent org data above Tier 1
    notes: Can see published/shared content only. No financial, operational, or sovereign data from parent.
```

### 5.3 Enforcement Mechanisms

Three enforcement levels, from lightest to strongest:

```yaml
enforcement_levels:
  behavioral:
    mechanism: Agent behavioral directives ("Do not reveal Tier 2+ content to external agents")
    strength: Soft — relies on agent compliance with instructions
    appropriate_for: Tier 2 boundaries in conversational agents
    limitation: Prompt injection, context loss, or ambiguous queries can bypass
    monitoring: Quarterly review of agent outputs for tier boundary violations

  structural:
    mechanism: File/system separation (Tier 2+ in separate files, QUICK files Tier 1 only)
    strength: Medium — agent cannot access what is not in its retrieval scope
    appropriate_for: Tier 2/3 boundaries between agent types
    limitation: Requires discipline in file construction; content can drift into wrong files
    monitoring: File-level classification audits during maintenance cycles

  system_level:
    mechanism: MCP/API access controls (agent credentials determine accessible endpoints)
    strength: Hard — enforced at infrastructure level regardless of agent behavior
    appropriate_for: Tier 3/4 boundaries, external agent access, cross-organization boundaries
    limitation: Requires infrastructure investment; not always available
    monitoring: Access logs, credential rotation, penetration testing
```

Choose enforcement per agent x tier combination based on risk. Higher tiers and external agents warrant stronger enforcement. Instance documents (ORG-INFORMATION-GOVERNANCE) map specific agent x tier combinations to enforcement levels.

---

## 6. Cross-Domain Sensitivity

### 6.1 Conflicts Are Features

The same data element may legitimately have different sensitivity tiers in different domains. This is domain-specific risk modeling, not a contradiction. Each domain faces different harm vectors, and the tier reflects the domain's assessment of potential harm from unauthorized access.

**Examples (generic):**

Compensation data:
- Finance domain: Tier 2 (budget line — aggregate departmental cost)
- HR domain: Tier 4 (individual salary — employment law protection)
- People Ops domain: Tier 1 (role band — organizational design information)

Restructuring plans:
- Operations domain: Tier 2 (strategic planning — pre-announcement)
- HR domain: Tier 3 (severance, employment law implications)
- Finance domain: Tier 2 (cost impact analysis)
- Post-announcement: Tier 1 across all domains

Compliance audit findings:
- Legal domain: Tier 3 (litigation exposure)
- Operations domain: Tier 2 pre-remediation, Tier 1 post-remediation
- Finance domain: Tier 2 (remediation budget impact)

### 6.2 Resolution Pattern

**Query context determines lens.** When a query touches data classified differently across domains, the agent determines which domain's lens applies based on the query's intent and the requesting user's role.

**Highest tier governs agent behavior.** When uncertain which domain lens applies, the agent defaults to the highest applicable tier. This is conservative by design — under-sharing is reversible, over-sharing may not be.

**Document, don't reconcile.** Cross-domain tier differences should be documented in both the shared framework and domain-specific files. They do not need to be reconciled — the difference IS the information. A domain that classifies compensation at Tier 2 and another that classifies it at Tier 4 are making different risk assessments, and both are correct for their context.

---

## 7. Classification Lifecycle

### 7.1 Temporal Sensitivity

Classifications are not permanent. Events change the sensitivity of information:

```yaml
temporal_patterns:
  pre_post_announcement:
    trigger: Public announcement of previously internal information
    effect: Tier 2 -> Tier 1
    examples: Restructuring plans, strategic partnerships, leadership changes
    timing: Effective immediately upon announcement

  remediation_completion:
    trigger: Identified issue is fully remediated
    effect: Tier 3 -> Tier 2 or Tier 1 (depends on residual risk)
    examples: Compliance findings, security vulnerabilities, operational gaps
    timing: After remediation verified AND documentation updated

  contract_end:
    trigger: Contractual relationship terminates
    effect: Stewarded data follows contract terms (return, destroy, or retain)
    examples: Client engagement data, vendor data, partner data
    timing: Per contractual retention schedule

  regulatory_change:
    trigger: New regulation or de-regulation changes handling requirements
    effect: Tier may increase or decrease
    examples: New privacy regulation, industry deregulation
    timing: Effective per regulatory compliance deadline
```

### 7.2 Classification Authority

**Domain stewards classify.** The domain owner (identified during DOMAIN-BOOTSTRAP Phase 1) is responsible for classifying domain content using the shared tier definitions.

**Central audit verifies.** The knowledge architect (or equivalent) conducts periodic audits to verify:
- Classifications are consistent with tier definitions
- Cross-domain conflicts are documented (not hidden)
- Temporal changes have been applied (pre-announcement -> post)
- Tier 3/4 content has not leaked into lower-tier locations

**Reclassification requires justification.** Tier changes are documented with: what changed, why, who authorized, effective date. Downward reclassification (lowering a tier) requires stronger justification than upward (raising a tier).

---

## 8. Agent Memory Governance

### 8.1 What Persistent Memory Can Contain

Agent persistent memory includes: kernel files loaded at conversation start, QUICK files retrieved per session, full reference files retrieved on demand, and working memory files (e.g., `memory/` directory in Claude Code).

```yaml
memory_tier_rules:
  tier_1:
    kernel: Allowed (structural, routing, behavioral)
    quick_files: Allowed
    full_reference: Allowed
    working_memory: Allowed
  tier_2:
    kernel: Never
    quick_files: Never
    full_reference: Allowed (retrieval only, not cached)
    working_memory: Never in persistent files; transient in-conversation OK
  tier_3:
    kernel: Never
    quick_files: Never
    full_reference: Allowed with behavioral gate
    working_memory: Never
  tier_4:
    kernel: Never
    quick_files: Never
    full_reference: Never
    working_memory: Never
```

### 8.2 Pattern Detection

Accidental inclusion of Tier 4 content is the highest-risk governance failure in agent knowledge systems. Common patterns to detect:

- **Tax identifiers:** `XX-XXXXXXX` (EIN format), `XXX-XX-XXXX` (SSN format)
- **Account numbers:** Bank routing numbers, account numbers in any format
- **Individual compensation:** Dollar amounts associated with named individuals in HR context
- **Clinical identifiers:** MRN, date of birth + name combinations
- **Privileged communications:** Email threads with counsel, documents marked "Privileged and Confidential"

**Detection cadence:** Quarterly scan of all agent-accessible files. Include in maintenance cycle (instance MAINTENANCE file §4.6). Automated grep patterns for known formats; manual review for contextual patterns that grep cannot detect.

---

## 9. SOC 2 Trust Service Criteria Alignment

### 9.1 Controls Per Tier

The framework maps tier controls to SOC 2 Trust Service Criteria. Organizations not pursuing SOC 2 certification still benefit from the control structure — it provides auditable, defensible governance.

```yaml
soc2_alignment:
  CC6.1_Logical_Access:
    description: Access to information restricted based on classification
    tier_1: Authentication required; standard access logging
    tier_2: Role-based access; access logging with review cadence; manager approval for cross-domain
    tier_3: Need-to-know with explicit authorization; full audit trails; quarterly access reviews
    tier_4: Hard exclusion; source systems only; break-glass for emergency human access

  CC6.3_Access_Removal:
    description: Access revoked when no longer needed
    tier_1: Standard offboarding procedures
    tier_2: Access review at role change; domain-level revocation
    tier_3: Immediate revocation on role change; quarterly verification
    tier_4: N/A (no agent access to revoke)

  CC6.6_System_Boundaries:
    description: System boundaries defined and protected
    tier_1: Agent type boundaries documented
    tier_2: Structural separation (file-level); behavioral directives
    tier_3: Behavioral gates + structural separation; human review layer
    tier_4: System-level exclusion; pattern detection for boundary violations

  C1.1_Confidential_Information_Identification:
    description: Confidential information identified and classified
    tier_mapping: Four-tier model (this framework) + type overlays (SS3)
    implementation: Domain stewards classify per SS7.2; central audit per SS7.2

  C1.2_Confidential_Information_Disposal:
    description: Confidential information disposed when no longer needed
    owned_data: Per retention schedule
    stewarded_data: Per stewardship terms (return, destroy, or retain per contract)
    agent_memory: Working memory files cleaned at session end; reference files follow maintenance cycle

  Privacy_P1_through_P8:
    description: Privacy controls for personal information
    sovereignty_model: SS4 (stewardship, per-entity isolation, consent-gated operations)
    hr_privacy: Type overlay for HR-Protected (SS3.1) — privacy-by-default, aggregate only
    phi_privacy: Type overlay for PHI (SS3.1) — HIPAA minimum necessary, breach notification
```

---

## 10. Federated Classification Model

**Unified tiers, domain-specific classification.** The framework establishes the tier architecture (§2) and type overlays (§3). Domain owners classify their content using these shared definitions.

**Central responsibilities:**
- Define tier structure, control expectations, and type overlays (this file)
- Conduct periodic classification audits (§7.2)
- Document cross-domain sensitivity conflicts (§6)
- Maintain pattern detection for Tier 4 leakage (§8.2)

**Domain responsibilities:**
- Classify domain content per shared tier definitions
- Document domain-specific classification guidance in domain files
- Apply type overlays where applicable
- Report cross-domain conflicts to central audit

**Integration with domain bootstraps (DOMAIN-BOOTSTRAP):**
- **Phase 3.5 (Design Brief):** Include sensitivity architecture — who queries this domain's agent, what different audiences should not see, inter-agent access boundaries
- **Phase 4.6 (Data Sensitivity Design):** Apply this framework's tier definitions. Define per-section tiers. Choose enforcement mechanisms. Document type overlays applicable to this domain.
- **Phase 5 (Construction):** Tier markers in files from the start. QUICK files Tier 1 only. Sensitivity-aware section design.
- **Phase 7 (Validation):** Include sensitivity boundary queries in test suite.

---

## 11. Future Domain Implications

### 11.1 Legal Domain

Attorney-client privilege is qualitatively different from other sensitivity categories. Exposure does not just create a privacy breach — it permanently and irreversibly waives a legal protection. This cannot be remediated, apologized for, or reversed.

**Design implications for legal domain bootstraps:**
- Legal-privileged material = always Tier 4 for agents, regardless of underlying business sensitivity
- Legal reference files contain process descriptions, policy frameworks, compliance structure — never privileged communications or litigation strategy
- Agent behavioral directive: "If user asks about a legal matter, do not search reference files — route to counsel"
- Privilege extends to drafts, notes, and communications with counsel — not just final opinions
- Work product doctrine: opinion work product (attorney's mental impressions) gets stronger protection than fact work product

### 11.2 HR Domain

Privacy-by-default. Most HR data stays in source systems (Rippling, Workday, etc.), accessed via MCP with role-based authentication. Reference files contain policy descriptions, compensation philosophy, aggregate structures — never individual data.

**Classification guidance:**
- Individual compensation/performance/discipline: Tier 4 (never in agent files)
- Compensation philosophy, salary bands: Tier 2
- Aggregate metrics (department headcount, cohort analysis): Tier 1
- Medical accommodations, FMLA status: Tier 4 (ADA/FMLA-protected)
- Investigations: Tier 4 (retaliation risk)
- EEO data: Tier 1 aggregate, Tier 4 individual
- Exit interview notes: Tier 4

### 11.3 Retroactive Audit

Existing domains bootstrapped before this framework should receive a retroactive classification audit:
1. Map existing content to the four-tier model
2. Identify content that needs tier markers
3. Verify QUICK files contain only Tier 1 content
4. Check for Tier 3/4 content that may have leaked into agent-accessible files
5. Document findings as maintenance backlog items

**Cadence:** Quarterly, aligned with instance maintenance cycle. Include in instance MAINTENANCE file §4.6.

---

## Maintenance

- **Version track:** MOSAIC-INFORMATION-GOVERNANCE follows its own version (v1.0, v1.1, etc.)
- **No company-specific data.** This file contains governance methodology only. If you find organization names, entity lists, or specific data examples tied to a real organization, they should be removed or genericized.
- **Relationship to instance files:** Instance ORG-INFORMATION-GOVERNANCE documents apply this framework to a specific organization's data landscape. Shared changes go here; organization-specific changes go in instance files.
- **Backwards compatibility:** Tier definitions are foundational. Renumbering or redefining tiers requires migration planning across all instances. New type overlays are additive. New sections are additive.
