# Installation Guide

## Install with pip

```bash
pip install .
pip install .[dev]  # Installe aussi les outils de dev
```

## Reproducible NixOS Build (wan22_build)

Use your shared dev shell from:

`/home/eelco/Workspace/NixOS/elixos#wan22_build`

Then run this from the repository root:

```bash
direnv allow
nix develop /home/eelco/Workspace/NixOS/elixos#wan22_build
wan22_sync
```

What this does:

- Creates and activates `.venv` if needed.
- Installs `torch`, `torchvision`, and `torchaudio` from the CUDA-matching PyTorch index.
- Installs all requirements except `flash_attn`.
- Installs the local package (`pip install -e .`).
- Verifies CUDA compatibility (`nvcc` version equals `torch.version.cuda`).

Optional `flash-attn` install:

```bash
INSTALL_FLASH_ATTN=1 wan22_sync
```

Quick compatibility check only:

```bash
wan22_check_cuda
```

## Install with Poetry

Ensure you have [Poetry](https://python-poetry.org/docs/#installation) installed on your system.

To install all dependencies:

```bash
poetry install
```

### Handling `flash-attn` Installation Issues

If `flash-attn` fails due to **PEP 517 build issues**, you can try one of the following fixes.

#### No-Build-Isolation Installation (Recommended)
```bash
poetry run pip install --upgrade pip setuptools wheel
poetry run pip install flash-attn --no-build-isolation
poetry install
```

#### Install from Git (Alternative)
```bash
poetry run pip install git+https://github.com/Dao-AILab/flash-attention.git
```

---

### Running the Model

Once the installation is complete, you can run **Wan2.2** using:

```bash
poetry run python generate.py --task t2v-A14B --size '1280*720' --ckpt_dir ./Wan2.2-T2V-A14B --prompt "Two anthropomorphic cats in comfy boxing gear and bright gloves fight intensely on a spotlighted stage."
```

#### Test
```bash
bash tests/test.sh
```

#### Format
```bash
black .
isort .
```
