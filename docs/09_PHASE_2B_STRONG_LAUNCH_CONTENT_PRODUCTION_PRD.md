# Tiny Dictator — Phase 2B Strong-Launch Content Production PRD

**Suggested repository path:** `docs/08_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md`  
**Document status:** Ready for staged content production  
**Phase:** 2B — Full Ministan content production, balance, and closed-alpha validation  
**Depends on:** Phase 1 and Phase 2A completion  
**Primary country:** Ministan  
**Engine:** Godot 4.x  
**Primary IDE and content-generation environment:** Cursor  
**Graphics policy:** Placeholder visuals remain acceptable throughout Phase 2B  
**Strong-launch content target:** 330 approved decisions  
**Target release scope:** One highly complete country rather than several shallow countries  

---

# 1. Purpose

Phase 2A created the narrative and gameplay machinery required for a real card-driven strategy game:

- Decision schema v2.
- Run stages.
- Content Director.
- Narrative arcs.
- Delayed event queue.
- Crises.
- Advisor affinity.
- Ruler traits.
- Special endings.
- Meta-progression.
- Diagnostics and automated simulation.

Phase 2B must use those systems to produce a complete, varied, coherent, replayable content library for Ministan.

The central Phase 2B objective is:

> Transform Tiny Dictator from a technically complete prototype into a content-complete game that can support a strong mobile launch.

Phase 2B is primarily a content-production and balancing phase. Cursor may generate and integrate large portions of the content, but it must do so through controlled batches, explicit inventories, validation, simulation, and human review.

Phase 2B must not become an uncontrolled request to “generate 300 funny cards.”

---

# 2. Final Phase 2B outcome

At the end of Phase 2B, Tiny Dictator must contain:

- 330 approved decisions.
- 8 main advisors with substantial content.
- 6 recurring guest or situational speakers.
- 18 major narrative arcs.
- 32 short narrative chains.
- 18 major crises.
- 50 active laws.
- 50 collectible endings.
- 24 placeholder palace upgrades.
- 12 ruler identities.
- Strong first-run onboarding.
- Recovery and endgame content for every relevant state.
- Sufficient content variation for repeated play.
- Validated content graphs.
- Balanced simulation results.
- A completed closed-alpha content pass.
- A frozen content and schema baseline ready for Phase 3 presentation work.

“Approved” means the content has passed all required quality gates. Raw model output does not count toward the target.

---

# 3. Strong-launch scope decision

## 3.1 One deep country

The strong-launch version will focus on one complete country:

```text
Ministan
```

Do not dilute production effort across several underdeveloped countries.

Future countries remain valid expansion opportunities, but launch quality depends on making Ministan feel broad, reactive, and replayable.

## 3.2 Content depth over raw count

The target is not merely 330 JSON objects.

The library must include:

- Standalone policy variety.
- Short remembered consequences.
- Branching story arcs.
- Advisor relationships.
- Crises.
- Recovery decisions.
- Endgame resolutions.
- Rare endings.
- Meaningful law combinations.

A smaller number of excellent connected decisions is more valuable than a larger number of interchangeable jokes. Nevertheless, 330 approved decisions is the minimum strong-launch target.

## 3.3 Candidate-generation expectation

To finish with 330 approved decisions, expect to generate approximately:

```text
370–400 candidate decisions
```

Approximately 10–18% may be:

- Rejected.
- Rewritten.
- Merged.
- Reclassified.
- Removed because of repetition.
- Removed because they never become selectable.
- Removed because one option dominates.
- Removed because the joke does not fit an advisor.

The project must track approved content separately from drafts and rejected candidates.

---

# 4. Definition of one decision

A decision counts toward the 330 target only when it is one player-facing card with:

- A unique decision ID.
- A speaker or system source.
- A proposal.
- Two or three selectable options.
- A result for every option.
- Valid mechanical effects.
- Valid eligibility conditions.
- A defined narrative role.
- A primary content class.
- A primary category.
- A stage or pacing role.
- Validation success.
- At least one completed test path.

Different branches inside the same card are not counted as separate decisions.

A crisis containing an initial card and a separate resolution card counts as two decisions.

---

# 5. Non-overlapping decision inventory

Every approved decision must have exactly one `primary_content_class`. This prevents double counting.

The final inventory is:

| Primary content class | Approved decisions |
|---|---:|
| First-run and onboarding | 10 |
| Standalone policy decisions | 72 |
| Short-chain decisions | 80 |
| Major-arc decisions | 96 |
| Crisis decisions | 28 |
| Recovery decisions | 24 |
| Endgame and rare-resolution decisions | 20 |
| **Total** | **330** |

A card may also have secondary tags such as `recovery`, `consequence`, or `ending_setup`, but it counts only under its primary class.

---

# 6. First-run and onboarding inventory

Target:

```text
10 decisions
```

These decisions must collectively teach:

- Four resources.
- Visible effects.
- Hidden consequences.
- Active laws.
- Advisors.
- A delayed follow-up.
- A crisis.
- An ending.
- Restart and replay.
- The fact that there is no universally correct answer.

The first run does not need to display all ten in a fixed order, but the Content Director must strongly prefer appropriate onboarding content until the required concepts have been introduced.

Recommended onboarding concepts:

1. Palace maintenance budget.
2. General Boom’s first parade.
3. Minister Penny’s cheap infrastructure proposal.
4. Auntie Olga’s practical citizen complaint.
5. Luna News reframes a visible problem.
6. Doctor Maybe offers a small experiment.
7. Sir Profit proposes a harmless-looking privatization.
8. Comrade Whiskers presents a cat petition.
9. Clerk Zero introduces a new form.
10. A simple crisis or delayed consequence resolves one earlier choice.

Requirements:

- Effects should generally be Small or Medium.
- No unavoidable Day 1–3 ending.
- At least one decision must create a law.
- At least one must queue a soft follow-up.
- At least one must produce an advisor-affinity change.
- At least one must alter a ruler trait.

---

# 7. Standalone policy inventory

Target:

```text
72 decisions
```

Standalone decisions provide run variety between connected stories.

Each standalone decision must have:

- A self-contained premise.
- An advisor-consistent voice.
- Meaningful trade-off.
- At least one mechanical or narrative consequence.
- No required follow-up.
- No dependency deeper than one optional state reference.

