### Repo overview

- Small data-analysis project with code and notebooks under the `data/` folder.
- Key files:
  - `data/main.py` — tiny CLI/runner.
  - `data/python_code.ipynb`, `data/assignment-01.ipynb` — working notebooks.
  - `data/datasets/` — CSV inputs: `cards_data.csv`, `transactions_data.csv`, `users_data.csv`.
  - `data/pyproject.toml` — declares dependencies (jupyterlab, pandas, matplotlib, seaborn) and `requires-python = ">=3.14"` (verify locally).
  - Virtual environment lives at `data/.venv/` (activate before running code).

### Main goals for an AI coding agent (concise)

- Prefer notebook-safe edits: preserve JSON cell structure and `metadata.language` fields.
- Make minimal, focused changes: update a single function or cell per PR when possible.
- Use examples from `data/` when suggesting fixes; reference exact file paths.

### Environment & developer workflows

- Activate local venv before running or editing: `source data/.venv/bin/activate`.
- Install the package/deps from `data/` if needed: `cd data && python -m pip install -e .` (or use pip to install listed deps).
- Run simple script: `python data/main.py` (with venv active).
- Run notebooks with jupyter in the `data/` folder: `cd data && jupyter lab`.

### Project-specific conventions and patterns

- Code and notebooks are colocated under `data/`. When referring to files, use relative paths from `data/` (e.g. `datasets/users_data.csv`).
- Notebooks include `metadata.language` for each cell. When editing programmatically, preserve `cell_type`, `metadata`, and `id` fields.
- There is no CI/tests directory in the repo; do not add sweeping changes that require test harnesses — prefer incremental PRs.

### Typical fixes and examples (from this repo)

- Notebook function scoping: in `data/python_code.ipynb` a cell contains `def max_profit(prices):` followed by top-level loop lines. Fix by indenting the loop into the function and correct iteration over mapping items (use `for k, v in prices.items():`).
  - Bad pattern observed: loop at top level breaking the function definition.
  - Suggested fix: ensure `def` block contains logic, return a value (e.g., best buy/sell pair), and avoid mutating global state.

- Data loading: prefer `pd.read_csv("datasets/transactions_data.csv")` relative to `data/`.

### Safety & style

- Keep notebook outputs minimal in PRs; clear outputs when appropriate or state why outputs were kept (e.g., visualization proof).
- Avoid changing Python version constraints in `pyproject.toml` without author confirmation — `>=3.14` is unusual; note it but do not modify.

### When to ask for human help

- Any change that mutates dataset files in `data/datasets/` or that updates `pyproject.toml` (dependency/metadata changes).
- Ambiguous fixes across multiple notebooks or when a change affects reproducibility (env, versions).

### PR & commit guidance for the agent

- Keep PR descriptions explicit and short: what changed, why, and a one-line test you ran locally.
- Use file paths in the PR description, e.g. "Fixed function `max_profit` in `data/python_code.ipynb` — adjusted indentation and iteration (`.items()`)".

If anything here is unclear or you want more examples (unit tests, CI steps, or preferred coding style), tell me what to expand. 
