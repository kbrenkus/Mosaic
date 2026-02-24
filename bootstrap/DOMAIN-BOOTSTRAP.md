# DOMAIN-BOOTSTRAP-PROTOCOL v0.3

> **Purpose:** A repeatable, teachable process for building new knowledge domains — whether adding a domain to an existing system or bootstrapping a new organization's knowledge architecture from scratch.
>
> **Design principle:** This protocol is a curriculum, not a checklist. Each phase teaches *why* the work matters and *how to recognize* when it's complete. It follows the Foundation + Freedom pattern: Foundation discovers what exists (generalizable), Freedom discovers how experts think (domain-specific). They converge to produce durable knowledge architecture.
>
> **Validated against:** One organizational deployment (Level 0, 70% -> ~88% projected) and two completed domains (Level 1, 72-82% -> ~87-92% projected). Retrospective validation details in Section 5.

---

## 1. Architecture Overview

The protocol operates at four levels, from most general to most specific:

```
Level 0: Organizational Discovery     "What kind of organization is this?"
    |                                   -> domain map, system inventory,
    |                                      steward assignments, culture profile,
    |                                      strategic context, invisible entities
    v
Level 1: Domain Bootstrap             "What does this domain contain?"
    |   (Foundation + Freedom tracks)   -> entity types, data map,
    |                                      reasoning frameworks, ontology,
    |                                      domain design brief
    v
Level 2: Architecture Design           "How should agents access this?"
    |                                   -> kernel vs. retrieval split,
    |                                      QUICK files, routing entries,
    |                                      entity-instance architecture
    v
Level 3: Enrichment Design             "How do we populate and maintain it?"
                                        -> discovery prompts, coverage gap
                                           detection, runtime behaviors,
                                           maintenance cadence
```

**Level 0** runs once per organization. It produces the map that all domain bootstraps build on.

**Levels 1-3** run once per domain. They produce the artifacts that make a domain operational in the knowledge architecture.

**Portability note:** Levels 0 and 1 are fully portable — they work for any organization and any domain. Level 2 assumes the Core + Retrieval architecture pattern (static kernel + dynamic retrieval). Level 3 is generated as an output of the earlier levels, not pre-written.

**Iteration note:** While the phases are numbered sequentially, real domain builds are iterative. Phases 2E and 3 especially may be revisited as construction (Phase 5) and enrichment (Phase 6) reveal new patterns or refine existing ones. The protocol describes the logical dependencies between phases, not a rigid waterfall. Think of it as: each phase must be *started* in order, but none is truly *finished* until the domain is validated.

---

## 2. Level 0: Organizational Discovery

> *Run once when deploying the knowledge architecture to a new organization. Skip if adding a domain to an existing deployment.*

Level 0 discovers the shape of the business before any domain is built. Its outputs inform every subsequent domain bootstrap.

### 2.1 Discovery Prompts

**O-1: Domain Landscape**
"What are the major functional areas of this organization? Not just department names — what are the *knowledge domains* where expertise lives? Where do decisions get made that require specialized understanding?"

*What you're listening for:* The natural boundaries where one kind of thinking ends and another begins. Sales thinks differently than Finance, even when they're looking at the same deal. Those thinking boundaries are your domain boundaries.

*Follow-up:* "How do these domains relate to each other? Are there hub domains that other domains reference constantly? Are there domains that exist at multiple levels — as a knowledge domain AND as a service line AND as a department?"

*You know you're done when:* You can draw a map of 5-10 domains with clear boundaries, name a person who "thinks in" each one, and identify which domains are hubs that others depend on.

**O-2: System Inventory**
"What systems does this organization use to run? Not just the IT asset list — where does *work actually happen*? Where do people go to do their jobs, track their work, communicate, and make decisions?"

*What you're listening for:* The difference between official systems and actual systems. The org chart says Salesforce, but the team actually tracks deals in a spreadsheet. Both matter — the official system has the data, the actual system has the truth.

*Critical follow-up:* "Which of these systems can talk to each other? Where are the manual handoffs? What data moves between systems automatically, and what requires someone to copy-paste or re-enter? What are the integration gaps?"

*Why this matters:* The absence of integration is often more architecturally consequential than the presence of systems. If all cross-system data flows are manual and the only shared key is a name string, that constraint shapes the entire agent architecture. The gap is as important as the inventory.

*You know you're done when:* You can list every system, who uses it, what entity types live in it, whether it's a system of record or convenience, AND map the integration topology — what connects, what doesn't, and where the manual handoffs are.

**O-3: Entity Landscape**
"What are the *things* this organization cares about? Customers, employees, contracts, projects, cases, products — what are the nouns that appear in every meeting?"

*What you're listening for:* Entities that span multiple domains. Customers touch Sales and Finance and Support. Employees touch HR and every other domain. These cross-cutting entities are where integration complexity lives — and where the most value comes from getting it right.

*Depth probe:* "For the most important entity types, how do you classify them? Not the official categories — the categories that actually change how you handle them. Are there multiple independent ways to categorize the same entity?"

*Why the depth probe matters:* Many domains require multi-dimensional classification. A customer entity might have both an entity type (Enterprise vs. SMB vs. Government) AND an entity class (Direct vs. Channel Partner) — these are independent axes that together determine how you engage. O-3 without the depth probe gets "customers" as a noun. With it, you get the classification matrix.

*You know you're done when:* You can list the core entity types, say which domains they touch, identify which domain is the "home" for each entity, and for the most important types, articulate the classification dimensions that matter.

**O-4: Information Culture**
"How does this organization think about information sharing? Is the default open or closed? What's sensitive and what isn't? How do decisions get communicated — formal process or hallway conversation?"

*What you're listening for:* The cultural defaults that will shape every reasoning framework you build. An organization that defaults to transparency needs sensitivity reasoning that identifies exceptions. An organization that defaults to confidentiality needs openness reasoning that identifies what can be shared. You can't design the Freedom layer without understanding the culture it operates in.

*Epistemological probe:* "Beyond what's sensitive, how does this organization think about *knowledge itself*? Is the default 'we know the answer' or 'we need to find out'? How much certainty is required before acting? Is uncertainty something to hide or something to name?"

