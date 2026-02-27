# MOSAIC-PRINCIPLES.md
## Design Principles Catalog

**Version:** 1.3
**Created:** 2026-02-23
**Classification:** Shared — Distributable across all Mosaic instances

---

## 1. About This File

This file catalogs the named design principles of the Mosaic knowledge system. These principles emerged empirically across 28+ sessions of building, tuning, and maintaining a production agent knowledge system. None were predicted from theory; all were discovered through observation.

**Audiences:**
- **Builders** creating new Mosaic instances or domains — use the Invocation Map (section 6) to find which principles activate at each build phase
- **Maintainers** operating existing instances — reference during tuning, auditing, and structural improvement
- **Adopters** evaluating the Mosaic methodology — the principles explain WHY the architecture works the way it does

**Relationship to other files:**
- **MOSAIC-REASONING** contains the ambient reasoning subset — the seven epistemic dispositions in section 7 that shape every agent conversation, plus the full epistemological frameworks in section 6. This catalog REFERENCES those sections; it does not duplicate them.
- **DOMAIN-BOOTSTRAP** contains build-phase checkpoints that invoke specific principles at the moment they're needed during domain construction.
- **Instance CLAUDE.md** files contain Level 3 (instance-specific) rules with pointers back to this catalog for methodology.

**This file is NOT loaded into agent kernel.** It is a builder and maintainer reference document (~20 KB). Agents don't need build methodology on every conversation — they need the epistemic dispositions in MOSAIC-REASONING section 7 and the frameworks in section 6. This file is consulted during builds, audits, and architecture decisions.

---

## 2. Level 1: Universal Agent Principles

These principles are true for any LLM-based agent knowledge system. They are not Mosaic-specific — they describe fundamental properties of how agents reason, how platforms behave, and how knowledge systems evolve.

### 2.1 Agent Cognition

How LLM agents process, retain, and reason with knowledge.

---

**U-001 Context Budget as Architectural Constraint**

Every agent platform imposes context limits (token windows, file size caps, retrieval ceilings). These are not technical limitations to work around — they are the resource economics that shape every design decision. Knowledge must "earn its budget."

- **Evidence:** Every Mosaic architecture decision filters through budget: 200 KB Claude.ai, 8K chars Copilot Studio, ~40 KB per retrieval file. The constraint produced the Core + Retrieval split, QUICK file architecture, and the six-layer domain model.
- **Test:** For any content in the kernel, ask: "Does this earn its budget by shaping reasoning, or is it consuming space with data that could be retrieved?" If the latter, it doesn't belong.
- **Anti-pattern:** Treating context budget as a problem to solve (compression, summarization, cramming) rather than an architectural constraint to design around.
- **Activates during:** Build (kernel/retrieval placement), maintenance (budget audits), architecture decisions

---

**U-002 Conversation as Unit of Coherence**

Agent context is per-conversation, not per-session or per-system. Topic transitions, domain loading, and context budget are all conversation-scoped. The agent starts fresh each conversation.

- **Evidence:** Fresh-conversation recommendations in test protocols. Domain loading happens per-conversation. Multi-conversation audit protocols split work across conversations to avoid context crashes.
- **Test:** Does your design assume the agent remembers something from a previous conversation? If so, the design is fragile — build for conversation-scoped coherence with external persistence for cross-conversation state.
- **Anti-pattern:** Designing features that depend on cross-conversation memory (e.g., "the agent will remember this client from last time"). LLM agents don't have sessions — they have conversations.
- **Activates during:** Build (conversation budget planning), maintenance (multi-conversation protocols)

---

**U-003 Human as Irreducible Bridge**

Some knowledge transitions require human judgment; no automation path exists. In multi-agent architectures, the human is often the only entity that can move information between agent contexts and decide when analytical findings become operational changes.

This principle has an operational manifestation: the division between automated and human-judgment layers. Automated population handles structured public data; human analysis handles strategic interpretation. The boundary between them is itself a design decision that cannot be automated.

- **Evidence:** Monthly sync requires human copy-paste between Claude.ai and Claude Code — no agent-to-agent channel exists. Audit-then-transfer workflows require human judgment about which findings to act on. The Copilot Studio observation "Agents maintain layers; humans interpret" is this principle applied to operational maintenance.
- **Test:** For any proposed automation: "Can this be done without human judgment?" If the task involves interpreting ambiguity, choosing between valid alternatives, or moving information across agent boundaries, the human is irreducible.
- **Anti-pattern:** Trying to automate the human out of a judgment loop. Also: assuming agents will spontaneously coordinate without a human bridge.
- **Activates during:** Build (automation boundary design), maintenance (sync protocols), architecture decisions

---

**U-004 Reflexive Architecture**

A mature knowledge system formally reasons about and modifies its own cognitive architecture as a first-class activity. The system's design principles apply to the system itself.

- **Evidence:** The tuning register, kernel epistemology framework, architecture roadmap, and "agent experience as design data" all emerged from the system observing and modifying itself. This catalog is itself an act of reflexive architecture.
- **Test:** Can the system articulate why its own architecture is structured the way it is? If the architecture is implicit, the system can't reason about improving it.
- **Anti-pattern:** Treating system architecture as fixed infrastructure rather than as a living artifact that evolves through self-observation.
- **Activates during:** Architecture decisions, tuning, maintenance audits

---

**U-005 Recovery Point Architecture**

LLM context is ephemeral. Any durable build process requires explicit checkpoints that survive context loss. Implementation briefs, plan persistence, and memory files are not documentation — they are recovery points.

- **Evidence:** Implementation briefs were created after losing refined analysis to context compaction. Plan mode persistence was added after a plan's reasoning was lost mid-build. Every complex multi-step operation now starts with a recovery point.
- **Test:** If context resets right now, can the next session pick up where this one left off? If not, a recovery point is missing.
- **Anti-pattern:** Treating context as durable. Starting complex work without writing the plan down first. Assuming the conversation will last long enough to finish.
- **Activates during:** Build (plan mode), maintenance (multi-step operations), any complex task

