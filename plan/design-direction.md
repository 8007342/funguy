# Funguy: a field notebook that comes alive

Design proposal, 2026-10-17. Initial direction for discussion; platform and data guarantees belong to the technical investigation.

## The feeling

A beautiful Southern California naturalist's notebook: warm paper, deep forest teal, mushroom photography, quiet coral details and generous space. Science should be legible before decoration. A ranger can open the app in harsh daylight, see what is actually on the device, and start recording within one thumb movement.

Suggested palette: paper `#F7F2E8`, light card `#FFFCF5`, forest ink `#173E36`, teal `#276D69`, moss `#778163`, coral `#EC6F7B`, ochre `#B97B35`. Treat these as proposed product tokens; the supplied character references take precedence for character colors. Use a confident editorial serif for short titles with a highly readable sans for labels and scientific detail. Bundle any chosen font and its license so offline display never depends on a font server.

Use rounded 20–28 px cards with restrained shadows and botanical line accents. Keep surfaces mostly flat; photography supplies depth. Large common names sit above italic scientific names. Observation date, locality precision and attribution remain visible rather than hidden inside an info menu. Distinguish status with an icon and words as well as color.

## Four destinations

| Destination | Primary task | Essential first-screen content |
| --- | --- | --- |
| Field guide | Explore the downloaded collection | Search, taxa/observations toggle, DNA-evidence filter, large photo cards, saved-only filter |
| Observe | Record an encounter | Camera or import, multi-photo checklist, location state, save locally |
| Notebook | Review personal records | Dated encounters, provisional labels, upload/export state, drafts |
| Offline packs | Prepare for a trip | Available space, installed packs, exact coverage, download and verify controls |

A prominent camera action can sit at the center of bottom navigation. On wider screens, use a rail and a detail pane; preserve the same routes and actions. A small persistent status line says “Offline · Coastal pack available” or “Online · last refreshed …”; do not infer connectivity from a decorative icon alone.

## The first beautiful screen

Start with “A little closer to the forest.” above a wide specimen photo and an understated “San Diego field collection” label. Below it, one compact preparation card shows actual local pack status and a call to explore the collection. Use a two-column photo grid on larger phones and a single spacious column when accessibility text grows. Show DNA evidence only where a record actually contains it. Until real ingestion exists, label seeded content as a demo collection in the interface and keep counters tied to that demo data.

Avoid manufactured live-weather badges, fabricated downloaded counts and fake identification confidence. Beautiful empty states are preferable to misleading readiness claims.

## Before leaving coverage

The pack screen previews region, snapshot date, observation count, taxon count, thumbnail count, expected download size and model size separately. Offer a compact metadata + thumbnail pack, larger photo pack, and optional identification model. Show “Available offline” only after every required file passes verification. Interrupted downloads resume where possible. Version updates must preserve the previous complete pack until the new one is ready.

Provide “Check my pack” with an explicit offline readiness result, a browse-preview action and the last verification time. Explain whether browser storage persistence was granted. Personal records have a separate export/backup action; deleting a guide pack must never delete a user's observations. Do not call cached weather current weather. Show its observation/forecast timestamp and label it cached.

## Photograph, observe, compare

Guide capture with four small optional prompts: cap, underside, complete stem/base, habitat. Let the person skip any prompt and save immediately. Ask for location only when recording; keep a manually chosen locality as a fallback. Display GPS accuracy and capture time. Record habitat, substrate, nearby trees, approximate size and field notes with easy chips plus free text. A photo can remain an observation even when location or a model is unavailable.

Save the record and originals locally before inference starts. Present local analysis as a separate cancellable operation. First identify photo suitability, then show a short ranked comparison set with matching traits and missing evidence. Display model version, downloaded coverage and uncertainty. “No reliable suggestion” is a legitimate finished result. Never present image inference as DNA confirmation or as an edibility decision. Evidence labels belong to the source specimen, not automatically to a new photographed mushroom.

Each suggestion opens a comparison sheet with this photograph beside attributed reference specimens, distinguishing features and look-alikes. The person's selected label stays marked provisional; preserve the model output separately from the user's determination. A saved observation can later gain a specimen accession and linked sequencing evidence without rewriting its history.

## Evidence that deserves trust

Use separate chips for community identification quality, DNA-related source evidence, and offline availability. A DNA chip should open its evidence: actual source field or link, accession when available, association to the specimen and last fetched time. “Research grade” and “DNA sequenced” must remain distinct. When sequencing evidence is unverified, say so rather than displaying a generic verified checkmark.

Source cards keep photographer credit, observation link, license and date. Handle hidden or obscured localities explicitly; precise personal coordinates are private by default and sharing is intentional. A sequence-backed reference helps comparison but cannot prove a new mushroom's identity.

## Tlatoāni and Mācron

Read and preserve the supplied [character canon](../assets/brand/character-canon.md). Tlatoāni observes calmly and admits uncertainty; Mācron acts and experiments. Their roles fit observation and local processing beautifully, but avoid making either an identification authority.

- Preparation: Tlatoāni checks a notebook while a small Mācron packs reference cards. Copy: “A few good references go a long way.”
- First empty notebook: Tlatoāni crouches beside a mushroom without touching it. Copy: “Start with what you notice.”
- Processing: a small Mācron compares photo cards; the real progress and cancel control remain ordinary accessible UI.
- Incomplete evidence: Tlatoāni considers the underside of a cap. Copy: “One more angle might help.”

Keep Tlatoāni pink with external coral gills, one tail, no facial hair, cream clothing and restrained teal geometry. Mācron is a tiny cream robot with a dark cyan-expression screen, antenna, two arms and a modular right arm; never a baby axolotl. Keep their canonical names and macrons. Avoid random pseudo-Mesoamerican ornaments and generated text inside artwork.

The downloaded [field reference](../assets/brand/tlatoani-field-reference.png) establishes warmth, terrain and notebook imagery. Its full-scene composition and embedded text make it supporting inspiration, not a production loading sprite. See [provenance](../assets/brand/PROVENANCE.md). Existing images are not automatically canon. New illustrations remain exploratory until the user approves them.

## Motion, access and field ergonomics

Use Flutter's built-in transitions for 150–250 ms fades, page changes and restrained button feedback. Honor reduced-motion preferences and pause animations when offscreen. Flame is optional for a future interactive character scene; it is unnecessary for navigation, pack progress and loading loops. Keep camera controls stable and avoid animation that competes with focus.

Plan for one-handed use, 48 logical pixel targets, screen readers, 200% text sizing, daylight contrast and safe areas. Camera import and manual notes remain available when permissions are denied. Avoid auto-playing video, decorative particle effects and animation during power-sensitive inference. Download sizes and progress should be understandable without color, sound or a moving character.

## Discussion decisions

Validate three journeys before expanding scope: prepare a verifiable offline pack, record a multi-photo encounter offline, and compare it against honest reference evidence. Prototype these first on an iPhone PWA and Android PWA; decide on native distribution using measured storage survival, offline restart, camera behavior and model performance. The visual system and Flutter routes should remain reusable if native becomes necessary.

## Sources inspected

- [Original asset directory](https://github.com/8007342/macron.dev/tree/main/assets)
- [Full character canon](https://github.com/8007342/macron.dev/blob/main/assets/Tlato%C4%81ni%20%2B%20M%C4%81cron%20cannon%20guidelines.md)
- Supporting originals inspected: Understand Movement, Measurements, Sir Isaac Newton Discovers Calculus, Read The Pattern, Tlatoani_banner_4 and Tillandsias GitHub App. The historical images span inconsistent styles; do not combine them indiscriminately.
