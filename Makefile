SHELL := /bin/sh

.PHONY: help check smoke status

help:
	@printf '%s\n' \
		'Targets:' \
		'  make check   Syntax-check install.sh' \
		'  make smoke   Run a no-op installer smoke test' \
		'  make status  Show git status'

check:
	@sh -n install.sh
	@printf 'install.sh syntax ok\n'

smoke: check
	@./install.sh --yes --no-deps --no-update --build-root /tmp/doomsday-system-smoke --repo-base file:///tmp/nonexistent --help >/dev/null
	@printf 'installer help smoke ok\n'

status:
	@git status --short

