# Copilot Instructions for Polish Compact Profilarr Database

## Project purpose

This repository contains a Profilarr PCD database for Polish-language compact media preferences.

Primary goals:
- prioritize Polish-language audio and subtitle tiers
- keep quality compact and practical for Radarr/Sonarr users
- enforce strict hard bans for low-quality / AI / 3D / oversized media
- avoid bringing back quality definitions that violate Arr API constraints
- maintain compatibility with Profilarr dependency model and schema requirements

This project is meant for:
- Radarr profiles for movies
- Sonarr profiles for TV series
- custom format scoring with language-first logic
- compact media size strategy while keeping technical quality secondary to language tiers

## Core design principles

1. Language-first ordering is the real priority
   - Polish Explicit > Trusted MULTi > Polish Subtitles > Fallback
   - technical bonuses must never override the language tier ordering

2. Hard bans are absolute
   - Unaccepted Media Quality
   - 3D
   - AI Generated / Upscaled
   - File Above 12GB (Radarr-only)

3. Compactness is a target, not a license to violate API constraints
   - source preferences and quality ranking are intentionally compact
   - all syncable values must remain valid for Arr/Profilarr APIs

4. Profilarr compatibility matters more than "ideal" database values
   - `pcd.json` must keep the schema dependency in the exact required repository URL form
   - database cache compilation must work before any profile logic matters

5. Prefer minimal valid changes over broad rewrites
   - avoid changing core logic without a clear root cause
   - do not add speculative quality names or mappings unless they are known valid in the upstream schema

## Important technical rules learned during fixes

### 1. Schema dependency format

This is required by Profilarr:

```json
"dependencies": {
  "https://github.com/Dictionarry-Hub/schema": "1.1.0"
}
```

Do not replace this with a short alias like `"schema": "^1.1.0"`.
Profilarr validates against the exact schema repository URL and will fail linking otherwise.

### 2. Do not re-insert canonical schema quality rows

The table `qualities` and `quality_api_mappings` are canonical schema data and must not be duplicated in the PCD base layer.

Problem observed:
- `UNIQUE constraint failed: qualities.name`

Rule:
- do not add duplicate rows into `qualities`
- do not add duplicate rows into `quality_api_mappings`
- only define profile-specific rows, custom formats, quality profile ordering, and delay profiles in this repo

### 3. Radarr/Sonarr quality definitions must satisfy Arr validation rules

The upstream Arr contract requires:
- `min_size <= preferred_size <= max_size`
- `max_size <= 2000` for quality definitions in the API surface
- values are represented in MB/min, not raw file size in GB

Problem observed:
- HTTP 400 on media management sync when size values were too high or invalidly ordered

Relevant constraints:
- `QualityDefinitionLimits.Max = 2000`
- `SizeSpecification` validator requires `Max > Min`

### 4. File Above 12GB custom format must use valid size bounds

The `SizeSpecification` validator in Radarr/Sonarr requires a finite `max` value greater than `min`.

This is valid pattern:
- `min_bytes = 12 * 1024 * 1024 * 1024`
- `max_bytes = 9999 * 1024 * 1024 * 1024`

Do not leave `max_bytes` as `NULL` in a custom format that is synced to Arr as a SizeSpecification, because it will serialize to invalid values and fail.

### 5. Quality definition targets and project targets are different concepts

Project target assumptions are conceptual and should remain realistic for compact media:
- 2160p movies: roughly 4–7 GB
- 1080p movies: roughly 2.5–5 GB
- 720p movies: up to 3 GB
- 2160p episodes: roughly 2–4 GB
- 1080p episodes: roughly 1–2 GB
- 720p episodes: roughly 0.5–1 GB

These are the project design targets, not necessarily the exact values used in Arr `quality_definitions` after conversion to MB/min.

### 6. Arr quality definition values are not direct GB values

For Arr UI/API, `quality_definitions` are in MB/min, not total file size in GB.

Example:
- 2160p target ~4–7 GB is approximately 40–75 MB/min
- this must still stay within the Arr-supported 0–2000 MB/min range

Do not write documentation or config using raw GB values as if they were direct `quality_definitions` values.

## Repository structure

- `README.md` — main project overview and documented behavior
- `pcd.json` — Profilarr database manifest and dependency declaration
- `ops/1.initial.sql` — main append-only SQL defining profiles, formats, conditions, testers, and quality definitions
- `deps/` — dependency layer placeholder
- `tweaks/` — optional tweaks layer placeholder

## File conventions

### SQL rules
- do not reintroduce duplicate canonical quality inserts
- keep the schema dependency and profile definitions separated properly
- ensure all inserted values match the supported Arr validation model
- preserve append-only style unless a specific fix requires targeted mutation

### README rules
- keep project assumptions accurate
- distinguish target profile intent from Arr API-compatible sync values
- explain the relationship between GB targets and MB/min values where relevant

## Approval criteria before making changes

Before finalizing a change, verify these items:
- `pcd.json` still contains the exact schema repository dependency format required by Profilarr
- there are no duplicate `qualities` inserts
- no invalid `quality_api_mappings` duplicates or unsupported names
- all custom format size limits are valid and finite
- all `quality_definitions` satisfy `min <= preferred <= max` and `max <= 2000`
- the final change does not break the database cache build during profiling/linking

## Common pitfalls to avoid

- changing the schema dependency key to a short alias
- re-inserting canonical quality rows in `ops/1.initial.sql`
- using `NULL` max bounds for Arr size conditions
- using size values outside the valid Arr contract
- mixing project target GB sizes with Arr API MB/min values without clarifying the difference
- adding speculative quality names that do not exist in upstream Arr schema

## Recommended workflow for future tasks

1. Start from the root cause, not a guess.
2. Check whether the problem is in:
   - manifest schema dependency
   - canonical schema data duplication
   - Arr validation of size fields
   - custom format condition logic
   - profile ordering / quality names
3. Make one minimal fix at a time.
4. Validate the relevant file structure and SQL syntax.
5. Re-test the link/build flow in Profilarr before adjusting other assumptions.

## Useful context for AI agents

This repository is intentionally opinionated but must remain compatible with external constraints.

The following are the "non-negotiables":
- no duplicate canonical rows
- no invalid size conditions in Arr custom formats
- no schema manifest shortcuts
- language-first logic remains primary
- compact quality targets remain realistic and aligned with the project goals

## Summary

When working on this repository, prioritize:
- Profilarr compatibility
- Arr validation rules
- schema integrity
- project compactness without breaking the API contract
- meaningful, minimal, explainable fixes

If a fix seems to "work" only by breaking Arr constraints or by duplicating canonical schema rows, it is not correct for this project.
