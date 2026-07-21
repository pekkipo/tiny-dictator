# Closed Alpha — Research Plan

Maps research questions to quantitative metrics and qualitative prompts.  
No fabricated answers: analysis waits for imported external export packages.

---

## Goals

Evaluate comprehension, choice quality, consequence visibility, advisor memorability, repetition, humor, pacing, difficulty, endings, restart motivation, and technical blockers with **20–50 external testers** and **≥200 completed runs** (or owner-accepted smaller set).

---

## Question → evidence map

| Research question | Quantitative signals | Qualitative signals |
|---|---|---|
| Do players understand the four resources? | Decision-time outliers on early/onboarding cards; abandonment after first resource crash | Feedback: confusion about treasury/happiness/order/elite |
| Do delayed consequences feel connected? | Arc start→completion rates; feedback on follow-ups | “I didn’t realize this came from earlier” comments |
| Are advisors distinct / memorable? | Advisor exposure distribution; favorite_moment flags by advisor | Named advisors in free text |
| Which cards are confusing? | Long median decision time; confusing_content flags; abandon-after-card | Low ratings + “confusing” checkbox |
| Which jokes repeat? | Repeated-card frequency within runs; repeated_content flags | “Heard this joke again” comments |
| Do choices feel meaningful? | Ending distribution spread; restart rate; option balance comments | “Choices felt the same” vs “felt earned” |
| Do players notice laws and arcs? | Laws activated counts; arc start/complete rates | Mentions of laws/arcs in feedback |
| Do crises feel different? | Crisis start/resolve rates; crisis-tagged feedback | “Crisis felt same as normal” comments |
| Do endings feel earned? | Ending distribution; ending feedback type; medals earned | Ending ratings / comments |
| Do players voluntarily restart? | `restart_after_ending` / restart rate | Self-report of wanting another run |
| Is run length too short/long? | Run duration + decision count distributions | Pacing feedback |
| Does meta-progression motivate? | Palace visits (indirect via multiple runs); medal comments | Archive/medal mentions |
| Weak / offensive / unclear content? | Offensive flag; low ratings | Free-text appendix |
| Technical blockers? | Crash/abandon markers; technical_bug feedback | Bug reports |

---

## Protocol

1. Recruit 20–50 external testers (no accounts required).
2. Ask each for ≥3 completed runs.
3. Encourage optional feedback; never force post-run surveys.
4. Collect export packages (`tiny_dictator_alpha_*`).
5. Import via `ClosedAlphaReportGenerator` / `tests/run_2b19_alpha_import.gd`.
6. Produce `CLOSED_ALPHA_RESULTS.md` and prioritized `CLOSED_ALPHA_CONTENT_FIX_BACKLOG.md` (P0–P3).

---

## Success criteria (milestone complete)

- Testers represented in range (or owner waiver)
- ≥200 completed runs analyzed (or owner waiver)
- Top technical blockers listed
- Top confusing cards listed
- Repetition problems listed
- Favorite / weakest content listed
- Restart rate calculated
- Prioritized content-fix backlog exists

Until real data is imported, milestone status remains **READY_FOR_EXTERNAL_TESTING**, not complete.
