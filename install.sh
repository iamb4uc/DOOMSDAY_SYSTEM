#!/bin/sh
set -eu

PROGRAM=${0##*/}
DEFAULT_BUILD_ROOT="${XDG_CACHE_HOME:-$HOME/.cache}/doomsday-system"
DEFAULT_PACKAGES_DIR=packages/void
DEFAULT_ETC_ROOT=etc

BUILD_ROOT=${BUILD_ROOT:-$DEFAULT_BUILD_ROOT}
PREFIX=${PREFIX:-/usr/local}
DOTFILES_PREFIX=${DOTFILES_PREFIX:-$HOME}
REPO_BASE=${REPO_BASE:-https://github.com/iamb4uc}
PACKAGES_DIR=${PACKAGES_DIR:-$DEFAULT_PACKAGES_DIR}
ETC_ROOT=${ETC_ROOT:-$DEFAULT_ETC_ROOT}

ASSUME_YES=0
INSTALL_DEPS=1
INSTALL_ETC=1
UPDATE_REPOS=1
DRY_RUN=0
LIST_ONLY=0
UNINSTALL=0
VERIFY_AFTER=1
SELECT_SYSTEM=0
SELECT_DOTS=0
SELECT_WM=0
SELECT_MENU=0
SELECT_TERM=0
SELECT_STATUS=0
SELECT_LOCK=0
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

Post-install a Void Linux system and the DOOMSDAY desktop pieces.
With no module selected, this defaults to --all.

Modules:
      --system          Install Void packages and tracked /etc files
      --dots            Install DoomDots
      --desktop         Install the interactive desktop modules
      --wm              Install DoomWM
      --menu            Install DoomMenu
      --term            Install DoomTerm
      --status          Install DoomStatus
      --lock            Install DoomLock
      --all             Install every module (default)

Legacy module aliases:
      --sst             Alias for --term
      --slstatus        Alias for --status
      --slock           Alias for --lock

Options:
  -y, --yes              Non-interactive mode; answer yes to prompts
      --dry-run          Print planned actions without changing the system
      --list             List modules and exit
      --uninstall        Uninstall selected modules instead of installing
      --no-verify        Skip post-install command verification
      --no-deps          Skip dependency installation
      --no-etc           Skip tracked /etc file installation
      --no-update        Do not git pull existing clones
      --build-root DIR   Clone/build repos under DIR
      --packages-dir DIR Read Void package manifests from DIR
      --etc-root DIR     Read tracked /etc files from DIR
      --prefix DIR       Install C projects under DIR (default: /usr/local)
      --dotfiles-prefix DIR
                         Install dotfile symlinks under DIR (default: \$HOME)
      --repo-base URL    Base GitHub/user URL (default: https://github.com/iamb4uc)
  -h, --help             Show this help

Environment:
  BUILD_ROOT, PACKAGES_DIR, ETC_ROOT, PREFIX, DOTFILES_PREFIX, REPO_BASE, SUDO

Examples:
  ./install.sh
  ./install.sh --yes
  ./install.sh --desktop
  ./install.sh --dry-run --all
  ./install.sh --list
  ./install.sh --yes --dots --term --no-deps --no-etc
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

is_void_linux() {
	[ -r /etc/os-release ] && grep -Eq '^(ID=void|DISTRIB_ID="?void"?)' /etc/os-release
}

require_void_linux() {
	if [ "$DRY_RUN" -eq 1 ]; then
		return 0
	fi

	is_void_linux || die "this installer is Void Linux exclusive"
	need_cmd xbps-install
}

package_list() {
	if [ -d "$PACKAGES_DIR" ]; then
		find "$PACKAGES_DIR" -type f | sort | while IFS= read -r file; do
			sed 's/#.*//;/^[[:space:]]*$/d' "$file"
		done
	elif [ "$PACKAGES_DIR" = "$DEFAULT_PACKAGES_DIR" ]; then
		default_package_list
	else
		die "missing package manifest directory: $PACKAGES_DIR"
	fi
}

default_package_list() {
	cat <<'EOF'
base-devel
bash
git
make
pkg-config
shellcheck
mdocml
ncurses
libX11-devel
libxcb-devel
libXext-devel
libXft-devel
libXinerama-devel
libXrandr-devel
libXrender-devel
fontconfig-devel
freetype-devel
pam-devel
xorg-minimal
xinit
dbus
elogind
NetworkManager
pulseaudio
xrandr
xset
setxkbmap
xbacklight
xwallpaper
picom
dunst
redshift
libnotify
firefox
thunderbird
keepassxc
ghostty
qutebrowser
zathura
zathura-pdf-mupdf
zathura-djvu
zathura-ps
htop
pulsemixer
ncmpcpp
mpd
mpc
pamixer
lf
neovim
tmux
fzf
ripgrep
jq
bat
starship
mpv
nsxiv
ImageMagick
ffmpeg
mediainfo
simple-mtpfs
cryptsetup
xclip
ncdu
ueberzug
syncthing
glow
alacritty
noto-fonts-ttf
nerd-fonts
EOF
}

install_dependencies() {
	if [ "$DRY_RUN" -eq 1 ]; then
		log "Would install Void packages from $PACKAGES_DIR"
		package_list | sed 's/^/  - /'
		return 0
	fi

	require_void_linux

	packages=$(package_list)
	[ -n "$packages" ] || die "no packages found in $PACKAGES_DIR"

	if [ "$ASSUME_YES" -eq 1 ]; then
		# shellcheck disable=SC2086
		as_root xbps-install -Sy $packages
	else
		# shellcheck disable=SC2086
		as_root xbps-install -S $packages
	fi
}

install_etc_overlay() {
	[ "$INSTALL_ETC" -eq 1 ] || return 0
	[ "$UNINSTALL" -eq 0 ] || return 0

	if [ -d "$ETC_ROOT" ]; then
		log "Installing tracked /etc files from $ETC_ROOT"
		find "$ETC_ROOT" -type f | sort | while IFS= read -r src; do
			rel=${src#"$ETC_ROOT"/}
			dest=/etc/$rel
			if [ "$DRY_RUN" -eq 1 ]; then
				run install -Dm644 "$src" "$dest"
			else
				as_root install -Dm644 "$src" "$dest"
			fi
		done
	elif [ "$ETC_ROOT" = "$DEFAULT_ETC_ROOT" ]; then
		install_builtin_etc_overlay
	fi
}

install_builtin_etc_overlay() {
	log "Installing built-in /etc files"
	install_builtin_etc_file doomsday-release /etc/doomsday-release
	install_builtin_etc_file issue /etc/issue
}

install_builtin_etc_file() {
	name=$1
	dest=$2

	if [ "$DRY_RUN" -eq 1 ]; then
		run install -Dm644 "<built-in:$name>" "$dest"
		return 0
	fi

	tmp=${TMPDIR:-/tmp}/doomsday-system.$name.$$
	write_builtin_etc_file "$name" > "$tmp"
	as_root install -Dm644 "$tmp" "$dest"
	rm -f "$tmp"
}

write_builtin_etc_file() {
	case "$1" in
		doomsday-release)
			cat <<'EOF'
NAME="DOOMSDAY_SYSTEM"
ID="doomsday-system"
BASE_ID="void"
PRETTY_NAME="DOOMSDAY_SYSTEM on Void Linux"
EOF
			;;
		issue)
			cat <<'EOF'

\e[0;32m
▒▒▒▒▒▒▒▒▒▒▒▒ ░▀█▀░█▀█░█▄█░█▀▄░█░█░█░█░█▀▀░▀░█▀▀
▒▒▒▒█▒▒█▒▒▒▒ ░░█░░█▀█░█░█░█▀▄░░▀█░█░█░█░░░░░▀▀█
▒▒▒▒█▒▒█▒▒▒▒ ░▀▀▀░▀░▀░▀░▀░▀▀░░░░▀░▀▀▀░▀▀▀░░░▀▀▀
▒▒▒▒▒▒▒▒▒▒▒▒ ░█▀▄░█▀█░█▀█░█▄█░█▀▀░█▀▄░█▀█░█░█
▒█▒▒▒▒▒▒▒▒█▒ ░█░█░█░█░█░█░█░█░▀▀█░█░█░█▀█░░█░
▒▒████████▒▒ ░▀▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀░░▀░▀░░▀░
▒▒▒▒▒▒▒▒▒▒▒▒ ░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█
THIS ISN'T A ░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█
A DRILL!!!!! ░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀
\e[0m

A HACKABLE LINUX ENVIRONMENT BASED ON \e[1;36mVOID LINUX\e[0m
EOF
			;;
		*) die "unknown built-in /etc file: $1" ;;
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
	dir=$BUILD_ROOT/DoomDots

	[ "$DRY_RUN" -eq 1 ] || [ -d "$dir" ] || die "DoomDots was not cloned into $dir"

	log "Installing dotfiles into $DOTFILES_PREFIX"
	run make -C "$dir" PREFIX="$DOTFILES_PREFIX" install
}

uninstall_dotfiles() {
	dir=$BUILD_ROOT/DoomDots

	[ "$DRY_RUN" -eq 1 ] || [ -d "$dir" ] || die "DoomDots was not cloned into $dir"

	log "Uninstalling dotfile symlinks from $DOTFILES_PREFIX"
	run make -C "$dir" PREFIX="$DOTFILES_PREFIX" uninstall
}

list_modules() {
	cat <<EOF
Available modules:
  --system    Void packages and tracked /etc files
  --dots      DoomDots
  --desktop   DoomWM, DoomMenu, DoomTerm, DoomStatus, DoomLock
  --wm        DoomWM
  --menu      DoomMenu
  --term      DoomTerm
  --status    DoomStatus
  --lock      DoomLock
  --all       all modules
EOF
}

selected_modules() {
	if [ "$SELECT_SYSTEM" -eq 1 ]; then
		printf '%s\n' VoidSystem
	fi
	if [ "$SELECT_DOTS" -eq 1 ]; then
		printf '%s\n' DoomDots
	fi
	if [ "$SELECT_WM" -eq 1 ]; then
		printf '%s\n' DoomWM
	fi
	if [ "$SELECT_MENU" -eq 1 ]; then
		printf '%s\n' DoomMenu
	fi
	if [ "$SELECT_TERM" -eq 1 ]; then
		printf '%s\n' DoomTerm
	fi
	if [ "$SELECT_STATUS" -eq 1 ]; then
		printf '%s\n' DoomStatus
	fi
	if [ "$SELECT_LOCK" -eq 1 ]; then
		printf '%s\n' DoomLock
	fi
}

select_desktop() {
	SELECT_WM=1
	SELECT_MENU=1
	SELECT_TERM=1
	SELECT_STATUS=1
	SELECT_LOCK=1
}

select_all() {
	SELECT_SYSTEM=1
	SELECT_DOTS=1
	select_desktop
	SELECT_ANY=1
}

select_module() {
	case "$1" in
		system) SELECT_SYSTEM=1 ;;
		dots) SELECT_DOTS=1 ;;
		desktop) select_desktop ;;
		wm) SELECT_WM=1 ;;
		menu) SELECT_MENU=1 ;;
		term) SELECT_TERM=1 ;;
		status) SELECT_STATUS=1 ;;
		lock) SELECT_LOCK=1 ;;
		all) select_all; return ;;
	esac
	SELECT_ANY=1
}