Distribute exactly eight standalone decisions across each category:

| Category | Count |
|---|---:|
| Economy | 8 |
| Public life | 8 |
| Military and order | 8 |
| Media and propaganda | 8 |
| Science and technology | 8 |
| Business and privatization | 8 |
| Bureaucracy | 8 |
| Cats and animals | 8 |
| Infrastructure | 8 |
| **Total** | **72** |

Examples are inspiration only; Cursor must not copy one joke repeatedly.

### Economy examples

- Tax luxury chairs.
- Replace coins with coupons.
- National lottery funds the budget.
- Government sells commemorative debt.
- Fine citizens for exact change.
- Treasury rents unused palace rooms.

### Public-life examples

- National bedtime.
- Free coffee morning.
- Universal birthday.
- Public compliment quota.
- Three-day weekend.
- Official queue etiquette.

### Military and order examples

- Mandatory marching lessons.
- Border parade.
- Emergency salute protocol.
- Pigeon air force.
- Palace curfew.
- Tanks used for ceremonial delivery.

### Media and propaganda examples

- Ministry of Memes.
- One-headline policy.
- Weather optimism law.
- Mandatory applause.
- National reality show.
- Licensed rumors.

### Science and technology examples

- Artificial sun pilot.
- Anti-gravity bus.
- Robot queue manager.
- National clone holiday.
- Predictive toaster administration.
- Experimental cloud removal.

### Business and privatization examples

- Sponsored capital name.
- Rent-a-ministry.
- Corporate palace subscription.
- Privatized air.
- Paid access to public benches.
- Advertisements on national anthem.

### Bureaucracy examples

- Permit for complaints.
- National filing week.
- Triple-stamp requirement.
- Form requesting more forms.
- Ministry of Waiting.
- License to stand in a queue.

### Cats and animals examples

- Cat census.
- Official nap zones.
- Mouse protection act.
- Fish subsidy.
- National dog apology.
- Pigeon citizenship trial.

### Infrastructure examples

- Sponsored potholes.
- Bridge to nowhere.
- Elevator Wi-Fi.
- Replace traffic lights with flags.
- Perfumed sewage.
- National clock synchronization reform.

---

# 8. Short-chain inventory

Target:

```text
80 decisions across 32 short chains
```

Required structure:

- 16 two-card chains.
- 16 three-card chains.
- Total: 80 decisions.

A short chain must:

- Begin with a clear setup.
- Contain at least one later card that explicitly references the setup.
- Have at least two possible outcomes across the chain.
- Complete within approximately 2–8 in-game days.
- Avoid requiring a major `ArcManager` object unless useful.
- Use hard, soft, or pool follow-ups appropriately.

Required chain catalog:

| # | Chain | Target length |
|---|---|---:|
| 1 | Umbrella Tax | 2 |
| 2 | National Coffee Reserve | 3 |
| 3 | Privatized Public Benches | 3 |
| 4 | Lottery Budget | 2 |
| 5 | Coin Shortage | 2 |
| 6 | Weekend Abolition | 3 |
| 7 | Salaries Paid in Coupons | 2 |
| 8 | Palace Gift Shop | 2 |
| 9 | Pothole Naming Rights | 3 |
| 10 | Elevator Wi-Fi | 2 |
| 11 | Bridge to Nowhere | 3 |
| 12 | Traffic Flags | 3 |
| 13 | Perfumed Sewage | 2 |
| 14 | National Clock Reform | 2 |
| 15 | State Meme Department | 3 |
| 16 | Weather Censorship | 2 |
| 17 | Applause Quotas | 3 |
| 18 | National Talent Show | 2 |
| 19 | Artificial Sun | 3 |
| 20 | Robot Queue Manager | 3 |
| 21 | Anti-Gravity Buses | 2 |
| 22 | National Clone Day | 2 |
| 23 | Pigeon Air Force | 2 |
| 24 | Border Parade | 3 |
| 25 | Camouflage Uniform Scandal | 2 |
| 26 | Tank Parking Crisis | 3 |
| 27 | Form to Request Forms | 3 |
| 28 | Ministry of Waiting | 2 |
| 29 | Stamp Shortage | 2 |
| 30 | Anti-Vacuum Referendum | 3 |
| 31 | Fish Currency Experiment | 3 |
| 32 | National Nap Hour | 3 |
| **Total** |  | **80** |

Cursor may refine names, but it must preserve:

- Category diversity.
- Exact card total.
- Two-card versus three-card distribution.
- Mechanical distinctness.

---

# 9. Major narrative-arc inventory

Target:

```text
96 decisions across 18 major arcs
```

Each major arc must have:

- An arc brief.
- Entry conditions.
- Setup decision.
- Escalation.
- At least two meaningful branches.
- At least two resolutions.
- At least one failure, abandonment, or betrayal path where appropriate.
- Clear endgame compatibility.
- Reachable state graph.
- At least one strong visual hook for Phase 3.
- A test script or documented debug path.

## 9.1 Eight advisor arcs

| Advisor arc | Target cards |
|---|---:|
| General Boom — The General’s Rise | 6 |
| Minister Penny — The Austerity Miracle | 5 |
| Luna News — The Media Becomes Reality | 5 |
| Auntie Olga — The Citizen Movement | 5 |
| Doctor Maybe — The Experimental Republic | 6 |
| Sir Profit — The Corporate State | 5 |
| Comrade Whiskers — The Cat Revolution | 6 |
| Clerk Zero — The Government of Forms | 5 |
| **Advisor arc total** | **43** |

## 9.2 Ten national arcs

| National arc | Target cards |
|---|---:|
| Cat Politics | 6 |
| Mandatory Happiness | 5 |
| Traffic and Military Control | 5 |
| AI Government | 6 |
| Sell the Moon | 5 |
| Hyperinflation | 5 |
| National Festival Economy | 5 |
| Fake Election Accident | 5 |
| International Cheese Crisis | 5 |
| Palace Renovation Scandal | 6 |
| **National arc total** | **53** |

Total major-arc decisions:

```text
43 + 53 = 96
```

## 9.3 Arc diversity requirements

Across the 18 arcs:

- At least six must have three or more possible resolutions.
- At least six must include advisor-affinity conditions.
- At least six must include ruler-trait effects.
- At least five must interact with active laws.
- At least five must use delayed events.
- At least four must contain a crisis.
- At least four must lead directly to a collectible ending.
- At least three pairs must be mutually exclusive.
- At least two must allow an unexpectedly positive resolution.
- No arc may require the player to know hidden numeric values.

---

# 10. Crisis inventory

Target:

```text
18 crisis definitions producing 28 crisis-class decisions
```

Required crises:

1. National Power Outage.
2. Bank Run.
3. Mass Protest.
4. Cheese Shortage.
5. Palace Fire.
6. Government Data Leak.
7. Military Mutiny.
8. Cat Occupation of Parliament.
9. National Internet Outage.
10. Water Supply Turns Blue.
11. International Border Confusion.
12. Currency Collapse.
13. Public Transport Strike.
14. AI Cabinet Lockout.
15. Moon Ownership Dispute.
16. Bureaucrat General Strike.
17. Fake News Panic.
18. National Festival Stampede.

Structure requirement:

- 10 crises must use two connected decisions.
- 8 crises may resolve through one decision.
- Total crisis decisions: 28.

Every crisis must have:

- Activation conditions.
- Severity.
- Two or three options.
- A meaningful resource trade-off.
- Success state.
- Failure or timeout state.
- At least one persistent consequence.
- At least one debug-force path.
- Clear interaction with the Content Director.

At least:

- Six crises can trigger an ending.
- Six crises can be resolved differently based on an active law.
- Four crises reference advisor affinity.
- Four crises can become part of a major arc.
- Three crises have a rare positive resolution.

---

# 11. Recovery inventory

Target:

```text
24 recovery decisions
```

Recovery decisions are selected when one or more resources are critically low.

Required distribution:

| Primary recovery target | Decisions |
|---|---:|
| Treasury | 6 |
| Happiness | 6 |
| Order | 6 |
| Elite Loyalty | 6 |
| **Total** | **24** |

Recovery rules:

- A recovery decision must improve its target by approximately 8–20 points.
- It must impose a cost elsewhere.
- It must not provide a universally dominant option.
- At least two recovery decisions for each resource must depend on advisor affinity, laws, or ruler traits.
- At least one recovery decision per resource must be available in endgame.
- At least one recovery decision per resource must carry a delayed downside.
- Recovery decisions must not become repetitive emergency buttons.

Examples:

- International loan.
- Public celebration paid from reserve.
- Temporary military emergency.
- Elite tax exemption.
- Sell a palace wing.
- Luna News launches a national optimism campaign.
- Auntie Olga organizes volunteer repairs.
- Doctor Maybe activates an experimental solution.

---

# 12. Endgame and rare-resolution inventory

Target:

```text
20 decisions
```

These cards exist primarily for:

- Resolving unfinished arcs.
- Delivering rare success.
- Creating ambiguous victories.
- Triggering unusual endings.
- Giving late runs narrative closure.

Required composition:

| Endgame role | Decisions |
|---|---:|
| General arc-resolution cards | 8 |
| Rare success or retirement cards | 4 |
| Ruler-identity climax cards | 4 |
| Secret or absurd late-game cards | 4 |
| **Total** | **20** |

Requirements:

- Allowed primarily in endgame.
- Must not start long arcs.
- At least eight must depend on accumulated laws or traits.
- At least eight must reference prior decisions explicitly.
- At least six must trigger or strongly set up a special ending.
- At least four must provide a non-failure conclusion.
- Secret cards must remain discoverable through diagnostics.

---

# 13. Speaker and advisor distribution

Every decision has one primary speaker or source.

Final primary-speaker targets:

| Speaker/source | Decisions |
|---|---:|
| General Boom | 38 |
| Minister Penny | 40 |
| Luna News | 38 |
| Auntie Olga | 42 |
| Doctor Maybe | 38 |
| Sir Profit | 36 |
| Comrade Whiskers | 34 |
| Clerk Zero | 36 |
| Guest speakers and national system | 28 |
| **Total** | **330** |

These counts include all primary content classes.

A card may mention or affect additional advisors without changing its primary-speaker classification.

## 13.1 Guest speakers

Phase 2B should support six recurring guest or situational speakers without full affinity systems:

- Foreign Ambassador.
- Chief Judge.
- Palace Chef.
- Youth Representative.
- Workers’ Union Leader.
- President of a neighboring tiny country.

Guest speakers should:

- Appear rarely.
- Support crises and international stories.
- Have simple voice notes.
- Use placeholder portraits in Phase 2B.
- Not create additional permanent UI meters.

---

# 14. Category distribution

Every decision must have one primary category.

Final targets:

| Primary category | Decisions |
|---|---:|
| Economy | 50 |
| Public life | 48 |
| Military and order | 38 |
| Media and propaganda | 34 |
| Science and technology | 40 |
| Business and privatization | 32 |
| Bureaucracy | 32 |
| Cats and animals | 26 |
| Infrastructure | 30 |
| **Total** | **330** |

Secondary tags may cross categories.

The content manifest must report actual versus target distribution after every batch.

---

# 15. Stage distribution

Every decision must have a primary intended run stage, even when allowed in several stages.

Target distribution:

| Primary stage | Target share | Approximate decisions |
|---|---:|---:|
| Establishment | 25% | 83 |
| Escalation | 30% | 99 |
| Instability | 27% | 89 |
| Endgame | 18% | 59 |
| **Total** | **100%** | **330** |

Tolerance:

```text
±5 decisions per stage
```

Additional requirements:

- Every stage must contain all four resource categories of recovery opportunities.
- Endgame must contain sufficient resolution cards.
- Establishment must not contain excessive severe crises.
- Instability must contain meaningful consequences rather than only stronger stat changes.

---

# 16. Laws inventory

Strong-launch target:

```text
50 active laws
```

Required law catalog:

## Economy — 8 laws

1. Window Tax.
2. Umbrella Tax.
3. Free Pizza Friday.
4. Coupon Salaries.
5. Luxury Chair Levy.
6. National Lottery Budget.
7. Coin Rounding Act.
8. Emergency Cheese Bonds.

## Public life — 8 laws

9. Mandatory Smiling.
10. National Bedtime.
11. Three-Day Weekend.
12. National Nap Hour.
13. Free Coffee Morning.
14. Public Compliment Quota.
15. Universal Birthday.
16. Official Queue Etiquette.

