# Ministan Content Style Guide

**Phase:** 2B-1 — Production scaffolding  
**Companion docs:** [MINISTAN_CHARACTER_VOICE_BIBLE.md](MINISTAN_CHARACTER_VOICE_BIBLE.md), [09_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md](../09_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md)

This guide governs all Phase 2B authoring. Only content that passes the quality rubric (≥16/20) may be marked `approved` in the manifest.

---

## 1. Proposal writing

Every proposal must:

- Be understandable in **five seconds**
- Usually fit **50–220 characters**
- Sound like the assigned speaker (see voice bible)
- Present **one concrete** problem or proposition
- Avoid explaining mechanics in the proposal text
- Avoid real-world political references
- Avoid obscure meme-only humor
- Create a visual or narrative image

Bad: “We should consider economic policy.”  
Good: “Tax every umbrella opened outdoors. Rain belongs to the treasury.”

---

## 2. Option writing

Each option must:

- Be concise (target **≤32 characters** for labels where possible)
- Express a **distinct governing approach**
- Avoid plain “Yes” / “No” when a fun label works
- Imply a meaningful trade-off without revealing every hidden effect
- Avoid a clearly dominant choice on paper

Provide two or three options per card unless schema requires otherwise.

---

## 3. Result writing

Each result must:

- Confirm what happened
- Include **one memorable detail**
- Stay shorter than a full paragraph
- Reference the choice taken
- Reflect the speaker or affected population
- Not repeat the proposal verbatim

---

## 4. Fictional-politics boundaries

Ministan is a **fictional** tiny country. Satire comes from absurd laws, advisors, and visuals—not real-world cruelty.

**Allowed:** Silly decrees, fictional neighbors, cat politics, corporate absurdity, bureaucratic nightmare.  
**Forbidden:** Real politicians, real parties, real wars, hate speech, realistic authoritarian propaganda, recognizable national tragedies.

Guest countries and leaders must be invented or obviously cartoonish.

---

## 5. Humor rules

- Tone: funny, absurd, charming, lightly dark
- Humor should land from **character voice** and **consequence**, not from mean-spirited targeting
- Every decision should have at least one funny consequence somewhere in its path
- Avoid jokes that only work in English spelling (tag `localization_risk: high` if unavoidable)

---

## 6. Repetition rules

Across the approved library (330 decisions):

| Rule | Limit |
|---|---|
| Identical core premise | 0 duplicates |
| Same joke tag share | ≤6% of all decisions |
| Primary advisor over target | ≤+5 cards |
| Primary category over target | ≤+5 cards |
| Same advisor three times in a row | Avoid outside mandatory chains |
| Reusable (non-one-time) decisions | <8% of library |
| One-time per run | ≥75% of decisions |
| References persistent state | ≥55% |
| Part of chain, arc, crisis, or ending path | ≥35% |
| State-dependent eligibility beyond day/one-time | ≥25% |

Log rejected near-duplicates in [REJECTED_IDEAS.md](REJECTED_IDEAS.md).

---

## 7. Choice-quality rules

- No option should dominate in simulation **and** narrative unless intentionally secret/endgame
- Avoid “good option / bad option” framing; prefer two compelling flawed approaches
- Options must remain understandable without hidden numeric knowledge
- Critical Reviewer pass must attempt to reject dominant or fake choices

---

## 8. Effect-design rules

A normal decision should usually affect **2–3 resources or state dimensions**.

It may also change: law, flag, counter, advisor affinity, ruler trait, arc state, narrative event, crisis state.

**Avoid:**

- No meaningful effect
- Four positive resource effects
- Four negative effects without narrative justification
- Unrelated flags
- Hidden consequences that feel arbitrary

Recovery cards: improve target resource ~8–20 points with a cost elsewhere.

---

## 9. Law and flag usage

Every approved law must:

- Have a unique icon key and at least one `visual_tag`
- Unlock, modify, or block at least two decisions
- Contribute to at least one ending, arc, crisis, or ruler identity
- Avoid being a purely decorative label

Flags should be named in `snake_case` and referenced by later content meaningfully.

---

## 10. Delayed-consequence guidance

Use the Phase 2A follow-up system appropriately:

| Type | Use when |
|---|---|
| Hard follow-up | Player must see consequence of a specific choice |
| Soft follow-up | Thematic echo; several days later |
| Pool follow-up | One of several consequences may fire |

Short chains complete in roughly **2–8 in-game days**. Major arcs may span multiple stages.

---

## 11. Localization readiness

English is the master authoring language.

- Keep option labels short
- Avoid untranslated text embedded in images
- Do not concatenate sentence fragments at runtime
- Keep variables and placeholders explicit (`{treasury}`, not inline math in prose)
- Tag wordplay in authoring metadata: `"localization_risk": "low" | "moderate" | "high"`
- Keep character and law names stable across languages

---

## 12. Visual-tag conventions

Use **snake_case** reusable asset keys in `visual_tags`:

```json
"visual_tags": ["pizza_stalls", "traffic_tanks", "smiling_citizens"]
```

Also document in authoring metadata when useful:

- Advisor expression
- Crowd state, building state, overlay effect, crisis effect

Target: ≥60% of ordinary cards reuse existing visual assets. Major arcs may use unique hooks.

Every approved law and ending needs at least one visual hook for Phase 3.

---

## 13. ID naming conventions

