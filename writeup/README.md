# Combined midterm report

`main.tex` contains the completed technical Methods, Results, and Discussion for
Parts 1 and 2, using the course's CVPR template. The compiled draft is four pages,
including references. Fill only the remaining team names and responsibilities;
no team identity or contributions have been invented. Review the analysis and
AI assistance disclosure before submission under course policy.

## Run and reproduce

Select the project's `.venv/bin/python` notebook kernel. From the repository root:

```sh
.venv/bin/python - <<'PY'
import nbformat
from nbclient import NotebookClient
path = 'CS5785_Midterm_Starter.ipynb'
notebook = nbformat.read(path, as_version=4)
NotebookClient(notebook, timeout=1200, kernel_name='python3').execute()
nbformat.write(notebook, path)
PY
make report-pdf
```

The notebook can also run from the parent workspace directory. Learned feature
transformations use training only. Calibration refits the full pipeline within
three training folds. No validation outcomes enter fitting or calibration. Part 1
reasons, embeddings, and IDs never enter Part 2 predictive features.

LaTeX requires MacTeX, TeX Live, or MiKTeX. Windows users can compile without Make:

```powershell
cd writeup
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex
```

The notebook regenerates `part1_results.tex`, `part1_feature_results.tex`,
`part1_knn_results.tex`, `part2_metrics.tex`, and `part2_reason_errors.tex` from
measured outputs. If experiments change, revise the surrounding interpretation too.
The CVPR font sizes/margins are unchanged. The seven-column reason table uses
slightly narrower cell padding to fit one column.

## Outputs

- `part1-results/`: initial 70 configurations, four Funding-threshold controls,
  25 neighbor configurations, labels, candidate settings, and diagnostic data.
- `figures/`: training-only PCA plots and observed cluster/reason heatmaps, as PNG
  and PDF; source code is in the notebook. PCA's first two components show 24.2%
  of training variance and are not clustering inputs.
- `part1-results/knn-experiment/best_augmented_candidate_submission.csv`: hybrid
  submitted to Part 1, with recorded public score 0.87927. The root
  `part1_submission.csv` remains the older K-means output for comparison.
- `part2-results/`: all 81 per-phase model scores, selected settings, full
  validation predictions, label provenance, and 18 reason-group comparisons.
- `part2_submission.csv`: 1,500 success probabilities, not uploaded by the notebook.
- `PART2_WALKTHROUGH.md`: sequential explanation with understanding checks.

Part 2 uses the latest Part 1 hybrid's reason lookup, preserving true labels
where available and marking estimates. Use reasons only for outcome error
analysis. Missing reason matches are their own group, and empty groups have N/A
rates. Small predicted groups and temporal shift limit interpretation. Part 2
log loss improves from 0.9401 to 0.5738, but Phase III false-success errors increase;
the report presents that trade-off.

`cvpr.sty` is the existing official CVPR 2026 style from
https://github.com/cvpr-org/author-kit/tree/12909ae437f6dbc7435069cfdb4ca44c18e6a02f.
