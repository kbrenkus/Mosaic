# Overlay YAML Pattern

> **Purpose:** Overlays are curated human-judgment fields that form the foundation layer for pipeline transformation. They represent decisions, not data.
>
> **Architecture reference:** MOSAIC-OPERATIONS §4.5 (The Overlay Pattern)

## What Overlays Are

An overlay YAML file contains fields that cannot be auto-derived from live systems:
- **Lifecycle state** — a human judgment about where an entity stands (active, prospect, paused)
- **Display names** — the canonical name for an entity (which may differ from CRM records)
- **Short names** — abbreviated identifiers used in file naming and cross-references
- **Tier assignments** — strategic prioritization levels (determines depth of coverage)
- **Strategic flags** — labels like "target-account", "expansion-candidate", "at-risk"
- **Owner/steward** — the human responsible for the relationship or domain
- **Notes** — free-text context about the entity

## Schema

```yaml
# {ORG}-{DOMAIN}-OVERLAY.yaml
# Curated human-judgment fields for pipeline transformation

EntityKey:
  display_name: "Full Display Name"
  short_name: "ShortName"           # Used in file naming: {ORG}-CLIENT-{ShortName}
  lifecycle: "active"               # active|engaged|prospect|paused|inactive|closed
  tier: 2                           # Coverage tier (1=highest, 3=lowest)
  owner: "Jane Smith"               # Relationship/domain owner
  flags:                            # Strategic labels
    - "target-account"
    - "expansion-candidate"
  asana_team: "Team Name"           # Cross-system identifier (optional)
  notes: "Free-text context"        # Human notes (optional)

AnotherEntity:
  display_name: "Another Entity Name"
  short_name: "AnotherEntity"
  lifecycle: "prospect"
  tier: 3
  owner: "John Doe"
  flags: []
  notes: ""
```

## How Overlays Interact with the Pipeline

```
Overlay YAML (human judgment)  +  Live system snapshot (current data)
                    ↓                        ↓
              Pipeline merges them into a single view
                    ↓
         Regenerated QUICK file section
```

The overlay provides the **stable fields** (lifecycle, tier, display name). The live system provides the **current data** (deal stages, amounts, dates, activity). The pipeline merges them and regenerates the reference file section.

## When to Edit Overlays

- **New entity discovered** — add an entry with lifecycle, tier, and owner
- **Lifecycle change** — update the lifecycle field (e.g., prospect -> active)
- **Tier change** — adjust based on strategic priority
- **Flag change** — add/remove strategic labels
- **Entity renamed** — update display_name and short_name

**Never auto-edit overlays.** The pipeline reads them but never writes to them. All overlay changes are human decisions.

## Governance

- One person (typically the system owner) maintains the overlay
- Changes are reviewed during the maintenance cycle (Step 4E in §10)
- Overlay edits trigger a pipeline re-run to propagate the change
- The overlay is version-controlled in git alongside other instance files
