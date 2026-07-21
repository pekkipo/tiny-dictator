# Milestone 2B-18 — Inventory Discrepancy Report (Part A)

**Date:** 2026-07-20  
**Status:** Baseline audit complete; **blocking −9 standalone gap closed** in Part A remediation (pack D). Final inventory confirmed **330/330**.

See also [2B_18_FINAL.md](2B_18_FINAL.md) for post-balance confirmation.

---

## 1. Runtime ↔ manifest sync (baseline)

| Check | Result |
|---|---|
| Runtime decision count (baseline) | 343 → **352** after pack D |
| Manifest decision records | 1:1 with runtime |
| Duplicate decision IDs | 0 |
| Every approved decision has exactly one primary content class | PASS |
| Draft/rejected in runtime folders | None |

---

## 2. Phase 2B inventory targets

| Catalog | Baseline | Final | Target |
|---|---:|---:|---:|
| Approved decisions | 321 | **330** | 330 |
| Standalone | 63 | **72** | 72 |
| Other classes / arcs / chains / crises / laws / endings / palace | At target | At target | Hold |

---

## 3. Remaining non-blocking gaps

- Category/speaker/stage distribution still outside ±5 for several buckets (Part F partial; pack D nudged cats/business/science).
- Review metadata (`voice_review_status`) largely `not_reviewed` — polish, not inventory-blocking.
- Ruler identities **7 / 12** (pre-existing).
- Palace-gated standalones intentionally rare in headless sims without meta purchases.

---

## 4. Audit command

```bash
godot --headless --path . -s tests/run_content_manifest.gd -- --export-audit
```