clone_selected_repos() {
	if [ "$SELECT_WM" -eq 1 ]; then
		clone_or_update DoomWM
	fi
	if [ "$SELECT_MENU" -eq 1 ]; then
		clone_or_update DoomMenu
	fi
	if [ "$SELECT_TERM" -eq 1 ]; then
		clone_or_update DoomTerm
	fi
	if [ "$SELECT_STATUS" -eq 1 ]; then
		clone_or_update DoomStatus
	fi
	if [ "$SELECT_LOCK" -eq 1 ]; then
		clone_or_update DoomLock
	fi
	if [ "$SELECT_DOTS" -eq 1 ]; then
		clone_or_update DoomDots
	fi
}

install_selected_modules() {
	if [ "$SELECT_WM" -eq 1 ] && confirm "Build and install DoomWM to $PREFIX?" y; then
		install_make_project DoomWM
	fi
	if [ "$SELECT_MENU" -eq 1 ] && confirm "Build and install DoomMenu to $PREFIX?" y; then
		install_make_project DoomMenu
	fi
	if [ "$SELECT_TERM" -eq 1 ] && confirm "Build and install DoomTerm to $PREFIX?" y; then
		install_make_project DoomTerm
	fi
	if [ "$SELECT_STATUS" -eq 1 ] && confirm "Build and install DoomStatus to $PREFIX?" y; then
		install_make_project DoomStatus
	fi
	if [ "$SELECT_LOCK" -eq 1 ] && confirm "Build and install DoomLock to $PREFIX?" y; then
		install_make_project DoomLock
	fi
	if [ "$SELECT_DOTS" -eq 1 ] && confirm "Install dotfile symlinks into $DOTFILES_PREFIX?" y; then
		install_dotfiles
	fi
}

