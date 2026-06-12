set shell := ["bash", "-cu"]

default:
	just --list

venv:
	uv venv --python 3.12

torch-cu128:
	uv pip install --python .venv/bin/python --index-url https://download.pytorch.org/whl/cu128 torch torchvision torchaudio

deps:
	grep -v '^flash_attn$' requirements.txt | uv pip install --python .venv/bin/python -r /dev/stdin

s2v-deps:
	uv pip install --python .venv/bin/python -r requirements_s2v.txt

setup: venv torch-cu128 deps

setup-s2v: setup s2v-deps

verify-gpu:
	.venv/bin/python -c "import torch; print(torch.cuda.is_available(), torch.cuda.get_device_name(0) if torch.cuda.is_available() else None)"

verify-wan:
	.venv/bin/python -c "import wan; print('wan import: ok')"

verify-s2v:
	.venv/bin/python -c "from wan.speech2video import WanS2V; print('WanS2V import: ok')"

install-flash-attn:
	uv pip install --python .venv/bin/python flash-attn --no-build-isolation