---

**U-012 Interception as Failure Mode**

When the same information exists at multiple distances from the agent, the agent finds the closer copy and stops before reaching the canonical source. Duplicated content does not reinforce — it intercepts.

This extends beyond files to within-file attention gradients (partial answers early in a file stopping deeper reading) and within-conversation interception (earlier-loaded content satisficing before the right file is retrieved).

For the full framework, see MOSAIC-REASONING section 6.3.

- **Evidence:** Phase 5 validation showed removing an inline copy improved benchmark scores because the agent followed the pointer to the deeper canonical source. TUN-014 showed scripted outputs intercepting natural reasoning.
- **Test:** For any content that exists in two places: "Will the agent find the closer copy and stop?" If yes, you have an interception risk. Replace the duplicate with a pointer.
- **Anti-pattern:** Putting "helpful summaries" of detailed content in QUICK files. Adding "convenient copies" of reference data to kernel files. Any duplication intended to make things easier to find.
- **Activates during:** Build (file structure), maintenance (content placement), tuning (directive design)

### 2.2 Agent Behavior

How agent platforms respond to directives, questions, and configuration.

---

**U-006 Behavioral Salience Follows Proximity to Identity**

The closer a directive is to the agent's self-concept (identity layer), the stronger its effect on what the agent decides to DO — not just how it responds. Identity-layer framing controls agent actions; instruction-layer framing controls response quality.

- **Evidence:** Copilot Studio three-layer testing: Description field ("your value is actively searching...") restored enterprise search that had been suppressed. Instructions field shaped synthesis quality but didn't change what the agent searched. Knowledge files had lowest behavioral salience.
- **Test:** Is your most critical behavioral directive in the identity layer or buried in a knowledge file? If the agent isn't doing something, check which layer the directive lives in.
- **Anti-pattern:** Putting critical action directives ("always search enterprise systems") in knowledge files where they have low salience, while the identity layer says something contradictory.
- **Activates during:** Tuning, agent configuration, multi-agent design

---

**U-007 Question Framing Drives Cognitive Posture**

The user's question type determines the agent's reasoning mode more powerfully than any behavioral directive. Strategic questions produce strategic reasoning; data-pull questions produce assembly mode. This is a platform property, not a tuning failure.

- **Evidence:** Same Copilot agent, same directives: "What's our engagement with X?" triggered category-organized assembly. "What should I know before a meeting with X?" triggered intelligence-mode analysis with talking points and sovereignty framing. No directive changed this.
- **Test:** If the agent is in "assembly mode" when you want strategic reasoning, try reframing the question before adjusting directives. The question type is the strongest lever.
- **Anti-pattern:** Writing increasingly detailed directives to force a reasoning mode that the question type naturally suppresses.
- **Activates during:** Tuning, user training, recipe design

---

**U-008 Fix the Data, Not the Behavior**

When correct behavioral directives produce wrong answers, the root cause is usually data quality, not tuning. Agents faithfully execute instructions against whatever data they have.

- **Evidence:** IHS Area field was 14% populated. Agent filtered on the field and returned a count. Correct behavior, wrong data. The fix was populating the field, not changing the directive.
- **Test:** Before tuning a directive, check: "Is the underlying data correct and complete?" If not, fix the data first. Behavioral tuning on bad data produces well-formatted wrong answers.
- **Anti-pattern:** Adding behavioral directives to compensate for data quality issues. "Don't trust the IHS Area field" is a band-aid; populating the field correctly is the fix.
- **Activates during:** Tuning (diagnosis phase), maintenance (data quality)

---

**U-009 Platform Defaults Are Structural**

Every agent platform has behavioral defaults that text directives cannot override. These are structural properties of the platform, not tuning failures. Identify them empirically, then optimize quality within them rather than fighting them.

- **Evidence:** Copilot Studio category-first organization on data questions persisted through 4 rounds of increasingly explicit directives. It's a platform default. Optimizing synthesis quality within categories (which IS tunable) was the productive path.
- **Test:** Has a behavioral change failed after 2+ rounds of directive adjustment? It may be a platform default. Test whether the behavior changes with a completely different question type — if it does, the behavior is question-dependent, not directive-dependent.
- **Anti-pattern:** Escalating directive complexity to override a structural platform behavior. Writing "IMPORTANT: do NOT organize by category" in increasingly bold formatting.
- **Activates during:** Tuning (diagnosis), agent configuration, platform evaluation

---

**U-014 Reasoning Depth Varies Across Agents**

Different agents (and platforms) vary in spontaneous reasoning depth — premise validation, data quality questioning, cross-system synthesis. This is a platform capability property, not a tuning parameter.

- **Evidence:** Claude spontaneously noticed IHS Area was 14% populated and searched the web for the authoritative count. Copilot filtered the field and returned whatever it found. Same directive, same knowledge file, different reasoning depth. This is a platform characteristic.
- **Test:** Before designing a multi-agent workflow, test each agent's reasoning depth on the same query. Route tasks requiring deep reasoning (premise validation, data quality diagnosis) to the agent with native depth for that task.
- **Anti-pattern:** Expecting tuning to give an agent reasoning capabilities it doesn't natively have. Also: designing a single-agent architecture when tasks require different reasoning depths.
- **Activates during:** Multi-agent design, tuning (failure diagnosis), platform evaluation

### 2.3 System Design

How knowledge systems should be structured and evolved.

---

**U-010 Discovery Is Not Authorization**

The agent discovers and proposes; the human decides when findings become edits. Analysis and editing are separate activities with separate governance. Finding information does not authorize acting on it.