uninstall_selected_modules() {
	if [ "$SELECT_WM" -eq 1 ] && confirm "Uninstall DoomWM from $PREFIX?" y; then
		uninstall_make_project DoomWM
	fi
	if [ "$SELECT_MENU" -eq 1 ] && confirm "Uninstall DoomMenu from $PREFIX?" y; then
		uninstall_make_project DoomMenu
	fi
	if [ "$SELECT_TERM" -eq 1 ] && confirm "Uninstall DoomTerm from $PREFIX?" y; then
		uninstall_make_project DoomTerm
	fi
	if [ "$SELECT_STATUS" -eq 1 ] && confirm "Uninstall DoomStatus from $PREFIX?" y; then
		uninstall_make_project DoomStatus
	fi
	if [ "$SELECT_LOCK" -eq 1 ] && confirm "Uninstall DoomLock from $PREFIX?" y; then
		uninstall_make_project DoomLock
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
		verify_command doomwm
	fi
	if [ "$SELECT_MENU" -eq 1 ]; then
		verify_command doommenu
	fi
	if [ "$SELECT_TERM" -eq 1 ]; then
		verify_command doomterm
	fi
	if [ "$SELECT_STATUS" -eq 1 ]; then
		verify_command doomstatus
	fi
	if [ "$SELECT_LOCK" -eq 1 ]; then
		verify_command doomlock
	fi
}

