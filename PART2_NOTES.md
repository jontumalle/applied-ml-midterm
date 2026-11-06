# Part 2: assumptions, experiments, and follow-ups

## Scope and earlier work

- Predict endpoint success separately for phases I/II/III. IDs and Part 1 reasons/embeddings are excluded from predictive inputs; reasons are used only for error analysis.
- Merged models use TF-IDF logistic regression with training-only sigmoid calibration in II/III. Equal-phase validation log loss: **0.5738**; recorded public Kaggle loss: **0.61046**, submission `58039392`.
- This experiment starts from updated `main` commit `0233983` on `feat/part2-failure-cost-experiment`.
- The earlier isolated-year experiment remains on `feat/part2-outcome-models` (commit `5eddc7a`), outside merged main. Its notes/results are preserved there, not silently merged into this branch.

## Failure-loss weighting — November 6, 2026

- **Hypothesis:** making observed failures more influential during optimization can reduce false-success errors, without changing the final threshold.
- Fix each phase's selected text features, C, seed, calibration procedure, and threshold **0.5**. Test relative failure/success loss weights **1:1, 2:1, 4:1**; add no year or drug-knowledge features.
- Normalize weights inside every fit, including calibration folds, so total weight equals the fit's row count. This keeps loss scale/C comparable while preserving the intended failure/success ratio. The 1:1 controls reproduce original probabilities.
- Fit nine configurations (three phases x three penalties). For II/III, also inspect mean raw probabilities from the **same fitted fold models** before sigmoid calibration, giving six diagnostic views without extra classifier fits.
- Calibration remains unweighted against observed training outcomes. It estimates natural outcome probabilities and can counteract cost-induced shifts; weighting calibration itself would be a different experiment.
- Evaluate supplied validation only: false-success and missed-success rates, precision/recall/F1, probability/ranking metrics, and reason-group errors with unchanged provenance/cohorts. No temporal check is performed here.

## Findings

- Phase I is uncalibrated. At 1x → 2x → 4x, false-success rate falls **37.5% → 25.0% → 9.4%**, but missed-success rate rises **17.6% → 31.8% → 51.8%**.
- Phase III shows the same trade-off before calibration:

| Relative failure penalty | False-success rate | Missed-success rate | Log loss |
|---|---:|---:|---:|
| 1x | 59.3% | 14.6% | 0.5487 |
| 2x | 36.6% | 26.3% | 0.5759 |
| 4x | 19.5% | 43.8% | 0.6616 |

- Phase III Efficacy-group errors before calibration fall **7/8 → 5/8 → 4/8**. These reason labels are estimates and the group is small.
- Keeping original calibration, Phase III false-success rates barely change: **59.3% → 58.5% → 57.7%**; Efficacy errors remain 7/8.
- In Phase II, raw false-success rates fall **28.7% → 4.5% → 0.4%**, but calibrated rates are **29.4% → 29.4% → 29.8%**. Calibration largely reverses the conservative probability shift.
- Equal-phase log loss under the selected calibration procedure worsens **0.5738 → 0.5796 → 0.5994**. Higher failure penalties do not improve the natural-probability/Kaggle objective overall.
- **Decision:** retain original submitted models. No automatic penalty choice, threshold change, or additional Kaggle upload. Fewer false successes alone is insufficient if the model misses too many real successes; no acceptable trade-off has been specified.
- Source is in the notebook. `part2-results/failure-penalty-experiment/` stores all metrics, normalized weight audits, validation predictions, group comparisons, specification, and separate candidate files.

## Possible follow-ups — not yet tested

- Specify an acceptable missed-success rate or a false-success/missed-success cost ratio before selecting a model.
- Compare training penalties and decision policies separately, retaining the distinction between probability estimation and cost-sensitive decisions.
- If weighting calibration is explored, label the changed probability target explicitly; do not present cost-tilted scores as calibrated natural outcome probabilities.
- Assess stability with trial-level resampling, training-only temporal diagnostics, and train-only hyperparameter selection. Small groups, inferred reasons, and repeated validation use limit conclusions.