## Order and military — 6 laws

17. Tank Traffic Control.
18. Mandatory Marching.
19. Pigeon Air Force.
20. Palace Curfew.
21. Border Parade Act.
22. Emergency Salute Protocol.

## Media — 6 laws

23. Ministry of Memes.
24. Weather Optimism Act.
25. Mandatory Applause.
26. One Headline Policy.
27. Public Rumor License.
28. National Reality Show.

## Science — 6 laws

29. Artificial Sun Program.
30. Robot Civil Service.
31. Anti-Gravity Transit.
32. Moon Replacement Research.
33. Clone Holiday.
34. AI Cabinet Pilot.

## Business — 5 laws

35. Privatize Air.
36. Corporate Capital Naming.
37. Sponsored Potholes.
38. Rent-a-Ministry.
39. Palace Subscription Plan.

## Bureaucracy — 5 laws

40. Form Request Form Act.
41. Ministry of Waiting.
42. Triple Stamp Requirement.
43. Permit for Complaints.
44. National Filing Week.

## Cats and animals — 6 laws

45. Cat Voting Rights.
46. Fish Subsidy.
47. Anti-Vacuum Act.
48. Cat Parliament Seats.
49. National Mouse Protection.
50. Official Nap Zones.

## 16.1 Law quality requirements

Every law must:

- Have a unique icon key.
- Have at least one visual tag.
- Unlock, modify, or block at least two decisions.
- Contribute to at least one ending, arc, crisis, or ruler identity.
- Produce at least one visible city-state change in Phase 3.
- Avoid being a purely decorative label.

At least:

- 20 laws must interact with another law.
- 12 laws must create a contradictory-law situation.
- 10 laws must have a delayed consequence.
- 8 laws must create a special endgame opportunity.

---

# 17. Ending inventory

Strong-launch target:

```text
50 collectible endings
```

## 17.1 Generic resource failures — 4

1. Bankrupt Leader.
2. People Had Enough.
3. Total Chaos.
4. Velvet Coup.

## 17.2 Major-arc endings — 18

One or more for every major arc:

5. The General Takes the Palace.
6. The General Becomes a Mascot.
7. The Spreadsheet State.
8. Austerity Without Citizens.
9. The Nation Becomes a Broadcast.
10. The Day Everyone Stopped Believing.
11. Auntie Olga’s People’s Cabinet.
12. The Palace Hears the Street.
13. The Experimental Republic.
14. The Experiment Leaves.
15. Corporate Ministan.
16. The Country Is Acquired.
17. The Purrfect Transfer of Power.
18. Cats Return to Their Boxes.
19. Government by Form.
20. The Final Stamp.
21. Cat Republic.
22. Happiness Reaches One Hundred Percent.
23. Tanks Direct Everything.
24. The AI Accepts Your Resignation.
25. The Moon Has a New Owner.
26. Hyperinflation Makes Everyone a Millionaire.
27. The Eternal National Festival.
28. Democracy by Administrative Error.
29. The Great Cheese Settlement.
30. The Palace Is Beautiful and Empty.
31. The Renovation Reveals the Truth.
32. The Traffic System Achieves Peace.

## 17.3 Ruler-identity endings — 12

33. The Smiling Tyrant.
34. The Spreadsheet Emperor.
35. Supreme Cat Servant.
36. The Chaotic Reformer.
37. The Technocratic Accident.
38. The People’s Favorite Problem.
39. The Sponsored Supreme Leader.
40. The Minister of Everything.
41. The Last Honest Propagandist.
42. The Parade Philosopher.
43. The Bureaucratic Oracle.
44. The Accidental Libertarian.

## 17.4 Advisor relationship endings — 8

45. General Boom Remains Loyal.
46. Minister Penny Balances the Final Budget.
47. Luna News Makes You Immortal.
48. Auntie Olga Sends You Home.
49. Doctor Maybe Finally Says “Definitely.”
50. Sir Profit Buys Your Retirement.
51. Comrade Whiskers Grants You a Cushion.
52. Clerk Zero Closes Your File.

## 17.5 Positive and rare conclusions — 6

53. Beloved Retirement.
54. Economic Miracle.
55. Peaceful Accidental Democracy.
56. Scientific Golden Age.
57. The Country Works Somehow.
58. The Smallest Superpower.

## 17.6 Secret absurd endings — 2

59. The Toaster Is Elected.
60. Everyone Moves Next Door.

The list above contains 60 candidate ending concepts.

Phase 2B must curate exactly:

```text
50 approved endings
```

At least ten concepts should be removed, merged, or deferred after testing.

This intentional over-supply supports quality curation.

## 17.7 Ending quality requirements

Each approved ending must have:

- Unique ID.
- Headline.
- Short subtitle.
- Description.
- Placeholder icon.
- Conditions or explicit trigger.
- Archive hint.
- Rarity.
- Priority.
- Debug-force path.
- Simulation reachability classification.

Ending rarity classes:

```text
common
uncommon
rare
secret
```

Target approved ending distribution:

| Rarity | Endings |
|---|---:|
| Common | 12 |
| Uncommon | 18 |
| Rare | 14 |
| Secret | 6 |
| **Total** | **50** |

---

# 18. Palace and meta-content inventory

Phase 2B must define:

```text
24 placeholder palace upgrades
```

Suggested categories:

- 6 throne-room upgrades.
- 4 propaganda-room upgrades.
- 4 emergency-bunker upgrades.
- 4 office and bureaucracy upgrades.
- 3 scientific-laboratory upgrades.
- 3 cat-related upgrades.

Each upgrade needs:

- ID.
- Display name.
- Description.
- Medal cost.
- Unlock condition.
- Placeholder state.
- Optional content unlock.

At least eight upgrades should unlock:

- A rare card.
- A cosmetic ending variant.
- A starting modifier.
- A small content pool.

Avoid powerful permanent stat advantages.

---

# 19. Character voice bible requirement

Before mass generation, create:

```text
docs/content/MINISTAN_CHARACTER_VOICE_BIBLE.md
```

For every main advisor, define:

- Role.
- Core desire.
- Fear.
- Relationship with the ruler.
- Sentence length.
- Vocabulary.
- Preferred metaphors.
- Prohibited phrases.
- Joke style.
- How they react when happy.
- How they react when angry.
- How they react when afraid.
- Typical mechanical trade-offs.
- Five canonical sample proposals.
- Five canonical result lines.
- Five examples that are out of character.

Guest speakers need shorter voice cards.

Cursor must read the voice bible before generating any content batch.

---

# 20. Content manifest

Create:

```text
data/content_manifest.json
```

Every candidate and approved content item must be tracked.

Recommended decision record:

```json
{
  "id": "umbrella_tax",
  "content_type": "decision",
  "primary_content_class": "short_chain",
  "primary_category": "economy",
  "primary_speaker_id": "minister_penny",
  "primary_stage": "establishment",
  "arc_id": null,
  "chain_id": "umbrella_tax_chain",
  "crisis_id": null,
  "status": "approved",
  "batch_id": "2b-short-chain-a-01",
  "schema_valid": true,
  "graph_valid": true,
  "simulation_selected_count": 248,
  "manually_tested": true,
  "voice_reviewed": true,
  "balance_reviewed": true,
  "visual_tags": ["umbrellas_in_square"],
  "notes": ""
}
```

Allowed statuses:

```text
idea
outlined
draft
integrated
validation_failed
simulation_failed
needs_rewrite
approved
rejected
deferred
```

Only `approved` decisions count toward 330.

The manifest must generate summary reports for:

- Decision-class quota.
- Category quota.
- Advisor quota.
- Stage quota.
- Arc count.
- Chain count.
- Crisis count.
- Laws.
- Endings.
- Approval status.
- Untested content.

---

# 21. Folder structure

Recommended content-production structure:

```text
docs/
  content/
    MINISTAN_CHARACTER_VOICE_BIBLE.md
    MINISTAN_CONTENT_STYLE_GUIDE.md
    MINISTAN_ARC_CATALOG.md
    MINISTAN_CHAIN_CATALOG.md
    MINISTAN_CRISIS_CATALOG.md
    BATCH_REPORTS/
    REJECTED_IDEAS.md

data/
  content_manifest.json

  decisions/
    ministan/
      onboarding/
      standalone/
      chains/
      arcs/
      crises/
      recovery/
      endgame/

  arcs/
    ministan_advisor_arcs.json
    ministan_national_arcs.json

  crises/
    ministan_crises.json

  laws/
    ministan_laws.json

  endings/
    ministan_endings.json

  palace/
    ministan_palace_upgrades.json
```

Do not place draft content in runtime data folders.

Drafts belong under:

```text
docs/content/drafts/
```

Only validated integrated content belongs under `data/`.

---

# 22. Content authoring metadata

Runtime content must remain compatible with Phase 2A schemas.

Optional development-only metadata may be added under:

```json
"authoring": {
  "primary_content_class": "major_arc",
  "primary_category": "science",
  "primary_stage": "escalation",
  "humor_tags": ["scientific_understatement"],
  "emotional_goal": "curiosity",
  "visual_hook": "tiny artificial sun over city",
  "localization_risk": "low",
  "writer_notes": ""
}
```

This block must not affect gameplay.

It may be stripped from production builds later.

---

# 23. Decision writing standard

Every decision must pass this structure.

## 23.1 Proposal

The proposal must:

- Be understandable in five seconds.
- Usually fit within 50–220 characters.
- Sound like the assigned speaker.
- Present one concrete problem or proposition.
- Avoid explaining mechanics.
- Avoid real-world political references.
- Avoid relying on obscure memes.
- Create a visual or narrative image.

## 23.2 Options

Each option must:

- Be concise.
- Express a distinct governing approach.
- Avoid being merely “yes” and “no” where a fun label is possible.
- Produce a meaningful trade-off.
- Stay understandable without revealing every hidden consequence.
- Avoid a clearly dominant choice.

## 23.3 Results

Each result must:

- Confirm what happened.
- Contain one memorable detail.
- Be shorter than a full paragraph.
- Reference the choice.
- Reflect the speaker or affected population.
- Avoid repeating the proposal.

## 23.4 Mechanical quality

A normal decision should usually affect:

```text
2–3 resources or state dimensions
```

It may additionally change:

- Law.
- Flag.
- Counter.
- Advisor affinity.
- Ruler trait.
- Arc state.
- Narrative event.
- Crisis state.

Avoid cards with:

- No meaningful effect.
- Four positive resource effects.
- Four negative effects without narrative justification.
- Unrelated flags.
- Hidden consequences that feel arbitrary.

---

# 24. Arc authoring template

Every major arc must begin with an approved planning document.

Template:

```text
Arc ID:
Title:
Arc type:
Primary advisor:
Secondary advisors:
Primary category:
Primary stage range:
Core fantasy:
Setup:
Escalation:
Player conflict:
Branch A:
Branch B:
Optional Branch C:
Resolution A:
Resolution B:
Failure/abandonment:
Possible ending:
Required laws:
Required flags:
Blocked arcs:
Affinity interactions:
Trait interactions:
Crisis interaction:
Visual hooks:
Card count:
Reachability risks:
Repeated-joke risks:
```

Cursor must not generate the final JSON before the arc graph is reviewed.

---

# 25. Short-chain authoring template

```text
Chain ID:
Title:
Length: 2 or 3 decisions
Speaker(s):
Setup decision:
Consequence timing:
Branching point:
Resolution:
Laws/flags:
Mechanical purpose:
Visual hook:
```

Short chains should be more compact than major arcs.

---

# 26. Crisis authoring template

```text
Crisis ID:
Title:
Activation conditions:
Severity:
Maximum duration:
Primary advisor:
Initial card:
Options:
Persistent consequence:
Success condition:
Failure condition:
Ending trigger:
Law variants:
Affinity variants:
Arc connection:
Visual hook:
```

---

# 27. Law authoring template

```text
Law ID:
Display name:
Short name:
Category:
Description:
Icon key:
Visual tags:
Unlocked decisions:
Blocked decisions:
Modified crises:
Interacting laws:
Ending contribution:
Delayed consequence:
```

A law cannot be approved if it has no downstream content interaction.

---

# 28. Ending authoring template

