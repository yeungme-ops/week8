#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

# Reuse a working environment; recreate it if the base Python has changed.
python_identity='import sys; print(sys.version); print(sys.base_prefix); print(sys.platform)'
expected_python="$(python3 -c "$python_identity")"
existing_python="$(.venv/bin/python -c "$python_identity" 2>/dev/null || true)"
if [[ "$existing_python" != "$expected_python" ]]; then
  echo "Creating the class virtual environment..."
  python3 -m venv --clear .venv
fi

# A normal restart only reads local files; it does not contact package indexes.
requirements_hash="$(python3 - <<'PY'
import hashlib
from pathlib import Path

digest = hashlib.sha256()
digest.update(Path('requirements.txt').read_bytes())
digest.update(Path('.devcontainer/setup.sh').read_bytes())
print(digest.hexdigest())
PY
)"
stamp_file=".venv/.requirements.sha256"
installed_hash="$(cat "$stamp_file" 2>/dev/null || true)"

if [[ "$installed_hash" != "$requirements_hash" ]]; then
  echo "Installing the class packages..."
  rm -f "$stamp_file"
  .venv/bin/python -m pip install --disable-pip-version-check --upgrade pip

  if [[ "$(uname -s)" == "Linux" ]]; then
    # Use CPU wheels in Codespaces. Keep the version in requirements.txt only.
    torch_requirement="$(python3 - <<'PY'
from pathlib import Path

pins = [line.strip() for line in Path('requirements.txt').read_text().splitlines()
        if line.startswith('torch==')]
if len(pins) != 1:
    raise SystemExit('requirements.txt must contain exactly one torch==VERSION pin')
print(pins[0])
PY
)"
    .venv/bin/python -m pip install --disable-pip-version-check \
      "${torch_requirement}+cpu" --index-url https://download.pytorch.org/whl/cpu
  fi

  # The installed +cpu build satisfies the portable torch==VERSION requirement.
  # On macOS, this command installs the native PyTorch wheel from PyPI instead.
  .venv/bin/python -m pip install --disable-pip-version-check -r requirements.txt
  .venv/bin/python -m pip check

  if [[ "$(uname -s)" == "Linux" ]]; then
    .venv/bin/python - <<'PY'
import torch

if torch.version.cuda is not None:
    raise SystemExit('Expected a CPU-only PyTorch installation in Codespaces')
PY
  fi

  # Record success only after installation and dependency checks have passed.
  printf '%s\n' "$requirements_hash" > "$stamp_file"
fi

echo "Ready: select .venv as your notebook kernel."
