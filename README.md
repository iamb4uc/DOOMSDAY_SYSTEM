# DOOMSDAY_SYSTEM

A one-command installer for my X11 desktop stack.

This repository is intentionally a meta-repo. It does not vendor the individual
projects or require git submodules. The installer clones each selected module
from GitHub, builds the suckless tools, and installs the dotfiles through their
own installer.

## Modules

| Flag | Installs | Source |
| --- | --- | --- |
| `--dots` | Shell, X11, editor, media, browser, and helper-script dotfiles | [`iamb4uc/dots`](https://github.com/iamb4uc/dots) |
| `--wm` | `vdwm` plus `dmenu` for the window-manager workflow | [`iamb4uc/vdwm`](https://github.com/iamb4uc/vdwm), [`iamb4uc/dmenu`](https://github.com/iamb4uc/dmenu) |
| `--sst` | StealthStreamTerminal, my `st` terminal build | [`iamb4uc/StealthStreamTerminal`](https://github.com/iamb4uc/StealthStreamTerminal) |
| `--slstatus` | Status monitor for the window-manager bar | [`iamb4uc/slstatus`](https://github.com/iamb4uc/slstatus) |
| `--slock` | Suckless screen locker build | [`iamb4uc/slock`](https://github.com/iamb4uc/slock) |
| `--all` | Every module above | All sources above |

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
curl -fsSL https://raw.githubusercontent.com/iamb4uc/DOOMSDAY_SYSTEM/main/install.sh | sh -s -- --wm
curl -fsSL https://raw.githubusercontent.com/iamb4uc/DOOMSDAY_SYSTEM/main/install.sh | sh -s -- --dots --sst
```

Local checkout:

```sh
git clone https://github.com/iamb4uc/DOOMSDAY_SYSTEM.git
cd DOOMSDAY_SYSTEM
./install.sh
```

## Installer Options

```text
--dots                 install dotfiles
--wm                   install vdwm and dmenu
--sst                  install StealthStreamTerminal
--slstatus             install slstatus
--slock                install slock
--all                  install everything, also the default
-y, --yes              run non-interactively
--no-deps              skip package-manager dependency installation
--no-update            do not git pull existing module checkouts
--build-root DIR       clone/build modules under DIR
--prefix DIR           install C projects under DIR, default /usr/local
--dotfiles-prefix DIR  install dotfile symlinks under DIR, default $HOME
--repo-base URL        use a different GitHub/user base URL
```

The default build root is:

```sh
${XDG_CACHE_HOME:-$HOME/.cache}/doomsday-system
```

## Supported Systems

The installer knows how to install build dependencies on:

- Void Linux with `xbps-install`
- Debian and Ubuntu with `apt-get`
- Arch Linux with `pacman`
- Fedora with `dnf`

Dependency installation can be skipped with `--no-deps` if the system is already
prepared or if you prefer to install packages manually.

## What It Changes

The script can make three kinds of changes:

- clones module repositories into the build root
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
.gitignore      ignores local module checkouts and build outputs
```

The actual desktop configuration lives in the linked module repositories.
