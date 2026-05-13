#!/bin/sh
set -eu

PROGRAM=${0##*/}
DEFAULT_BUILD_ROOT="${XDG_CACHE_HOME:-$HOME/.cache}/doomsday-system"

BUILD_ROOT=${BUILD_ROOT:-$DEFAULT_BUILD_ROOT}
PREFIX=${PREFIX:-/usr/local}
DOTFILES_PREFIX=${DOTFILES_PREFIX:-$HOME}
REPO_BASE=${REPO_BASE:-https://github.com/iamb4uc}

ASSUME_YES=0
INSTALL_DEPS=1
UPDATE_REPOS=1
DRY_RUN=0
LIST_ONLY=0
UNINSTALL=0
VERIFY_AFTER=1
SELECT_DOTS=0
SELECT_WM=0
SELECT_SST=0
SELECT_SLSTATUS=0
SELECT_SLOCK=0
SELECT_ANY=0

SUDO=
[ "$(id -u)" -eq 0 ] || SUDO=${SUDO:-sudo}

can_write_prefix() {
	target=$1

	if [ ! -d "$target" ]; then
		target=$(dirname "$target")
	fi

	while [ ! -d "$target" ] && [ "$target" != "/" ]; do
		target=$(dirname "$target")
	done

	[ -d "$target" ] || return 1
	probe=$target/.doomsday-write-test.$$
	if ( : > "$probe" ) 2>/dev/null; then
		rm -f "$probe"
		return 0
	fi

	return 1
}

usage() {
	cat <<EOF
Usage: $PROGRAM [module] [options]

Clone, build, and install the DOOMSDAY desktop pieces without git submodules.
With no module selected, this defaults to --all.

Modules:
      --dots            Install dotfiles
      --wm              Install vdwm and dmenu
      --sst             Install StealthStreamTerminal
      --slstatus        Install slstatus
      --slock           Install slock
      --all             Install every module (default)

Options:
  -y, --yes              Non-interactive mode; answer yes to prompts
      --dry-run          Print planned actions without changing the system
      --list             List modules and exit
      --uninstall        Uninstall selected modules instead of installing
      --no-verify        Skip post-install command verification
      --no-deps          Skip dependency installation
      --no-update        Do not git pull existing clones
      --build-root DIR   Clone/build repos under DIR
      --prefix DIR       Install C projects under DIR (default: /usr/local)
      --dotfiles-prefix DIR
                         Install dotfile symlinks under DIR (default: \$HOME)
      --repo-base URL    Base GitHub/user URL (default: https://github.com/iamb4uc)
  -h, --help             Show this help

Environment:
  BUILD_ROOT, PREFIX, DOTFILES_PREFIX, REPO_BASE, SUDO

Examples:
  ./install.sh
  ./install.sh --yes
  ./install.sh --wm
  ./install.sh --dry-run --all
  ./install.sh --list
  ./install.sh --yes --dots --sst --no-deps
EOF
}

log() {
	printf '%s\n' "==> $*"
}

die() {
	printf '%s\n' "error: $*" >&2
	exit 1
}

need_cmd() {
	command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

confirm() {
	prompt=$1
	default=${2:-y}

	if [ "$ASSUME_YES" -eq 1 ] || [ "$DRY_RUN" -eq 1 ]; then
		return 0
	fi

	case "$default" in
		y|Y) suffix='[Y/n]' ;;
		n|N) suffix='[y/N]' ;;
		*) suffix='[y/n]' ;;
	esac

	printf '%s %s ' "$prompt" "$suffix"
	read -r answer
	answer=${answer:-$default}

	case "$answer" in
		y|Y|yes|YES) return 0 ;;
		*) return 1 ;;
	esac
}

run() {
	printf '+'
	for arg in "$@"; do
		printf ' %s' "$arg"
	done
	printf '\n'
	if [ "$DRY_RUN" -eq 1 ]; then
		return 0
	fi
	"$@"
}

as_root() {
	if [ "$(id -u)" -eq 0 ]; then
		run "$@"
	else
		need_cmd "$SUDO"
		run "$SUDO" "$@"
	fi
}

with_install_privileges() {
	if [ "$(id -u)" -eq 0 ] || can_write_prefix "$PREFIX"; then
		run "$@"
	else
		need_cmd "$SUDO"
		run "$SUDO" "$@"
	fi
}

