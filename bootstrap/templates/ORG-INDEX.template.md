# {ORG}-INDEX.md
## {Organization Name} — Master Agent Reference Index

**Version:** 1.0
**Created:** {DATE}
**Last Verified:** {DATE}
**Owner:** {Owner Name} / {Team}
**Classification:** Internal — Agent Reference File

---

## About This File

This is the master index for **Mosaic** — {Organization Name}'s multi-agent intelligence system. Mosaic weaves together organizational reference data, behavioral protocols, and domain-specific knowledge across AI agents to create a unified intelligence picture. **Any AI agent working with {Organization Name} should read this file first.** It provides organizational context, a map of all connected systems, and pointers to domain-specific reference files for deeper context.

### Related Reference Files

Mosaic's reference system has four layers:

- **Shared Reasoning** (static, company-agnostic) — MOSAIC-REASONING: people reasoning, analytical intelligence, retrieval architecture, agent coordination, design principles. Versioned independently, distributable across instances.
- **Instance Kernel** (static project knowledge) — 5 {ORG}-specific files: this index, behavioral directives, taxonomy, agent-to-agent protocol, and domain routing. See {ORG}-MAINTENANCE §2.1 for current versions.
- **Domain files** (retrieved dynamically) — QUICK and full-depth files organized by domain. See {ORG}-DOMAIN-ROUTER for the complete domain map, file inventory, and retrieval protocol.
- **Supporting artifacts** — entity profiles, discovery prompts, test plan. See {ORG}-MAINTENANCE §2.2 for the full inventory.

For file versions and currency, {ORG}-MAINTENANCE §2.1/§2.2 is authoritative.

---

## Organizational Overview

### Mission

<!-- Describe the organization's mission, legal structure, and primary activities. -->

{Organization description here.}

### Corporate Structure

<!-- List the organization's entities (parent, subsidiaries, affiliates) with their relationships. -->

| Entity | State / Type | Relationship | Description |
|--------|-------------|-------------|-------------|
| **{Primary Entity}** | {State} — {Type} | **Parent / Operating entity** | {Description} |
<!-- Add rows for subsidiaries, affiliates, etc. -->

### Approval Authority Quick Reference

<!-- Document the delegation of authority structure. This is high-frequency reference data that earns kernel budget. -->

| Level | Role | Authority | Scope |
|-------|------|----------|-------|
| **Level I** | {Role} ({Name}) | {Limit} | {Scope} |
<!-- Add rows as needed -->

### Internal Departments / Domains

<!-- Map the organizational structure to knowledge domains. This informs domain routing and steward identification. -->

| Domain | Lead | Scope |
|--------|------|-------|
| **{Domain Name}** | {Lead Name} | {Systems and responsibilities} |
<!-- Add rows for each domain identified in Level 0 discovery -->

### Key Leadership

<!-- List key personnel with system IDs for cross-system correlation. -->

| Name | Role | CRM Owner ID | Project Tool ID | Notes |
|------|------|-------------|-----------------|-------|
| {Name} | {Role} | {ID} | {ID} | {Notes} |

---

## System Landscape

### M365 Organization Topology

<!-- Map the Microsoft 365 environment if applicable. -->

| Component | Details |
|-----------|---------|
| Tenant | {tenant}.onmicrosoft.com |
| Environment | {License tier} |
<!-- Add relevant M365 topology -->

### Business Systems Summary

<!-- List all business systems with their roles and integration status. -->

| System | Category | Primary Use | Integration Status |
|--------|----------|-------------|-------------------|
| {System} | {Category} | {Use} | {MCP / API / Manual / None} |

---

## Business Metrics Summary

<!-- High-level organizational metrics that provide strategic context for agent reasoning. -->

| Category | Metric | Value | Source | As Of |
|----------|--------|-------|--------|-------|
| {Category} | {Metric} | {Value} | {Source} | {Date} |

---

## Changelog

<!-- All changes tracked in {ORG}-MAINTENANCE consolidated changelog. -->

| Version | Date | Change |
|---------|------|--------|
| 1.0 | {DATE} | Initial version from Level 0 organizational discovery. |
