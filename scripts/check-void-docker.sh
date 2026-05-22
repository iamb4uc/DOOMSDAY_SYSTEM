#!/bin/sh
set -eu

image=${VOID_IMAGE:-voidlinux/voidlinux}

docker run --rm \
	-v "$PWD:/repo" \
	-w /repo \
	"$image" \
	/bin/sh -lc '
		set -eu
		arch=$(xbps-uhelper arch)
		case "$arch" in
			*-musl) repo=https://repo-default.voidlinux.org/current/musl ;;
			*) repo=https://repo-default.voidlinux.org/current ;;
		esac

		mkdir -p /etc/xbps.d
		printf "%s\n" "repository=$repo" > /etc/xbps.d/00-repository-main.conf
		xbps-install -Syu xbps || true
		xbps-install -Syu
		build_packages=$(sed "s/#.*//;/^[[:space:]]*$/d" packages/void/00-build)
		# shellcheck disable=SC2086
		xbps-install -Sy $build_packages
		./scripts/check-void-packages.sh
		make check
		make smoke
		BUILD_ROOT=/tmp/doomsday-system-modules \
			PREFIX=/tmp/doomsday-system-prefix \
			DOTFILES_PREFIX=/tmp/doomsday-system-home \
			make modules
	'
