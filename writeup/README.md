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
