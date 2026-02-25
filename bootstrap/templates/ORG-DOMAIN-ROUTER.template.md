# {ORG}-DOMAIN-ROUTER.md — {Organization Name} Domain Routing Manifest
**Version:** 1.0 | **Updated:** {DATE} | **Owner:** {Owner Name}

---

## Retrieval Protocol

For retrieval architecture reasoning (Core + Retrieval pattern, 4-question protocol, session preloading, hub-and-spoke, failure handling), see MOSAIC-REASONING §4. This section covers {ORG}-specific implementation.

**`get_section` retrieval:** Syntax: `get_section("filename", "section_ref")` — bare section numbers matching `## N.` or `### N.M` headers. Returns ~3-5 KB per call. Blob scope: all non-kernel `.md` files from reference/, clients/, and other retrieval directories.

**QUICK files:** All in blob. Retrieve routing headers and data sections via `get_section("filename", "N")` — do NOT load whole (note context cost).

**Kernel-only vs. requires-retrieval:**
- **Kernel answers (no retrieval):** {List query types answerable from kernel alone}
- **Requires retrieval:** {List query types requiring domain file retrieval}

**File sizes:** See {ORG}-MAINTENANCE §2.1/§2.2. Large files (>50 KB) have attention gradients — retrieve specific sections, not whole files.

**Hub domain:** {Identify central operational hub domain, if any.}

---

## Domains

<!-- Add one section per domain. Each domain follows this structure: -->

### {Domain Name}

**Triggers:** {comma-separated list of keywords and phrases that should route to this domain}

**Domain entry — routing header:**

|File|Retrieval|Routing Header Content|
|---|---|---|
|{ORG}-{DOMAIN}-QUICK|`get_section("{ORG}-{DOMAIN}-QUICK", "0")`|Domain triggers, section index, routing rules.|

**On-demand files:**

|File|Blob Name|Content|
|---|---|---|
|{ORG}-{DOMAIN}|{ORG}-{DOMAIN}.md|{Description of full file content}|

**Kernel note:** {What reasoning is in kernel vs. what data is in retrieval for this domain}

**Specialist tools:** {MCP connectors or tools relevant to this domain, if any}

---

<!-- Copy domain section template above for each domain.
     Domains added as bootstrapped via DOMAIN-BOOTSTRAP.md.
     First domain entry comes from Phase 3 of KERNEL-BOOTSTRAP.md.

     DESIGN RULE: Never hardcode counts or sizes in Content descriptions.
     Use "count = rows in [table]" or "count = [source metric]" so the
     router stays accurate as data changes. File sizes live in MAINTENANCE
     §2.1/§2.2, not here. See MOSAIC-PRINCIPLES U-011 (Volatile Data). -->

## Changelog

|Version|Date|Change|
|---|---|---|
|1.0|{DATE}|Initial version with retrieval protocol. Domain entries added as domains are bootstrapped.|