- **Evidence:** Session protocol rule applied consistently: "Present analysis and wait for user direction before editing files." Prevents the agent from conflating research with action. User commentary on findings does NOT equal approval to apply changes.
- **Test:** Before any edit: "Did the user explicitly authorize this change, or am I inferring authorization from their interest in my analysis?"
- **Anti-pattern:** Agent makes edits based on analytical findings without explicit user approval. "The user seemed interested in my recommendation, so I went ahead and implemented it."
- **Activates during:** Runtime (every session), maintenance, build

---

**U-011 Volatile Data in Stable Text Creates Drift**

Never hardcode a count, date, status, or other volatile value in narrative text. Reference the definitive source instead. Static values in prose always diverge from reality — not immediately, but inevitably.

- **Evidence:** File counts and client counts in prose diverged from actual tables within weeks. "We serve 44 tribal nations" became wrong when the 45th was added but the prose wasn't updated. The table was updated; the prose was not.
- **Test:** Search for hardcoded numbers in narrative text. For each one: "Will this value change? If so, does it reference its source?" Counts belong in tables and metrics; prose points to them.
- **Anti-pattern:** "We currently have 12 reference files covering 6 domains." Both numbers will change. Write: "count = IP-MAINTENANCE section 2.1 manifest."
- **Activates during:** Build (content authoring), maintenance (content review), every edit session

---

**U-013 Empirical Discovery over A Priori Design**

The most important principles of agent system design cannot be predicted from first principles — they emerge from observing real agent behavior on real queries. "Authority kills curiosity" was not predictable. "Foundation + Freedom" was not deducible. Build iteratively from real queries, not from abstract completeness checklists.

- **Evidence:** 15 tuning register entries, all discovered through iteration, none predicted from theory. The domain architecture that works best was built by running actual questions and discovering what was missing — not by designing top-down from a completeness checklist.
- **Test:** Is the current design decision based on observed behavior or theoretical prediction? If theoretical, test it empirically before committing.
- **Anti-pattern:** Designing a complete knowledge architecture on paper before running a single query. Over-engineering from imagined requirements rather than discovered needs.
- **Activates during:** Build (domain construction), tuning, architecture decisions

---

## 3. Level 2: Mosaic Architecture Principles

These principles are specific to the Mosaic pattern (Core + Retrieval architecture with shared reasoning kernel, instance-specific domain files, and MCP-based retrieval). They apply to any Mosaic deployment but may not generalize to all agent knowledge systems.

### 3.1 Knowledge System Dynamics

How knowledge evolves, synchronizes, and maintains integrity across layers.

---

**A-001 Three Learning Loops**

Knowledge systems improve through three concurrent loops operating at different speeds and producing different returns:
- **Loop 1 (Data):** Freshen facts — update values, correct errors, fill gaps. Linear improvement. Most frequent.
- **Loop 2 (Reasoning):** Improve reasoning patterns — refine frameworks, add principles, tune directives. Compounding improvement. Each reasoning upgrade makes all future data more useful.
- **Loop 3 (Substrate):** Expand architecture — add domains, restructure files, build new capabilities. Transformative improvement. Each substrate change creates new surfaces for Loops 1 and 2.

- **Evidence:** Knowledge delta pipeline design revealed these three loops operating concurrently. Data freshening (Loop 1) happened weekly. Reasoning improvements (Loop 2) happened across sessions with compounding effects. Architecture expansion (Loop 3) happened in phases with transformative effects.
- **Test:** For any proposed change: "Is this Loop 1 (data), Loop 2 (reasoning), or Loop 3 (substrate)?" Each loop has different governance, frequency, and risk profile.
- **Anti-pattern:** Treating all knowledge changes as Loop 1 (data updates). Applying Loop 1 governance (auto-apply, high frequency) to Loop 2 or Loop 3 changes.
- **Activates during:** Maintenance (change classification), build (architecture decisions), pipeline design

---

**A-002 Reference Files Are Views, Not Sources of Truth**

Reference files materialize a view from live sources combined with curated overlay. They are not authoritative copies of reality — they are agent-readable projections of organizational knowledge. Build regeneration logic, not synchronization logic.

- **Evidence:** Client profiles combine HubSpot data (regenerable) with manually curated intelligence (not regenerable). The reference file is a VIEW that joins these sources. When HubSpot data changes, the view should be regenerated, not manually synchronized field-by-field.
- **Test:** For each section of a reference file: "Can this be regenerated from a source system, or is it manually curated?" The answer determines the maintenance model.
- **Anti-pattern:** Treating reference files as the source of truth and manually keeping them in sync with source systems. Building synchronization workflows instead of regeneration workflows.
- **Activates during:** Build (file design), maintenance (update patterns), pipeline design

---

**A-003 Three Data Tiers**

Different data has different governance:
- **Generated:** Pipeline can regenerate from source systems. Auto-apply with confidence gating.
- **Enriched:** Human adds value to generated data (corrections, context, cross-references). Surgical integration — preserve enrichments when regenerating the generated layer.
- **Curated:** Human-authored content with no source system (strategic assessments, relationship notes). Manual updates only — never overwrite.

- **Evidence:** Client profiles have all three tiers: generated (HubSpot deal data), enriched (human-corrected entity names), curated (intelligence assessments). Treating all three the same either breaks enrichments or fails to update generated data.
- **Test:** For any proposed automated update: "Will this overwrite enriched or curated data?" If yes, the automation boundary is wrong.
- **Anti-pattern:** Full-file regeneration that overwrites curated content. Or: refusing to automate generated data because the file also contains curated data.
- **Activates during:** Pipeline design, maintenance (update protocols), build (file structure)

---

**A-004 Confidence Gating**

Source trust determines automation level. High-confidence source changes auto-apply; lower-confidence changes stage for human review. Reasoning and architectural changes are never automated regardless of source confidence.

