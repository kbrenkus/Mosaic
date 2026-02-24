# {ORG}-DOMAIN-ROUTER.md
## {Organization Name} — Domain Routing Manifest

**Version:** 1.0
**Created:** {DATE}
**Last Updated:** {DATE}
**Owner:** {Owner Name} / {Team}
**Classification:** Internal — Agent Reference File

---

## Retrieval Protocol

For retrieval architecture reasoning (Core + Retrieval pattern, 4-question protocol, session preloading, hub-and-spoke, failure handling), see MOSAIC-REASONING §4. This section covers {ORG}-specific implementation.

**`get_section` retrieval ({Org} Reference Files connector):** Primary retrieval mechanism. Syntax: `get_section("filename", "section_ref")` — bare section numbers matching `## N.` or `### N.M` headers (e.g., `get_section("{ORG}-ADMIN", "2.3")`). Returns ~3-5 KB per call. Use the § reference from the domain file tables below. Blob scope: all non-kernel `.md` files from reference/, clients/, and other retrieval directories.

**QUICK files via get_section:** All domain QUICK files are in blob. Retrieve routing headers and data sections using `get_section("filename", "N")` — do NOT load QUICK files whole (note context cost).

**Kernel-only vs. requires-retrieval:**
- **Kernel answers (no retrieval):** {List query types answerable from kernel files alone}
- **Requires retrieval:** {List query types requiring domain file retrieval}

**Hub domain:** {Identify the central operational hub domain, if any — the domain other domains reference most.}

---

## Domains

<!-- Add one section per domain. Each domain follows this structure: -->

### {Domain Name}

**Triggers:** {comma-separated list of keywords and phrases that should route to this domain}

**Domain entry — routing header:**

| File | Retrieval | Routing Header Content |
|------|-----------|------------------------|
| {ORG}-{DOMAIN}-QUICK | `get_section("{ORG}-{DOMAIN}-QUICK", "0")` | Domain triggers, section index, routing rules. |

**On-demand files:**

| File | Blob Name | Size | Content |
|------|-----------|------|---------|
| {ORG}-{DOMAIN} | {ORG}-{DOMAIN}.md | ~{N} KB | {Description of full file content} |

**Kernel note:** {What reasoning is in the kernel vs. what data is in retrieval for this domain}

**Specialist tools:** {MCP connectors or tools relevant to this domain, if any}

---

<!-- Copy the domain section template above for each domain.
     Domains are added as they're bootstrapped via DOMAIN-BOOTSTRAP.md.
     The first domain entry comes from Phase 3 of KERNEL-BOOTSTRAP.md. -->

## Changelog

| Version | Date | Change |
|---------|------|--------|
| 1.0 | {DATE} | Initial version with retrieval protocol. Domain entries added as domains are bootstrapped. |