detect_package_manager() {
	if command -v xbps-install >/dev/null 2>&1; then
		printf '%s\n' xbps
	elif command -v apt-get >/dev/null 2>&1; then
		printf '%s\n' apt
	elif command -v pacman >/dev/null 2>&1; then
		printf '%s\n' pacman
	elif command -v dnf >/dev/null 2>&1; then
		printf '%s\n' dnf
	else
		printf '%s\n' unknown
	fi
}

install_dependencies() {
	if [ "$DRY_RUN" -eq 1 ]; then
		log "Would install build dependencies with $(detect_package_manager)"
		return 0
	fi

	pm=$(detect_package_manager)

	case "$pm" in
		xbps)
			if [ "$ASSUME_YES" -eq 1 ]; then
				as_root xbps-install -Sy git base-devel pkg-config libX11-devel libXext-devel libXft-devel libXinerama-devel libXrandr-devel libXrender-devel fontconfig-devel freetype-devel pam-devel ncurses
			else
				as_root xbps-install -S git base-devel pkg-config libX11-devel libXext-devel libXft-devel libXinerama-devel libXrandr-devel libXrender-devel fontconfig-devel freetype-devel pam-devel ncurses
			fi
			;;
		apt)
			as_root apt-get update
			as_root apt-get install -y git build-essential pkg-config libx11-dev libxext-dev libxft-dev libxinerama-dev libxrandr-dev libxrender-dev libfontconfig1-dev libfreetype6-dev libpam0g-dev ncurses-bin
			;;
		pacman)
			if [ "$ASSUME_YES" -eq 1 ]; then
				as_root pacman -Syu --needed --noconfirm git base-devel pkgconf libx11 libxext libxft libxinerama libxrandr libxrender fontconfig freetype2 pam ncurses
			else
				as_root pacman -Syu --needed git base-devel pkgconf libx11 libxext libxft libxinerama libxrandr libxrender fontconfig freetype2 pam ncurses
			fi
			;;
		dnf)
			as_root dnf install -y git make gcc pkgconf-pkg-config libX11-devel libXext-devel libXft-devel libXinerama-devel libXrandr-devel libXrender-devel fontconfig-devel freetype-devel pam-devel ncurses
			;;
		*)
			die "unsupported package manager; install git, make, cc, pkg-config, X11/Xext/Xft/Xinerama/Xrandr/Xrender/fontconfig/freetype/PAM headers, and ncurses/tic manually, then rerun with --no-deps"
			;;
	esac
}

repo_url() {
	name=$1
	printf '%s/%s.git\n' "$REPO_BASE" "$name"
}

clone_or_update() {
	name=$1
	url=$(repo_url "$name")
	dest=$BUILD_ROOT/$name

	if [ "$DRY_RUN" -eq 1 ]; then
		if [ -e "$dest/.git" ]; then
			log "Would use existing $name checkout at $dest"
			if [ "$UPDATE_REPOS" -eq 1 ]; then
				run git -C "$dest" pull --ff-only
			fi
		else
			run git clone "$url" "$dest"
		fi
		return 0
	fi

	if [ -e "$dest/.git" ]; then
		log "Using existing $name checkout"
		if [ "$UPDATE_REPOS" -eq 1 ]; then
			run git -C "$dest" pull --ff-only
		fi
	elif [ -e "$dest" ]; then
		die "$dest exists but is not a git checkout"
	else
		run git clone "$url" "$dest"
	fi
}

install_make_project() {
	name=$1
	dir=$BUILD_ROOT/$name

	[ "$DRY_RUN" -eq 1 ] || [ -d "$dir" ] || die "$name was not cloned into $dir"

	log "Building and installing $name"
	run make -C "$dir" clean
	with_install_privileges mkdir -p "$PREFIX/share/terminfo"
	with_install_privileges env TERMINFO="$PREFIX/share/terminfo" make -C "$dir" PREFIX="$PREFIX" clean install
	run make -C "$dir" clean
}

uninstall_make_project() {
	name=$1
	dir=$BUILD_ROOT/$name

	[ "$DRY_RUN" -eq 1 ] || [ -d "$dir" ] || die "$name was not cloned into $dir"

	log "Uninstalling $name"
	with_install_privileges env TERMINFO="$PREFIX/share/terminfo" make -C "$dir" PREFIX="$PREFIX" uninstall
}