```text
Ending ID:
Headline:
Subtitle:
Description:
Type:
Rarity:
Priority:
Conditions:
Explicit trigger:
Archive hint:
Placeholder icon:
Related arc:
Related advisor:
Required debug path:
Expected simulation frequency:
```

---

# 29. Cursor content-generation workflow

Cursor must not generate and integrate a large content batch in one uncontrolled pass.

Every batch follows seven steps.

## Step 1 — Gap analysis

Cursor reads:

- This PRD.
- Content manifest.
- Voice bible.
- Existing content.
- Latest diagnostics.
- Latest simulation report.

It produces a gap report:

- Missing quota.
- Overrepresented category.
- Underrepresented advisor.
- Stage shortage.
- Repeated joke risks.
- Arc coverage.
- Laws or endings lacking content.

## Step 2 — Batch plan

Cursor creates a short plan containing:

- Candidate IDs.
- Speaker.
- Category.
- Stage.
- Narrative role.
- Referenced laws.
- Expected trade-off.
- Expected follow-up.
- Visual hook.

No JSON integration yet.

## Step 3 — Candidate generation

Generate no more than:

```text
12–15 new candidate decisions per sub-batch
```

For major arcs:

```text
One major arc per sub-batch
```

or two very small arcs only when their combined card count is under 12.

## Step 4 — Self-review

Cursor must review candidates against:

- Voice.
- Repetition.
- Dominant choices.
- Schema.
- Narrative logic.
- Stage pacing.
- Law relevance.
- Ending reachability.
- Localization risk.

Weak candidates must be rewritten or rejected before integration.

## Step 5 — Integration

Only reviewed content is added to runtime data.

Cursor updates:

- Content files.
- Manifest.
- Arc or chain catalogs.
- Laws/endings where required.
- Validation fixtures.

## Step 6 — Diagnostics

After every sub-batch:

- Run content validation.
- Run static graph diagnostics.
- Run at least 1,000 simulations.
- Report selection counts.
- Report content exhaustion.
- Report never-selected decisions.
- Report fallback use.
- Report ending changes.

## Step 7 — Manual paths

Manually test:

- At least one intended path per standalone batch.
- Every branch of a chain.
- Every branch of a major arc.
- Every crisis resolution.
- Every new ending trigger.

Only then set status to `approved`.

---

# 30. AI role separation inside Cursor

For quality, Cursor should use separate passes even if the same Agent performs them.

## 30.1 Content Planner

Produces:

- Quota analysis.
- Arc graph.
- Candidate IDs.
- Mechanical purpose.
- No finished prose yet.

## 30.2 Character Writer

Produces:

- Proposal.
- Option labels.
- Result text.
- Advisor-consistent language.

## 30.3 Systems Editor

Checks:

- Effects.
- Requirements.
- Flags.
- Laws.
- Arc actions.
- Follow-up timing.
- Ending conditions.

## 30.4 Critical Reviewer

Attempts to reject content because of:

- Weak joke.
- Repetition.
- Dominant option.
- Unclear consequence.
- Out-of-character writing.
- Impossible graph.
- Excessive complexity.
- Cultural or localization problem.

## 30.5 Integrator

Writes final data and runs validation.

Cursor must not skip the Critical Reviewer pass.

---

# 31. Content quality rubric

Each decision receives a score from 0 to 2 on each criterion.

| Criterion | 0 | 1 | 2 |
|---|---|---|---|
| Immediate clarity | Confusing | Understandable after reread | Instantly clear |
| Advisor voice | Wrong/generic | Partly distinctive | Clearly character-specific |
| Choice quality | Dominant or fake | Some trade-off | Two compelling approaches |
| Consequence quality | Arbitrary | Mechanically logical | Mechanically and narratively memorable |
| Novelty | Repeated | Familiar with twist | Distinctive |
| State integration | Isolated | One state link | Multiple meaningful links |
| Replay value | Always same | Some variation | Branching or state-dependent |
| Visual potential | None | Basic | Strong visual hook |
| Localization readiness | High risk | Moderate | Low risk |
| Technical validity | Broken | Valid with concern | Clean and testable |

Maximum:

```text
20 points
```

Approval threshold:

```text
16 points
```

Additionally, no decision may score `0` for:

- Immediate clarity.
- Choice quality.
- Technical validity.
- Advisor voice for advisor-spoken cards.

The review score belongs in batch reports, not runtime files.

---

# 32. Repetition and novelty rules

Across the approved library:

- No identical core premise.
- No advisor uses the same sentence structure excessively.
- No joke tag should account for more than 6% of all decisions.
- No primary advisor should exceed the target distribution by more than five cards.
- No category should exceed its target by more than five cards.
- No same advisor three times in a row outside mandatory chains.
- No same humor tag in adjacent unrelated decisions where avoidable.
- Reusable decisions must remain below 8% of the library.
- At least 75% of decisions must be one-time per run.
- At least 55% of decisions must reference or modify persistent state.
- At least 35% must be part of a chain, arc, crisis, or ending path.
- At least 25% must have state-dependent eligibility beyond day and one-time rules.

---

# 33. Localization readiness

English should be the master authoring language unless the project selects another master language before production.

Requirements:

- Avoid untranslated text embedded in images.
- Keep option labels concise.
- Avoid jokes based only on English spelling.
- Tag wordplay with `localization_risk`.
- Avoid direct cultural references that cannot transfer.
- Keep laws and character names stable.
- Do not concatenate translated sentence fragments at runtime.
- Keep variables and placeholders explicit.

The full localization implementation may occur later, but content must be authored so it can be extracted and translated.

---

# 34. Visual-production hooks

Phase 2B uses placeholders but must prepare Phase 3.

Every approved decision must have:

```text
visual_tags
```

Where relevant, also define:

- Advisor expression.
- Country prop.
- Crowd state.
- Building state.
- Overlay effect.
- Crisis effect.
- Ending illustration key.

Examples:

```json
"visual_tags": [
  "pizza_stalls",
  "happy_crowd",
  "cheese_boxes_at_palace"
]
```

The manifest must generate a future asset inventory showing:

- Unique advisor expressions.
- Unique city props.
- Unique overlays.
- Unique crisis visuals.
- Unique ending illustrations.
- Frequency of asset reuse.

Avoid creating hundreds of single-use art requirements.

Target:

- At least 60% of ordinary cards use reusable visual assets.
- Major arcs may use unique visual hooks.
- Every approved law needs a reusable visual prop.
- Every approved ending needs at least a placeholder illustration key.

---

# 35. Simulation strategies

Random choice simulation is not sufficient.

Phase 2B must support at least four choice strategies:

## Random

Random valid option.

## Resource Preserver

Prefers the option that best protects the lowest resource.

## Power Maximizer

Prefers Order and Elite Loyalty.

## Chaotic Explorer

Prefers laws, flags, rare tags, experiments, and high-variance outcomes.

Optional:

## Happiness Populist

Prefers Happiness.

These strategies help identify content that is reachable only under one playstyle.

---

# 36. Simulation quality targets

## After every sub-batch

Run:

```text
1,000 simulations
```

Required:

- Zero blocking errors.
- Zero content-exhaustion runs.
- No forced-follow-up loops.
- No event-queue loops.
- New content appears where intended.
- Real save remains untouched.

## After every major wave

Run:

```text
5,000 simulations
```

Across at least three choice strategies.

## Final content freeze

Run:

```text
10,000 simulations
```

Across all supported choice strategies and multiple seeds.

Final targets:

| Metric | Target |
|---|---|
| Content exhaustion | 0 |
| Blocking validation errors | 0 |
| Fallback-card share | <1% of selected cards |
| One-time decision repetition | 0 |
| Average run length | 18–30 decisions |
| Runs reaching Day 40 | 8–20% |
| Special-ending share | 25–45% |
| Generic resource-failure share | 40–65% |
| Decisions never selected | <3%, excluding intentional secrets |
| Major arcs never started | 0 |
| Major arcs without completed paths | 0 |
| Crises never activated | 0 |
| Same-advisor triple outside chain | <0.5% of relevant sequences |
| Average unique-card ratio per run | >95% |
| Content manifest approved count | 330 |

Secret endings may remain extremely rare, but diagnostics must prove that they are reachable.

---

# 37. Manual playtesting targets

Automated simulation cannot judge humor, comprehension, or emotional pacing.

## 37.1 Internal authoring playtest

After every major arc:

- Play every branch using debug tools.
- Verify references to prior choices.
- Verify advisor voice.
- Verify results are understandable.
- Verify visual tags make sense.

## 37.2 Closed internal test

Before closed alpha:

```text
5–10 players
```

Each completes at least three runs.

Measure:

- Did they understand choices?
- Did they notice consequences?
- Which advisor was memorable?
- Which jokes repeated?
- Did they restart?
- Did endings feel earned?

## 37.3 Closed alpha

Target:

```text
20–50 external players
```

Recommended minimum dataset:

```text
200 completed runs
```

Track:

- Runs per player.
- Unique cards seen.
- Repeated cards.
- Ending distribution.
- Arc completion.
- Decision time.
- Restart rate.
- Qualitative favorite and least-favorite content.
- Confusing cards.
- Offensive or culturally unclear content.

Phase 2B is not frozen until closed-alpha findings are addressed.

---

# 38. Content roadmap

Use this roadmap sequentially.

Do not ask Cursor to implement all milestones at once.

## Milestone 2B-0 — Existing-content audit and manifest

Goals:

- Inventory all current Phase 2A content.
- Classify every existing decision.
- Create content manifest.
- Mark approved, rewrite, rejected, or deferred.
- Produce exact gap counts against this PRD.

No major new content.

## Milestone 2B-1 — Voice bible and production scaffolding

Goals:

- Create character voice bible.
- Create content style guide.
- Create arc, chain, and crisis catalogs.
- Create draft/review folder structure.
- Add content-quota and manifest reports.
- Establish batch review workflow.

No more than five canonical sample cards per advisor.

## Milestone 2B-2 — First-run and onboarding pack

Target approved content:

```text
10 onboarding decisions
```

Must prove all major game concepts without overwhelming the player.

## Milestone 2B-3 — Standalone policy pack A

Target approved content:

```text
24 standalone decisions
```

Primary focus:

- Economy.
- Public life.
- Infrastructure.

## Milestone 2B-4 — Standalone policy pack B

Target approved content:

```text
24 standalone decisions
```

Primary focus:

- Military and order.
- Media and propaganda.
- Science and technology.

## Milestone 2B-5 — Standalone policy pack C

Target approved content:

```text
24 standalone decisions
```

Primary focus:

- Business.
- Bureaucracy.
- Cats and animals.
- Quota gap correction.

Standalone total after 2B-5:

```text
72
```

## Milestone 2B-6 — Short-chain pack A

Target:

```text
20 decisions
```

Use approximately eight chains from the required catalog.

## Milestone 2B-7 — Short-chain pack B

Target:

```text
20 decisions
```

## Milestone 2B-8 — Short-chain pack C

Target:

```text
20 decisions
```

## Milestone 2B-9 — Short-chain pack D

Target:

```text
20 decisions
```

Short-chain total after 2B-9:

```text
80
```

## Milestone 2B-10 — Major-arc pack A

Target:

```text
24 decisions
```

Recommended arcs:

- General Boom.
- Minister Penny.
- Traffic and Military Control.
- Hyperinflation.

## Milestone 2B-11 — Major-arc pack B

Target:

```text
24 decisions
```

Recommended arcs:

- Luna News.
- Auntie Olga.
- Mandatory Happiness.
- Fake Election Accident.

## Milestone 2B-12 — Major-arc pack C

Target:

```text
24 decisions
```

Recommended arcs:

- Doctor Maybe.
- Sir Profit.
- AI Government.
- Sell the Moon.

## Milestone 2B-13 — Major-arc pack D

Target:

```text
24 decisions
```

Recommended arcs:

- Comrade Whiskers.
- Clerk Zero.
- Cat Politics.
- National Festival Economy.
- International Cheese Crisis.
- Palace Renovation Scandal.

The exact distribution must still total 96 major-arc decisions.

## Milestone 2B-14 — Crisis content pack

Target:

```text
28 crisis decisions across 18 crisis definitions
```

## Milestone 2B-15 — Recovery content pack

Target:

```text
24 recovery decisions
```

Exactly six per resource.

## Milestone 2B-16 — Endgame and rare-resolution pack

Target:

```text
20 decisions
```