*Why this matters:* These epistemological defaults shape the agent's behavioral layer. An organization that treats uncertainty as first-class information gets agents that flag confidence levels. An organization that prizes authority gets agents that defer to designated experts. Principles like "authority kills curiosity" or "reference files are a curriculum, not a database" emerge from understanding how the organization relates to its own knowledge.

*You know you're done when:* You can articulate the organization's information philosophy in one sentence, name 2-3 examples of how it manifests in practice, AND describe how the organization relates to uncertainty and expertise.

**O-5: Steward Identification**
"For each domain you've identified, who is the person that *thinks* in that domain? Not necessarily the department head — the person other people go to when they need to understand something deeply."

*What you're listening for:* Domain expertise, not positional authority. The best steward for a Finance domain might be the controller who's been there 15 years, not the CFO who joined last quarter. You want the person who has internalized the reasoning patterns — who can tell you what's "obvious" to them that others miss.

*Follow-up:* "For each person you named, what *kind* of authority do they have — decision rights, deep knowledge, or trusted relationships? Are there people who span multiple domains or serve as connectors between them?"

*You know you're done when:* Each domain has a named steward who has agreed to participate in the discovery process, and you understand whether their authority is positional, domain-based, or relational.

**O-6: Strategic Context**
"What is this organization trying to accomplish right now? What are the goals, the priorities, and the things that keep leadership up at night? What's the 1-year plan? The 3-year vision?"

*What you're listening for:* Time-bound organizational priorities that shape which domains to build first, what entities matter most, and how the knowledge architecture should be weighted. The difference between "we have 600 entities in our directory" and "75 of them are target accounts because of our 2026 growth strategy" is strategic context.

*Why this matters:* Strategic context determines domain priority order, entity tiering (which entities get deep profiles vs. directory stubs), and the reasoning frameworks that the kernel needs to support decision-making. Without this, you build domains in arbitrary order. With it, you build the ones that serve the strategy first.

*You know you're done when:* You can articulate the organization's top 3 strategic priorities and explain how each maps to one or more knowledge domains.

**O-7: AI/Automation Context**
"How does this organization currently use AI, automation, or intelligent tools? Who are the power users? What's worked and what hasn't? What do people wish the tools could do that they can't?"

*What you're listening for:* The existing agent landscape, integration patterns, cultural receptiveness to AI, and the boundaries people have already established. If AI agents already exist, they are systems in their own right — with capabilities, access boundaries, and behavioral norms. If the organization is new to AI, the cultural onboarding will shape how the Freedom layer is designed.

*Why this matters:* The multi-agent architecture (who can access what, how agents coordinate, what access boundaries exist) is both a system inventory item and an organizational capability. Agent access boundaries (e.g., "no agent gets clinical data access") are expressions of information culture, not just technical constraints.

*You know you're done when:* You can describe the current AI/automation landscape, name the agents or tools in use, map their capabilities and boundaries, and articulate the organization's cultural stance toward AI-assisted work.

**O-8: Invisible Entity Scan**
"Looking across all the domains you've identified — what nouns appear in *every* domain but have no domain of their own? What things does this organization reason about daily that are currently invisible to the architecture?"

*What you're listening for:* Entities that exist as attributes of other things but can't be reasoned about independently. The test: can the system answer "tell me about X" through reasoning, or does it require knowing which specific file to look in? If the latter, X is still an attribute, not a first-class entity.

*Why this is critical:* When the kernel only knows something as an attribute of other entities, the system can retrieve facts but cannot reason about the thing itself. If "people" only exist as team members, deal owners, and approval authorities, the system can look up facts but can't synthesize "tell me about Jane Smith" or reason about who to trust on a given topic. The invisible entity becomes a silent ceiling on every composite concept that depends on it.

*Common invisible entities:* People (exist as team members, deal owners, approval authorities — but have no reasoning framework), Processes (exist as steps in workflows — but can't be reasoned about as entities), Relationships (exist as attributes of deals or contacts — but can't be synthesized across contexts).

*You know you're done when:* You've examined every cross-domain noun and can either point to its home domain or flag it as an invisible entity that may need its own reasoning framework.

### 2.2 Level 0 Outputs

| Output | Description | Used By |
|--------|-------------|---------|
| Domain Map | Named domains with boundaries, stewards, hub relationships, and priority order | Every Level 1 bootstrap |
| System Inventory | All systems with owners, entity types, integration topology, and agent accessibility | Level 1 Foundation track |
| Entity Landscape | Core entity types with classification dimensions, home domains, and cross-domain bridges | Level 1 ontology construction |
| Culture Profile | Information philosophy, epistemological defaults, sensitivity norms, decision patterns | Level 1 Freedom track |
| Strategic Context | Goals, priorities, entity tiering implications, domain priority order | Level 1 domain selection and design |
| AI/Automation Profile | Current agents/tools, capabilities, access boundaries, cultural stance | Level 2 architecture design |
| Invisible Entity Register | Cross-domain entities that need reasoning frameworks or their own domain | Level 1 domain creation decisions |

### 2.3 Level 0 Retrospective (Post-First-Domain)

After completing the first domain bootstrap, return to Level 0 and run one additional prompt:

**O-R: Emergence Retrospective**
"What surprised you? What did you discover during the first domain build that you didn't expect? What assumptions broke? What architectural patterns emerged that you didn't plan?"

*What you're capturing:* Architectural insights that only emerge from building — hub-and-spoke domain relationships, the need for a Maintenance domain, principles like "curriculum not database." These are genuinely emergent and cannot be discovered by asking. They can only be captured retrospectively.

*Update the Level 0 outputs with these insights.* They become inputs to every subsequent domain bootstrap.

---

## 3. Level 1: Domain Bootstrap

> *Run once per domain. Requires Level 0 outputs (or equivalent organizational knowledge). The Foundation and Freedom tracks run in parallel and converge at Phase 3.*

### Overview