install_dotfiles() {
	dir=$BUILD_ROOT/dots

	[ "$DRY_RUN" -eq 1 ] || [ -d "$dir" ] || die "dots was not cloned into $dir"

	log "Installing dotfiles into $DOTFILES_PREFIX"
	run make -C "$dir" PREFIX="$DOTFILES_PREFIX" install
}

uninstall_dotfiles() {
	dir=$BUILD_ROOT/dots

	[ "$DRY_RUN" -eq 1 ] || [ -d "$dir" ] || die "dots was not cloned into $dir"

	log "Uninstalling dotfile symlinks from $DOTFILES_PREFIX"
	run make -C "$dir" PREFIX="$DOTFILES_PREFIX" uninstall
}

list_modules() {
	cat <<EOF
Available modules:
  --dots      dots
  --wm        vdwm, dmenu
  --sst       StealthStreamTerminal
  --slstatus  slstatus
  --slock     slock
  --all       all modules
EOF
}

selected_modules() {
	if [ "$SELECT_DOTS" -eq 1 ]; then
		printf '%s\n' dots
	fi
	if [ "$SELECT_WM" -eq 1 ]; then
		printf '%s\n' dmenu vdwm
	fi
	if [ "$SELECT_SST" -eq 1 ]; then
		printf '%s\n' StealthStreamTerminal
	fi
	if [ "$SELECT_SLSTATUS" -eq 1 ]; then
		printf '%s\n' slstatus
	fi
	if [ "$SELECT_SLOCK" -eq 1 ]; then
		printf '%s\n' slock
	fi
}

select_all() {
	SELECT_DOTS=1
	SELECT_WM=1
	SELECT_SST=1
	SELECT_SLSTATUS=1
	SELECT_SLOCK=1
	SELECT_ANY=1
}

select_module() {
	case "$1" in
		dots) SELECT_DOTS=1 ;;
		wm) SELECT_WM=1 ;;
		sst) SELECT_SST=1 ;;
		slstatus) SELECT_SLSTATUS=1 ;;
		slock) SELECT_SLOCK=1 ;;
		all) select_all; return ;;
	esac
	SELECT_ANY=1
}

clone_selected_repos() {
	if [ "$SELECT_WM" -eq 1 ]; then
		clone_or_update dmenu
		clone_or_update vdwm
	fi
	if [ "$SELECT_SST" -eq 1 ]; then
		clone_or_update StealthStreamTerminal
	fi
	if [ "$SELECT_SLSTATUS" -eq 1 ]; then
		clone_or_update slstatus
	fi
	if [ "$SELECT_SLOCK" -eq 1 ]; then
		clone_or_update slock
	fi
	if [ "$SELECT_DOTS" -eq 1 ]; then
		clone_or_update dots
	fi
}

install_selected_modules() {
	if [ "$SELECT_WM" -eq 1 ] && confirm "Build and install vdwm and dmenu to $PREFIX?" y; then
		install_make_project dmenu
		install_make_project vdwm
	fi
	if [ "$SELECT_SST" -eq 1 ] && confirm "Build and install StealthStreamTerminal to $PREFIX?" y; then
		install_make_project StealthStreamTerminal
	fi
	if [ "$SELECT_SLSTATUS" -eq 1 ] && confirm "Build and install slstatus to $PREFIX?" y; then
		install_make_project slstatus
	fi
	if [ "$SELECT_SLOCK" -eq 1 ] && confirm "Build and install slock to $PREFIX?" y; then
		install_make_project slock
	fi
	if [ "$SELECT_DOTS" -eq 1 ] && confirm "Install dotfile symlinks into $DOTFILES_PREFIX?" y; then
		install_dotfiles
	fi
}

uninstall_selected_modules() {
	if [ "$SELECT_WM" -eq 1 ] && confirm "Uninstall vdwm and dmenu from $PREFIX?" y; then
		uninstall_make_project dmenu
		uninstall_make_project vdwm
	fi
	if [ "$SELECT_SST" -eq 1 ] && confirm "Uninstall StealthStreamTerminal from $PREFIX?" y; then
		uninstall_make_project StealthStreamTerminal
	fi
	if [ "$SELECT_SLSTATUS" -eq 1 ] && confirm "Uninstall slstatus from $PREFIX?" y; then
		uninstall_make_project slstatus
	fi
	if [ "$SELECT_SLOCK" -eq 1 ] && confirm "Uninstall slock from $PREFIX?" y; then
		uninstall_make_project slock
	fi
	if [ "$SELECT_DOTS" -eq 1 ] && confirm "Uninstall dotfile symlinks from $DOTFILES_PREFIX?" y; then
		uninstall_dotfiles
	fi
}