## Milestone 2B-17 — Laws, endings, and palace-content completion

Targets:

- 50 approved laws.
- 50 approved endings.
- 24 palace upgrades.
- Complete archive copy.
- Complete newspaper copy.
- Complete visual-hook inventory.

This milestone may adjust decisions to ensure every law and ending has meaningful support.

## Milestone 2B-18 — Full-library diagnostics and balance

Requirements:

- Exactly 330 approved decisions.
- Quota compliance.
- 10,000 simulations.
- Four or more strategies.
- No exhaustion.
- Low fallback.
- Reachability.
- Effect rebalance.
- Repetition correction.
- Remove or rewrite weak content.

## Milestone 2B-19 — Closed alpha

Requirements:

- Package content-complete build.
- Test with 20–50 players.
- Collect quantitative and qualitative results.
- Produce prioritized content-fix report.
- Do not add random content without evidence.

## Milestone 2B-20 — Strong-launch content freeze

Requirements:

- Apply closed-alpha fixes.
- Final validation.
- Final 10,000-run simulation.
- Final manifest.
- Final content inventory.
- Known limitations.
- Phase 2B completion report.
- Freeze runtime content schemas.
- Hand off to Phase 3.

---

# 39. Milestone batching rule

Milestones with more than 15 new decisions must be implemented through sub-batches.

Example for a 24-card milestone:

```text
Sub-batch 1: 12 candidates
→ review
→ validation
→ simulation
→ approval

Sub-batch 2: 12 candidates
→ review
→ validation
→ simulation
→ approval
```

Do not generate 24 polished decisions in one unreviewed pass.

For major arcs:

```text
One arc per sub-batch
```

unless two arcs together contain no more than 12 cards.

---

# 40. Generic Cursor prompt template

```text
Read:

- docs/08_PHASE_2B_STRONG_LAUNCH_CONTENT_PRODUCTION_PRD.md
- docs/06_PHASE_2A_NARRATIVE_AND_SYSTEMS_DESIGN_PRD.md
- docs/07_PHASE_2A_IMPLEMENTATION_ROADMAP.md
- docs/content/MINISTAN_CHARACTER_VOICE_BIBLE.md, if present
- data/content_manifest.json
- the latest validation, diagnostic, and simulation reports

Implement only Phase 2B Milestone [NUMBER AND NAME].

Before changing runtime data:

1. Audit the current manifest and calculate the exact remaining quota.
2. Inspect existing content for repetition and conflicts.
3. Produce a batch plan with IDs, speakers, categories, stages, mechanical roles, and visual hooks.
4. Do not implement later milestones.
5. Do not change core systems unless a verified bug blocks content.
6. Keep each sub-batch within the size limit from the PRD.

Required output:
[copy the milestone target and relevant quality requirements]

After drafting:

1. Perform the Critical Reviewer pass.
2. Reject or rewrite weak candidates.
3. Integrate only reviewed content.
4. Update the content manifest.
5. Run validation and static diagnostics.
6. Run the required simulations.
7. Report never-selected content, fallback use, ending changes, and quota changes.
8. Provide manual branch tests.
9. List all changed files.
10. Do not proceed to the next milestone.
```

---

# 41. Cursor prohibitions

Cursor must not:

- Generate all 330 decisions in one task.
- Add cards without manifest records.
- Count draft content as approved.
- Rewrite engine architecture to accommodate one weak card.
- Add new mechanics casually.
- Copy real political events.
- Reuse one joke with different nouns.
- Use generic assistant-like character voices.
- Create a dominant “correct” option repeatedly.
- Skip simulation.
- Skip manual branch testing for arcs.
- Add final graphics.
- Create new countries during Phase 2B.
- Modify accounts, ads, IAP, or backend systems.
- Claim a content batch is complete without evidence.

---

# 42. Phase 2B acceptance criteria

Phase 2B is complete only when all criteria pass.

## Inventory

- Exactly 330 approved decisions.
- 10 onboarding decisions.
- 72 standalone decisions.
- 80 short-chain decisions.
- 96 major-arc decisions.
- 28 crisis decisions.
- 24 recovery decisions.
- 20 endgame decisions.
- 18 major arcs.
- 32 short chains.
- 18 crises.
- 50 laws.
- 50 endings.
- 24 palace upgrades.
- 8 main advisors.
- 6 guest speakers.

## Quality

- Every approved card scores at least 16/20.
- No approved card scores zero in mandatory rubric dimensions.
- Advisor voices are distinguishable.
- No major unresolved repetition problem.
- No obviously dominant options.
- Prior decisions are referenced meaningfully.
- Laws have downstream impact.
- Endings feel earned.

## Technical

- No blocking validation errors.
- No impossible required arc.
- No unresolvable crisis.
- No event cycles.
- No content exhaustion.
- No one-time repetition.
- No real-save mutation from simulation.
- Old saves remain compatible.
- Runtime schemas remain stable.

## Simulation

- Final 10,000-run simulation completed.
- All major arcs start.
- Every major arc has a completed path.
- Every crisis activates.
- Every approved ending is proven reachable or intentionally tagged secret with a debug proof.
- Fallback share below 1%.
- Never-selected ordinary decisions below 3%.
- Average unique-card ratio above 95%.

## Playtesting

- Closed alpha completed.
- At least 200 total runs observed.
- Main content confusion corrected.
- Major repetition complaints corrected.
- Offensive or culturally inappropriate content corrected.
- Final content-fix report completed.

---

# 43. Definition of ready for Phase 3

Phase 3 may begin when:

- The strong-launch content inventory is complete.
- The library is frozen except for bug fixes.
- The required visual tags are stable.
- The advisor expression inventory is generated.
- The law-prop inventory is generated.
- Crisis visual requirements are generated.
- Ending illustration requirements are generated.
- UI text lengths are known.
- Audio-event hooks are known.
- The game no longer expects major content-schema changes.
- Phase 3 can focus on presentation rather than rewriting the game.

---

# 44. Recommended first Phase 2B task

The first task after adding this PRD is:

```text
Milestone 2B-0 — Existing-content audit and manifest
```

Do not generate new content until the current Phase 2A library has been:

- Counted.
- Classified.
- Reviewed.
- Added to the manifest.
- Compared against the exact quotas in this document.
