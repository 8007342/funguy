# Forge diagnostics — FunGuy initialization

Observed 2026-10-17 in `/home/forge/src/funguy`. This is a maintainer handoff, not a claim that every absent tool is a forge defect. No credentials are included.

## Confirmed blockers

### Outbound connections reset for required source APIs and media

Reproduce from the container:

```sh
curl -I --max-time 15 https://api.inaturalist.org/v1/projects/sdmyco
curl -I --max-time 15 https://upload.wikimedia.org/
```

Both return `curl: (56) Recv failure: Connection reset by peer`, before an HTTP status. Python urllib downloads of three concrete Wikimedia original JPEG URLs likewise return `[Errno 104] Connection reset by peer`. This prevents resolving the live SDMYCO project identity, testing real observation payloads and bundling licensed reference photos. The browser-backed web reader can read Wikimedia description pages; that does not restore container binary downloads. GitHub source/artwork fetching and npm dependency installation worked.

Suggested investigation: inspect outbound proxy/domain policy and TLS connectivity for `api.inaturalist.org`, `upload.wikimedia.org` and thumbnail/media hosts. No cause was established here; do not assume the remote service, proxy or DNS is responsible without checking. No proxy configuration was changed.

### Documented project-discipline CLI is absent

```sh
command -v tillandsias-plan
tillandsias-plan discipline show
tillandsias-plan discipline derive
```

`command -v` has no result; the commands report `command not found`. The installed `/home/forge/.codex/skills/project-discipline/SKILL.md` directs agents to use these commands before determining branch discipline. This checkout has no `.tillandsias/branch-discipline.yaml`. `git config --get core.hooksPath` points to `/home/forge/.cache/tillandsias/git-hooks`, containing attribution `prepare-commit-msg` and expert-refresh `post-commit` hooks, with no pre-commit/pre-push discipline hooks. The documented discipline audit could not run. Provide the CLI or update the skill to describe the available replacement/fallback.

## Tooling boundaries and non-blocking observations

- Flutter **works** through `/usr/local/sbin/flutter`, a host-backed wrapper, rather than an SDK under `/opt/flutter`. `flutter --version` reports Flutter 3.47.7 / Dart 3.13.5. `flutter create`, `flutter analyze`, `flutter test` and the release web build succeeded. The first create took roughly a minute before output; long silent command startup can look stalled. More progress/host-session status would help. Do not report Flutter as missing.
- `dart` is available separately at `/home/forge/.cache/tillandsias-project/dart/dart-sdk/bin/dart`; formatting works.
- Node 22.23.1 / npm 10.9.8 work, including `npm ci`. Every Node/npm launch emits `UNDICI-EHPA: EnvHttpProxyAgent is experimental`; non-fatal noise. Check wrapper defaults if unnecessary for this Node version.
- No `adb` or `xcodebuild` found on the container PATH. Java is present. `flutter doctor -v` in the host-backed toolchain confirms **Unable to locate Android SDK**. Android native builds therefore need SDK provisioning; the project scaffold alone cannot produce an APK here. iOS release builds require a macOS/Xcode runner and are an expected Linux limitation.
- No local `chromium` or `google-chrome` command found. `flutter doctor -v` also cannot find Chrome in the Flutter toolchain. Host browser tools are supplied and a local Wrangler preview rendered successfully through them; use those instead of assuming browser verification is unavailable. Direct `flutter run -d chrome` requires separate Chrome configuration. Preview/browser results are recorded below.
- OpenSpec CLI is installed and initialization/validation worked. The scaffold skill first writes legacy `openspec/project.md`, causing a migration warning when modern `openspec init` runs. Useful context was migrated into `openspec/config.yaml`; consider updating the scaffold script to write modern config directly.

### Additional host toolchain gaps from `flutter doctor -v`

Linux desktop build tools are absent in the shared Flutter image: `clang++`, CMake, Ninja and pkg-config. Linux desktop is outside this project’s requested targets, so these did not block the web work. Flutter doctor reports its standard network-resource checks pass; those checks do not cover the failing iNaturalist/Wikimedia domains above.

## Project features deliberately not shipped

The remaining iNaturalist ingestion, field-pack downloads, camera/GPS, durable notebook, local inference and feedback system are product milestones, not forge installation failures. Cloudflare authentication/deployment and native signing were not attempted. See `plan/roadmap.md`.

## Verification handoff

- Flutter analysis: passed, no issues.
- Widget integration flow (guide search → bookmark → notebook → specimen detail): passed.
- OpenSpec validation: 1 spec passed.
- Release web build and content-versioned offline shell generation: passed.
- `npx wrangler deploy --dry-run --outdir /tmp/funguy-deploy-check`: passed, including the configured custom Flutter build. No public deployment or account authentication was performed.
- Host Chromium preview rendered at iPhone 12 Pro Max (428 × 926) and iPhone SE (320 × 568) dimensions. After complete custom service-worker installation, a normal reload with CDP network emulation set offline rendered the Flutter app (`navigator.onLine == false`, `flutter-view` present, loading placeholder removed). This is an app-shell smoke test, not a physical iOS/Safari storage-retention or full field-pack test.
- Initial offline checks exposed a project integration issue: Flutter’s default bootstrap registered a legacy service worker in the same scope. Added `web/flutter_bootstrap.js` to load Flutter without that registration; FunGuy now owns its worker. This was fixed in project code and is not a forge defect.
- The host browser’s network allowlist blocked Google font fallback requests from an earlier build containing unsupported arrow glyphs. Those decorative glyphs were removed. Production typography should use bundled fonts rather than rely on fallback font downloads.
