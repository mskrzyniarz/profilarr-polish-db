# Polish Compact Profilarr Database

Polish-focused, compact-media Profilarr Compliant Database (PCD) for:
- Radarr (movies)
- Sonarr (TV series)

This repository follows the current PCD operational model (`pcd.json` + append-only SQL in `ops/`).

## Purpose

This database is designed to enforce a strict language-first selection strategy for Polish users while keeping files compact:

1. Prefer explicit Polish audio
2. Then prefer trusted `MULTi` releases from trusted Polish release groups
3. Then prefer Polish subtitles
4. Allow non-Polish fallback releases temporarily
5. Upgrade fallback releases when higher language tiers become available
6. Keep technical preferences strictly secondary to language tiers

### Size Targets (Guideline)

This database also targets compact file sizes as a practical baseline.

Movies (Radarr):
- 2160p: usually around 5-8.5 GB (hard automatic rejection above 12 GB)
- 1080p: usually around 2.5-5 GB
- 720p: usually around 1-3 GB

Episodes (Sonarr):
- 2160p: usually around 1-3 GB per episode
- 1080p: usually around 0.7-2 GB per episode
- 720p: usually around 0.35-1 GB per episode

## Supported Applications

- Radarr
- Sonarr

## Installation and Usage

1. Add this repository as a custom database source in Profilarr.
2. Ensure Profilarr version is compatible with this repository (`minimum_version` in [pcd.json](pcd.json)).
3. Import and apply:
	- `Polish Compact Movies` to Radarr
	- `Polish Compact Series` to Sonarr
4. Sync custom formats, profiles, and quality definitions.

## Language Priority System

Primary tier scores:
- `Polish Explicit`: `+500000`
- `Trusted MULTi`: `+400000`
- `Polish Subtitles`: `+300000`
- Fallback (no language-tier match): `0`

Hard bans:
- Every hard ban CF score is `-999999`

The mandatory tier ordering is preserved:

`Polish Explicit` > `Trusted MULTi` > `Polish Subtitles` > `Fallback`

## Trusted Polish Release Groups

Each trusted group has an individual regex:

`AdL`, `AZQ`, `BiRD`, `CoLO`, `DENDA`, `DReaM`, `DSiTE`, `DZiDEK`, `ELiTE`, `FOX`, `FT`, `GUN`, `J`, `K37`, `K83`, `KiT`, `KPFR`, `LEX`, `LLA`, `LTN`, `LTS`, `MAXX`, `MiNS`, `Mixio`, `Net`, `Nitro`, `NN`, `OzW`, `PABLO`, `R22`, `Ralf`, `RobSil`, `RX`, `S56`, `S78`, `wasik`, `WiKi`, `XuploaD`.

They are aggregated by `Polish Release Group` (score `0`, classification-only).

## Trusted MULTi Logic

`Trusted MULTi` applies only when:

- `MULTi` marker is present
- and at least one trusted Polish release group marker is present

Important:

- `MULTi` alone does not get `+400000`
- Trusted group alone does not get `+400000`

## Polish Subtitle Fallback

`Polish Subtitles` applies on explicit Polish subtitle markers (for example `Napisy PL`) and sits strictly below `Trusted MULTi`.

`Napisy PL (AI)` can match subtitle logic, but the AI hard-ban CF still forces rejection.

## Hard-Ban Policy

The following are hard banned (`-999999`):
- `Unaccepted Media Quality`
- `3D`
- `AI Generated / Upscaled`
- `File Above 12GB` (Radarr-only)

### Unaccepted Media Quality includes

- `CAM`/`TS`/`TC`/`SCREENER`/`WORKPRINT` - style release markers
- DCP-style theatrical low-quality markers covered by reused CAM-core pattern
- line/mic dubbed low-quality markers

Polish language markers never override hard bans.

## File Size Policy

### Radarr (Movies)

- Typical target: compact movie sizes
- Absolute hard ceiling: > 12GB is rejected by `File Above 12GB`