```
FOUNDATION TRACK                          FREEDOM TRACK
(generalizable, system-oriented)          (domain-specific, expert-guided)

Phase 1F: Substrate Audit                 Phase 1E: Expert Engagement
  "What systems hold this data?"            "Who thinks in this domain?"
  "What can agents actually access?"        "What makes them an expert?"
                |                                      |
Phase 2F: Data Mapping                    Phase 2E: Worldview Extraction
  "What does the data look like?"           "How do you evaluate X?"
  "What's the quality?"                     "What's your mental model?"
  "What are the relationships?"             "What do others miss?"
                |                           "What should we NOT build?"
                |                                      |
                +------------------+-----------------+
                                   |
                    Phase 3: Ontology Construction
                      Merge substrate (what exists) +
                      worldview (how to think about it)
                      -> Taxonomies, frameworks, patterns
                                   |
                    Phase 3.5: Domain Design Brief
                      Blueprint for steward review
                      before construction begins
                                   |
                    Phase 4: Architecture Decision
                      What earns kernel budget?
                      What goes to retrieval?
                      Entity-instance architecture?
                                   |
                    Phase 5: Artifact Construction
                      QUICK files, reasoning files,
                      router entries, entity templates,
                      behavioral directives
                                   |
                    Phase 6: Enrichment Design
                      Discovery prompts, coverage gap
                      detection, runtime behaviors,
                      maintenance cadence
                                   |
                    Phase 7: Validation
                      Benchmark queries, before/after
                      testing, steward review
```

---

### Phase 1F: Substrate Audit (Foundation Track)

> *Goal: Map every place this domain's knowledge currently lives — and what agents can actually access.*

**Prompt F1-1: System Inventory**
"Looking at [domain name], which systems from our organizational inventory hold data relevant to this domain? For each system, what entity types does it contain that belong to or touch this domain?"

*What you're building:* A source map — the list of systems and data types that will feed this domain. This is the raw material inventory before you start building.

*Technique:* Start with the Level 0 system inventory and filter for relevance. Then probe for hidden sources — spreadsheets, shared drives, email folders, institutional knowledge that hasn't been digitized.

*Critical addition — agent accessibility:* "For each system, can the AI agents access it programmatically? What are the connector limitations? What data is visible to MCP/API and what requires manual export or workarounds?"

*Why this matters:* The distinction between "system holds data" and "agent can access data" is foundational. If a CRM has custom objects that are invisible to the MCP connector, that drives the entire multi-agent execution model — you need manual exports, different agents for different access patterns, and workaround pipelines. Discover this in Phase 1, not Phase 5.

**Prompt F1-2: Current Knowledge Audit**
"Where does the existing knowledge architecture already know something about this domain? Which files, sections, or attributes currently reference [domain concept]?"

*What you're building:* A scatter map — showing how domain knowledge is currently distributed. This is how you find "invisible entities" (things the system knows facts about but can't reason about).

*What you're looking for:* Knowledge that exists as attributes of other entities rather than as entities in its own right. If "budget approval" only appears as a field in project records, the system can look up who approved a budget but can't reason about the approval process itself.

*Go beyond data distribution:* Also identify the *reasoning failures* caused by the scatter — what questions can the system NOT answer because this domain's knowledge is distributed as attributes? These reasoning failures become the success criteria for the finished domain.

**Completion criteria:**
- [ ] Every relevant system identified with entity types listed
- [ ] Agent accessibility assessed per system (MCP/API, manual, workaround needed)
- [ ] Every existing reference to this domain in the current architecture cataloged
- [ ] At least one "invisible entity" or scattered-knowledge pattern identified
- [ ] Reasoning failures from the scatter documented (these become success criteria)
- [ ] Data quality issues noted (inconsistent naming, stale data, system-of-record conflicts)

---

### Phase 1E: Expert Engagement (Freedom Track)

> *Goal: Identify the domain steward(s) and understand what makes them experts.*

**Prompt E1-1: Steward Introduction**
"Tell me about your role in [domain]. Not your job title — what do you actually *do* every day? What decisions do you make? What questions do people come to you with?"

*What you're listening for:* The shape of their expertise. Where they spend their time reveals what matters in this domain. What people ask them reveals what's hard to figure out without expertise.

**Prompt E1-2: Expertise Origins**
"How did you become the person who understands this? What did you learn the hard way that you wish someone had told you earlier?"

*What you're listening for:* The learning path reveals the reasoning patterns. "I learned that you can't just look at the contract value — you have to understand the funding source, because government funding has different rules than commercial funding" is a reasoning pattern hiding in a personal story.

**Prompt E1-3: Knowledge Landscape**
"Who else knows things about this domain that you don't? Where are the other pockets of expertise — people who see a different angle or have different experience?"

*What you're listening for:* Complex domains often have multiple knowledge holders with complementary expertise. The BD lead understands deal flow, the policy person understands the regulatory context, the tech lead understands the systems. A single steward is the primary guide, but the protocol should capture which other experts to consult during specific phases.

*Note on steward-as-builder:* Sometimes the domain steward is also the system architect (as happened with the Growth and People domains). This produces deeper integration but less external validation. If the steward is also the builder, plan for explicit external validation checkpoints — have someone else review the ontology and reasoning frameworks.

**Completion criteria:**
- [ ] Primary steward identified and engaged
- [ ] Their decision-making scope understood
- [ ] At least 2-3 "hard-won lessons" captured (these become reasoning pattern candidates)
- [ ] Secondary knowledge holders identified with their specific expertise areas
- [ ] Steward-as-builder scenario noted if applicable (plan extra validation)

---

### Phase 2F: Data Mapping (Foundation Track)

> *Goal: Understand the data in detail — types, relationships, quality, and flows.*

**Prompt F2-1: Entity Inventory**
"For each system identified in Phase 1F, what are the specific entity types? What fields matter? What are the relationships between entities?"

*Technique:* If you have MCP or API access to the systems, run exploratory queries. List object types, sample records, field names. If no programmatic access, interview the steward or system admin about what the screens look like and what data they enter.

**Prompt F2-2: Cross-System Identity**
"Do the same entities appear in multiple systems? How are they identified in each? Are the names consistent or do they vary?"