| Entity | Pattern | Example |
|---|---|---|
| Decision | `snake_case` noun phrase | `umbrella_tax_proposal` |
| Chain (planning) | `chain_` prefix | `chain_umbrella_tax` |
| Arc (planning) | `arc_` prefix | `arc_penny_austerity` |
| Crisis (planning) | `crisis_` prefix | `crisis_bank_run` |
| Law | `snake_case` | `window_tax` |
| Ending | `snake_case` | `cat_republic` |
| Flag | `snake_case` | `fish_subsidy_active` |

IDs must be unique, stable, and never renamed after approval without manifest update.

---

## 14. Primary categories (Phase 2B canonical)

Every decision has exactly one **primary category** toward the 330 quota:

| Category ID | Target count |
|---|---:|
| `economy` | 50 |
| `public_life` | 48 |
| `military_and_order` | 38 |
| `media_and_propaganda` | 34 |
| `science_and_technology` | 40 |
| `business_and_privatization` | 32 |
| `bureaucracy` | 32 |
| `cats_and_animals` | 26 |
| `infrastructure` | 30 |

### Legacy Phase 2A mapping (manifest reports)

Until reclassification during batch integration:

| Legacy value | Maps to |
|---|---|
| `military` | `military_and_order` |
| `media` | `media_and_propaganda` |
| `science` | `science_and_technology` |
| `administration`, `government` | `bureaucracy` |
| `absurd_law`, `politics`, `follow_up` | Context-dependent; reassign at integration |
| `economy`, `public_life`, `infrastructure` | Same |

---

## 15. Content-file placement

| Content state | Location |
|---|---|
| Draft prose, batch plans | `docs/content/drafts/` |
| Batch reports | `docs/content/BATCH_REPORTS/` |
| Planning catalogs | `docs/content/MINISTAN_*_CATALOG.md` |
| Validated runtime JSON | `data/decisions/`, `data/laws/`, etc. |
| Manifest inventory | `data/content_manifest.json` (dev-only, not loaded at boot) |

**Never** place unreviewed drafts in `data/`.

Recommended runtime layout (Phase 2B):

```text
data/decisions/ministan/
  onboarding/
  standalone/
  chains/
  arcs/
  crises/
  recovery/
  endgame/
```

Current Phase 2A files remain valid until migrated per batch.

---

## 16. Development-only metadata

Optional block in runtime JSON (does not affect gameplay):

```json
"authoring": {
  "primary_content_class": "major_arc",
  "primary_category": "science_and_technology",
  "primary_stage": "escalation",
  "humor_tags": ["scientific_understatement"],
  "emotional_goal": "curiosity",
  "visual_hook": "tiny artificial sun over city",
  "localization_risk": "low",
  "writer_notes": ""
}
```

May be stripped from production builds later. Rubric scores live in batch reports, not runtime files.

---

## 17. Content quality rubric

Score each criterion **0–2** (max **20**).

| Criterion | 0 | 1 | 2 |
|---|---|---|---|
| Immediate clarity | Confusing | Understandable after reread | Instantly clear |
| Advisor voice | Wrong/generic | Partly distinctive | Clearly character-specific |
| Choice quality | Dominant or fake | Some trade-off | Two compelling approaches |
| Consequence quality | Arbitrary | Mechanically logical | Memorable + logical |
| Novelty | Repeated | Familiar with twist | Distinctive |
| State integration | Isolated | One state link | Multiple meaningful links |
| Replay value | Always same | Some variation | Branching or state-dependent |
| Visual potential | None | Basic | Strong visual hook |
| Localization readiness | High risk | Moderate | Low risk |
| Technical validity | Broken | Valid with concern | Clean and testable |

**Approval threshold: 16/20**

**Mandatory non-zero scores** for advisor-spoken cards:

- Immediate clarity
- Choice quality
- Technical validity
- Advisor voice

---

## 18. Batch workflow (seven steps)

Every sub-batch (max **12–15** candidate decisions; one major arc per sub-batch unless ≤12 cards combined):

1. **Gap analysis** — Read PRD, manifest, voice bible, diagnostics, simulation report
2. **Batch plan** — IDs, speaker, category, stage, trade-off, visual hook (no JSON yet)
3. **Candidate generation** — Prose in `docs/content/drafts/`
4. **Self-review / Critical Reviewer** — Voice, repetition, dominant choices, schema, pacing
5. **Integration** — Validated content into `data/`; update manifest and catalogs
6. **Diagnostics** — Validation, static graph, ≥1,000 simulations per sub-batch
7. **Manual paths** — Test branches; then set manifest status to `approved`

### AI role separation (same agent may run separate passes)

| Role | Output |
|---|---|
| Content Planner | Quota analysis, IDs, mechanical purpose |
| Character Writer | Proposal, options, results |
| Systems Editor | Effects, requirements, flags, follow-ups |
| Critical Reviewer | Reject weak content |
| Integrator | JSON, manifest, tests |

---

## 19. Known Phase 2A conflicts (do not fix in 2B-1)

| Issue | Resolution milestone |
|---|---|
| Category taxonomy mismatch | Reclassify during batch integration |
| Smile/happiness premise cluster | 2B-11 review |
| `cat_voting_proposal` vs `cat_voting_rights` | **Resolved 2B-5A** — duplicate removed from runtime |
| Minor arc `traffic_military` vs PRD arc/chain split | Planning catalogs document overlap |
| Placeholder recovery/endgame cards | 2B-15 / 2B-16 rewrite |
| Legacy `free_pizza_consequences` (4 cards) | Refactor in 2B-7+ chain packs |
| Zero guest speakers in runtime | 2B-14+ crisis/international batches |

---

## Revision history

| Version | Date | Notes |
|---|---|---|
| 1.0 | 2026-07-15 | Milestone 2B-1 initial style guide |
