# Requires a current uv installation: https://docs.astral.sh/uv/getting-started/installation/
# Run `make setup`, then select .venv/bin/python as your notebook kernel.
# Override if needed: make setup PYTHON_VERSION=3.13
PYTHON_VERSION ?= 3.14
VENV ?= .venv
UV ?= uv
export UV_CACHE_DIR ?= .uv-cache

.DEFAULT_GOAL := setup
.PHONY: setup venv install lab

setup: install

venv:
	@command -v $(UV) >/dev/null 2>&1 || { echo "Install uv first: https://docs.astral.sh/uv/getting-started/installation/"; exit 1; }
	$(UV) python install $(PYTHON_VERSION)
	$(UV) venv --python $(PYTHON_VERSION) "$(VENV)"

install: venv
	$(UV) pip install --python "$(VENV)/bin/python" -r requirements.txt
	@echo "Ready. Select $(VENV)/bin/python in your editor, or run make lab."

lab: setup
	"$(VENV)/bin/jupyter" lab CS5785_Midterm_Starter.ipynb

LATEX ?= pdflatex

.PHONY: report-pdf
report-pdf:
	cd writeup && $(LATEX) -interaction=nonstopmode -halt-on-error main.tex
	cd writeup && $(LATEX) -interaction=nonstopmode -halt-on-error main.tex
