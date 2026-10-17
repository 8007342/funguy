# FunGuy 🍄

A little closer to nature. A mobile mushroom field companion for San Diego explorers: prepare a regional guide before hiking, record discoveries offline, and compare possible identifications with visible evidence.

## Current foundation

Flutter web, Android and iOS scaffolds; OpenSpec requirements; a parchment-and-forest mobile preview with illustrative species cards, search, session bookmarks and detail sheets. Existing Tlatoāni artwork supports empty states. Cloudflare deployment configuration and a custom offline app-shell cache are included.

**Not implemented yet:** live SDMYCO import, downloadable field packs, durable notes, camera/GPS capture, weather, local models and feedback submission. The “Meet a mushroom” button explains the planned interaction. “Fungi!” will celebrate mushroom detection; “This looks like…” will introduce uncertain species suggestions. Drawings are decorative, not identification references.

## Run and verify

Requires Flutter on PATH and Node.js 22+.

```sh
flutter pub get
npm ci
npm run dev
npm run check
npm run build
```

`npm run build` runs `flutter build web --release --no-web-resources-cdn`, then generates a content-versioned service worker for the app shell and bundled assets. The first complete online installation is required. This does not yet implement verified regional pack downloads. Bookmarks are intentionally session-only in this preview.

## Cloudflare

```sh
npx wrangler login
npx wrangler deploy
```

Wrangler runs the build and publishes `build/web` as Workers Static Assets. The Wrangler deployment dry run passed; no public Cloudflare deployment has been performed. Run builds where Flutter is installed; Cloudflare's standard Node build environment needs a separately provisioned Flutter SDK. Use `npm run build`, not `npx run build`.

For a local production preview: `npx wrangler dev --ip 0.0.0.0 --port 8080`. A normal reload with network disabled passed in host Chromium after the first complete service-worker installation. Physical Android/iOS storage-retention and Safari tests remain. Updates wait for old app tabs to close; user encounters will use a separate durable store in a later milestone.

## Product decisions

Start with the PWA. Camera, GPS and offline storage do not require an app store. Measure storage reliability and local model performance on actual ranger phones before deciding on native distribution. Android/iOS project scaffolds are ready for future adapters; the host toolchain currently lacks the Android SDK; native releases still need toolchains, final app identifiers, permissions, icons, signing and store accounts. No native build has been verified here.

DNA sequence evidence, analysis links, voucher records and iNaturalist Research Grade remain separate. A visual suggestion cannot establish DNA evidence for a new specimen. User feedback is optional and must not silently become a verified training label.

## Project memory

- `openspec/specs/funguy/spec.md`: intended product requirements, including future milestones.
- `plan/roadmap.md`: remaining work.
- `plan/data-research.md`: source projects, DNA fields, attribution and ingestion policy.
- `plan/platform-research.md`: PWA/native decision and offline architecture, with primary sources.
- `plan/design-direction.md`: visual language, capture/comparison flows and character rules.
- `FORGE_DIAGNOSTICS.md`: observed forge/toolchain gaps and reproduction commands.
- `assets/brand/PROVENANCE.md`: supplied artwork provenance and authorization context.

Software license: see LICENSE. Supplied character artwork has separate provenance; do not assume the software license applies to it.
