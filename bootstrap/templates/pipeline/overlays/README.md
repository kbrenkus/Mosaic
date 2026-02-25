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

## Production Lessons

### Schema Evolution

Start with a generous schema. Production deployments consistently discover the need for optional fields that weren't anticipated during initial design:

- `verify` (list of strings): Fields with conflicting signals needing human verification. Omit when clean; populate when discrepancies are detected between systems. Example: lifecycle shows "Active" in CRM but no recent communication in 8 months.
- `deal_name_aliases` or `name_aliases` (list of strings): Additional name variants for fuzzy matching against system records. Handles "Acme Corp" vs "Acme Corporation" vs "ACME" mismatches that name normalization alone can't resolve.
- `profile_filename` (string): Override auto-detected profile filename for entities whose short name doesn't map cleanly to file naming conventions (special characters, abbreviations, disambiguation).
- Cross-system GID fields (e.g., `asana_team_gid`, `hubspot_company_id`): Explicit identity overrides for entities that cannot be matched by name alone. These bypass name matching entirely — essential for entities with very common names or names that differ significantly across systems.

### Cross-System Identity

The overlay's entity key (typically the short name) becomes the identity anchor across all systems. Name normalization in the pipeline handles common variations (case, whitespace, punctuation), but some entities require explicit mapping. Build this incrementally:

1. First pipeline run surfaces unmatched entities in the run summary
2. Investigate each: is it a name variant (add alias), a new entity (add to overlay), or junk data (add to exclusion filter)?
3. Add aliases or GID overrides as mismatches appear
4. Over time, the overlay's identity mapping becomes comprehensive

Expect 3-5 iterations before match rates stabilize above 95%.

### Overlay Size

One entry per tracked entity. A production overlay with ~40 entities at ~10-12 lines each produces ~500 lines of YAML. YAML scales well to 200+ entries without performance concerns. For very large domains (500+ entities), consider splitting into sub-overlays by tier or category, loaded selectively by the pipeline.
