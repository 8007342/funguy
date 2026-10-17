# FunGuy

## Purpose

Help San Diego mushroom explorers prepare offline, record discoveries and compare possible identifications with transparent evidence. This spec includes the intended product; README and roadmap distinguish shipped foundation from future work.

## Requirements

### Requirement: Mobile field guide
The app SHALL present a readable mobile field guide with search, species details and independent labels for source observations, community identification and DNA evidence.

#### Scenario: Browsing a sample
- **WHEN** someone opens the foundation preview
- **THEN** they can browse, search and bookmark clearly labeled illustrative species
- **AND** sample entries SHALL NOT claim verified SDMYCO membership or DNA evidence

### Requirement: Provenanced regional collection
The app SHALL import the resolved SDMYCO project identity, source observation and taxon IDs, quality grade, raw evidence fields, public location precision, timestamps and per-photo attribution/license.

#### Scenario: A sequenced observation awaits identification
- **WHEN** an observation has an ITS sequence but quality grade needs_id
- **THEN** sequence evidence and community status SHALL appear independently
- **AND** DNA validated SHALL require an agreed curator review policy

### Requirement: Verified offline preparation
The app SHALL support versioned metadata and permitted thumbnail packs with size estimates, resumable transfer, checksum verification, storage-error handling and explicit readiness.

#### Scenario: A download is interrupted
- **WHEN** connectivity disappears before every required file is verified
- **THEN** the new pack SHALL remain incomplete and the previous valid pack SHALL remain usable
- **AND** an airplane-mode cold restart SHALL preserve a previously verified guide

### Requirement: Private field encounters
The app SHALL save original photos and notes locally, attach permitted GPS with time and accuracy, support manual habitat/substrate/location notes and export, and distinguish downloaded weather snapshots from current readings.

#### Scenario: No network or location fix
- **WHEN** a ranger captures a mushroom without a network or usable GPS fix
- **THEN** the encounter SHALL save with missing context explicitly recorded
- **AND** no upload SHALL occur without explicit user action

### Requirement: Explainable identification assistance
The app SHALL use a locally available evaluated model to offer possible matches as “This looks like…”, show similar reference specimens, uncertainty and unknown outcomes, and expose evidence used for each suggestion. Explanations SHALL distinguish model inputs from observable similarities and SHALL NOT invent model reasoning.

#### Scenario: A mushroom is detected
- **WHEN** local detection finds a mushroom
- **THEN** FunGuy MAY celebrate with “Fungi!”
- **AND** species suggestions SHALL separately show visual/contextual evidence used, missing evidence, source references and uncertainty
- **AND** the suggestion SHALL NOT imply edibility or DNA confirmation of the new specimen

### Requirement: Feedback improves the experience
The app SHALL offer optional feedback about suggestion usefulness, comparison clarity and corrected identifications, with consent before sharing photos/location and offline queuing where supported.

#### Scenario: A user disputes a suggestion
- **WHEN** a user marks a suggestion unhelpful or supplies a correction
- **THEN** the app SHALL retain feedback separately from verified taxonomic labels
- **AND** model training SHALL NOT automatically treat this feedback as ground truth
