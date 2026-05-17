# Module Reference

This file is the human-readable module map for `install.sh`.

| Module name | Installer flag | Repository name | Installs | Install method |
| --- | --- | --- | --- | --- |
| DoomDots | `--dots` | `dots` | Dotfile symlinks | `make PREFIX="$DOTFILES_PREFIX" install` |
| VeryDynamicWindowManager | `--wm` | `vdwm` | `vdwm` | `make PREFIX="$PREFIX" clean install` |
| DoomMenu | `--wm` | `dmenu` | `dmenu`, `dmenu_run`, `dmenu_path`, `stest` | `make PREFIX="$PREFIX" clean install` |
| StealthStreamTerminal | `--sst` | `StealthStreamTerminal` | `st` | `make PREFIX="$PREFIX" clean install` |
| SentinelStatus | `--slstatus` | `slstatus` | `slstatus` | `make PREFIX="$PREFIX" clean install` |
| ShadowLock | `--slock` | `slock` | `slock` | `make PREFIX="$PREFIX" clean install` |

`--wm` intentionally installs both `vdwm` and `dmenu`, because the desktop
workflow expects the menu alongside the window manager.
