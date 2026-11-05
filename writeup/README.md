# Team report

Fill in `main.tex`: team names and responsibilities, Abstract, Methods,
Results, Discussion, and References. Replace all TODOs and table placeholders.
The included CVPR style follows the template linked in the assignment.
Keep the report within five pages including figures; references are excluded.

From the repository root, run `make report-pdf`. Output: `writeup/main.pdf`.
Requires a LaTeX installation such as MacTeX, TeX Live, or MiKTeX.

Windows teammates can install MiKTeX and run these commands in PowerShell
without Make, from the repository root:

```powershell
cd writeup
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex
```

Two passes resolve references. The bibliography uses entries in `main.tex`.
`cvpr.sty` is the unmodified official CVPR 2026 style from
https://github.com/cvpr-org/author-kit/tree/12909ae437f6dbc7435069cfdb4ca44c18e6a02f.

## Part 1 implementation

The starter notebook now runs K-means and diagonal-GMM label recovery, weighted
binary logistic regressions, supervised controls, and feature ablations. Run all
cells in order with the project virtual environment. From the repository root:

```sh
.venv/bin/python - <<'PY'
import nbformat
from nbclient import NotebookClient
path = 'CS5785_Midterm_Starter.ipynb'
notebook = nbformat.read(path, as_version=4)
NotebookClient(notebook, timeout=600, kernel_name='python3').execute()
nbformat.write(notebook, path)
PY
make report-pdf
```

The environment's Python must be the notebook kernel. In an editor, select
`.venv/bin/python`. Launching from the parent workspace is also supported.

Measured outputs are in `part1-results/`: all 70 validation configurations,
clustering diagnostics, selected settings, dependency versions, label counts,
recovered training labels, validation/test predictions, and a reason lookup for
Part 2. `part1_submission.csv` uses the selected semi-supervised model. The
lookup retains true training/validation labels and marks pseudo-labels and test
predictions explicitly. Use it only for Part 2 error analysis, never as outcome
classifier input.

The notebook regenerates `part1_results.tex` and `part1_feature_results.tex` from
its actual validation metrics. Part 1 Methods, Results, and Discussion in
`main.tex` are filled in. The report is still a draft: team details, Part 2,
and the combined abstract remain to be completed. If experiments change,
update the surrounding prose as well as regenerating the tables.

The best semi-supervised model is K-means with 10 clusters, recovery threshold
0.3, pseudo-label weight 0.25, and logistic-regression C=0.1 on embeddings.
Its sample-wise F1 is 0.8547, below the starter's 0.8654. The report preserves
this negative result and discusses rare-label suppression, extra-feature
limitations, temporal shift, and selection uncertainty on 78 validation rows.

## PCA and cluster inspection

The notebook now includes a training-only diagnostic section after model
selection. It saves three figures as PNG and PDF in `writeup/figures/`:

- `part1_pca_clusters`: cluster-colored PCA projection, observed-label markers,
  and projected centroids.
- `part1_pca_reasons`: five panels of observed positive/negative reasons; hidden
  labels are shown separately, and multi-label trials can occur in several panels.
- `part1_cluster_reason_heatmap`: raw positive counts and smoothed recovery
  probabilities, with the selected 0.3 threshold marked.

CSV diagnostics in `part1-results/` include cluster sizes, observed counts/rates,
smoothed scores, PCA coordinates/variance, nearest-centroid representative
trials, and a Funding-specific inspection. Representatives are selected in the
original 150-dimensional space; their clinical metadata is context, not the
unavailable stopping explanation text.

The first two PCs explain 24.2% of variance, so the 2D display cannot establish
original-space separation. Funding positives occur in four clusters; even the
highest smoothed Funding score (0.2051) is below 0.3. This directly explains the
absence of Funding pseudo-labels. These diagnostics do not change the trained
classifier, predictions, or validation scores.

## Controlled Funding-threshold follow-up

The notebook tests recovery thresholds 0.30, 0.20, 0.15, and 0.10 while holding
clustering, features, other pseudo-labels, classifier regularization, and row
weights fixed. Outputs are in `part1-results/funding-threshold-experiment/`.
The three lower thresholds all add the same 112 Funding pseudo-positives.
Validation Funding true positives stay at 1/4 while false positives rise from
0 to 3. Funding F1 falls from 0.40 to 0.25 and sample-wise F1 from 0.8547 to
0.8419. The original model and submission are retained. K-NN remains a proposed
follow-up, not an evaluated method.

## K-NN and hybrid follow-up

The notebook evaluates neighbors 3, 5, 9, and 15 with uniform/distance voting,
using observed training labels only. Direct K-NN, K-NN recovery + weighted LR,
and an equal K-means/K-NN hybrid are compared with a matched labeled-only LR
control (25 new configurations). Best hybrid sample/macro F1: 0.8868/0.7792;
best K-NN recovery: 0.8803/0.7873. Both recover 2/4 Funding validation cases
with no Funding false positives. The hybrid creates 16 Funding pseudo-labels.

All results, per-configuration validation predictions, the best augmented
training labels, candidate settings, and a separate candidate submission are in
`part1-results/knn-experiment/`. The notebook regenerates
`writeup/part1_knn_results.tex`. The report now includes the negative Funding
threshold experiment and the positive local-recovery follow-up; earlier
statements in this README describe the frozen initial experiment. The original
root submission is preserved. No Kaggle upload has been performed.
