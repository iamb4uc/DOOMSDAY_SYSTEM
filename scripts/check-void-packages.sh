#!/bin/sh
set -eu

PACKAGES_DIR=${PACKAGES_DIR:-packages/void}

[ -d "$PACKAGES_DIR" ] || {
	printf '%s\n' "missing package manifest directory: $PACKAGES_DIR" >&2
	exit 1
}

status=0
packages=$(sed 's/#.*//;/^[[:space:]]*$/d' "$PACKAGES_DIR"/* | sort -u)

for pkg in $packages; do
	if xbps-query -R "$pkg" >/dev/null 2>&1; then
		printf 'ok: %s\n' "$pkg"
	else
		printf 'missing: %s\n' "$pkg" >&2
		status=1
	fi
done

exit "$status"
