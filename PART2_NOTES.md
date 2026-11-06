# Part 2: assumptions, experiments, and follow-ups

## Objective and assumptions

- Predict endpoint success, independently of stopping reasons, with separate models for phases I/II/III. Reason labels/embeddings and IDs are analysis-only, never predictive features.
- Select success probabilities by validation log loss; threshold at 0.5 only for F1/error counts. Better probability scores need not reduce every subgroup's false-success rate.
- Historical train/validation trials may not represent later test trials. Year can capture associations, but does not itself measure endpoint strictness or establish causal change.

## Initial experiments and findings

- Compared text feature blocks, logistic-regression C/class weights, Multinomial Naive Bayes, and train-only three-fold sigmoid calibration: 81 configurations across phases.
- Selected criteria-only LR for I (C=10) and II (C=1, calibrated); separated clinical text LR for III (C=1, calibrated). Equal-phase validation loss improved from **0.9401 to 0.5738**.
- Phase III false-success rate rose from 49.6% to 59.3% despite better aggregate metrics. Most matched stopping reasons are estimates, and small groups are uncertain.
- Original submitted models received public Kaggle loss **0.61046**, submission `58039392`. Public-subset and validation cohorts differ; the gap does not establish temporal shift as its cause.

## Year-only follow-up — November 5, 2026

- Hypothesis: year might provide useful information hidden by the earlier joint drug-knowledge/year ablation. Stricter success criteria over time are a hypothesis, not an observed fact.
- Hold each selected phase's text features, C, class weights, calibration procedure, and decision threshold fixed. Compare no year versus an added training-imputed/standardized year block with a missingness indicator. Do not add drug knowledge or retune.
- Evaluate both the supplied validation split and a retrospective temporal check: fit through 2010, evaluate 2011–2013, using training data only. Unknown-year rows are excluded from both temporal cohorts; whole trials stay together across phases.
- Refit all preprocessing and calibration within each fitting cohort. The temporal cohort appeared in earlier training/model selection, so this is a retrospective diagnostic, not an untouched independent test. Twelve fixed configurations were evaluated; controls reproduce the original validation probabilities.

| Phase | Supplied validation: no year → +year | Temporal check: no year → +year |
|---|---|---|
| I | 0.5603 → 0.5656 | 0.6994 → 0.7296 |
| II | 0.6127 → 0.6134 | 0.5949 → 0.5997 |
| III | 0.5485 → 0.5537 | **0.4661 → 0.4416** |
| Equal-phase mean | 0.5738 → 0.5776 | 0.5868 → 0.5903 |

- All values above are log loss (lower is better). Temporal false-success rates increase with year in every phase; Phase III rises from 75.7% to 86.5% despite better loss/F1.
- Later temporal-cohort success rates are higher: I 55.6% → 62.1%, II 46.0% → 58.2%, III 62.6% → 82.2%. Cohort composition may explain this; it is not evidence about endpoint strictness.
- **Decision:** retain the original submitted models. Store the with-year candidate separately; no additional Kaggle upload. The results do not rule out other uses of year.
- Reproducible source is in the notebook. `part2-results/year-only-experiment/` contains metrics, predictions, cohort manifests, descriptive yearly rates, specification, and the separate candidate submission.

## Possible follow-ups — not yet tested

- Predefine training-only rolling temporal evaluations before selecting representations/hyperparameters; check whether the Phase III benefit repeats across years.
- Compare nonlinear year effects, independent year regularization, and explicit missing-year handling while keeping other changes controlled.
- Inspect cohort/disease/drug composition and outcome definitions before attributing trends to stricter criteria.
- Bootstrap paired differences with trial-level resampling and evaluate stability; repeated phase rows must stay together.
