# {ORG}-{SERVICE}-API v1.0
**Last validated:** YYYY-MM-DD

<!-- API Recipe File Template v1.0

     PURPOSE: Encodes everything an agent needs to make correct API calls to
     an external service — call syntax, recipes, quirks, validation status,
     and self-correction feedback loops.

     BUILT FROM: Three production recipe files (HubSpot v1.7, GA4 v1.0,
     LinkedIn v1.5) across two connection types (Azure MCP, Zapier MCP).
     Patterns validated through 6 MCP integration phases.

     HOW TO USE THIS TEMPLATE:
     1. Copy to reference/{ORG}-{SERVICE}-API.md
     2. Replace {ORG}, {SERVICE}, {TOOL_NAME} placeholders
     3. Delete sections marked CONDITIONAL that don't apply
     4. Delete all <!-- template guidance --> comments
     5. Validate each Active endpoint live during construction
     6. Follow the NTIC checklist in CLAUDE.md after completion

     SECTION NUMBERING: Keep section numbers stable even if you delete
     conditional sections. Agents and cross-references depend on §N being
     predictable. Use "§N [Not applicable]" rather than renumbering.

     SIZE TARGET: ~15-25 KB for a typical service. If exceeding 40 KB,
     split into core recipe + supplementary reference (see MOSAIC-REASONING §4.7).
-->

---

## 0. Routing

**Retrieval-only** (not QUICK). Retrieve when constructing {SERVICE} API calls, debugging API issues, or answering questions about {SERVICE} capabilities.

**When to retrieve:** Agent needs {SERVICE} call syntax, recipe selection, instance-specific mappings, or quirks reference. Domain QUICK files ({ORG}-{DOMAIN}-QUICK §8A) provide question-type routing; this file provides the call recipes.

**Sections:** §1 Tool Routing, §2 Read Recipes, §3 Write Recipes, §4 Query Patterns, §5 Instance-Specific Mappings, §6 API Quirks, §7 Endpoint Catalog, §8 Intelligence Baseline, §9 Delta Feedback.

**Delta pattern:** API behavior changes, new endpoints discovered, or validation status updates -> emit `[RECIPE]` delta targeting the relevant section of this file.

<!-- ROUTING SECTION DESIGN NOTES:
     - "When to retrieve" tells the agent WHEN to fetch this file. Be specific
       about the triggers — "answering questions about X" is too broad.
       "Constructing X API calls" and "debugging X API issues" are concrete triggers.
     - The section index is load-bearing — agents use it to decide which §N to
       retrieve via get_section. Keep it accurate.
     - Connection info (which tool, what transport) goes here as a one-liner.
       Full call syntax goes in §1.
-->

---

## 1. Tool Routing

**Single tool: `{TOOL_NAME}`** ({connection_type} -- {server_name} v{X.Y.Z}). {capability_summary}.

<!-- CONNECTION TYPES (pick one):
     - Azure MCP: "Azure MCP -- {org}-mcp-server v{X.Y.Z}"
     - Zapier MCP: "Zapier MCP -- linkedin_api_request_beta" (or similar)
     The connection type affects call syntax significantly:
       Azure MCP: tool name + parameters (method, path, body, etc.)
       Zapier MCP: method, url (full URL required), headers, querystring, body, fail_on_errors
-->

```yaml
call_syntax:
  tool: {TOOL_NAME}
  tool_search: "{validated search string}"
  parameters:
    method: "GET | POST | PATCH | PUT | DELETE"
    path: "/api/endpoint"  # path-only for Azure MCP; full URL for Zapier
    body: {}  # optional, for POST/PATCH/PUT
    # Add service-specific parameters (e.g., realm_id for multi-tenant)
  constraint: "{access level — read-only, full CRUD, confirm before write, etc.}"

routing:
  reads: {TOOL_NAME} method=GET -- {description}
  writes: {TOOL_NAME} method=POST/PATCH/DELETE -- {description}
  search: {TOOL_NAME} {search_pattern}
  reports: {TOOL_NAME} {report_pattern}

common_paths:
  # Top 5-10 most-used paths. Agent uses these as quick reference
  # before consulting full §7 catalog.
  entity_list: "/path/to/entities"
  entity_detail: "/path/to/entities/{id}"
  search: "/path/to/search"
  reports: "/path/to/reports/{type}"
```

