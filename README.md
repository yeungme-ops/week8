# AISCI210-Unit3-GradientDescent

Materials for Unit 3 of UC Irvine AI SCI 210: **Gradient Descent**.

## Start in GitHub Codespaces

1. Click **Use this template** to create your own private repository.
2. In your repository, choose **Code → Codespaces → Create codespace on main**.
3. Wait for setup to finish, then open `GradientDescent.ipynb`.
4. Select **.venv** as the notebook's Python kernel.

`GradientDescent.ipynb` is a starter notebook with imports for NumPy, pandas, Matplotlib, scikit-learn, and PyTorch. Add the class notes and exercises there.

## Environment

The devcontainer uses **Python 3.14** on Debian Bookworm. `requirements.txt` pins the direct dependencies as of November 16, 2026:

- JupyterLab and ipykernel for notebooks.
- NumPy and pandas for numerical computing and tabular data.
- scikit-learn for sample datasets and reference models.
- Matplotlib for plots.
- PyTorch for later automatic differentiation and neural-network examples.

Linux setup installs the **CPU-only PyTorch build** from the official PyTorch package index before installing the other requirements from PyPI. These classroom examples run on the CPU. On macOS, setup installs the native PyTorch wheel from PyPI.

The environment is checked each time the Codespace starts. Packages are installed on the first start and when the requirements or setup script change. Ordinary restarts reuse the existing environment without contacting package indexes. Setup recreates the virtual environment if the base Python changes.

## Local development

With Python 3.14 installed, run:

```bash
bash .devcontainer/setup.sh
```

Then select `.venv` as your notebook kernel in VS Code, or launch JupyterLab:

```bash
.venv/bin/python -m jupyterlab
```

Keep notebooks under version control. `.gitignore` excludes virtual environments, notebook checkpoints, caches, and local credentials.
