# Closed Alpha — Data Import Guide

How the owner imports real tester export packages and regenerates analysis docs.

---

## What to collect from each tester

One folder per export (or per tester session):

```text
tiny_dictator_alpha_<timestamp>/
  runs.json
  runs.csv
  feedback.json
  summary.json
  summary.txt
  versions.json
  manifest_snapshot.json
  session.json
  KNOWN_LIMITATIONS.txt
```

Do **not** treat simulation diagnostics (`user://diagnostics/`) as closed-alpha user data.  
Do **not** invent runs.

---

## Import location

1. Create a working import directory, e.g.:

```text
user://alpha_imports/
```

   or a repo-side folder such as:

```text
docs/alpha/imports/<tester_or_batch>/
```

2. Copy each received `tiny_dictator_alpha_*` package into that directory (keep package folders intact).

---

## Generate reports (headless)

From the project root, with Godot 4.7:

```bash
godot --headless -s res://tests/run_2b19_alpha_import.gd -- \
  --import-dir="res://docs/alpha/imports" \
  --write-docs=true
```

If `--import-dir` is omitted, the runner looks for `user://alpha_imports/`.

Outputs:

- `docs/alpha/CLOSED_ALPHA_RESULTS.md`
- `docs/alpha/CLOSED_ALPHA_CONTENT_FIX_BACKLOG.md`

When no packages are found, both files state clearly:

> No external closed-alpha dataset has been imported.

---

## Manual inspection

Open `summary.json` / `summary.txt` inside a package for a quick per-install glance before merging.

---

## Completion gate

After import + analysis, the milestone is complete only when evidence meets Part J criteria (or the owner explicitly accepts a smaller alpha). Until then, status remains **READY_FOR_EXTERNAL_TESTING**.