- **Evidence:** Delta pipeline design: T1 (internal systems) deltas could auto-apply for Generated tier data. T3-T4 (external) deltas always stage for review. Loop 2/3 changes (reasoning, architecture) always require human judgment even from T1 sources.
- **Test:** For any proposed automated change: "What is the source confidence AND what loop is this change?" Both must pass the gate.
- **Anti-pattern:** Auto-applying changes based on source confidence alone without considering what type of change it is. A high-confidence source can still produce a reasoning-level change that needs human review.
- **Activates during:** Pipeline design, maintenance automation

---

**A-005 Four-Layer Sync Problem**

Source systems, full reference files, QUICK summary files, and manifests each go stale independently. This is structural, not a design flaw — it's inherent to any system with multiple layers of abstraction. Maintenance must address all four layers explicitly.

- **Evidence:** IP-MAINTENANCE section 1 framing. Quarterly audits check all four layers. The most common drift pattern: source system changes, full file updates, but QUICK file and manifest are forgotten.
- **Test:** After any data change, check: "Did I update the full file AND the QUICK file AND the manifest?" If not, the sync is incomplete.
- **Anti-pattern:** Updating the full reference file and assuming the QUICK file and manifest will catch up. They won't — they're separate artifacts with separate update paths.
- **Activates during:** Maintenance (every update), build (file structure design)

---

**A-019 Phenomenological Feedback**

Agent self-report about kernel experience is design data, not anecdote. When an agent describes a file as "navigated rather than absorbed," that maps to the dispositional/procedural axis and predicts which content benefits from ambient presence vs. retrieval. Distinct from Loop 4 `[META]` observations, which capture reasoning errors — phenomenological feedback captures the agent's experience of architecture itself.

- **Evidence:** Claude.ai reported a 19 KB kernel file as "navigated rather than absorbed." Applying the dispositional/procedural classification section-by-section led to 39% reduction with zero behavioral regression and +1 score improvement. The agent's subjective experience predicted the classification outcome.
- **Test:** Ask the agent: "Which files feel like they've become part of how you think, and which feel like references you consult?" Files in the second category are pruning candidates. Validate with pre/post behavioral test.
- **Anti-pattern:** Dismissing agent self-report as non-actionable. Treating all kernel content as equally important because it passed the eligibility gate.
- **Activates during:** Phase 8 retroactive audits, kernel headroom reviews, post-build validation

### 3.2 Build Methodology

How to construct and evolve Mosaic knowledge architecture.

---

**A-007 QUICK File Architecture**

Two-tier retrieval pattern: a routing header (section 0) for domain entry, followed by numbered sections for targeted data. The routing header tells the agent what this domain covers and where to navigate — it's the table of contents the agent reads first.

QUICK files are subsets or condensations of fuller reference files. The subset vs. condensed distinction determines escalation behavior: subsets point to the full file for additional detail; condensations stand alone. QUICK files condense knowledge, process, and curated views — they should NOT carry operational state (open items, version manifests, metrics) or volatile counts that drift from source.

Every QUICK file should define **inclusion criteria**: what entities or content qualify for inclusion, and where non-qualifying items route instead. The routing header (§0) is the natural home for these criteria. When a domain covers multiple entity populations at different depths (e.g., active relationships vs. broader market), separate QUICK files with distinct inclusion criteria prevent unbounded growth and give the agent clear routing boundaries.

- **Evidence:** All 7 domain QUICK files use section 0 routing headers. Agent retrieves `get_section("filename", "0")` on domain entry instead of loading the whole file. This pattern emerged from observing that agents need routing context before they can make targeted retrieval decisions. The inclusion criteria pattern was discovered when a client QUICK file grew to cover both active relationships and market intelligence — separating them into distinct QUICK files with explicit admission rules restored routing clarity and prevented unbounded growth.
- **Test:** Can a new agent entering this domain read the routing header and know (a) what questions this domain answers, (b) where to navigate for each question type, (c) when to escalate to the full file, and (d) what qualifies for inclusion here vs. what routes elsewhere?
- **Anti-pattern:** QUICK files that are wholesale copies of the full file's first section. QUICK files without routing headers. QUICK files that accumulate lookup data beyond their budget justification. QUICK files without inclusion criteria that grow unboundedly as entities are added. QUICK files carrying operational state (open items, metrics, version manifests) that belongs in the full reference file.
- **Activates during:** Build (domain construction), maintenance (QUICK file audits)

---

**A-008 Atomic Multi-File Operations**

Distributed knowledge systems require operations that span multiple files atomically. Version bumps, file moves, structural changes, and principle additions all touch multiple locations — they succeed together or not at all.

- **Evidence:** The "2-part atomic operation" rule for version bumps: increment header version, update manifest row. Change history tracked in git. Any step done alone creates drift. File renames that don't update cross-references create broken pointers.
- **Test:** For any structural change: "How many files does this touch?" If more than one, list all affected files before starting. Check them off as you go. The manifest/index is the canary — if it's out of date, the operation is incomplete.
- **Anti-pattern:** "I'll update the manifest later." You won't. Or: updating one file and moving on, creating invisible inconsistencies that compound over time.
- **Activates during:** Build (every structural change), maintenance (every version bump)

---

**A-009 Progressive Entity Promotion**

