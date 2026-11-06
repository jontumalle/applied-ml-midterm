# Part 2 walkthrough

Use one component per conversation turn and check understanding before advancing.

## 1. Objective and starting data

- Predict whether a trial met its primary endpoint: success = 1, failure = 0.
- This is a different task and larger dataset than Part 1: 8,037 training rows, 1,013 validation rows, 1,500 hidden-outcome test rows.
- Trials can appear in multiple phases. Fit one classifier for each of phases I, II, and III; no trial crosses the supplied splits.
- Predict from eligibility criteria, diseases, drugs, and other permitted trial details. Part 1 reasons/embeddings are reserved for later error analysis, never classifier inputs.
- Check: Is the difference between predicting an outcome and explaining a stopping reason clear?

## 2. Establish a baseline

- Reproduce the starter's binary bag-of-words logistic regression separately per phase, linking to HW2.
- Fit vocabulary and coefficients on training data; evaluate against known validation outcomes.
- Output a success probability. Threshold it at 0.5 only for F1 and error counts.
- Kaggle scores probability log loss: a confident wrong prediction costs more than an uncertain wrong one. Lower is better.
- Baseline equal-phase validation log loss: 0.9401.
- Check: Is the distinction between the probability and its thresholded decision clear?

## 3. Use Part 1 to understand errors

- Take validation trials with known outcome 0 and ask how often the model incorrectly predicts 1.
- Match trial IDs to the Part 1 hybrid's reason labels, preserving observed/predicted provenance. A multi-label trial can belong to several groups.
- Put unmatched failures into a separate "no recorded stopping reason" group; lack of a match does not mean no explanation exists.
- Among 452 unsuccessful phase rows, 27 have observed reasons, 171 predicted reasons, and 254 are unmatched. These are phase rows, not necessarily distinct trials across phases.
- Example baseline problem: 6/8 Phase III Efficacy-group failures are predicted successful; all eight reason labels are estimates.
- Check: Is it clear that reasons are used after prediction, not to tell the model which trials failed?

## 4. Test changes suggested by the errors

- Normalize text, preserve negations/numbers and intact ICD/pathway identifiers, and compare TF-IDF representations with separate field blocks.
- Compare regularization strengths, class balancing, and Multinomial Naive Bayes on nonnegative TF-IDF features.
- Test sigmoid probability calibration using three training-only folds. Preprocessing is refitted inside every fold.
- Evaluate 27 configurations per phase, choosing by validation log loss; reasons never determine individual training weights.
- Check: Is it clear why better features, better decisions, and better probability confidence are different changes?

## 5. What was selected

- Phase I: criteria TF-IDF logistic regression, C=10, no calibration.
- Phase II: criteria TF-IDF logistic regression, C=1, train-only sigmoid calibration.
- Phase III: separate criteria/context/ICD TF-IDF blocks, C=1, train-only sigmoid calibration.
- No selected model uses balanced class weights or the extra drug-knowledge/year block.
- Equal-phase validation log loss falls to 0.5738. F1/ROC-AUC/AP improve in every phase.
- Check: Does it make sense that different phases can prefer different representations and probability adjustments?

## 6. The trade-off in the results

| Phase | Baseline F1 | Selected F1 | Baseline loss | Selected loss |
|---|---:|---:|---:|---:|
| I | 0.7006 | 0.7821 | 0.8791 | 0.5603 |
| II | 0.6141 | 0.6288 | 1.0603 | 0.6127 |
| III | 0.7739 | 0.7915 | 0.8808 | 0.5485 |

- Phase I/II overall false-success rates decrease. Phase III's increases from 49.6% to 59.3% despite better aggregate metrics.
- Phase III Efficacy errors rise from 6/8 to 7/8; the unmatched group rises from 37/82 to 48/82. Other groups improve.
- A balanced Phase III alternative reduces overall false-success rate to 40.7%, but has worse log loss (0.5734) and F1 (0.7580) than the selected model. This alternative is measured, not chosen.
- Selection follows the competition's log-loss objective; the report explicitly includes subgroup regressions and small/inferred-group uncertainty.
- Check: Is it clear how better overall metrics can coexist with worse errors for a subgroup?

## 7. Deliverables and remaining uncertainty

- `part2_submission.csv`: 1,500 success probabilities in original test ID order. Uploaded as Kaggle submission `58039392`; status COMPLETE, public log loss **0.61046**.
- `part2-results/`: all 81 candidate scores, selected settings, baseline/selected validation predictions, reason-label provenance, and all 18 reason-group comparisons.
- `writeup/main.tex`: combined technical report; `make report-pdf` builds the five-page draft. Team names/responsibilities still require user-provided facts.
- Later-year test trials may differ from historical train/validation data. Public log loss is 0.0366 above the equal-phase validation loss of 0.57383. The public score covers a subset with potentially different composition; this does not prove temporal shift caused the gap. Full-test and per-phase test performance remain unavailable.
- Check: Is it clear which conclusions are measured and which remain hypotheses about generalization?

## Follow-up: training penalties rather than decision thresholds

- `PART2_NOTES.md` records 1x/2x/4x failure-loss weights with fixed threshold 0.5.
- Raw Phase III fold-model false-success rates fall 59.3% → 36.6% → 19.5%, but missed-success rates rise 14.6% → 26.3% → 43.8%.
- Unweighted calibration largely restores the original probability balance; selected-procedure Phase III false-success rates are 59.3% → 58.5% → 57.7%.
- This explains why changing training costs and then calibrating to natural frequencies can pursue different goals. No penalty is automatically selected and no new upload is made.