<!-- TOOL_SEARCH FIELD: This is the validated search string that reliably
     finds the tool in Claude.ai's MCP tool picker. Zapier tools have
     unreliable search indexing — test multiple strings and encode the
     one that works. For Azure MCP tools, the tool name usually suffices.
     This same string goes in {ORG}-A2A-QUICK §5.x.
-->

**Decision shortcut:** {One-sentence summary of when to use which call pattern. Keep this to 1-2 sentences max — it's the "I don't want to read the whole file" fast path.}

<!-- CONDITIONAL: VERSIONING
     Include this sub-section if the API has version-specific behavior
     (e.g., LinkedIn v2 vs REST, or API version headers).
     Delete if the API uses a single stable version.

```yaml
versioning:
  current: "{version}"
  header: "{version header if required}"
  maintenance: "{rotation schedule and check trigger}"
```
-->

---

## 2. Read Recipes

All recipes use `{TOOL_NAME}` with `method: GET`. {Path convention note.}

<!-- READ RECIPE DESIGN NOTES:
     - Group recipes by domain concept (not by API endpoint). Users ask
       "how is our content performing?" not "what does /statistics/list return?"
     - Each recipe should have: path, method, parameters, output_hint,
       validation status, and notes.
     - INVESTIGATION DEPTH PATTERNS (A-024): For every aggregate endpoint,
       include the corresponding detail endpoint. Mark it explicitly:
       "INVESTIGATION DEPTH PATTERN. [Aggregate] shows totals.
       To drill into [specific], use [detail endpoint] below."
       This teaches the agent when to make a second call.
     - output_hint: Tell the agent what the response contains in plain English.
       This helps the agent decide whether to make the call before seeing results.
     - Validation status tags (standard vocabulary):
       validated: YYYY-MM-DD  -- live call confirmed working
       UNCONFIRMED            -- encoded from docs, not live-tested
       UNTESTED               -- known endpoint, never attempted
       FAILED                 -- does not work, see workaround
-->

### {Category 1} (e.g., Financial Reports, Traffic Analytics, Contact Lists)

```yaml
{recipe_name}:
  method: GET
  path: "{API path}"
  # querystring: "{params}"  # if needed
  output_hint: "{what the response contains}"
  validated: YYYY-MM-DD
  note: |
    INVESTIGATION DEPTH PATTERN. {Aggregate description}.
    To drill into {specific detail}, use {detail_recipe} below.

{detail_recipe_name}:
  method: GET
  path: "{detail API path}"
  output_hint: "{what the detail response contains}"
  validated: YYYY-MM-DD
  note: Drill-down from {recipe_name} above. {When to use.}
```

### {Category 2}

```yaml
# Continue pattern for each logical grouping
```

<!-- RECIPE GROUPING GUIDANCE:
     - GA4 groups by: Traffic, Acquisition, Content, Conversions, Audience, Realtime
     - HubSpot groups by: Marketing Emails, Contact Lists, Custom Objects, Schema
     - LinkedIn groups by: Follower Analytics, Engagement, Page Views, Posts
     - QBO might group by: Financial Reports, Entity Queries, Transaction Queries
     Choose groupings that match how users ask questions, not how the API
     organizes its endpoints.
-->

---

## 3. Write Recipes

<!-- CONDITIONAL: Include this section only if the tool supports write operations
     (POST/PATCH/PUT/DELETE that modify data). Delete for read-only services.

     If included, §3.1 Write Safety Classification is REQUIRED — it's how the
     agent decides what language to use when offering a write.
-->

All writes use `{TOOL_NAME}` with `method: POST`, `PATCH`, or `DELETE`. **Explicit user confirmation required before every write.** Present proposed changes, wait for approval.

### 3.1 Write Safety Classification

Field-level classification for write offers. Language gradient and resolve-first routing: {ORG}-{AGENT}-BEHAVIORS §Delta Output.

```yaml
write_safety:
  mechanical:
    description: "Rule-based corrections with deterministic new value"
    confidence: high
    offer_pattern: "Direct -- '[field] is [problem]. Change to [fix]?'"
    examples: ["{example1}", "{example2}"]
    pipeline_eligible: true

  data_fill:
    description: "Populating blank fields with context-derived values"
    confidence: medium
    offer_pattern: "Suggestive -- 'I'd suggest [value] based on [evidence]. Update?'"
    examples: ["{example1}", "{example2}"]
    pipeline_eligible: false

  interpretive:
    description: "Fields requiring human judgment -- value depends on business context"
    confidence: requires_judgment
    offer_pattern: "Observation + capability -- 'I noticed [observation]. I can update if you'd like.'"
    examples: ["{example1}", "{example2}"]
    pipeline_eligible: false

  structural:
    description: "Changes entity relationships or system architecture"
    offer_pattern: "Pipeline/maintenance only -- never real-time"
    pipeline_eligible: maintenance_only
```

<!-- WRITE SAFETY DESIGN NOTES:
     - Classify EVERY writable field into one of the 4 tiers.
     - The language gradient is load-bearing — it determines how the agent
       phrases write offers. "Direct" vs "Suggestive" vs "Observation" produces
       measurably different user trust responses.
     - pipeline_eligible determines whether the CLIENTS-QUICK pipeline can
       auto-generate write recommendations for this field.
     - See DOMAIN-BOOTSTRAP §4.11 for the full write architecture framework.
-->

### {Entity Type 1} (e.g., Deals, Invoices, Accounts)

```yaml
update_{entity}:
  method: PATCH
  path: "/path/to/{entity}/{id}"
  body: {"{field}": "{value}"}
  key_fields: "{comma-separated writable fields}"
  validated: YYYY-MM-DD

create_{entity}:
  method: POST
  path: "/path/to/{entity}"
  body: {"{required_fields}": "{values}"}
  required: "{field_list}"
  validation_status: WRITE_DEFERRED
```

---

## 4. Query Patterns

<!-- CONDITIONAL: Include this section if the API has its own query language
     or search syntax (e.g., QBO's SQL-like queries, HubSpot's filterGroups,
     SOQL for Salesforce). Delete if the API uses only REST GET endpoints.

     For APIs without a formal query language, merge any search patterns
     into §2 Read Recipes instead.
-->

{API name} uses {query language description}. All queries use `{TOOL_NAME}` with `method: {METHOD}`.

```yaml
{example_query_pattern}:
  method: {METHOD}
  path: "{query path}"
  # body or querystring with the query
  output_hint: "{what results look like}"
  validated: YYYY-MM-DD

query_syntax:
  # Encode the query language rules the agent needs:
  # operators, field names, pagination, date formats,
  # string quoting, reserved words, etc.
```

<!-- QUERY LANGUAGE DESIGN NOTES:
     - Encode enough syntax that the agent can construct correct queries
       without external documentation.
     - Include 2-3 worked examples for common patterns.
     - Document pagination (cursor-based vs offset) — agents frequently
       get this wrong on first attempt.
     - Document date format requirements — every API has its own.
-->

---

## 5. Instance-Specific Mappings

<!-- CONDITIONAL: Include this section if the service has instance-specific
     IDs, configurations, or entity mappings that the agent needs.
     Examples: pipeline stage IDs, owner lookups, org IDs, realm IDs,
     custom object type IDs, property name mappings.

     Delete if the service has no instance-specific configuration
     (rare — most services have at least account/org IDs).

     KERNEL BUDGET DECISION: Content here is retrieval-only by default.
     Only promote to kernel (A2A-QUICK §5.x) if consumed on >50% of
     queries in this domain. See CLAUDE.md "Kernel Architecture" section.
-->

### {Mapping Category 1} (e.g., Pipeline Stages, Entity IDs, Account Config)

```yaml
{mapping_name}:
  # ID lookups, stage mappings, entity configurations
  # Use YAML for structured lookups (57% fewer tokens than tables)
```

### {Mapping Category 2}

```yaml
# Continue for each mapping category
```

---

## 6. API Quirks

<!-- QUIRKS SECTION DESIGN NOTES:
     - This is the primary defense against rediscovering bugs in production.
       Every non-obvious API behavior gets a numbered entry here.
     - Number quirks sequentially and NEVER renumber (even if retired).
       Cross-references in recipes point to quirk numbers.
     - Each quirk must have: issue, affects, detail/fix, confirmed date.
     - When a quirk is retired (e.g., migrating off Zapier removes Zapier
       quirks), comment it out with a note — don't delete. Historical
       reference prevents regression if the integration changes again.

     COMMON QUIRK CATEGORIES (from production experience):
     - Date/time format mismatches (every API has one)
     - Pagination behavior (cursor vs offset, max page size)
     - Response format surprises (strings instead of numbers, nested vs flat)
     - Version-specific endpoint differences
     - Auth scope limitations (endpoint exists but scope blocks it)
     - Rate limiting behavior
     - Query language edge cases
     - Proxy/middleware quirks (Zapier, API gateways)
-->

```yaml
quirk_1_{short_name}:
  issue: "{one-line description of the non-obvious behavior}"
  affects: "{which endpoints or call patterns}"
  detail: "{full explanation and fix/workaround}"
  confirmed: YYYY-MM-DD

quirk_2_{short_name}:
  issue: "{description}"
  affects: "{endpoints}"
  detail: "{explanation}"
  confirmed: YYYY-MM-DD

# Continue numbering sequentially. Never renumber.
# Retired quirks: comment out with note, don't delete.
# Example:
# quirk_3 (zapier_output_format): Retired — Zapier decommissioned YYYY-MM-DD.
```

---

## 7. Endpoint Catalog

Full inventory of {SERVICE} API endpoints accessible via `{TOOL_NAME}`. Validation status tags per CLAUDE.md standard.

<!-- ENDPOINT CATALOG DESIGN NOTES:
     - This is the comprehensive reference — every endpoint the tool can reach.
     - §2/§3 recipes are the "how to use" view; §7 is the "what exists" view.
     - Status tags create the self-correction loop: agent encounters UNCONFIRMED
       → attempts call → emits [RECIPE] delta → maintenance updates status.
     - "Available but No Active Recipe" captures endpoints that work but aren't
       needed yet. When a future domain activates, promote from here to §2/§3.

     Validation status vocabulary:
       validated: YYYY-MM-DD       -- live call confirmed working on date
       UNCONFIRMED                  -- encoded from docs, not live-tested
       UNTESTED                     -- known path, never attempted
       FAILED                       -- attempted, does not work (note workaround)
       WRITE_DEFERRED               -- write endpoint, schema confirmed, live test
                                       deferred to avoid side effects
-->

### Reads (GET)

|Endpoint|Description|Status|
|---|---|---|
|`/path/to/endpoint`|{Description}|validated: YYYY-MM-DD|
|`/path/to/another`|{Description}|UNCONFIRMED|

### Searches (POST)

<!-- CONDITIONAL: Include if the API uses POST for searches.
     Delete if searches are GET-only. -->

|Endpoint|Description|Status|
|---|---|---|
|`/path/to/search`|{Description}|validated: YYYY-MM-DD|

### Writes (POST/PATCH/DELETE)

<!-- CONDITIONAL: Include if write-enabled. Delete for read-only services. -->

|Endpoint|Method|Description|Status|
|---|---|---|---|
|`/path/to/entity`|POST|Create {entity}|WRITE_DEFERRED|
|`/path/to/entity/{id}`|PATCH|Update {entity}|validated: YYYY-MM-DD|

### Available but No Active Recipe

<!-- Endpoints that work but aren't needed by any current domain.
     When a future domain needs one, promote it to §2/§3 with a recipe. -->

|Endpoint|Method|Description|Notes|
|---|---|---|---|
|`/path/to/future`|GET|{Description}|{Why deferred}|

<!-- CONDITIONAL: FUTURE DOMAIN ENTRIES
     Include if there are known-useful endpoints that no current domain
     needs. Encode for awareness so future domain bootstraps find them.
     LinkedIn does this extensively (§3 future entries).

### Future Domain Entries

```yaml
future_entries:
  {entry_name}:
    status: future-{Domain}
    endpoint_area: /path/prefix
    use_case: "{why this would be valuable}"
    prerequisite: "{what's needed to activate}"
```
-->

---

## 8. Intelligence Baseline

<!-- CONDITIONAL: Include this section if the service contains Type B
     (curated intelligence) data worth capturing as a point-in-time snapshot.
     Examples: LinkedIn follower demographics, GA4 traffic baselines,
     QBO chart of accounts structure.

     This is NOT a dump of live data (that's Type A — query live).
     This is strategic context that changes slowly and helps the agent
     reason even without a live call. Update when materially changed.

     Delete this section for services where all data is Type A (live-query).
     Most CRM/transactional services won't need this section.
-->

Type B data -- strategic intelligence baseline. Query live for current values; update this section when materially changed.

**Last validated:** YYYY-MM-DD

```yaml
# Curated intelligence snapshots
# Example: follower demographics, account structure, entity inventory
```

---

## 9. Delta Feedback Pattern

API behavior changes, new endpoint discoveries, or validation status updates should emit `[RECIPE]` deltas:

```
[RECIPE] target: {ORG}-{SERVICE}-API §{section}
Pattern: {what changed or was discovered}
Working alternative: {if applicable}
Source: {live API call or documentation}, YYYY-MM-DD
```

**Trigger conditions:**
- UNCONFIRMED/UNTESTED endpoint attempted -> emit delta with pass/fail result
- New endpoint discovered or undocumented behavior -> emit delta for §7 catalog or §6 quirks
- API version change or deprecation notice -> emit delta for affected recipes
- Write operation succeeds or fails unexpectedly -> emit delta for §3 or §6

<!-- DELTA FEEDBACK DESIGN NOTES:
     - The delta pattern is the self-correction loop. Without it, recipe
       files become stale documentation instead of living operational guides.
     - "Trigger conditions" tell the agent WHEN to emit a delta. Be exhaustive —
       any API behavior change the agent discovers should trigger a delta.
     - Add service-specific triggers as needed:
       - OAuth scope changes
       - Rate limit changes
       - API version deprecation
       - New features or endpoints
     - The maintenance cycle reads [RECIPE] deltas from the Asana Intelligence
       Queue and applies updates to this file. This closes the loop.
-->

<!-- CONSTRUCTION CHECKLIST (delete after completing):
     [ ] §0 Routing header with section index
     [ ] §1 Tool routing with call_syntax and tool_search
     [ ] §2 Read recipes with investigation depth patterns
     [ ] §3 Write recipes + §3.1 safety classification (if write-enabled)
     [ ] §4 Query patterns (if API has query language)
     [ ] §5 Instance-specific mappings
     [ ] §6 API quirks (validate live — document every surprise)
     [ ] §7 Endpoint catalog with status tags
     [ ] §8 Intelligence baseline (if Type B data exists)
     [ ] §9 Delta feedback pattern
     [ ] All Active endpoints validated live during construction
     [ ] Investigation depth patterns marked for every aggregate endpoint
     [ ] NTIC 8-location update (see CLAUDE.md new tool checklist — includes governance reclassification + conflict scan)
     [ ] Smoke test (3 queries in Claude.ai after upload)
-->
