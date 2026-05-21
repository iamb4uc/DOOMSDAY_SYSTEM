#!/bin/sh
set -eu

image=${VOID_IMAGE:-voidlinux/voidlinux}

docker run --rm \
	-v "$PWD:/repo" \
	-w /repo \
	"$image" \
	/bin/sh -lc '
		set -eu
		mkdir -p /etc/xbps.d
		printf "%s\n" repository=https://repo-default.voidlinux.org/current > /etc/xbps.d/00-repository-main.conf
		xbps-install -Syu xbps || true
		xbps-install -Syu
        xbps-install -Sy \
          base-devel \
          bash \
          git \
          make \
			pkg-config \
			shellcheck \
			mdocml \
			ncurses \
			libX11-devel \
			libxcb-devel \
			libXext-devel \
			libXft-devel \
			libXinerama-devel \
			libXrandr-devel \
			libXrender-devel \
			fontconfig-devel \
			freetype-devel \
			pam-devel
		make check
		make smoke
		BUILD_ROOT=/tmp/doomsday-system-modules \
			PREFIX=/tmp/doomsday-system-prefix \
			DOTFILES_PREFIX=/tmp/doomsday-system-home \
			make modules
	'
