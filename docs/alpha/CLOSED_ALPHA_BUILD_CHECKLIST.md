# Closed Alpha — Build Checklist

**Target platform for 2B-19:** Desktop (Godot editor play + documented desktop export).  
Do **not** claim Android/iOS packaging unless export templates and a successful package exist.

---

## Pre-build

- [ ] `data/config/closed_alpha.json` → `closed_alpha_enabled: true`
- [ ] `project.godot` `application/config/version` matches alpha version (`0.2.0-alpha`)
- [ ] Content manifest reflects approved Ministan library (post 2B-18)
- [ ] Debug cheats gated (F1 requires unlock in alpha)
- [ ] No accounts / ads / IAP / backend analytics enabled

---

## Godot editor smoke (minimum)

- [ ] Boot to Start screen
- [ ] Version label shows Closed Alpha + content batch
- [ ] Start a run; complete at least **three** full runs to endings
- [ ] Save/load meta (medals, ending archive) across relaunch
- [ ] Restart from Run End; restart flag recorded
- [ ] Palace / archive opens and updates
- [ ] Optional feedback form saves locally
- [ ] Report issue opens feedback (bug type)
- [ ] Alpha Settings → Export creates `user://alpha_exports/tiny_dictator_alpha_*`
- [ ] Export contains runs/feedback/summary/versions/manifest/limitations — **not** `save.json`
- [ ] No email/name/device serial/ad ID/location in export
- [ ] Hidden debug locked by default; unlock via Alpha Settings or long-press version
- [ ] Force-quit mid-run; relaunch marks prior run abandoned / interrupted
- [ ] Content version recorded in run logs and export `versions.json`

---

## Desktop export (when templates available)

1. Open Godot → **Project → Export**
2. Use presets in `export_presets.cfg` (macOS primary; Windows/Linux if needed)
3. Install export templates matching the Godot version if prompted
4. Export to a local `builds/` folder (gitignored if large)
5. Smoke-test the binary with the checklist above
6. Document the exact Godot version and OS used in the release note to testers

If templates are **not** installed: ship editor play instructions only. Do not invent a packaged binary.

---

## Packaging notes for testers

Include with the build:

- `docs/alpha/CLOSED_ALPHA_TESTER_GUIDE.md`
- Known limitations summary
- How to export and return the `tiny_dictator_alpha_*` folder

---

## Sign-off

| Check | Owner | Date |
|---|---|---|
| Editor smoke passed | | |
| Export produced (or N/A — templates missing) | | |
| Ready for external testing | | |