*What you're building:* The cross-system correlation map. This is almost always harder than expected. The same client might be "Acme Corporation" in one system and "ACME" in another and "Acme Corp" in a third. The same employee might have a formal name in HR and a nickname in chat.

*You know you're done when:* You can tell someone "Entity X is called Y in System A, Z in System B" for every major entity type.

**Prompt F2-3: Data Flow**
"How does data move between systems? When something changes in one system, does it update elsewhere? Are there manual handoffs? What breaks?"

*What you're building:* The integration map — where data flows automatically, where it requires manual effort, and where it falls through cracks. This directly informs the maintenance and enrichment design in Phase 6.

**Prompt F2-4: Data Quality Assessment**
"For each data source, how trustworthy is it? When was it last updated? What's known to be wrong or incomplete?"

*What you're building:* The confidence map. Not all data is equal. A system of record that's actively maintained is more trustworthy than a spreadsheet from last year. This informs which sources to prioritize and what caveats to attach.

**Prompt F2-5: Market/Universe Mapping**
"Is there a broader universe of entities beyond the ones we're currently tracking? For a client domain — what's the total addressable market? For a people domain — are there contractor or partner categories we're not tracking? For a compliance domain — are there regulations we should be monitoring?"

*What you're building:* The boundary between what you actively manage and what you should be aware of. This drives tiered depth architecture in Phase 4 — the distinction between entities that get full profiles and entities that get directory stubs.

*When to skip:* Not every domain has a "universe" beyond its active entities. Skip this for internally-bounded domains (like Maintenance).

**Completion criteria:**
- [ ] Entity types documented with key fields and relationships
- [ ] Cross-system identity mapping complete for major entity types
- [ ] Data flow documented (automatic, manual, broken)
- [ ] Data quality assessed per source (high/medium/low confidence)
- [ ] Broader entity universe mapped if applicable (total addressable market, external entities)

---

### Phase 2E: Worldview Extraction (Freedom Track)

> *Goal: Surface the expert's mental models, decision frameworks, and tacit knowledge.*

This is the most important and most difficult phase. Experts have internalized their reasoning to the point where they don't realize they're applying frameworks. The prompts below are designed to surface that invisible structure.

**Prompt E2-1: Evaluation Frameworks**
"When you look at [core domain concept], what do you evaluate? Walk me through a recent example — what did you look at first, what changed your assessment, what did you decide?"

*Technique:* Concrete examples surface reasoning better than abstract questions. Don't ask "What's your framework for X?" Ask "Tell me about the last time you had to decide X." Then listen for the implicit framework.

**Prompt E2-2: Pattern Recognition**
"What patterns do you see that others miss? When a new [entity type] comes in, what tells you early whether it's going to be straightforward or complicated?"

*What you're listening for:* Expert intuition often runs on pattern matching that can be decomposed into rules. "I can tell within 5 minutes whether a contract is going to be a problem" — great, what are the signals? Those signals become classification criteria in the ontology.

**Prompt E2-3: Taxonomy Elicitation**
"If you had to sort all [domain entities] into categories that matter for how you handle them, what would those categories be? Not the official categories — the ones that actually change how you think about them."

*What you're listening for:* The working taxonomy vs. the official taxonomy. HR might categorize employees by department, but the expert might categorize them by "self-directed vs. needs-structure" or "client-facing vs. internal." The working taxonomy reveals the reasoning patterns.

**Prompt E2-4: Cross-Domain Influence**
"When does a decision in your domain cascade into other domains? When does something happening in another domain change what you need to do?"

*What you're listening for:* The cross-domain bridges that the ontology needs to encode. These are often the most valuable insights because they're invisible to anyone who only thinks within one domain.

**Prompt E2-5: Failure Modes**
"What goes wrong in your domain? When something fails, how do you diagnose it? What's your mental checklist?"

*What you're listening for:* Diagnostic reasoning patterns. These are often the most operational and immediately useful frameworks — they tell the system how to help when things aren't working.

**Prompt E2-6: Tacit Knowledge Surfacing**
"What's something that's 'obvious' to you about [domain] that you've noticed other people consistently get wrong or overlook?"

*What you're listening for:* The gold. This surfaces the reasoning that's so internalized the expert doesn't even think of it as knowledge. These insights often become the most valuable reasoning patterns in the domain.

**Prompt E2-7: Negative-Space Design**
"What should this domain's knowledge system *not* try to do? What would over-engineering look like? Where's the line between useful reasoning support and something that's harmful, invasive, or just not worth the complexity?"

*What you're listening for:* Design constraints. The People domain's most important design decisions were about what NOT to build: no skills databases, no performance profiles, no surveillance instruments. For reasoning-heavy domains where the design space is vast, the boundaries are as important as the content. Without explicitly asking, stewards often assume you'll be reasonable about scope — but "reasonable" looks different to different people.

*Why this matters:* Over-engineering risk is highest in domains with rich reasoning patterns. A People domain could become a surveillance tool. A Finance domain could over-automate judgment calls. A Compliance domain could create rigid rules that prevent reasonable exceptions. The anti-patterns are domain-specific and must come from the expert.

**Prompt E2-8: Philosophical Stance**
"If you had to teach someone to *think* about this domain — not just work in it — what would you teach them? What beliefs about [domain] shape every decision you make?"

*What you're listening for:* The expert's meta-level reasoning about the domain itself. "Enterprise clients are strategic partners, not just revenue sources" isn't an evaluation framework — it's a worldview that shapes every framework. "Hierarchy tells you who decides, not who knows" isn't a diagnostic pattern — it's a philosophical stance about authority. These deep beliefs become the domain's design principles and often produce the most powerful reasoning frameworks.

*When this matters most:* Some domains are primarily operational (the expert shares procedures and patterns). Others are primarily philosophical (the expert shares a way of seeing the world). The People domain was deeply philosophical; the Technology domain was primarily operational. Both needed worldview extraction, but the philosophical domains need this prompt specifically.

