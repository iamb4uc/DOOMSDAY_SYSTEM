# Module Reference

This file is the human-readable module map for `install.sh`.

| Module name | Installer flag | Repository name | Installs | Install method |
| --- | --- | --- | --- | --- |
| DoomDots | `--dots` | `DoomDots` | Dotfile symlinks | `make PREFIX="$DOTFILES_PREFIX" install` |
| Desktop bundle | `--desktop` | all desktop modules | DoomWM, DoomMenu, DoomTerm, DoomStatus, DoomLock | mixed module installs |
| DoomWM | `--wm` | `DoomWM` | `doomwm` | `make PREFIX="$PREFIX" clean install` |
| DoomMenu | `--menu` | `DoomMenu` | `doommenu`, `doommenu_run`, `doommenu_path`, `stest` | `make PREFIX="$PREFIX" clean install` |
| DoomTerm | `--term` | `DoomTerm` | `st` | `make PREFIX="$PREFIX" clean install` |
| DoomStatus | `--status` | `DoomStatus` | `slstatus` | `make PREFIX="$PREFIX" clean install` |
| DoomLock | `--lock` | `DoomLock` | `doomlock` | `make PREFIX="$PREFIX" clean install` |

Legacy aliases `--sst`, `--slstatus`, and `--slock` still work for older
commands, but the preferred flags are `--term`, `--status`, and `--lock`.