### Sonarr (Series)

- Separate Sonarr quality definitions are provided
- Values are tuned for episode/season-pack behavior and are intentionally lower than movie expectations

## Resolution Preference

Within the same language tier:
- `2160p`: `+40000`
- `1080p`: `+25000`
- `720p`: `+10000`

## Codec Preference

Within the same language/resolution tier:
- `AV1`: `+20000`
- `HEVC/x265`: `+15000`
- `AVC/x264`: `+5000`
- `Codec x265 Missing`: `-2000` (applies to `1080p/2160p` titles missing `AV1/HEVC/AVC` markers)

No hard ban is applied to `x264`, `AVC`, or `XviD`.

## HDR Preference

Secondary video bonuses:
- Dolby Vision: `+10000`
- Dolby Vision Without Fallback: `-6000` (Dolby Vision marker with no HDR fallback marker)
- HDR10+: `+9000`
- HDR10: `+7000`
- HDR: `+5000`
- 10bit: `+3000`

Conditions include negations to reduce overlapping HDR double-stacking.

## Audio Preference

Secondary audio bonuses:
- Atmos: `+8000`
- DTS:X: `+7000`
- TrueHD: `+6000`
- DTS-HD MA: `+5500`
- DDP5.1: `+4500`
- Dolby Digital Plus: `+4000`
- DD5.1: `+3000`
- Dolby Digital: `+2000`
- DD2.0: `+1000`

Conditions include negations to minimize accidental double-counting.

## Source Preference

- WEB-DL: `+8000`
- WEBRip: `+4000`

Remux and BR-DISK are disabled in profile quality ordering for compactness.

## Score Safety Validation

Language tier gap is `100000` between primary tiers.

Configured technical maximum is constrained below that gap:
- Max resolution bonus: `40000`
- Max codec bonus: `20000`
- Max HDR stack (after negation design): `13000` (`Dolby Vision + 10bit`)
- Max audio bonus target: `8000`
- Max source bonus: `8000`

Total practical max technical bonus:

`40000 + 20000 + 13000 + 8000 + 8000 = 89000 < 100000`

Therefore technical stacking cannot bridge language tiers.

## Upgrade and Fallback Behavior

Both profiles are configured with:

- `minimum_custom_format_score = 0` (fallback allowed)
- finite `upgrade_until_score = 589000`

This keeps fallback viable while allowing upgrades to better language tiers when available.

## Native Arr Upgrade Limitations

Radarr/Sonarr may not always replace a technically superior higher-resolution fallback release with a lower-resolution higher-language-tier release in every scenario, depending on native quality/upgrade constraints.

This repository does not claim unsupported native behavior.

## Test Coverage

Custom format tests are included in [ops/1.initial.sql](ops/1.initial.sql) using the provided release-title corpus for:
- hard-ban detection
- Polish explicit detection
- trusted MULTi detection
- Polish subtitles detection
- positive and negative matching behavior

Note: title-based tests cannot validate file-size conditions directly because size-aware logic uses `condition_sizes` with runtime metadata.

## Repository Structure

- [pcd.json](pcd.json): manifest
- [ops/1.initial.sql](ops/1.initial.sql): base append-only operations
- [deps/.gitkeep](deps/.gitkeep): dependency layer placeholder
- [tweaks/.gitkeep](tweaks/.gitkeep): optional tweaks layer placeholder

## Attribution / Reused Sources

Patterns and conventions were reused from:
- Dictionarry-Hub/database
- Dumpstarr/Database
- Dictionarry-Hub/trash-pcd
- Dictionarry-Hub/schema

## Credits

This database was built by following the architecture and conventions used by the three PCD source databases below and by reusing selected tested patterns from them:
- Dictionarry Database: https://github.com/Dictionarry-Hub/database
- Dumpstarr Database: https://github.com/Dumpstarr/Database
- TRaSH Guides PCD: https://github.com/Dictionarry-Hub/trash-pcd
