.PHONY: setup_env lint lint_fix test clean install build

VENV_DIR := ./.venv
PYTHON := $(VENV_DIR)/bin/python
UV := uv
PROJECT := waveform_assert

# Default target
all: setup_env lint_fix lint test

setup_env:
	$(UV) venv --clear;
	$(UV) sync --project $(PROJECT)

lint_fix:
	$(PYTHON) -m black $(PROJECT)

lint:
	$(PYTHON) -m black $(PROJECT) --check
	$(PYTHON) -m flake8 $(PROJECT) --count --select=E9,F63,F7,F82 --show-source --statistics
	$(PYTHON) -m flake8 $(PROJECT) --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

test:
	$(PYTHON) -m pytest --cov=$(PROJECT) --cov-report=xml:coverage.xml --junitxml=pytest-report.xml

install: 
	$(UV) pip install .

build: 
	$(UV) build --package $(PROJECT)

clean:
	@rm -rf $(VENV_DIR) .pytest_cache .coverage coverage.xml pytest-report.xml $(PROJECT).egg-info uv.lock build dist