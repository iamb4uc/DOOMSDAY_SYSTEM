# DOOMSDAY_SYSTEM

```
████▄  ▄████▄ ▄████▄ ██▄  ▄██ ▄█████ ████▄  ▄████▄ ██  ██
██  ██ ██  ██ ██  ██ ██ ▀▀ ██ ▀▀▀▄▄▄ ██  ██ ██▄▄██  ▀██▀ 
████▀  ▀████▀ ▀████▀ ██    ██ █████▀ ████▀  ██  ██   ██  

▄█████ ██  ██ ▄█████ ██████ ██████ ██▄  ▄██
▀▀▀▄▄▄  ▀██▀  ▀▀▀▄▄▄   ██   ██▄▄   ██ ▀▀ ██
█████▀   ██   █████▀   ██   ██▄▄▄▄ ██    ██
```

[![check](https://github.com/iamb4uc/DOOMSDAY_SYSTEM/actions/workflows/check.yml/badge.svg)](https://github.com/iamb4uc/DOOMSDAY_SYSTEM/actions/workflows/check.yml)
![POSIX sh](https://img.shields.io/badge/shell-POSIX%20sh-222222)
![Void Linux](https://img.shields.io/badge/platform-Void%20Linux-478061)
![X11](https://img.shields.io/badge/session-X11-444444)

A one-command Void Linux bootstrapper for a fresh post-install system.

This repository is intentionally a meta-repo. It does not vendor the individual
projects or require git submodules. The installer clones each selected module
from GitHub, installs only the Void packages needed by those modules, builds the
suckless tools, and installs the dotfiles through their own installer. It also
applies the tracked `/etc` overlay so a fresh Void base install can be brought
back to the same DOOMSDAY baseline with less manual setup.

## Modules

| Flag | Module name | Installs | Source |
| --- | --- | --- | --- |
| `--system` | Void system | Package manifests and tracked `/etc` files | This repo |
| `--dots` | DoomDots | Shell, X11, editor, media, browser, and helper-script dotfiles | [`iamb4uc/DoomDots`](https://github.com/iamb4uc/DoomDots) |
| `--desktop` | Desktop bundle | DoomWM, DoomMenu, DoomTerm, DoomStatus, and DoomLock | All desktop module sources |
| `--wm` | DoomWM | `doomwm` window manager | [`iamb4uc/DoomWM`](https://github.com/iamb4uc/DoomWM) |
| `--menu` | DoomMenu | `doommenu`, `doommenu_run`, `doommenu_path`, and `stest` | [`iamb4uc/DoomMenu`](https://github.com/iamb4uc/DoomMenu) |
| `--term` | DoomTerm | `doomterm` terminal build | [`iamb4uc/DoomTerm`](https://github.com/iamb4uc/DoomTerm) |
| `--status` | DoomStatus | `doomstatus` bar status monitor | [`iamb4uc/DoomStatus`](https://github.com/iamb4uc/DoomStatus) |
| `--lock` | DoomLock | `doomlock` screen locker | [`iamb4uc/DoomLock`](https://github.com/iamb4uc/DoomLock) |
| `--all` | All modules | Every module above | All sources above |

With no module flag, `install.sh` defaults to `--all`.

## Quick Start

Straight install:

```sh
curl -fsSL https://raw.githubusercontent.com/iamb4uc/DOOMSDAY_SYSTEM/main/install.sh | sh
```

For unattended installs:

```sh
curl -fsSL https://raw.githubusercontent.com/iamb4uc/DOOMSDAY_SYSTEM/main/install.sh | sh -s -- --yes --all
```

Install only selected modules:

```sh
curl -fsSL https://raw.githubusercontent.com/iamb4uc/DOOMSDAY_SYSTEM/main/install.sh | sh -s -- --desktop
curl -fsSL https://raw.githubusercontent.com/iamb4uc/DOOMSDAY_SYSTEM/main/install.sh | sh -s -- --dots --term
```

Local checkout:

```sh
git clone https://github.com/iamb4uc/DOOMSDAY_SYSTEM.git
cd DOOMSDAY_SYSTEM
./install.sh
```

## Installer Options

```text
--system               install Void packages and tracked /etc files
--dots                 install dotfiles
--desktop              install the interactive desktop modules
--wm                   install DoomWM
--menu                 install DoomMenu
--term                 install DoomTerm
--status               install DoomStatus
--lock                 install DoomLock
--all                  install everything, also the default
-y, --yes              run non-interactively
--dry-run              print planned actions without changing the system
--list                 list modules and exit
--uninstall            uninstall selected modules
--no-verify            skip post-install command verification
--no-deps              skip package-manager dependency installation
--no-etc               skip tracked /etc file installation
--no-update            do not git pull existing module checkouts
--build-root DIR       clone/build modules under DIR
--packages-dir DIR     read Void package manifests from DIR
--etc-root DIR         read tracked /etc files from DIR
--prefix DIR           install C projects under DIR, default /usr/local
--dotfiles-prefix DIR  install dotfile symlinks under DIR, default $HOME
--repo-base URL        use a different GitHub/user base URL
```

Legacy aliases `--sst`, `--slstatus`, and `--slock` still work, but the
preferred family flags are `--term`, `--status`, and `--lock`.

## Manual Pages

This meta-repo ships manual pages for the installer and each named module:

```text
doomsday-system(1)
doomdots(1)
doomwm(1)
doommenu(1)
doomterm(1)
doomstatus(1)
doomlock(1)
```

The module repositories may also install command manual pages such as
`doomwm(1)`, `doommenu(1)`, `doomterm(1)`, `doomstatus(1)`, and `doomlock(1)`.

## CI Checks

Pull requests use a Void Linux container only as a test harness. The end goal of
the repo is still the real-machine bootstrap flow above.

- shell syntax checks for the installer
- `shellcheck`, when available
- manual page rendering with `mandoc`
- installer dry-run smoke tests
- cross-repo module checks that clone, build, install into a temporary prefix,
  and verify `doomwm`, `doommenu`, `doomterm`, `doomstatus`, and `doomlock`
- DoomDots `make lint`

The default build root is:

```sh
${XDG_CACHE_HOME:-$HOME/.cache}/doomsday-system
```

## Void System

This repo is Void Linux exclusive. The package manifests live in
`packages/void`:

- `00-build` has compiler, bash, git, shellcheck, mandoc, and X11/PAM headers.
- `10-session` has the X11 session, service, audio, network, and compositor
  packages used by DoomDots and DoomWM.
- `20-workflow` has applications and CLI tools referenced by DoomWM bindings,
  DoomDots scripts, and editor/media configs.

Tracked `/etc` files live under `etc` and are installed to matching absolute
paths. For example, `etc/issue` installs to `/etc/issue`.

Dependency installation can be skipped with `--no-deps`, and `/etc` installation
can be skipped with `--no-etc`.

## Useful Commands

Preview an install:

```sh
./install.sh --dry-run --all
```

List modules:

```sh
./install.sh --list
```

Uninstall selected modules:

```sh
./install.sh --uninstall --desktop
```

By default, the installer verifies selected command modules after install:
`doomwm`, `doommenu`, `doomterm`, `doomstatus`, and `doomlock`.

## What It Changes

The script can make these kinds of changes:

- clones module repositories into the build root
- installs Void packages with `xbps-install`
- installs tracked files from `etc` into `/etc`
- installs compiled tools into `PREFIX`, usually `/usr/local`
- symlinks dotfiles into `DOTFILES_PREFIX`, usually `$HOME`

The dotfile installer backs up conflicts before linking. Read the module
repositories before installing on a machine you care about, especially the
dotfiles and helper scripts.

## Repository Shape

This repo should stay small:

```text
README.md       project overview and usage
install.sh      installer for all modules
packages/void/  Void package manifests
etc/            tracked /etc overlay
man/            meta manual pages
.gitignore      ignores local module checkouts and build outputs
```

The actual desktop configuration lives in the linked module repositories.