**Prompt E2-9: Temporal Dimension**
"How do things in this domain change over time? What's the difference between a snapshot of today and the full story? When is the current state misleading because it doesn't account for history?"

*What you're listening for:* Temporal reasoning patterns. "People are temporal entities — a former Chairman now serving as Health Director brings governance perspective to clinical decisions." "A client that churned and came back has different trust dynamics than a new client." The history matters, and the system needs to know when to look beyond the current state.

**Completion criteria:**
- [ ] At least 2 evaluation frameworks documented (from concrete examples)
- [ ] Expert's working taxonomy captured (may differ from official categories)
- [ ] Cross-domain influence points identified (at least 3)
- [ ] At least 3 "tacit knowledge" insights surfaced
- [ ] Failure modes and diagnostic patterns documented
- [ ] Negative-space design constraints documented (what NOT to build)
- [ ] Philosophical stance captured (domain-level beliefs that shape all reasoning)
- [ ] Temporal dimension assessed (when history matters, when current state is misleading)

---

### Phase 3: Ontology Construction (Convergence)

> *Goal: Merge what exists (Foundation) with how to think about it (Freedom) into a coherent knowledge structure.*

This is where an AI agent adds the most value. You have a substrate map (Phase 2F) and a set of reasoning patterns (Phase 2E). The synthesis produces:

**3.1 Entity Ontology**
Combine the entity inventory (F2-1) with the expert's working taxonomy (E2-3) to produce:
- Entity types with clear definitions
- Classification frameworks that reflect how experts actually think (not just official categories)
- Relationship types between entities
- State models (lifecycle stages, status progressions)

*Test:* Can you classify a new entity the expert hasn't seen before using this ontology? If yes, you've captured the pattern. If you need to ask the expert, you've only captured the instances.

