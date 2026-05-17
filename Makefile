SHELL := /bin/sh

.PHONY: help check smoke status

help:
	@printf '%s\n' \
		'Targets:' \
		'  make check   Syntax-check install.sh' \
		'  make smoke   Run no-op installer smoke tests' \
		'  make status  Show git status'

check:
	@sh -n install.sh
	@if command -v shellcheck >/dev/null 2>&1; then shellcheck install.sh; fi
	@if command -v mandoc >/dev/null 2>&1; then mandoc -Tascii man/*.1 >/dev/null; fi
	@printf 'install.sh syntax ok\n'

smoke: check
	@./install.sh --help >/dev/null
	@./install.sh --list >/dev/null
	@./install.sh --dry-run --no-deps --no-update --wm --sst --build-root /tmp/doomsday-system-smoke --prefix /tmp/doomsday-system-prefix >/dev/null
	@./install.sh --dry-run --uninstall --wm --sst --build-root /tmp/doomsday-system-smoke --prefix /tmp/doomsday-system-prefix >/dev/null
	@printf 'installer smoke tests ok\n'

status:
	@git status --short