verify_command() {
	cmd=$1
	if command -v "$cmd" >/dev/null 2>&1; then
		printf 'ok: %s\n' "$cmd"
	else
		printf 'missing: %s\n' "$cmd"
	fi
}

verify_selected_modules() {
	if [ "$DRY_RUN" -eq 1 ] || [ "$VERIFY_AFTER" -eq 0 ] || [ "$UNINSTALL" -eq 1 ]; then
		return 0
	fi

	log "Verifying installed commands"
	if [ "$SELECT_WM" -eq 1 ]; then
		verify_command dmenu
		verify_command vdwm
	fi
	if [ "$SELECT_SST" -eq 1 ]; then
		verify_command st
	fi
	if [ "$SELECT_SLSTATUS" -eq 1 ]; then
		verify_command slstatus
	fi
	if [ "$SELECT_SLOCK" -eq 1 ]; then
		verify_command slock
	fi
}

print_plan() {
	log "Mode: $([ "$UNINSTALL" -eq 1 ] && printf uninstall || printf install)"
	log "Selected modules:"
	selected_modules | sed 's/^/  - /'
	log "Build root: $BUILD_ROOT"
	log "Install prefix: $PREFIX"
	log "Dotfiles prefix: $DOTFILES_PREFIX"
}

parse_args() {
	while [ "$#" -gt 0 ]; do
		case "$1" in
			--dots)
				select_module dots
				;;
			--wm)
				select_module wm
				;;
			--sst)
				select_module sst
				;;
			--slstatus)
				select_module slstatus
				;;
			--slock)
				select_module slock
				;;
			--all)
				select_module all
				;;
			-y|--yes)
				ASSUME_YES=1
				;;
			--dry-run)
				DRY_RUN=1
				;;
			--list)
				LIST_ONLY=1
				;;
			--uninstall)
				UNINSTALL=1
				INSTALL_DEPS=0
				VERIFY_AFTER=0
				;;
			--no-verify)
				VERIFY_AFTER=0
				;;
			--no-deps)
				INSTALL_DEPS=0
				;;
			--no-update)
				UPDATE_REPOS=0
				;;
			--build-root)
				[ "$#" -ge 2 ] || die "--build-root needs a directory"
				BUILD_ROOT=$2
				shift
				;;
			--prefix)
				[ "$#" -ge 2 ] || die "--prefix needs a directory"
				PREFIX=$2
				shift
				;;
			--dotfiles-prefix)
				[ "$#" -ge 2 ] || die "--dotfiles-prefix needs a directory"
				DOTFILES_PREFIX=$2
				shift
				;;
			--repo-base)
				[ "$#" -ge 2 ] || die "--repo-base needs a URL"
				REPO_BASE=${2%/}
				shift
				;;
			-h|--help)
				usage
				exit 0
				;;
			*)
				die "unknown option: $1"
				;;
		esac
		shift
	done

	if [ "$SELECT_ANY" -eq 0 ]; then
		select_all
	fi
}

main() {
	parse_args "$@"

	if [ "$LIST_ONLY" -eq 1 ]; then
		list_modules
		exit 0
	fi

	if [ "$DRY_RUN" -eq 1 ]; then
		print_plan
	else
		log "Build root: $BUILD_ROOT"
		log "Install prefix: $PREFIX"
		log "Dotfiles prefix: $DOTFILES_PREFIX"
	fi

	if [ "$INSTALL_DEPS" -eq 1 ] && confirm "Install build dependencies with the system package manager?" y; then
		install_dependencies
	fi

	need_cmd git
	need_cmd make

	run mkdir -p "$BUILD_ROOT"

	clone_selected_repos
	if [ "$UNINSTALL" -eq 1 ]; then
		uninstall_selected_modules
	else
		install_selected_modules
		verify_selected_modules
	fi

	log "Done"
}

main "$@"
