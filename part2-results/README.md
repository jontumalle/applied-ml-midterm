# Part 2 measured outputs

- `experiments.csv`: 27 configurations per phase (81 total), validation F1,
  ROC-AUC, average precision, log loss, Brier score, false-success rate, and
  confident-wrong fraction. All decisions use probability threshold 0.5.
- `selected_models.csv` / `.json`: per-phase validation-log-loss selection;
  models fit training only. Calibration uses three training-only folds.
- `metric_comparison.csv`: required baseline/selected metrics for all phases.
- `baseline_validation_predictions.csv`, `selected_validation_predictions.csv`:
  observed outcomes, model probabilities, and binary predictions.
- `baseline_failed_trial_audit.csv`, `selected_failed_trial_audit.csv`: unsuccessful
  validation rows joined to Part 1 reasons, with detailed observed/predicted/unmatched
  provenance. These are analysis artifacts, not model input.
- `reason_error_comparison.csv`: six reason groups x three phases, observed and
  predicted reason counts, error counts, rates, and changes. Empty Phase III
  Funding rates are undefined (NaN), not zero. Groups can overlap.
- `part1_hybrid_reason_lookup.csv`, `part1_reason_lineage.json`: exact Part 1
  hybrid labels and settings used for analysis. The older root Part 1 lookup
  is deliberately not used.
- `family_comparison.csv`, `baseline_metrics.csv`, `baseline_reason_errors.csv`,
  `selected_reason_errors.csv`, `split_summary.csv`, `environment.json`:
  supplementary model, split, and reproducibility information.

The notebook generates `../part2_submission.csv` with 1,500 test success
probabilities and report tables in `../writeup/`. The file was uploaded separately
through the Kaggle CLI as submission `58039392` (COMPLETE). Public log loss is
0.61046, compared with equal-phase validation loss 0.57383 (gap about 0.0366).
`kaggle_submission.json` records this result. The public score covers a subset;
full-test and per-phase scores are not available. Cohort/phase composition,
selection optimism, and possible temporal shift limit interpretation of the gap.
The equal-phase validation log loss improves from 0.9401 to 0.5738; improved
aggregate metrics do not imply every group improves (notably Phase III).

`failure-penalty-experiment/` contains normalized 1x/2x/4x failure-loss
comparisons, same-fold pre-calibration diagnostics, weight audits, all validation
predictions, 90 reason-group rows, within-view group changes, and unsubmitted
candidate files. See `../PART2_NOTES.md`. These are separate from the frozen
original selected-model/Kaggle artifacts.