> *Design principle — Progressive Entity Promotion (A-009):* Assess which entities are invisible (not yet represented), which are attributes (scattered mentions in other entities' files), and which are ready for first-class reasoning. The entity ontology you build here determines what the system can reason about vs. what it can only retrieve facts about. See MOSAIC-PRINCIPLES section 3.2.

**3.2 Reasoning Frameworks**
Distill the expert's evaluation patterns (E2-1, E2-2), diagnostic patterns (E2-5), tacit knowledge (E2-6), and philosophical stance (E2-8) into teachable frameworks:
- Decision trees or evaluation criteria
- Pattern recognition rules (signals and what they indicate)
- Diagnostic playbooks (symptom -> investigation path -> resolution)
- Design principles derived from the expert's philosophical stance

*Test:* Would a junior person in this domain, reading these frameworks, make noticeably better decisions? If yes, you've captured real reasoning. If they'd still need to ask the expert, you've only captured surface-level descriptions.

**3.3 Cross-Domain Bridges**
From the cross-domain influence mapping (E2-4), document:
- Which domains this domain depends on (inputs)
- Which domains depend on this domain (outputs)
- What entities or concepts span the boundary
- What information needs to flow across the bridge

*Test:* When a change happens in this domain, can the system identify which other domains might be affected? If yes, the bridges are well-defined.

**3.4 Anti-Pattern Register**
From the negative-space design (E2-7), document:
- What this domain explicitly does NOT do
- Where the boundaries are between useful reasoning and over-engineering
- Specific anti-patterns to avoid (with rationale from the steward)

*Test:* If someone proposed adding [feature X] to this domain, could you evaluate whether it crosses a boundary? If the register gives you clear guidance, the constraints are well-defined.

**Completion criteria:**
- [ ] Entity ontology documented with types, classifications, relationships, and states
- [ ] At least 2 reasoning frameworks documented that teach patterns (not just list facts)
- [ ] Cross-domain bridges mapped with direction and content
- [ ] Anti-pattern register documented with rationale
- [ ] All four tests above pass
- [ ] Steward reviews and confirms: "Yes, this captures how I think about it"

---

### Phase 3.5: Domain Design Brief

> *Goal: Create a strategic blueprint that the steward reviews before construction begins.*

Before building files, write a design document that synthesizes everything from Phases 1-3 into a construction plan. This is the bridge between "I understand the domain" and "I know what to build."

**The brief should include:**
- **Vision:** What this domain will enable that doesn't exist today (tied to the reasoning failures identified in Phase 1F)
- **Architecture sketch:** What files will be created, what goes in each, estimated sizes
- **Entity-instance decision:** Does this domain have N entities that each need their own file? (See Phase 4 entity-instance architecture for details)
- **Tiered depth model:** Do all entities need the same level of detail, or should there be tiers? What determines the tier?
- **Implementation sequence:** What to build first, what depends on what
- **Success criteria:** How will we know the domain works? (Link back to the reasoning failures)
- **Open questions:** What still needs resolution before or during construction

**Why this step exists:** Complex domains benefit enormously from a design document between ontology construction and file building. For example, one domain's intelligence brief defined a 5-layer profile model, the tiering system, and the implementation phases *before* most construction began. Without it, construction is ad hoc. With it, construction is guided.

*The steward reviews this document and confirms: "Yes, build this."*

**Completion criteria:**
- [ ] Design brief written with all sections above
- [ ] Steward has reviewed and approved the construction plan
- [ ] Open questions resolved or explicitly deferred with rationale

---

### Phase 4: Architecture Decision

> *Goal: Decide what earns static kernel budget, what belongs in dynamic retrieval, and whether entity-instance architecture is needed.*

Apply the core test from the Mosaic architecture principle: **"Does this file teach a pattern the agent needs on every query, or provide data the agent looks up for specific queries?"**

**4.1 Kernel Candidates (Static)**
Reasoning frameworks from Phase 3 that the agent needs for general query handling:
- Decision frameworks that apply across many queries
- Routing reasoning (how to find the right person/resource)
- Classification taxonomies that the agent uses to interpret any question in this domain
- Cross-domain bridge definitions

> *Design principles for this phase:* Absorption over Creation (A-010) — reuse existing frameworks before inventing new ones. Query-Pattern Boundaries for Splits (A-011) — split files along how agents ask questions, not how humans organize data. Context Budget as Constraint (U-001) — every byte of kernel budget has an opportunity cost; earn placement with reasoning value, not data volume. See MOSAIC-PRINCIPLES sections 2.1 and 3.2.

**4.2 Retrieval Candidates (Dynamic)**
Data substrates from Phase 2F that are looked up per-query:
- Entity inventories (people, systems, clients, contracts, etc.)
- Lookup tables (IDs, names, cross-references)
- Historical records and logs
- Status dashboards and current-state data

**4.3 The QUICK Split**
For large data files, apply the two-tier retrieval pattern:
- **QUICK file** (session-level, loaded on first domain query): The 20% of data that answers 80% of questions. Index-level information — names, key attributes, cross-references.
- **Full file** (on-demand, loaded when QUICK isn't sufficient): Complete data with all detail, history, and edge cases.

**4.4 Entity-Instance Architecture**
"Does this domain have N tracked entities that each need their own detailed file?"

If yes, design:
- **Template:** A structured document that defines what a complete entity-instance file looks like. Include fields, source attribution (where each field comes from), entity-type variants (if different entity types need different sections), and confidence tagging conventions.
- **Tiering model:** Not all entities need the same depth. Define tiers (e.g., T0 directory stub, T1 lightweight profile, T2 full profile) with explicit upgrade triggers.
- **On-demand loading:** Entity-instance files are loaded when a user asks about a specific entity by name. They are never loaded as session-level data (too numerous). Design the naming convention and loading pattern.

*When to use entity-instance architecture:* Domains with more than ~10-15 tracked entities that each need individual detail. Client domains, people directories, contract registries, compliance tracking — any domain where the system needs to answer "tell me about [specific entity]" with deep detail.

**4.5 Extraction Operations**
If existing files contain a mix of reasoning and data (common in pre-domain architectures), plan the extraction:
- Identify reasoning fragments embedded in data files
- Assess reasoning density (what percentage of the file teaches patterns vs. stores facts?)
- Plan the split: extract reasoning into a new kernel file, leave data in the file and move to retrieval
- Verify no cross-references break during the split

**4.6 Budget Check**
Estimate file sizes for kernel candidates. Does it fit within available headroom? If not, what reasoning can be condensed or what data can be moved to retrieval without losing reasoning capability?

**Completion criteria:**
- [ ] Every artifact from Phase 3 assigned to kernel or retrieval
- [ ] QUICK vs. full split defined for any large data files
- [ ] Entity-instance architecture designed if applicable (template, tiering, loading pattern)
- [ ] Extraction operations planned if splitting existing files
- [ ] Kernel budget impact estimated and confirmed within headroom
- [ ] Routing triggers defined for this domain (what queries should activate retrieval)

---

### Phase 5: Artifact Construction

> *Goal: Build the actual files that make this domain operational.*

> *Design principles for construction:* Atomic Multi-File Operations (A-008) — when a change touches multiple files (kernel + retrieval + router + manifest), all updates happen in the same session. Marker System as Construction Methodology (A-017) — use explicit markers (TODO, PLACEHOLDER, NEEDS-REVIEW) during construction so incomplete work is visible, not silently absent. See MOSAIC-PRINCIPLES section 3.2.

**5.1 Domain Retrieval Files**
- QUICK file: Session-level data, optimized for the most common queries
- Full file: Complete data, available for escalation
- Follow existing naming conventions ({ORG}-{DOMAIN}-QUICK.md for index files)

**5.2 Kernel Reasoning File (if needed)**
- Only if Phase 4 identified reasoning patterns that earn kernel budget
- Follow the "curriculum not database" principle — teach patterns, not facts
- Reference the retrieval file for data: "The reasoning is here; the data is in [QUICK file]"

**5.3 Entity-Instance Files (if needed)**
- Build the template first, then create instances for the highest-tier entities
- Include source attribution markers so agents know which fields come from which source
- Follow the tiering model — don't build full profiles for entities that only need directory stubs

**5.4 Router Entries**
- Add domain to {ORG}-DOMAIN-ROUTER with trigger keywords, file paths, and sizes
- Include kernel note explaining the reasoning/data split

**5.5 Behavioral Directives**
- Update agent behavior files if the new domain requires specific handling
- Apply behavioral parity check — does this directive apply to both agents?
- For retrieval-aware rewrites: verify that directives previously assuming static data now correctly reference domain retrieval

**Completion criteria:**
- [ ] QUICK file written and sized within retrieval guidelines
- [ ] Full file written (if applicable)
- [ ] Reasoning file written (if applicable) and within kernel budget
- [ ] Entity-instance template and initial instances created (if applicable)
- [ ] Router entry added with triggers and notes
- [ ] Behavioral directives updated (if needed) in both agent files
- [ ] All files follow cross-reference conventions and naming standards

---

### Phase 6: Enrichment Design

> *Goal: Create the operational system that populates and maintains this domain over time.*

This is the **Level 3 (instance-specific)** layer — it's generated from everything you've learned, not pre-written. For data-heavy domains, this phase produces a complete enrichment operating system, not just a few prompts.

**6.1 Initial Population Prompts**
For each data source identified in Phase 2F, write a structured prompt that:
- Specifies what system to query and what to extract
- Defines the output format (matching the QUICK/full file structure)
- Includes data quality checks (what to validate, what's known to be unreliable)
- Names the agent best suited to execute it (Claude for MCP-accessible systems, Copilot for Microsoft ecosystem, manual for systems without API access)
- Includes a companion variant for each additional agent if multi-agent execution is needed

**6.2 Maintenance Triggers**
Define the events that should trigger a domain update:
- Data changes in source systems
- New entities appearing
- Lifecycle state transitions
- Scheduled refresh cadence (monthly, quarterly, etc.)

**6.3 Delta Prompts**
Write lightweight prompts for incremental updates — checking what's changed since the last refresh rather than rebuilding from scratch.

**6.4 Coverage Gap Detection**
Design the runtime behavior for when agents encounter incomplete data:
- What completeness thresholds apply per entity tier? (e.g., Active clients need 80%+ across all data layers; Prospects need only basic identity)
- How should the agent detect gaps? (Source attribution markers like `[MCP-TBD]`, missing sections, stale timestamps)
- What should the agent do when it finds a gap? (Flag it, recommend a specific enrichment prompt, or auto-queue a maintenance task)
- When should the agent NOT fire gap detection? (During rapid-fire queries, when the user is clearly asking about something else)

*Why this matters:* Coverage gap detection is the difference between a knowledge repository and an intelligence system. Without it, data quality degrades silently. With it, the system actively monitors its own completeness and recommends maintenance actions.

**6.5 Authoritative Sources Catalog**
For domains that draw on external data, curate a catalog of trusted sources:
- Source name, URL, what data it provides
- Trust tier (authoritative government source, institutional reference, commercial database, etc.)
- Mapping to specific template fields (which fields in your entity template come from which source)
- Update frequency (how often the source itself refreshes)

**Completion criteria:**
- [ ] At least one initial population prompt per data source
- [ ] Maintenance triggers defined and documented
- [ ] Delta prompts written for routine updates
- [ ] Agent assignment clear (which agent runs which prompt)
- [ ] Cadence calendar established
- [ ] Coverage gap detection designed (thresholds, detection rules, agent behavior)
- [ ] Authoritative sources cataloged (for domains with external data)

---

### Phase 7: Validation

> *Goal: Prove the domain works and hasn't broken anything.*

> *Design principle — Phased Risk Sequencing (A-014):* Prove the pattern at incrementally higher risk. Start with the simplest queries and known-good scenarios before testing edge cases and cross-domain interactions. If the easy cases fail, the hard cases will too — and you'll debug faster with simple examples. See MOSAIC-PRINCIPLES section 3.2.

**7.1 Benchmark Design**
Write 8-10 test queries spanning:
- Simple lookups ("Who owns system X?")
- Multi-step reasoning ("How would I evaluate a new [entity]?")
- Cross-domain queries ("How does [this domain] affect [other domain]?")
- Edge cases and known-tricky scenarios from the steward's experience
- At least 2 queries that test the specific reasoning failures identified in Phase 1F

**7.2 Before/After Testing**
If modifying an existing system:
1. Run benchmark queries BEFORE deploying the new domain
2. Deploy the domain artifacts
3. Run the SAME queries AFTER deployment
4. Compare scores — no regressions allowed, improvements expected on domain-specific queries

**7.3 Steward Validation**
Have the domain steward review 3-5 query responses. Their test: "Would I be comfortable if a new team member used this answer to make a decision?"

This should be a formal review with documented feedback, not just an informal "looks good." The steward's corrections become input for refinement.

**Completion criteria:**
- [ ] Benchmark queries written and scored
- [ ] Before/after comparison shows no regressions
- [ ] At least 2-point improvement on domain-specific queries
- [ ] Steward formally reviews 3-5 responses and confirms quality
- [ ] Phase 1F reasoning failures now resolved (success criteria met)

---

## 4. Discovery Prompt Portability Layers

The prompts in this protocol are organized into three portability layers:

| Layer | Scope | Persistence | Examples |
|-------|-------|-------------|----------|
| **Universal** | Any organization, any domain | Permanent (this protocol) | "What entity types exist?" "How does an expert evaluate X?" "What should this domain NOT do?" |
| **Architecture-Specific** | Any Mosaic-pattern deployment | Permanent (this protocol) | "What earns kernel budget?" "What's the QUICK split?" "Design coverage gap detection" |
| **Instance-Specific** | One domain in one organization | Generated per-bootstrap (Phase 6 output) | "Check CRM for deal stages" "Query project tool for team assignments" |

When transporting the system to a new organization:
- Levels 0 and 1 (Universal + Architecture-Specific) travel with the protocol
- Level 3 (Instance-Specific) is regenerated by running the protocol against the new organization's systems

---

## 5. Retrospective Validation

This protocol was validated retrospectively against three targets: one organizational deployment (Level 0) and two completed domains (Level 1).

### 5.1 Level 0: Organizational Deployment
*Coverage: v0.1 scored ~70%. v0.2 projected ~88%.*

| Prompt | v0.1 Score | Gap Identified | v0.2 Fix |
|--------|-----------|----------------|----------|
| O-1: Domain Landscape | 70% | Multi-axis domain models, hub-and-spoke | Added follow-up for domain relationships |
| O-2: System Inventory | 80% | Integration absence as constraint | Added integration topology follow-up |
| O-3: Entity Landscape | 60% | Multi-dimensional classification | Added classification depth probe |
| O-4: Information Culture | 75% | Epistemological principles missing | Added epistemological probe |
| O-5: Steward Identification | 65% | Multi-authority model, trust anchors | Added authority type follow-up |
| — | — | Strategic context entirely missing | Added O-6 |
| — | — | AI/automation context missing | Added O-7 |
| — | — | Org-level invisible entities | Added O-8 |

Key finding: ~10% of organizational knowledge is genuinely emergent — only discoverable by building. Added O-R (Emergence Retrospective) to capture these lessons after the first domain build.

### 5.2 Mature Domain (Level 1)
*Coverage: v0.1 scored ~72%. v0.2 projected ~87%.*

| Phase | v0.1 Score | Gap Identified | v0.2 Fix |
|-------|-----------|----------------|----------|
| 1F: Substrate Audit | 85% | Agent accessibility not assessed | Added to F1-1 |
| 1E: Expert Engagement | 60% | Multi-expert, steward-as-builder | Added E1-3, steward-as-builder note |
| 2F: Data Mapping | 90% | No market/universe mapping | Added F2-5 |
| 2E: Worldview Extraction | 70% | No negative-space, no temporal | Added E2-7, E2-8, E2-9 |
| 3: Ontology | 80% | No tiered depth architecture | Addressed in Phase 3.5 and 4.4 |
| 4: Architecture | 85% | No entity-instance pattern, no extraction ops | Added 4.4 and 4.5 |
| 5: Artifact Construction | 65% | Entity templates missing, no design brief | Added 5.3, added Phase 3.5 |
| 6: Enrichment | 75% | No coverage gap detection, no source catalog | Added 6.4 and 6.5 |
| 7: Validation | 80% | Steward validation informal | Strengthened 7.3 |

Key finding: The protocol would have done three things BETTER than the organic build: (1) cross-system identity mapping would have been systematic from Session 1 instead of error-discovered over 6 sessions, (2) cross-domain bridges would have been mapped deliberately rather than discovered incrementally, (3) the Foundation + Freedom parallel structure would have prevented the "identity crisis" where entity questions preceded classification questions.

### 5.3 Fresh Domain (Level 1)
*Coverage: v0.1 scored ~82%. v0.2 projected ~92%.*

| Phase | v0.1 Score | Gap Identified | v0.2 Fix |
|-------|-----------|----------------|----------|
| 1F: Substrate Audit | 85% | Reasoning failures not documented | Added to F1-2 completion criteria |
| 1E: Expert Engagement | 70% | Philosophical expertise not prompted | Added E1-3, steward-as-builder |
| 2F: Data Mapping | 80% | No structural quality assessment | Addressed in F2-5 and Phase 3.5 |
| 2E: Worldview Extraction | 75% | No negative-space, no philosophical, no temporal | Added E2-7, E2-8, E2-9 |
| 3: Ontology | 90% | Creative synthesis vs. mechanical convergence | Iteration note added to Section 1 |
| 4: Architecture | 95% | Extraction operations not addressed | Added 4.5 |
| 5: Artifact Construction | 95% | Opportunistic improvements during build | Iteration note covers this |
| 6: Enrichment | 50% | Protocol would have IMPROVED actual build | Expanded Phase 6 significantly |
| 7: Validation | 95% | Steward validation informal | Strengthened 7.3 |

Key finding: The protocol's most important contribution for this domain would have been Phase 6 (Enrichment Design), where the actual build under-invested. This validates that the protocol adds discipline to steps that expert builders tend to skip when focused on more intellectually engaging work.

Critical question tested: **Would the protocol have discovered that people were invisible entities?** Answer: Yes, the mechanism exists (F1-2 invisible entity prompt), but the triggering condition (a system-wide audit, not a domain-specific search) is Level 0 territory. Added O-8 (Invisible Entity Scan) to Level 0 to address this.

### 5.4 Prospective Validation (Planned)
The next domain will be the first bootstrapped *using* the protocol — providing three-point validation: mature retrospective, fresh retrospective, and live prospective application.

---

## 6. The Steward Experience

The Freedom track depends on a domain expert who may never have externalized their knowledge systematically. Design the experience for them:

**Make it conversational, not interrogative.** "Walk me through the last time you had to..." works better than "List your criteria for..." The former surfaces tacit knowledge; the latter produces a checklist.

**Start with stories, end with frameworks.** Let the expert tell stories about real situations. The frameworks emerge from asking "What made that different from the other time?" across multiple stories. Pattern recognition happens naturally.

**Match the expert's register.** Some experts are operational — they share procedures, patterns, and diagnostics. Others are philosophical — they share worldviews, beliefs, and meta-reasoning about the domain. Prompts E2-1 through E2-6 serve operational experts well. Prompts E2-7, E2-8, and E2-9 are designed for philosophical experts. Use the steward introduction (E1-1) to calibrate which register to emphasize.

**Validate as you go.** After extracting a framework, reflect it back: "So it sounds like when you evaluate X, you're really looking at A, B, and C, and C matters most when..." Let the expert correct and refine in real time.

**Name what they taught you.** When you can say "The funding-source rule you described — where government vs. commercial funding changes the entire evaluation — I'm going to call that the 'funding authority framework'" — you've made tacit knowledge legible. Experts respond well to seeing their intuition given structure and a name.

**Ask what NOT to build.** This is often the most important conversation. Experts have seen over-engineered systems in their domain and have strong intuitions about where the line is. "What should we explicitly not do?" is a question that produces design constraints worth more than features.

**Expect iteration.** The first pass captures 60-70% of the reasoning. The second pass (reviewing draft artifacts) surfaces "Oh, I forgot to mention..." and "Actually, that's not quite right because..." Plan for at least two review cycles with the steward.

> *Design principle — Empirical Discovery over A Priori Design (U-013):* The most important lessons cannot be predicted. The first build teaches what the protocol cannot encode. Every completed domain will surface principles, shortcuts, and failure modes that no protocol anticipated. Capture these discoveries — they are the raw material for methodology improvement. See MOSAIC-PRINCIPLES section 2.3.

---

## 7. Changelog

| Version | Date | Change |
|---------|------|--------|
| v0.1 | 2026-02-15 | Initial protocol design. Reverse-engineered from two completed domain anatomies. |
| v0.3 | 2026-02-23 | Principles codification: added 5 design principle checkpoints at key decision points (Phase 3 §3.1, Phase 4 §4.1, Phase 5, Phase 7, Section 6) referencing MOSAIC-PRINCIPLES catalog. Principles invoked: A-009, A-010, A-011, U-001, A-008, A-017, A-014, U-013. |
| v0.2 | 2026-02-16 | Retrospective validation applied. Level 0: added O-6 (Strategic Context), O-7 (AI/Automation), O-8 (Invisible Entity Scan), O-R (Emergence Retrospective); modified O-2 (integration gaps), O-3 (classification depth), O-4 (epistemological norms), O-5 (authority types). Level 1: added F1-1 agent accessibility, F1-2 reasoning failures, F2-5 (universe mapping), E1-3 (knowledge landscape), E2-7 (negative-space design), E2-8 (philosophical stance), E2-9 (temporal dimension); added Phase 3.5 (Domain Design Brief) and Phase 3.4 (anti-pattern register); added Phase 4.4 (entity-instance architecture), 4.5 (extraction operations); added Phase 5.3 (entity-instance files); expanded Phase 6 with 6.4 (coverage gap detection) and 6.5 (authoritative sources); strengthened Phase 7.3 (formal steward validation). Added iteration note to architecture overview. Updated validation section with scores and gap/fix tables. |
