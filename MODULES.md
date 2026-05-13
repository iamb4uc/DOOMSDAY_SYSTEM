# Module Reference

This file is the human-readable module map for `install.sh`.

| Module | Installer flag | Repository name | Install method |
| --- | --- | --- | --- |
| Dotfiles | `--dots` | `dots` | `make PREFIX="$DOTFILES_PREFIX" install` |
| Window manager | `--wm` | `vdwm` | `make PREFIX="$PREFIX" clean install` |
| Menu | `--wm` | `dmenu` | `make PREFIX="$PREFIX" clean install` |
| Terminal | `--sst` | `StealthStreamTerminal` | `make PREFIX="$PREFIX" clean install` |
| Status bar | `--slstatus` | `slstatus` | `make PREFIX="$PREFIX" clean install` |
| Lock screen | `--slock` | `slock` | `make PREFIX="$PREFIX" clean install` |

`--wm` intentionally installs both `vdwm` and `dmenu`, because the desktop
workflow expects the menu alongside the window manager.

