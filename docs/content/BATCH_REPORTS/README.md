# Batch reports

One markdown report per content sub-batch after integration.

## Report template

```markdown
# Batch {batch_id}

**Date:** YYYY-MM-DD
**Milestone:** 2B-N
**Candidates generated:** N
**Integrated:** N
**Approved:** N
**Rejected:** N

## Quota delta

| Dimension | Before | After | Target gap |
|---|---:|---:|---:|

## Per-card rubric scores

| ID | Clarity | Voice | Choice | Consequence | Novelty | State | Replay | Visual | L10n | Technical | Total | Approved? |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|

Approval threshold: **16/20**. No zero on clarity, choice quality, technical validity, or advisor voice.

## Simulation summary

- Runs:
- Never-selected new IDs:
- Fallback use:

## Manual paths tested

- [ ] Standalone spot-check
- [ ] Chain branches
- [ ] Arc branches
- [ ] Crisis resolutions

## Rejected or deferred IDs

Move permanently rejected ideas to [REJECTED_IDEAS.md](../REJECTED_IDEAS.md).
```

Regenerate manifest quota after every batch:

```bash
godot --headless --path . -s tests/run_content_manifest.gd -- --export-audit
```
