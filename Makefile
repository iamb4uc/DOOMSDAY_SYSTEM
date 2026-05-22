SHELL := /bin/sh

.PHONY: help check smoke modules void void-glibc void-musl status

help:
	@printf '%s\n' \
		'Targets:' \
		'  make check   Syntax-check install.sh' \
		'  make smoke   Run no-op installer smoke tests' \
		'  make modules Run cross-repo module build checks' \
		'  make void    Test bootstrap checks in glibc and musl Void containers' \
		'  make void-glibc Test bootstrap checks in a glibc Void container' \
		'  make void-musl  Test bootstrap checks in a musl Void container' \
		'  make status  Show git status'

check:
	@sh -n install.sh
	@if command -v shellcheck >/dev/null 2>&1; then shellcheck install.sh; fi
	@if command -v mandoc >/dev/null 2>&1; then mandoc -Tascii man/*.1 >/dev/null; fi
	@printf 'install.sh syntax ok\n'

smoke: check
	@./install.sh --help >/dev/null
	@./install.sh --list >/dev/null
	@./install.sh --dry-run --no-deps --no-update --desktop --build-root /tmp/doomsday-system-smoke --prefix /tmp/doomsday-system-prefix >/dev/null
	@./install.sh --dry-run --uninstall --desktop --build-root /tmp/doomsday-system-smoke --prefix /tmp/doomsday-system-prefix >/dev/null
	@printf 'installer smoke tests ok\n'

modules:
	@./scripts/check-modules.sh

void: void-glibc void-musl

void-glibc:
	@./scripts/check-void-docker.sh

void-musl:
	@VOID_IMAGE=voidlinux/voidlinux-musl ./scripts/check-void-docker.sh

status:
	@git status --short
