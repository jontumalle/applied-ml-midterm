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
