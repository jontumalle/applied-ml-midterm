# Part 1: assumptions, experiments, and follow-ups

## Objective and assumptions

- Predict five overlapping stopping reasons: Safety, Funding, Efficacy, Recruitment, and Other. Use 157 labeled and 1,014 unlabeled training trials; compare models on 78 validation trials and predict 312 test trials.
- Assume nearby standardized reason embeddings contain useful reason information. Clusters need not correspond one-to-one to reasons; each trial can have several labels.
- Estimate cluster reason frequencies from observed training labels, with smoothing. Threshold these scores to recover missing labels; retain all observed labels unchanged.
- Treat recovered labels as uncertain: compare full weight with quarter weight in the final logistic-regression training loss.
- Fit learned preprocessing on training data only. Labeled trials are generally earlier than unlabeled/test trials, so observed reason frequencies may not transfer over time.

## Experiments and findings

- The starter logistic-regression baseline scored **0.8654 sample-wise F1**. A supervised control with a highest-score fallback reached **0.8782**.
- Compared K-means and diagonal GMM recovery, cluster counts, thresholds, pseudo-label weights, and regularization. Best K-means: **0.8547**; best GMM: **0.8312**. Quarter-weight pseudo-labels were preferred.
- Added year and text/drug TF-IDF features; these did not improve the initial clustering-based models.
- Inspected PCA projections and cluster-by-reason counts. Two PCs retain only **24.2%** of variance, so plotted overlap cannot establish original-space separation. Sparse labeled clusters make frequency estimates uncertain.
- Funding disappeared because its highest smoothed cluster score was **0.205**, below **0.3**. Lowering its threshold added 112 pseudo-positives but increased validation false positives; overall F1 fell to **0.8419**.
- Tested 3/5/9/15-neighbor recovery and uniform/distance voting. Three uniform neighbors plus equal blending with K-means scores achieved **0.8868 sample-wise F1 / 0.7792 macro F1**. It recovered 16 Funding positives and identified 2/4 Funding validation cases without false positives.
- The submitted hybrid received a recorded Kaggle public score of **0.87927**. Its file is `part1-results/knn-experiment/best_augmented_candidate_submission.csv`; root `part1_submission.csv` remains the original K-means output.

## Possible follow-ups — not yet tested

- Train with soft labels or filter pseudo-labels by confidence.
- Audit text fields individually and preserve structured identifiers; compare nonlinear final classifiers while holding recovered labels fixed.
- Check sensitivity to seeds, neighbor/cluster choices, and temporal evaluation. With only four Funding validation positives and 99 evaluated configurations, improvements may reflect selection noise.
