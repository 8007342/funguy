# iNaturalist / SDMYCO data research

Research date: 2026-10-17. Sources below are primary sources. Live API requests failed from this environment, so current counts and the numeric ID behind `sdmyco` remain unverified.

## What already exists

The [old repository](https://github.com/8007342/inat-observations-wp) is more developed than the cached GitHub overview suggests. Its current source has a normalized observation-fields table, DNA filtering, cached API results, REST endpoints, and a filterable WordPress UI. Reuse its domain lessons, not PHP infrastructure. The default source is `project_id=sdmyco`; [sample-data.md](https://github.com/8007342/inat-observations-wp/blob/main/sample-data.md) specifically explains why nested `ofvs` must be flattened into a searchable local index.

The [SDMYCO barcoding program](https://www.sdmyco.org/projects/mushroom-barcoding-project/) describes voucher specimens in the San Diego Natural History Museum herbarium and DNA barcoding. The [2019 Mycoflora project](https://www.inaturalist.org/projects/san-diego-mycological-society-mycoflora-project) is historically ID **35572**, verified in the old repository's observation fixture. A [2024 project journal](https://ecuador.inaturalist.org/projects/sdmyco-2024/journal) describes photographing local fungi and tagging observations with DNA barcodes after lab sequencing. These are related sources, not proof that every collection slug represents the same membership. Resolve `GET /v1/projects/sdmyco` before importing and save the returned ID, title, rules, and project type in the pack manifest. Do not equate San Diego county observations with SDMYCO project membership.

## DNA evidence and Research Grade are independent

[Research Grade](https://help.inaturalist.org/en/support/solutions/articles/151000169936) is a community data-quality status. It does not certify DNA analysis. Species consensus usually requires more than two thirds agreement, with documented exceptions for lower-resolution community IDs.

The repository's [real fixture](https://github.com/8007342/inat-observations-wp/blob/main/sample-observation-with-dna.json) is observation **197193940**, Hemimycena, `quality_grade=needs_id`, and contains these fields:

| Field ID | Name | Fixture datatype | Meaning |
| --- | --- | --- | --- |
| 2330 | DNA Barcode ITS | dna | Actual sequence evidence |
| 15771 | DNA Barcode ITS #2 | text | Second sequence; datatype-only detection misses it |
| 9864 | MycoMap BLAST Results | text | External analysis link |
| 17912 | 2nd Mycomap BLAST | text | Additional analysis link |
| 10109 | Trace Files (Raw DNA Data) | text | External raw-data reference |
| 16701 | Sequencing technology | text | Nanopore (ONT) in fixture |
| 16718 | Reads in Consensus (RiC) | text | Supporting sequencing metadata |
| 1162 | Voucher Specimen Taken | text | Collection evidence, not sequencing evidence |
| 2863 | Voucher Number(s) | text | Specimen identifier |
| 10675 | Provisional Species Name | text | Provisional determination |
| 20740 | Barcode Inferred Species or Name | text | Barcode interpretation |

Store original fields and provenance alongside normalized evidence. Suggested separate badges: **Research Grade**, **DNA sequence attached**, **Analysis linked**, **Voucher recorded**, and later **Curator reviewed**. Reserve “DNA validated” for an agreed review policy linking specimen, sequence, and taxonomic determination. A nonempty field alone does not establish that conclusion. Keep provisional names separate from accepted taxon names. Do not infer barcode absence merely from an incomplete list response; hydrate relevant records in ID batches and test fields against known fixtures.

## Ingestion and offline packs

Use public unauthenticated API reads on a controlled ingestion job, then publish compact, versioned packs through Cloudflare. Each pack should include source project identity, observation IDs and source URLs, taxon IDs and names, public coordinates and uncertainty/geoprivacy, observed date, quality grade, evidence fields, thumbnail metadata, credits/licenses, generation time, revision, byte size, and checksums. Keep catalog browsing separate from user sightings. Respect obscured locations; do not infer or publish hidden coordinates.

Recommended pipeline: fetch metadata → normalize fields → select permitted photos → download bounded thumbnail sizes → validate/checksum → write immutable pack plus manifest → user explicitly downloads before hiking. Incremental refresh must also reconcile removed records and changed licenses. Pack availability should be based on verified local files, with resumable progress and storage budgeting.

[iNaturalist's recommended practices](https://www.inaturalist.org/pages/api+recommended+practices) request about **1 request/second**, around **10,000/day**, use of a single fetching IP, and backoff for 429 responses. Observation pages support up to 200 records; use `order_by=id&order=asc&id_above=…` rather than deep page offsets. Prefer export tools for bulk work; avoid thousands of browser clients independently crawling the source. A distributed Worker ingestion design needs care because the guidance requests one IP. A controlled scheduled runner is a better starting point. Limits also apply to media: over 5 GB/hour or 24 GB/day may cause blocking. Identify the app with a User-Agent when supported. Confirm v1/v2 current API response contracts before implementing.

## Rights and model data

[Photo rights and observation licenses are separate](https://help.inaturalist.org/en/support/solutions/articles/151000173511). Preserve photo-level license and attribution. For a reusable starter pack, allowlist CC0 and CC BY; add other licenses deliberately only when their conditions fit the distribution. Do not copy all-rights-reserved images into offline packs. CC BY-NC needs an explicitly noncommercial use policy. Store license URLs and source observation/photo URLs with every bundled image. A project's open-source software license does not license contributed iNaturalist photos.

A regional observation collection is a useful reference set but is not automatically a sufficient training dataset. [iNaturalist's own training documentation](https://help.inaturalist.org/en/support/solutions/articles/151000170368-which-taxa-are-included-in-the-computer-vision-suggestions-) discusses minimum photo/observation counts and separate validation data. An offline model needs independent evaluation, geographic and taxonomic coverage, confusion tests, and unknown-species behavior. Split train/test by observation and preferably observer/site to reduce leakage. Never treat a visual match as DNA evidence for a newly photographed specimen.

## Prototype photo candidates

The following source pages explicitly report CC0. They are **demo references, not verified SDMYCO observations**. Binary downloads failed in this environment (connection reset for Wikimedia, unavailable iNat photo URLs), so no photo files are claimed to be installed.

- [Fly agaric, Bernard Spragg](https://commons.wikimedia.org/wiki/File:Amanita_muscaria,_(fly_agaric)_(41266565421).jpg): New Zealand; CC0.
- [King bolete, Bryan Menger](https://commons.wikimedia.org/wiki/File:Boletus_edulis_279895777.jpg): New Zealand; CC0; original iNat photo 279895777.
- [Turkey tail, Brittany Darwell](https://commons.wikimedia.org/wiki/File:Trametes_versicolor_104435227.jpg): California; CC0; original iNat photo 104435227.
- [Chanterelles, Daderot](https://commons.wikimedia.org/wiki/File:Chanterelles_-_San_Francisco,_CA.jpg): San Francisco; CC0.

## Decisions still needed

1. Confirm intended `sdmyco` project identity and whether to include the historical 35572 project.
2. Agree evidence tiers with SDMYCO curators before using “DNA validated”.
3. Choose photo license policy and pack download budget.
4. Obtain a model with deployment rights and evaluate its local mushroom coverage; do not assume iNaturalist production models are freely downloadable.
