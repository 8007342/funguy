# Platform recommendation

Research checked 2026-10-17. Start with a Flutter mobile PWA and keep native Android/iOS adapters possible. A PWA can provide a downloadable field guide, photo capture, foreground location, field notes, and small on-device models. App stores are not required merely to access camera, location, or offline storage. Native builds become valuable when real-device trials demonstrate unacceptable inference speed, storage reliability, camera control, or interrupted-download behavior.

## What the platforms can do

| Need | Mobile PWA | Native Flutter app |
| --- | --- | --- |
| Offline guide and thumbnails | Custom service worker plus Cache API/IndexedDB; versioned downloads and quota handling required | App files and database; explicit backup/export still needed |
| Camera | Permission-based browser capture, HTTPS; test rear-camera selection and photo quality | More direct platform camera controls through plugins |
| GPS | Permission-based foreground location; preserve fix age and accuracy, allow manual location | Platform APIs and optional background modes; GPS still needs field testing |
| Local inference | JS interop to ONNX Runtime Web; WASM CPU baseline, optional detected GPU acceleration | Platform inference runtime adapter; evaluate hardware delegates on actual devices |
| Long downloads/sync | Make foreground resumable downloads the baseline; resume on next launch | OS background transfer/scheduling options; execution is still system controlled |
| Weather without a network | Previously downloaded weather snapshot, visibly timestamped | Same fundamental limitation; a phone does not supply a live weather forecast |
| Distribution | HTTPS URL and home-screen install | Signing, store accounts/review and release operations |

Camera and location require secure contexts and user permission under the [Media Capture specification](https://w3c.github.io/mediacapture-main/getusermedia.html) and [Geolocation specification](https://www.w3.org/TR/geolocation/). Offline location must show errors and manual fallback rather than assume a fresh fix is always obtainable.

WebKit supports storage estimates and persistence requests, but grants are heuristic and default storage is best effort. Home-screen web apps receive browser-level quotas; do not promise a fixed megabyte allowance or permanent retention. Inspect storage before download, handle quota failures, offer exports, and verify packs before a trip. See [WebKit storage policy](https://webkit.org/blog/14403/updates-to-storage-policy/). Home-screen web apps are exempt from ITP's seven-day script-storage cap; this is separate from general storage pressure and user deletion. See [WebKit tracking prevention](https://webkit.org/tracking-prevention/).

Flutter currently requires an explicitly configured service worker for advanced caching/offline use; a generated Flutter project alone is insufficient. Its web runtime also does not provide Dart isolates, so inference should use a web worker where practical. See [Flutter Web FAQ](https://docs.flutter.dev/platform-integration/web/faq).

## Proposed architecture

1. **Shared Dart domain and UI:** observations, taxon descriptions, evidence records, field encounters, pack manifests and readiness state. Interfaces for catalog storage, image storage, capture, location, inference and synchronization keep browser details outside widgets.
2. **Cloudflare ingestion and distribution:** scheduled ingestion creates immutable, attributed, versioned regional packs. Store catalog manifests/metadata separately from thumbnails and model artifacts. Serve Flutter's `build/web` through Workers Static Assets; add Worker API endpoints and R2 only when ingestion needs them. [Cloudflare Static Assets](https://developers.cloudflare.com/workers/static-assets/) supports this deployment unit.
3. **Offline packs:** immutable pack ID, source query and fetch time, licenses, checksum, byte count, taxon coverage and thumbnail coverage. Download into staging, verify every required file, then atomically mark ready. Keep the previous valid pack until replacement succeeds. Separate downloadable public catalog data from irreplaceable personal photos/notes.
4. **Field encounters:** save photo locally first, then coordinates with accuracy and capture time, habitat/substrate notes and manual correction. Queue optional uploads explicitly; the guide remains useful without signing in. Weather snapshots include source, fetched time and applicable interval. Zone/habitat data can be preloaded; never invent unavailable sensor readings.
5. **Model pack:** independently downloadable quantized model, preprocessing contract, class mapping, checksum, license and evaluation report. Return candidate taxa and uncertainty, with an explicit unknown result. Geospatial/seasonal context reranks candidates, but should not eliminate plausible observations solely because they fall outside known records. No identification model is selected or shipped yet.

[ONNX Runtime Web](https://onnxruntime.ai/docs/tutorials/web/) supports offline inference once artifacts are downloaded; its WASM backend supports all ONNX operators while GPU backends support subsets. Treat acceleration as an optimization and benchmark rather than assuming every mobile browser has an equivalent GPU path. Bundle runtime binaries and model artifacts with the pack instead of relying on a CDN during field use; see [runtime deployment requirements](https://onnxruntime.ai/docs/tutorials/web/deploy.html).

## Staged delivery and native decision

- **Foundation:** Flutter web/Android/iOS project structure, OpenSpec, mobile visual prototype, Cloudflare build/deploy scripts, service-worker shell caching. This is not yet the complete offline field product.
- **Offline guide:** verified source selection and DNA-evidence mapping, attributed thumbnail packs, transactional downloads, airplane-mode browsing and cold restart tests.
- **Field notebook:** camera, foreground location, durable encounters, export/import, resumable sync and clear pack readiness.
- **Inference experiment:** choose legally usable models/data, evaluate on held-out field photographs, measure latency, peak memory, battery cost and confidence calibration on representative older Android and iPhone devices. A small regional reference catalog is not automatically enough training data for a robust classifier.
- **Native gate:** build Android/iOS when measured requirements cannot be met on the PWA. Keep the same UI/domain; replace storage, capture and inference adapters. Android recommends [WorkManager for persistent work](https://developer.android.com/develop/background-work/background-tasks/persistent). iOS [background strategies](https://developer.apple.com/documentation/BackgroundTasks/choosing-background-strategies-for-your-app) remain scheduled by the OS, so native is not a guarantee of unrestricted background execution.

Suggested acceptance targets for discussion, not established benchmarks: verified pack survives a closed-app airplane-mode restart; interrupted downloads resume; original photos/notes can be exported; no inference requires a network; candidate results include uncertainty and never imply edibility or DNA confirmation from an image. DNA evidence belongs to its source specimen/observation, not every encounter of the predicted species.

## Build and deploy shape

Use `npm run build` as a convenience wrapper around `flutter build web --release` plus offline-manifest generation. `npx run build` is not the normal npm script invocation. Set Wrangler assets to `./build/web`; use `npx wrangler deploy` after the build, or configure Wrangler's custom build command. Keep service-worker/update files revalidated and immutable versioned pack artifacts cacheable. A deployment must not silently discard user encounters or active offline packs. Android builds require the Android toolchain; iOS release/signing requires macOS/Xcode and separate store distribution, not Wrangler.
