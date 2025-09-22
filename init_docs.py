## 🛠️ Script: `init_docs.py`

import os
from datetime import datetime

# Create docs directory
os.makedirs("docs", exist_ok=True)

# Timestamp for versioning
version = datetime.now().strftime("%Y-%m-%d")

# File content templates
files = {
    "README.md": f"""# IPTV Data Harmonization System

**Version:** {version}  
**Author:** Andrew Pearen  
**Purpose:** Unify fragmented M3U and EPG sources into a reproducible, config-driven pipeline for IPTV apps like Tivimate.

## Goals
- Normalize and reconcile M3U and EPG data from multiple sources
- Apply consistent naming conventions (e.g., `US-ABC-WXYZ (Detroit)`)
- Enable config-driven transformation, grouping, and filtering
- Support GUI for mapping, rule editing, and preview
- Ensure reproducibility, auditability, and future-proofing

## Architecture Summary
See `hld.md` for full design.
""",

    "decision_log.md": f"""# Decision Log

**Version:** {version}  
**Maintainer:** Andrew Pearen

## 2025-09-21 — Channel Naming Convention Finalized
**Decision:** Use format `{country}-{network}-{station} ({location})` or `{country}-{network} {variant}`  
**Rationale:** Ensures sortability, clarity, and disambiguation across countries  
**Examples:**  
- US-ABC-WXYZ (Detroit)  
- CA-CTV-CBLT (Toronto)  
- US-HBO 1  
- UK-HBO 1

## 2025-09-21 — Config-Driven Architecture Adopted
**Decision:** All transformations, mappings, and source definitions will be YAML/JSON-based  
**Rationale:** Enables reproducibility, auditability, and GUI integration
""",

    "hld.md": f"""# High-Level Design (HLD)

**Version:** {version}  
**System Name:** IPTV Harmonizer

## Modules
- Source Registry & Fetch Engine
- Normalization Layer
- Alias Resolution & Matching
- Transformation Engine
- Reconciliation & Exception Handling
- Output Generator
- GUI & Automation
- Metadata Enrichment

## Data Flow
1. Fetch M3U/EPG sources
2. Normalize to canonical schema
3. Apply alias resolution
4. Transform using config rules
5. Match M3U to EPG
6. Export final M3U/XMLTV
""",

    "progress_tracker.md": f"""# Progress Tracker

**Version:** {version}  
**Maintainer:** Andrew Pearen

## ✅ Completed
- [x] Define naming convention
- [x] Canonical schema for M3U and EPG
- [x] Source registry config
- [x] Binder structure and documentation plan

## 🔄 In Progress
- [ ] Rule config for renaming, grouping, filtering
- [ ] Alias dictionary for fuzzy matching
- [ ] Sample transformation run
- [ ] GUI wireframe sketches

## 🧠 To Figure Out
- Best fuzzy matching strategy (Levenshtein, token sort)
- GUI framework (Electron vs PyQt)
- Handling dynamic M3U scripts and manual uploads
""",

    "source_registry.md": f"""# Source Registry

**Version:** {version}  
**Format:** YAML

## Sample Entries
```yaml
- name: epg_CA
  type: epg
  country: CA
  url: https://epg.pw/xmltv/epg_CA.xml.gz
  format: xmltv
  update: daily
  decompress: true

- name: m3u_US
  type: m3u
  country: US
  url: https://freetv.fun/test_channels_united_states_new.m3u
  format: m3u
  update: weekly
```
""",

    "canonical_schema.md": f"""# Canonical Schema

**Version:** {version}  
**Format:** JSON/YAML

## M3U Channel Entry
```yaml
channel_id: "WXYZ"
name: "US-ABC-WXYZ (Detroit)"
network: "ABC"
station: "WXYZ"
location: "Detroit"
country: "US"
group: "US Entertainment"
url: "http://stream.example.com/abc"
logo: "http://logo.example.com/abc.png"
```

## EPG Channel Entry
```yaml
channel_id: "WXYZ"
name: "US-ABC-WXYZ (Detroit)"
country: "US"
programs:
  - start: "2025-09-21T20:00:00Z"
    end: "2025-09-21T21:00:00Z"
    title: "Evening News"
    description: "Local and national headlines."
    category: "News"
```
"""
}

# Write files
for filename, content in files.items():
    with open(os.path.join("docs", filename), "w", encoding="utf-8") as f:
        f.write(content)

print("📁 Documentation initialized in /docs")

