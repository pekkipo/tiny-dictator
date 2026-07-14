# Known Issues and Limitations — Phase 1 Prototype

Intentional scope limits (per the Phase 1 PRDs), not defects:

## Art and presentation

- All visuals are emoji/ColorRect placeholders; no final art, typography, or theme.
- No animations or tweens (delta feedback is instant text, not animated).
- No audio of any kind.
- Country diorama states are placeholder emoji rows, not the final layered scene.

## Content volume

- One country (Ministan), 16 decisions (10 core + 6 follow-ups). The PRD target
  of 24+6 is a pure-JSON authoring task with no code changes required.
- Because of the small pool, long runs repeat the fallback decision
  ("generic_minister_disagreement") after roughly day 10, which makes the
  day-30 survival ending fairly common (3 of 5 simulated playthroughs).
  Authoring more decisions will restore variety and risk in the late game.

## Platform and export

- Desktop editor play only; no Android/iOS export configuration or testing yet.
- Portrait layout is responsive, but only spot-checked at 1080×1920 aspect ratios.

## Systems deferred beyond Phase 1

- Save system stores only unlocked endings, settings, and the last run summary.
  A version mismatch resets the save (no migration path yet).
- No mid-run persistence — closing the game abandons the current run.
- No monetization, analytics, ads, localization, or accessibility options.
- TC-013 (weighted-selection distribution over 1,000 draws) is not automated;
  all shipped decisions currently use the default weight of 10.

## Minor known quirks

- A fresh run reads as "tense" in the diorama summary because 55 order sits in
  the middle tier by design; tune thresholds in `CountryStateResolver` if desired.
- The debug overlay's RELOAD CONTENT acts immediately; reloading mid-run while
  a decision is displayed keeps the already-selected card until the next day.