Entities graduate through a lifecycle: invisible (not represented) to attribute (scattered mentions in other entities' files) to entity (dedicated reasoning framework) to domain (full retrieval architecture). The promotion trigger is when the entity becomes central to organizational reasoning and requires synthesis to understand.

The related ambient principle "Implicit knowledge is invisible knowledge" (MOSAIC-REASONING section 7) captures the entity-scale insight: when the system only knows something as an attribute of other entities, it can retrieve facts but cannot reason about the thing itself. The composite-concept corollary: when a composite concept (like "capability") depends on multiple components, every component must be legible to the system — if one is invisible, the composite reasoning is silently capped.

- **Evidence:** Clients were originally attributes scattered across deal records. Promoting them to first-class entities (with profiles, intelligence files, and a domain routing framework) transformed system capability. People are the next candidate (REC-013) — currently attributes, becoming central to reasoning.
- **Test:** Can the system answer "tell me about X" through reasoning, or does it require knowing which specific file to look in? If the latter, X is still an attribute, not an entity.
- **Anti-pattern:** Creating a dedicated file for something that is currently only mentioned as an attribute of one other entity. Promotion should follow demonstrated reasoning need, not anticipated importance.
- **Activates during:** Build (Phase 3 entity ontology), maintenance (entity graduation assessment)

---

**A-010 Absorption over Creation**

When new content is needed, prefer absorbing it into existing files over creating new ones. Fewer files means less routing complexity, fewer cross-references to maintain, and simpler retrieval patterns.

- **Evidence:** Phase 4 architecture decisions: DOA thresholds absorbed into IP-INDEX, process recipes absorbed into A2A-QUICK. Both were initially proposed as new files. Absorption proved correct — the routing was simpler and the agent found the content faster in context with related material.
- **Test:** Before creating a new file: "Can this content be absorbed into an existing file without exceeding its size ceiling or diluting its focus?" If yes, absorb. Create new files only when query patterns clearly diverge.
- **Anti-pattern:** Creating a new file for every new topic. File proliferation creates routing complexity that degrades agent performance more than the organizational benefit of separation.
- **Activates during:** Build (Phase 4 architecture decisions), maintenance (when adding content)

---

**A-011 Query-Pattern Boundaries for Splits**

When files must be split, split along query-pattern boundaries — different files for different question types. The question the user asks determines the file boundary, not content similarity or organizational hierarchy.

- **Evidence:** IP-SYSTEMS splits into CRM, M365, and infrastructure — not because of content similarity but because users ask different questions about each. "How do I add a deal in HubSpot?" and "What's our M365 license count?" never co-occur in the same conversation.
- **Test:** Do the two sections of this file get queried in the same conversations? If not, they're candidates for splitting. If yes, they should stay together even if they seem topically distinct.
- **Anti-pattern:** Splitting files by organizational hierarchy ("Technology > Sub-team A, Sub-team B") when all sub-teams are queried in the same conversations. Also: splitting by file size alone without considering query patterns.
- **Activates during:** Build (Phase 4 architecture), maintenance (when files exceed ~40 KB)

---

**A-014 Phased Risk Sequencing**

Sequence architectural changes by risk level — prove the pattern at incrementally higher stakes. Each phase validates before the next begins. Low-risk changes build confidence for higher-risk changes.

- **Evidence:** Architecture roadmap Phases 1-5: started with low-risk QUICK file restructuring, progressed to medium-risk kernel reorganization, deferred high-risk behavioral migration. Each phase's success validated the approach for the next. The 47-point benchmark recovery came from the lowest-risk phase.
- **Test:** Am I attempting a high-risk change before validating the approach on a low-risk version? Can I sequence this into phases where each phase is independently valuable and validates the next?
- **Anti-pattern:** "Big bang" migrations that change everything at once. Also: skipping validation between phases because "it's obvious the next step will work."
- **Activates during:** Build (phase planning), architecture decisions, any multi-step migration

---

**A-015 Build Playbook as Phased Pipeline**

Domain construction follows a phased pipeline: Skeleton (structure) to Discovery (data gathering) to Enrichment (human analysis) to MCP Enrichment (system integration) to QUICK Generation (kernel summary). Each phase has a defined actor, deliverable, and quality gate.

- **Evidence:** IP-MAINTENANCE section 8 build playbook. The pipeline emerged from observing which steps could be parallelized vs. which required sequential completion. The sequence is not arbitrary — each phase produces inputs the next phase consumes.
- **Test:** Before starting a domain build: "Am I following the phased pipeline, or am I jumping to a later phase before completing earlier ones?" Skeleton before enrichment; enrichment before QUICK generation.
- **Anti-pattern:** Writing the QUICK file before the full file exists. Enriching data that hasn't been validated in the skeleton phase. Skipping discovery because "we already know what's important."
- **Activates during:** Build (domain construction), maintenance (rebuild planning)

---

**A-017 Marker System as Construction Methodology**

Typed gaps ([MCP-TBD], [USER-INPUT-TBD], [PROCESS-TBD]) are first-class construction artifacts. Markers make incompleteness visible and actionable — they are counted, tracked, and have resolution paths. A file with explicit markers is more trustworthy than a file that looks complete but silently omits things.

- **Evidence:** IP-MAINTENANCE section 4.4, section 5.2. Marker counts are tracked in quarterly audits. Resolution paths vary by marker type: MCP-TBD markers wait for system integration; USER-INPUT-TBD markers wait for human knowledge; PROCESS-TBD markers wait for process documentation.
- **Test:** Does every gap in this file have a typed marker? Can someone reading the file tell what's missing and what the resolution path is?
- **Anti-pattern:** Leaving gaps unmarked ("we'll fill this in later" without a marker). Using a single generic marker type for all gaps. Treating markers as defects rather than construction methodology.
- **Activates during:** Build (Phase 5 artifact construction), maintenance (marker resolution)

**A-018 Narrative Qualification Test**

Prose in kernel files must pass five tests to earn its budget. Narrative that fails multiple tests is the highest-priority candidate for condensation to pointers or removal. The five tests synthesize kernel epistemology (MOSAIC-REASONING section 6.1), ambient context (section 6.2), and interception (section 6.3) into a narrative-specific rubric:

1. **Epistemological type** — Is this dispositional (shapes how the agent thinks) or hermeneutical (shapes how the agent interprets)? If yes, it earns budget. If it's ontological (what exists) or navigational (where to go) dressed as prose, it doesn't.
2. **Derivability** — Can the agent learn this from other loaded files, live systems, or structured data already in the kernel? If the same information is in another kernel file, the narrative creates interception (U-012), not reinforcement.
3. **Ambient necessity** — Does the agent need this before it knows it needs it? Content that shapes reasoning posture works by being present. Content that describes facts works just as well retrieved on-demand.
4. **Staleness risk** — Is this about facts that change? Static prose about dynamic facts is a future lie. Unlike tables, which pipelines can regenerate, stale narrative has no detection or correction mechanism.
5. **Landscape vs. curriculum** — Does this teach a reasoning pattern (curriculum), or describe the current state of the world (landscape)? Landscape descriptions go stale and can be derived. Curriculum compounds — it makes every future answer better.

The most common failure pattern: a behaviors file that was written as the "tell the agent everything" file before the system decomposed into specialized files. It accumulates duplicated retrieval protocol, system lists, escalation reasoning, and counting rules from other kernel files — creating interception where the agent finds shallow copies and stops before reaching canonical sources.

- **Evidence:** Narrative audit (Session 33) of six kernel files. IP-CLAUDE-BEHAVIORS contained ~1.7 KB of duplicated content from IP-DOMAIN-ROUTER, MOSAIC-REASONING, IP-INDEX, IP-A2A-QUICK, and IP-TAXONOMY-QUICK. IP-TAXONOMY-QUICK passed cleanly — its narrative was almost entirely hermeneutical (teaching reasoning patterns). MOSAIC-REASONING passed cleanly — pure curriculum throughout. The distinction was not file size but narrative quality: files with hermeneutical/dispositional narrative earned budget; files with ontological/navigational prose dressed as narrative did not.
- **Test:** For each prose paragraph in a kernel file, apply the five tests. Score: earns budget (3+ pass), marginal (2 pass), candidate for condensation (0-1 pass). The harshest filter: narrative that is ontological, derivable, non-ambient, stale-prone, and landscape-descriptive is the lowest-value content in the kernel.
- **Anti-pattern:** Grandfathering narrative because it was written early. Leaving "helpful context" paragraphs that duplicate content from other kernel files. Treating interception elimination as less important than byte savings — the reasoning quality improvement from reaching canonical sources exceeds the budget recovery.
- **Activates during:** Build (content authoring), maintenance (budget audits, narrative review), Session 1-type behavioral rewrites

---

**A-020 Navigation vs. Absorption Test**

When an agent reports content feels navigated (consulted at point of use) rather than absorbed (internalized, shaping all reasoning), the content is a retrieval candidate. Inverse of the ambient context principle (MOSAIC-REASONING §6.2). Applied at the section level within files that have already passed the kernel eligibility gate.

- **Evidence:** Same as A-019. Delta formatting content (schema, worked examples, posting instructions) was "navigated" — 65 lines consuming ambient budget. Type table and confidence gating (15 lines) were "absorbed" — they shaped delta awareness. After moving navigated content to retrieval, delta emission improved from 0 to 2 inline deltas despite less formatting guidance being ambient.
- **Test:** Would the agent's reasoning quality change if this section were absent at the start of the conversation? If no — retrieval candidate. If yes — must be ambient. The counterfactual test distinguishes content that shapes reasoning from content consumed at a workflow moment.
- **Anti-pattern:** Assuming that content which is useful is therefore ambient. Useful-at-a-moment content can be retrieved at that moment. Only content that shapes reasoning before the moment arrives must be ambient.
- **Activates during:** Build (kernel content authoring), maintenance (section-level kernel audits)

---

### 3.3 Multi-Agent Design

Principles for systems with multiple agents or agent types.

---

**A-006 Tuning Methodology**

Agent tuning is distinct from maintenance (data currency), build (new knowledge), and structural improvement (reorganization). Tuning improves how agents reason with existing knowledge — same reference files, same data, different output quality.

The methodology has five detection channels (user observation, benchmark/smoke test, agent self-observation, cross-agent comparison, maintenance audit), and six best practices: diagnose before prescribing, one directive per failure mode, parity check across agents, smoke test after every edit, log the principle, and frame as current state.

The canonical example: zero knowledge changes, four behavioral edits, 47-point benchmark improvement.

- **Evidence:** IP-MAINTENANCE section 5G tuning register. 15 tuning entries, each discovered through the detection-diagnosis-fix-test cycle. The methodology itself emerged from observing what worked across those 15 entries.
- **Test:** Before writing a behavioral directive: "Have I diagnosed the specific failure mode at the individual query level?" If not, diagnosis is incomplete.
- **Anti-pattern:** Writing broad behavioral directives hoping they improve general performance. Bundling multiple behavioral changes in a single edit (makes attribution impossible). Skipping the smoke test.
- **Activates during:** Tuning sessions, behavioral regression investigation

---

**A-012 Multi-Agent Parity Produces Generality**

The constraint of supporting multiple agents (Claude + Copilot, or any multi-platform deployment) forces all reasoning to be agent-agnostic. This constraint, rather than being a burden, pushes methodology toward higher portability. What works for both agents is more likely to work for a third.

The operational insight that "each agent makes the others smarter" is a manifestation of this principle: when one agent's behavioral improvement is tested for parity with the other, both agents improve. Search agents finding better because reference files tell them where to look; reasoning agents querying better because reference files provide IDs and patterns.

- **Evidence:** Behavioral Parity Check rule: every tuning insight gets evaluated for both agents. The shared reasoning kernel (MOSAIC-REASONING) exists because multi-agent support required agent-agnostic reasoning. Instance-specific content (behaviors, platform config) is the only thing that varies.
- **Test:** Does this behavioral directive apply to one agent or all agents? If only one, document why. The default assumption is parity.
- **Anti-pattern:** Writing agent-specific directives without checking if they generalize. Building reasoning frameworks that only work with one agent's capabilities.
- **Activates during:** Tuning (parity check), build (architecture decisions), agent evaluation

---

**A-013 The Portability Seam**

Shared methodology lives in one repository; instance-specific content lives in another. The boundary between them IS the portability boundary. Everything in the shared repo is methodology — portable to any organization. Everything in the instance repo is customization — specific to one organization.

- **Evidence:** The Mosaic/mosaic-ip repo split. MOSAIC-REASONING (shared) contains no company names, system IDs, or entity data. Instance files contain all organization-specific content. A new organization starts with the shared repo and builds their instance.
- **Test:** Does this content contain any organization-specific data (names, IDs, entity lists)? If yes, instance repo. If no, shared repo. There's no middle ground.
- **Anti-pattern:** Putting methodology in instance files where it can't travel. Putting instance data in shared files where it pollutes the methodology.
- **Activates during:** Build (file placement), maintenance (content authoring), every edit session

---

**A-016 Worked Examples with Anti-Patterns**

Behavioral directives are most effective when they include both the correct path and the incorrect path. Anti-pattern examples ("compare the bad path") are as powerful as positive examples for shaping agent behavior. Agents learn boundaries from seeing what NOT to do.

- **Evidence:** TUN-009 principle. IP-CLAUDE-BEHAVIORS worked examples include both good and bad response patterns. Directives with anti-patterns produced more consistent behavior than directives with only positive examples.
- **Test:** Does this behavioral directive show the agent both what to do AND what not to do? A directive without an anti-pattern example is half a directive.
- **Anti-pattern:** (Meta: this entry is itself an example.) Writing directives that only describe the desired behavior without showing what violation looks like.
- **Activates during:** Tuning (directive design), build (behavior file authoring)

---

## 4. Level 3: Instance Rules

Level 3 rules are specific to one Mosaic instance (one organization's deployment). They live in instance CLAUDE.md files, not in this shared catalog.

**Examples from the originating instance:**
- File naming conventions (IP-* prefix)
- Specific system IDs (GIDs, platform identifiers)
- Tribal data sovereignty rules (specific to the organization's mission)
- Sensitivity tiering (Tier 1/2 mapping to specific data types)
- Git workflow for the instance repo
- Session protocol specifics (upload procedures, blob sync)
- PowerShell coding rules

**The Level 3 test:** If this rule references a specific organization, system, person, or entity, it's Level 3. If it describes a pattern that any Mosaic instance would follow, it's Level 2 and belongs here.

**Promotion path:** When an instance-specific rule is discovered to be general, promote it: write the full entry at the new level in this catalog, replace the instance-specific definition with a pointer, and note "Promoted from Level 3."

---

## 5. Governance: Adding New Principles

Principles are discovered empirically (U-013). When a new one surfaces, follow this process:

### 5.1 Discovery and Documentation

1. **Observe** — Notice the pattern in at least one concrete instance. What behavior did you see? What was the failure mode or the success pattern?
2. **Name** — Give it a short, memorable name. The name should evoke the insight without needing to read the definition.
3. **Test for generality** — Is this true only for this instance (Level 3), for any Mosaic deployment (Level 2), or for any agent system (Level 1)?
4. **Write the entry** — Name, definition (one sentence), evidence, test, anti-pattern, activation context. Follow the format used in sections 2 and 3 above.
5. **Place at the right level** — Level 1 in section 2, Level 2 in section 3, Level 3 in instance CLAUDE.md.

### 5.2 Integration (Atomic Operation)

All affected files update in the same session:

| Step | Action | File |
|------|--------|------|
| 1 | Write full entry | MOSAIC-PRINCIPLES (this file) |
| 2 | Add to Quick Reference Index | MOSAIC-PRINCIPLES section 7 |
| 3 | IF ambient epistemic disposition: add one-line entry | MOSAIC-REASONING section 7 |
| 4 | IF build-relevant: add checkpoint to appropriate phase | DOMAIN-BOOTSTRAP |
| 5 | Update instance CLAUDE.md if it affects build rules | Instance CLAUDE.md |
| 6 | Version bump all changed files | Headers + changelogs |
| 7 | Submit proposal (Level 1/2 only) | Mosaic/proposals/ |

**The section 7 gate test:** Only epistemic dispositions earn MOSAIC-REASONING section 7 budget — principles that shape how the agent reasons on every conversation. Builder/architect principles (system design, context budget, recovery points) belong in this catalog and DOMAIN-BOOTSTRAP checkpoints, not in the ambient reasoning table. The test: "Does this shape how the agent reasons, or how the system is designed?" If the latter, it's not ambient.

### 5.3 Promotion

When an instance-specific rule is discovered to be general:
1. Write the full entry at the new level in this file
2. Replace the instance-specific definition with a pointer to the canonical entry
3. Follow the integration protocol above for the new level
4. Note in the entry: "Promoted from Level 3. Originally discovered as [instance-specific context]."

### 5.4 The Discipline Rule

This governance process is itself an instance of A-008 (Atomic Multi-File Operations). When you add a principle, all affected files update together. The Quick Reference Index (section 7) is the sync canary — if a principle exists in the catalog but not in the index, the sync is incomplete.

---

## 6. Invocation Map

When do principles activate, and through what mechanism?

| Context | Principles That Activate | Mechanism |
|---------|--------------------------|-----------|
| **Every conversation** (ambient) | MOSAIC-REASONING section 7 dispositions + section 6 frameworks | Loaded in agent kernel — always present |
| **New instance bootstrap** | All Level 1 + Level 2 | DOMAIN-BOOTSTRAP protocol references at each phase |
| **New domain build** | A-007, A-008, A-009, A-010, A-011, A-014, A-015, A-017, U-001 | DOMAIN-BOOTSTRAP phase checkpoints |
| **Tuning session** | A-006, U-006, U-007, U-008, U-009, U-013, U-014 | Tuning methodology (A-006) |
| **Maintenance session** | A-005, A-008, A-018, U-010, U-011 | Maintenance protocols reference this catalog |
| **Architecture decision** | U-001, U-004, A-010, A-011, A-012, A-013 | Architecture roadmap references this catalog |
| **Plan mode** | U-005, U-010, A-008, A-014 | CLAUDE.md plan mode rules |
| **File editing** | U-011, U-012, A-008, A-013, A-018 | CLAUDE.md session protocol |

---

## 7. Quick Reference Index

All 32 named principles with one-line definitions. For full entries with evidence, tests, and anti-patterns, see the section references.

### Level 1: Universal Agent Principles

| ID | Name | One-Line Definition | Section |
|----|------|---------------------|---------|
| U-001 | Context Budget as Architectural Constraint | Platform context limits are resource economics, not obstacles. | 2.1 |
| U-002 | Conversation as Unit of Coherence | Agent context is per-conversation, not per-session. | 2.1 |
| U-003 | Human as Irreducible Bridge | Some transitions require human judgment; no automation path exists. | 2.1 |
| U-004 | Reflexive Architecture | The system reasons about and modifies its own architecture. | 2.1 |
| U-005 | Recovery Point Architecture | Durable processes require explicit checkpoints that survive context loss. | 2.1 |
| U-012 | Interception as Failure Mode | Duplicated content intercepts lookups; pointers deepen them. See MOSAIC-REASONING section 6.3. | 2.1 |
| U-006 | Behavioral Salience Follows Proximity to Identity | Identity-layer directives control actions; instruction-layer controls response quality. | 2.2 |
| U-007 | Question Framing Drives Cognitive Posture | Question type determines reasoning mode more than directives. | 2.2 |
| U-008 | Fix the Data, Not the Behavior | Wrong answers from correct directives usually mean bad data. | 2.2 |
| U-009 | Platform Defaults Are Structural | Some platform behaviors cannot be overridden by text directives. | 2.2 |
| U-014 | Reasoning Depth Varies Across Agents | Platforms differ in spontaneous reasoning depth. | 2.2 |
| U-010 | Discovery Is Not Authorization | Finding information doesn't authorize acting on it. | 2.3 |
| U-011 | Volatile Data in Stable Text Creates Drift | Hardcoded values in prose always diverge from reality. | 2.3 |
| U-013 | Empirical Discovery over A Priori Design | The most important principles emerge from observation, not theory. | 2.3 |

### Level 2: Mosaic Architecture Principles

| ID | Name | One-Line Definition | Section |
|----|------|---------------------|---------|
| A-001 | Three Learning Loops | Data freshening (linear), reasoning improvement (compounding), architecture expansion (transformative). | 3.1 |
| A-002 | Reference Files Are Views, Not Sources of Truth | Build regeneration logic, not synchronization logic. | 3.1 |
| A-003 | Three Data Tiers | Generated (regenerable), Enriched (preserve), Curated (manual only). | 3.1 |
| A-004 | Confidence Gating | Source trust + change type together determine automation level. | 3.1 |
| A-005 | Four-Layer Sync Problem | Source, full file, QUICK file, and manifest each go stale independently. | 3.1 |
| A-006 | Tuning Methodology | Five detection channels, six best practices, diagnose-before-prescribing. | 3.3 |
| A-007 | QUICK File Architecture | Two-tier retrieval with routing header, inclusion criteria, and no operational state. | 3.2 |
| A-008 | Atomic Multi-File Operations | Multi-file changes succeed together or not at all. | 3.2 |
| A-009 | Progressive Entity Promotion | Entities graduate: invisible to attribute to entity to domain. | 3.2 |
| A-010 | Absorption over Creation | Prefer absorbing content into existing files over creating new ones. | 3.2 |
| A-011 | Query-Pattern Boundaries for Splits | Split files along question types, not content similarity. | 3.2 |
| A-012 | Multi-Agent Parity Produces Generality | Supporting multiple agents forces portable methodology. | 3.3 |
| A-013 | The Portability Seam | Shared repo = methodology (portable). Instance repo = customization (specific). | 3.3 |
| A-014 | Phased Risk Sequencing | Prove the pattern at incrementally higher stakes. | 3.2 |
| A-015 | Build Playbook as Phased Pipeline | Skeleton to Discovery to Enrichment to MCP to QUICK. | 3.2 |
| A-016 | Worked Examples with Anti-Patterns | Show agents both the correct path and the incorrect path. | 3.3 |
| A-017 | Marker System as Construction Methodology | Typed gaps are first-class construction artifacts, not defects. | 3.2 |
| A-018 | Narrative Qualification Test | Prose earns kernel budget through five tests: epistemological type, derivability, ambient necessity, staleness risk, landscape vs. curriculum. | 3.2 |
| A-019 | Phenomenological Feedback | Agent self-report about kernel experience is actionable design data. | 3.1 |
| A-020 | Navigation vs. Absorption Test | Navigated content is a retrieval candidate; absorbed content must be ambient. | 3.2 |

---

## Maintenance

- **Version track:** MOSAIC-PRINCIPLES follows its own version (v1.0, v1.1, etc.).
- **No company-specific data:** This file contains methodology only. If you find organization-specific names, IDs, or entity data, they should be removed or genericized.
- **Sync canary:** If a principle exists in sections 2-3 but not in the Quick Reference Index (section 7), the sync is broken.
- **Backwards compatibility:** New principles are additive. Existing principles may be refined (evidence, tests, anti-patterns) but their core definitions should remain stable. If a principle is discovered to be wrong, document why and deprecate it rather than silently removing it.
