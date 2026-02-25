# Pipeline Template — CLIENTS-QUICK Pipeline Architecture

> **Purpose:** Template pipeline for automated data freshness (Learning Loop 1). Bridges the gap between MCP-accessible live systems and deterministic file transformation.
>
> **Architecture reference:** MOSAIC-OPERATIONS §4 (Pipeline Architecture).

## Architecture

```
Phase 1: MCP Data Acquisition (Claude Code)
  Agent queries live systems via MCP → writes JSON snapshots to inputs/
      ↓
Phase 2: Transformation (Python)
  Script reads snapshots + overlay YAML + lookup tables → regenerates QUICK file sections
      ↓
Phase 3.5: Enrichment Queue (Python)
  Script scans entity profiles for gap markers → outputs prioritized CSV + prompts
      ↓
Phase 3: Post-Processing (Claude Code + User)
  Review run summary → process batch CSV → mark deltas complete → upload
```

## Directory Structure

```
pipeline/
├── README.md                              (this file)
├── generate-domain-quick.py               (Phase 2 — adapt from template)
├── generate_enrichment_queue.py            (Phase 3.5 — adapt from template)
├── overlays/
│   └── {ORG}-{DOMAIN}-OVERLAY.yaml        (curated human-judgment fields)
├── inputs/                                (.gitignored — Phase 1 JSON snapshots)
│   └── *.json                             (e.g., deals-2026-03-15.json)
└── run-logs/                              (.gitignored — pipeline outputs)
    ├── run-summary-YYYY-MM-DD.md
    ├── enrichment-queue-YYYY-MM-DD.csv
    ├── enrichment-prompts-YYYY-MM-DD.md
    └── {system}-updates-YYYY-MM-DD.csv
```

## Setup

1. Copy `generate-domain-quick.py.template` to `generate-domain-quick.py`
2. Copy `generate_enrichment_queue.py.template` to `generate_enrichment_queue.py`
3. Create your overlay YAML in `overlays/` (see overlays/README.md)
4. Create `inputs/` and `run-logs/` directories (gitignored)
5. Configure lookup tables (stage mapping, owner mapping) as YAML in `pipeline/`
6. Update instance CLAUDE.md Pipeline Operations section with your system-specific MCP procedure

## Phase 1 JSON Schema

Each snapshot wraps its data in a named object (self-documenting):

```json
{"deals": [{"id": "123", "name": "Acme Corp - Service", "stage": "negotiation", ...}]}
{"teams": [{"gid": "456", "name": "Engineering", ...}]}
{"tasks": [{"gid": "789", "name": "[DELTA] Acme: Owner changed", ...}]}
```

## Batch Update CSV Format

For pushing corrections back to source systems (e.g., CRM bulk update tools):

```csv
Action,Record ID,Record Name (current),Property,Current Value,New Value,Category,Notes
Update,12345,Acme Corp,owner,old_owner_id,new_owner_id,Owner Reassignment,Departed employee
Update,12346,Acme Corp - Phase 2,dealname,Acme Corp - Phase 2,Acme Corporation - Phase 2,Name Fix,Standardize naming
```

## Enrichment Track Classification

| Track | Criteria | Method |
|-------|----------|--------|
| **Track 2** | >12 MCP-TBD gaps | Claude Code MCP enrichment (parallel system pulls) |
| **Track 1** | <=12 MCP-TBD gaps | Claude.ai web research (generated prompt) |
| **BD-only** | Gaps require human knowledge | Route to relationship owner |
| **Missing** | No profile exists | Create from template if lifecycle warrants |

## Customization Points

Each instance customizes:
- **Phase 1 MCP calls** — which systems, which properties, which filters
- **Overlay schema** — which fields represent human judgment in your domain
- **Lookup tables** — stage mappings, owner mappings, terminology normalization
- **Matching logic** — how to correlate live data entities with overlay entries
- **Gap markers** — which markers indicate missing data in your profiles (MCP-TBD, BD-TBD, etc.)
- **Enrichment prompts** — what questions to ask about each entity for Track 1/Track 2
