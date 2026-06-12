# Copyright 2024-2025 The Alibaba Wan Team Authors. All rights reserved.
from . import configs, distributed, modules
from .image2video import WanI2V
from .text2video import WanT2V
from .textimage2video import WanTI2V


def _missing_optional_class(name, requirement_hint, import_error):
	class _MissingOptionalDependency:
		def __init__(self, *args, **kwargs):
			raise ModuleNotFoundError(
				f"{name} requires optional dependencies. Install {requirement_hint}."
			) from import_error

	_MissingOptionalDependency.__name__ = name
	return _MissingOptionalDependency


try:
	from .speech2video import WanS2V
except ModuleNotFoundError as exc:
	WanS2V = _missing_optional_class("WanS2V", "requirements_s2v.txt", exc)

try:
	from .animate import WanAnimate
except ModuleNotFoundError as exc:
	WanAnimate = _missing_optional_class("WanAnimate", "requirements_animate.txt", exc)