print_plan() {
	log "Mode: $([ "$UNINSTALL" -eq 1 ] && printf uninstall || printf install)"
	log "Selected modules:"
	selected_modules | sed 's/^/  - /'
	log "Build root: $BUILD_ROOT"
	log "Package manifests: $PACKAGES_DIR"
	log "Etc overlay: $ETC_ROOT"
	log "Install prefix: $PREFIX"
	log "Dotfiles prefix: $DOTFILES_PREFIX"
}

parse_args() {
	while [ "$#" -gt 0 ]; do
		case "$1" in
			--system)
				select_module system
				;;
			--dots)
				select_module dots
				;;
			--desktop)
				select_module desktop
				;;
			--wm)
				select_module wm
				;;
			--menu)
				select_module menu
				;;
			--term|--sst)
				select_module term
				;;
			--status|--slstatus)
				select_module status
				;;
			--lock|--slock)
				select_module lock
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
			--no-etc)
				INSTALL_ETC=0
				;;
			--no-update)
				UPDATE_REPOS=0
				;;
			--build-root)
				[ "$#" -ge 2 ] || die "--build-root needs a directory"
				BUILD_ROOT=$2
				shift
				;;
			--packages-dir)
				[ "$#" -ge 2 ] || die "--packages-dir needs a directory"
				PACKAGES_DIR=$2
				shift
				;;
			--etc-root)
				[ "$#" -ge 2 ] || die "--etc-root needs a directory"
				ETC_ROOT=$2
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
	require_void_linux

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

	if [ "$INSTALL_DEPS" -eq 1 ] && confirm "Install Void packages from $PACKAGES_DIR?" y; then
		install_dependencies
	fi

	if [ "$SELECT_SYSTEM" -eq 1 ] && confirm "Install tracked /etc files from $ETC_ROOT?" y; then
		install_etc_overlay
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
