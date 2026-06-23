#!/bin/sh
set -eu

REPO_BASE=${REPO_BASE:-https://github.com/iamb4uc}
REPO_BASE=${REPO_BASE%/}
BUILD_ROOT=${BUILD_ROOT:-/tmp/doomsday-system-modules}
PREFIX=${PREFIX:-/tmp/doomsday-system-prefix}
DOTFILES_PREFIX=${DOTFILES_PREFIX:-/tmp/doomsday-system-home}

make_modules='DoomWM DoomMenu DoomTerm DoomStatus DoomLock'
dot_module='DoomDots'

log() {
	printf '%s\n' "==> $*"
}

run() {
	printf '+'
	for arg in "$@"; do
		printf ' %s' "$arg"
	done
	printf '\n'
	"$@"
}

repo_url() {
	printf '%s/%s.git\n' "$REPO_BASE" "$1"
}

clone_or_update() {
	name=$1
	dest=$BUILD_ROOT/$name

	if [ -e "$dest/.git" ]; then
		run git -C "$dest" pull --ff-only
	elif [ -e "$dest" ]; then
		printf '%s\n' "error: $dest exists but is not a git checkout" >&2
		exit 1
	else
		run git clone "$(repo_url "$name")" "$dest"
	fi
}

check_bin() {
	bin=$1
	if [ ! -x "$PREFIX/bin/$bin" ]; then
		printf '%s\n' "error: missing executable $PREFIX/bin/$bin" >&2
		exit 1
	fi
	printf 'ok: %s\n' "$PREFIX/bin/$bin"
}

run mkdir -p "$BUILD_ROOT" "$PREFIX" "$DOTFILES_PREFIX"

for module in $make_modules "$dot_module"; do
	clone_or_update "$module"
done

for module in $make_modules; do
	log "Checking $module"
	run make -C "$BUILD_ROOT/$module" clean
	run env TERMINFO="$PREFIX/share/terminfo" make -C "$BUILD_ROOT/$module" PREFIX="$PREFIX" clean install
	run make -C "$BUILD_ROOT/$module" clean
done

check_bin doomwm
check_bin doommenu
check_bin doomterm
check_bin doomstatus
check_bin doomlock

if [ -f "$BUILD_ROOT/$dot_module/Makefile" ]; then
	log "Checking $dot_module"
	run make -C "$BUILD_ROOT/$dot_module" lint
fi

log "Module checks passed"
