# Keybindings

This file documents the active keyboard and mouse bindings across the
DOOMSDAY_SYSTEM module chain.

Notation:

- `Mod` in DoomWM means `Alt`, from `MODKEY Mod1Mask`.
- `Super` in DoomTerm means the X11 Super key, from `MODKEY Mod4Mask`.
- `Leader` in Neovim means `Space`.
- tmux bindings below are pressed after the tmux prefix, `Ctrl-a`, unless noted.

## DoomWM

### Launchers

| Binding            | Action                                                  |
| ------------------ | ------------------------------------------------------- |
| `Mod+Shift+Return` | Open `doomterm`                                         |
| `Mod+Shift+m`      | Open `ncmpcpp` in `doomterm`                            |
| `Mod+Shift+h`      | Open `htop` in `doomterm`                               |
| `Mod+Shift+v`      | Open `nvim` in `doomterm`                               |
| `Mod+Shift+t`      | Open a new tmux session in `doomterm`                   |
| `Mod+Shift+a`      | Attach tmux in `doomterm`                               |
| `Mod+Shift+f`      | Open `lf` in `doomterm`                                 |
| `Mod+Shift+F4`     | Open `pulsemixer` in `doomterm`                         |
| `Mod+Shift+n`      | Open network manager TUI in `doomterm`                  |
| `Mod+F8`           | Stop NetworkManager                                     |
| `Mod+Shift+F8`     | Restart NetworkManager                                  |
| `Mod+Shift+F7`     | Run `void-maintenance` in `doomterm`                    |
| `Mod+Shift+s`      | Start Flameshot GUI                                     |
| `Mod+Shift+p`      | Toggle scratchpad terminal                              |
| `Mod+Shift+w`      | Open Firefox                                            |
| `Mod+Shift+r`      | Open Zathura                                            |
| `Mod+Shift+k`      | Open KeePassXC                                          |
| `Mod+Shift+F12`    | Open Thunderbird                                        |
| `Mod+d`            | Open `doommenu_run`                                     |
| `Mod+Shift+q`      | Open the session action menu                            |
| `Mod+F11`          | Run `doomlock`, then suspend with `loginctl suspend -i` |

### Music, Audio, And Brightness

| Binding        | Action                |
| -------------- | --------------------- |
| `Mod+F1`       | Toggle MPD playback   |
| `Mod+Shift+F1` | Toggle MPD shuffle    |
| `Mod+F2`       | Lower MPD volume      |
| `Mod+Shift+F2` | Previous MPD track    |
| `Mod+F3`       | Raise MPD volume      |
| `Mod+Shift+F3` | Next MPD track        |
| `Mod+F5`       | Lower brightness      |
| `Mod+F6`       | Raise brightness      |
| `Mod+Shift+F5` | Lower brightness more |
| `Mod+Shift+F6` | Raise brightness more |

### Window Management

| Binding            | Action                                  |
| ------------------ | --------------------------------------- |
| `Mod+b`            | Toggle bar                              |
| `Mod+j`            | Focus next client                       |
| `Mod+k`            | Focus previous client                   |
| `Mod+o`            | Increase master count                   |
| `Mod+p`            | Decrease master count                   |
| `Mod+h`            | Shrink master area                      |
| `Mod+l`            | Grow master area                        |
| `Mod+Return`       | Zoom focused client into master         |
| `Mod+Tab`          | Toggle previous tag view                |
| `Mod+Shift+c`      | Kill focused client                     |
| `Mod+t`            | Tiled layout                            |
| `Mod+Shift+y`      | Floating layout                         |
| `Mod+y`            | Monocle layout                          |
| `Mod+u`            | Fibonacci spiral layout                 |
| `Mod+Shift+u`      | Fibonacci dwindle layout                |
| `Mod+i`            | Centered master layout                  |
| `Mod+Shift+i`      | Centered floating master layout         |
| `Mod+Space`        | Cycle layout                            |
| `Mod+Shift+Space`  | Toggle floating for focused client      |
| `Mod+0`            | View all tags                           |
| `Mod+Shift+0`      | Send focused client to all tags         |
| `Mod+,`            | Focus previous monitor                  |
| `Mod+.`            | Focus next monitor                      |
| `Mod+Shift+,`      | Send focused client to previous monitor |
| `Mod+Shift+.`      | Send focused client to next monitor     |
| `Mod+-`            | Decrease gaps                           |
| `Mod+=`            | Increase gaps                           |
| `Mod+Shift+=`      | Reset gaps                              |
| `Mod+Ctrl+Shift+x` | Quit DoomWM                             |
| `Mod+Ctrl+Shift+q` | Restart DoomWM                          |

### Tags

For tags `1` through `9`:

| Binding               | Action                       |
| --------------------- | ---------------------------- |
| `Mod+1..9`            | View tag                     |
| `Mod+Ctrl+1..9`       | Toggle tag in current view   |
| `Mod+Shift+1..9`      | Move focused client to tag   |
| `Mod+Ctrl+Shift+1..9` | Toggle focused client on tag |

### Mouse

| Binding                 | Action                       |
| ----------------------- | ---------------------------- |
| Layout symbol `Button1` | Cycle layout                 |
| Layout symbol `Button3` | Monocle layout               |
| Window title `Button2`  | Zoom focused client          |
| Status text `Button2`   | Open `doomterm`              |
| Client `Mod+Button1`    | Move client                  |
| Client `Mod+Button2`    | Toggle floating              |
| Client `Mod+Button3`    | Resize client                |
| Tag `Button1`           | View tag                     |
| Tag `Button3`           | Toggle tag view              |
| Tag `Mod+Button1`       | Move focused client to tag   |
| Tag `Mod+Button3`       | Toggle focused client on tag |

## DoomTerm

Source: `DoomTerm/config.h`.

### Keyboard

| Binding               | Action                              |
| --------------------- | ----------------------------------- |
| `Break`               | Send break                          |
| `Ctrl+Print`          | Toggle printer                      |
| `Shift+Print`         | Print screen                        |
| `Print`               | Print selection                     |
| `Ctrl+Shift++`        | Zoom in                             |
| `Ctrl+=`              | Zoom in                             |
| `Ctrl+KeypadPlus`     | Zoom in                             |
| `Ctrl+-`              | Zoom out                            |
| `Ctrl+KeypadMinus`    | Zoom out                            |
| `Ctrl+0`              | Reset zoom                          |
| `Ctrl+Keypad0`        | Reset zoom                          |
| `Ctrl+Shift+PageUp`   | Zoom in                             |
| `Ctrl+Shift+PageDown` | Zoom out                            |
| `Ctrl+Shift+Home`     | Reset zoom                          |
| `Ctrl+Shift+C`        | Copy selection                      |
| `Ctrl+Shift+V`        | Paste clipboard                     |
| `Ctrl+Shift+Y`        | Paste primary selection             |
| `Shift+Insert`        | Paste primary selection             |
| `Ctrl+Shift+NumLock`  | Toggle numlock mode                 |
| `Super+1..9`          | Select color scheme `1` through `9` |
| `Super+0`             | Next color scheme                   |
| `Super+Ctrl+0`        | Previous color scheme               |
| `Shift+PageUp`        | Scroll up                           |
| `Shift+PageDown`      | Scroll down                         |

### Mouse

| Binding         | Action          |
| --------------- | --------------- |
| `Shift+Button4` | Scroll up       |
| `Shift+Button5` | Scroll down     |
| `Button2`       | Paste selection |
| `Button4`       | Scroll up       |
| `Button5`       | Scroll down     |

## DoomMenu

Sources: `DoomMenu/config.h` and `DoomMenu/doommenu.c`.

DoomMenu starts with vi mode enabled. `Esc` enters vi mode, and `q` quits while
in vi mode.

### Vi Mode

| Binding              | Action                                               |
| -------------------- | ---------------------------------------------------- |
| `0`                  | Move cursor to start                                 |
| `$`                  | Move cursor to end                                   |
| `b`                  | Move to previous word edge                           |
| `e`                  | Move to end of word                                  |
| `g`                  | Select first item                                    |
| `G`                  | Select last item                                     |
| `h`                  | Move cursor left                                     |
| `j`                  | Select next item                                     |
| `k`                  | Select previous item                                 |
| `l`                  | Move cursor right                                    |
| `w`                  | Move to next word                                    |
| `a`                  | Enter insert mode after cursor                       |
| `i`                  | Enter insert mode                                    |
| `A`                  | Enter insert mode at end                             |
| `I`                  | Enter insert mode at start                           |
| `p`                  | Paste primary selection after cursor                 |
| `P`                  | Paste primary selection at cursor                    |
| `Ctrl+p` or `Ctrl+P` | Reserved; does nothing                               |
| `Ctrl+d`             | Page/select down, or jump to end if no next page     |
| `Ctrl+u`             | Page/select up, or jump to start if no previous page |
| `Ctrl+c`             | Quit                                                 |
| `D`                  | Delete from cursor to end                            |
| `x`                  | Delete character                                     |
| `Enter`              | Accept selected item                                 |
| `Shift+Enter`        | Accept typed text instead of selected item           |
| `Ctrl+Enter`         | Mark selected item as output and keep menu open      |
| `Tab`                | Complete input from selected item                    |

### Insert And Normal Editing

| Binding                                | Action                                           |
| -------------------------------------- | ------------------------------------------------ |
| `Esc`                                  | Enter vi mode, or quit from regular key handling |
| `Ctrl+a`                               | Home                                             |
| `Ctrl+b`                               | Left                                             |
| `Ctrl+c`                               | Escape/quit                                      |
| `Ctrl+d`                               | Delete                                           |
| `Ctrl+e`                               | End                                              |
| `Ctrl+f`                               | Right                                            |
| `Ctrl+g`                               | Escape/quit                                      |
| `Ctrl+h`                               | Backspace                                        |
| `Ctrl+i`                               | Tab                                              |
| `Ctrl+j`, `Ctrl+J`, `Ctrl+m`, `Ctrl+M` | Enter                                            |
| `Ctrl+n`                               | Down                                             |
| `Ctrl+p`                               | Up                                               |
| `Ctrl+k`                               | Delete right                                     |
| `Ctrl+u`                               | Delete left                                      |
| `Ctrl+w`                               | Delete previous word                             |
| `Ctrl+y`                               | Paste primary selection                          |
| `Ctrl+Shift+y`                         | Paste clipboard                                  |
| `Ctrl+Left`                            | Move to previous word edge                       |
| `Ctrl+Right`                           | Move to next word edge                           |
| `Alt+b`                                | Move to previous word edge                       |
| `Alt+f`                                | Move to next word edge                           |
| `Alt+g`                                | Home                                             |
| `Alt+Shift+g`                          | End                                              |
| `Alt+h`                                | Up                                               |
| `Alt+j`                                | Page down                                        |
| `Alt+k`                                | Page up                                          |
| `Alt+l`                                | Down                                             |
| `Home`                                 | Cursor start, or first item                      |
| `End`                                  | Cursor end, or last item                         |
| `Left`                                 | Cursor left, or previous item in horizontal mode |
| `Right`                                | Cursor right, or next item in horizontal mode    |
| `Up`                                   | Previous item                                    |
| `Down`                                 | Next item                                        |
| `PageUp`                               | Previous page                                    |
| `PageDown`                             | Next page                                        |
| `Backspace`                            | Delete previous character                        |
| `Delete`                               | Delete current character                         |
| `Enter`                                | Accept selected item                             |
| `Shift+Enter`                          | Accept typed text instead of selected item       |
| `Ctrl+Enter`                           | Mark selected item as output and keep menu open  |
| `Tab`                                  | Complete input from selected item                |

## DoomDots

DoomDots carries most daily application bindings.

### Neovim

Sources: `DoomDots/.config/nvim/lua/config/keymaps.lua`,
`DoomDots/.config/nvim/lua/plugins/telescope.lua`, and
`DoomDots/.config/nvim/lua/plugins/filetree.lua`.

#### Files, Windows, And Buffers

| Binding      | Mode            | Action                          |
| ------------ | --------------- | ------------------------------- | -------------- |
| `Leader+fs`  | Normal          | Save file                       |
| `Leader+fsa` | Normal          | Save all files                  |
| `Leader+qq`  | Normal          | Quit                            |
| `Leader+qf`  | Normal          | Force quit                      |
| `Leader+fsq` | Normal          | Save and quit                   |
| `Leader+     | `               | Normal                          | Vertical split |
| `Leader+-`   | Normal          | Horizontal split                |
| `Leader+wc`  | Normal          | Close window                    |
| `Ctrl+h`     | Normal/terminal | Move to left window             |
| `Ctrl+j`     | Normal/terminal | Move to lower window            |
| `Ctrl+k`     | Normal/terminal | Move to upper window            |
| `Ctrl+l`     | Normal/terminal | Move to right window            |
| `H`          | Normal          | Previous buffer                 |
| `L`          | Normal          | Next buffer                     |
| `Leader+bd`  | Normal          | Delete buffer                   |
| `Leader+e`   | Normal          | Toggle Mini Files file explorer |

#### Editing And Tools

| Binding     | Mode          | Action                         |
| ----------- | ------------- | ------------------------------ |
| `Leader+a`  | Normal        | Run `compiler` on current file |
| `Leader+p`  | Normal        | Run `opout` on current file    |
| `Leader+oc` | Normal        | Open Neovim config             |
| `Leader+sz` | Normal        | Open zshrc                     |
| `Leader+la` | Normal        | Open Lazy                      |
| `J`         | Visual        | Move selection down            |
| `K`         | Visual        | Move selection up              |
| `Leader+y`  | Normal/visual | Yank to clipboard              |
| `Leader+Y`  | Normal        | Yank line to clipboard         |
| `Leader+r`  | Normal        | Replace word under cursor      |
| `Leader+fm` | Normal        | Format file                    |
| `Leader+?`  | Normal        | Show WhichKey                  |
| `Leader+zz` | Normal        | Toggle ZenMode                 |
| `s`         | Normal        | Flash jump                     |
| `S`         | Normal        | Flash treesitter               |

#### Telescope

| Binding         | Mode   | Action                 |
| --------------- | ------ | ---------------------- |
| `Leader+ff`     | Normal | Find files             |
| `Leader+Leader` | Normal | Find files             |
| `Leader+lg`     | Normal | Live grep              |
| `Leader+bb`     | Normal | List buffers           |
| `Leader+ht`     | Normal | Help tags              |
| `Leader+of`     | Normal | Old files              |
| `Leader+/`      | Normal | Find word under cursor |
| `Leader+kk`     | Normal | Find keymaps           |
| `Leader+fd`     | Normal | Find diagnostics       |
| `Leader+ds`     | Normal | Document symbols       |
| `Leader+gc`     | Normal | Git commits            |
| `Leader+gs`     | Normal | Git status             |

Inside Telescope:

| Binding  | Mode          | Action                |
| -------- | ------------- | --------------------- |
| `Esc`    | Insert        | Leave insert mode     |
| `Ctrl+c` | Insert        | Close picker          |
| `Ctrl+j` | Insert        | Next selection        |
| `Ctrl+k` | Insert        | Previous selection    |
| `Ctrl+d` | Insert/normal | Scroll preview down   |
| `Ctrl+u` | Insert/normal | Scroll preview up     |
| `q`      | Normal        | Close picker          |
| `Esc`    | Normal        | Close picker          |
| `j`      | Normal        | Next selection        |
| `k`      | Normal        | Previous selection    |
| `gg`     | Normal        | Top                   |
| `G`      | Normal        | Bottom                |
| `Enter`  | Normal        | Select                |
| `Ctrl+v` | Normal        | Open vertical split   |
| `Ctrl+x` | Normal        | Open horizontal split |
| `Ctrl+t` | Normal        | Open tab              |
| `?`      | Normal        | Show picker key help  |

#### LSP, Diagnostics, Git, Trouble, And Terminal

| Binding     | Mode          | Action                            |
| ----------- | ------------- | --------------------------------- | ------------------------ |
| `gd`        | Normal        | Go to definition                  |
| `gD`        | Normal        | Go to declaration                 |
| `gi`        | Normal        | Go to implementation              |
| `gr`        | Normal        | Go to references                  |
| `K`         | Normal        | Hover documentation               |
| `Leader+rn` | Normal        | Rename symbol                     |
| `Leader+ca` | Normal/visual | Code action                       |
| `[d`        | Normal        | Previous diagnostic               |
| `]d`        | Normal        | Next diagnostic                   |
| `Leader+dd` | Normal        | Line diagnostics                  |
| `Leader+dl` | Normal        | Diagnostics location list         |
| `Leader+hp` | Normal        | Preview hunk                      |
| `Leader+hs` | Normal        | Stage hunk                        |
| `Leader+hr` | Normal        | Reset hunk                        |
| `Leader+hS` | Normal        | Stage buffer                      |
| `Leader+hR` | Normal        | Reset buffer                      |
| `Leader+hb` | Normal        | Blame line                        |
| `Leader+hd` | Normal        | Diff this                         |
| `Leader+xx` | Normal        | Toggle Trouble diagnostics        |
| `Leader+xX` | Normal        | Toggle Trouble buffer diagnostics |
| `Leader+xs` | Normal        | Toggle Trouble symbols            |
| `Leader+xl` | Normal        | Toggle Trouble LSP                |
| `Leader+xq` | Normal        | Toggle Trouble quickfix           |
| `Leader+tt` | Normal        | Toggle floating terminal          |
| `Leader+t-` | Normal        | Toggle horizontal terminal        |
| `Leader+t   | `             | Normal                            | Toggle vertical terminal |
| `Leader+ta` | Normal        | Toggle all terminals              |
| `Esc`       | Terminal      | Terminal normal mode              |
| `Leader+tt` | Terminal      | Toggle floating terminal          |

#### Mini Files

| Binding     | Action                           |
| ----------- | -------------------------------- |
| `q`         | Close                            |
| `l`         | Go in                            |
| `Enter`     | Go in plus                       |
| `h`         | Go out                           |
| `H`         | Go out plus                      |
| `Backspace` | Reset                            |
| `.`         | Reveal current working directory |
| `g?`        | Show help                        |
| `s`         | Synchronize                      |
| `<`         | Trim left                        |
| `>`         | Trim right                       |

### tmux

Source: `DoomDots/.config/tmux/tmux.conf`.

Prefix is `Ctrl-a`. The old defaults `Ctrl-b`, `"`, and `%` are unbound.

| Binding              | Action                                                     |
| -------------------- | ---------------------------------------------------------- | ----------------------- |
| `Ctrl-a`             | Send prefix through to nested tmux                         |
| `                    | `                                                          | Split pane horizontally |
| `-`                  | Split pane vertically                                      |
| `r`                  | Reload tmux config                                         |
| `h`                  | Select pane left                                           |
| `j`                  | Select pane down                                           |
| `k`                  | Select pane up                                             |
| `l`                  | Select pane right                                          |
| `H`                  | Resize pane left by 5                                      |
| `J`                  | Resize pane down by 5                                      |
| `K`                  | Resize pane up by 5                                        |
| `L`                  | Resize pane right by 5                                     |
| `Ctrl+h`             | Previous window                                            |
| `Ctrl+l`             | Next window                                                |
| `Escape`             | Enter copy mode                                            |
| `Ctrl+[`             | Enter copy mode                                            |
| `v` in copy mode     | Begin selection                                            |
| `Enter` in copy mode | Copy selection through `reattach-to-user-namespace pbcopy` |
| `y` in copy mode     | Copy selection through `reattach-to-user-namespace pbcopy` |
| `p`                  | Paste buffer                                               |
| `Ctrl+j`             | Select next pane                                           |

tmux also uses vi keys in the status line and copy mode, and mouse support is on.

### lf

Source: `DoomDots/.config/lf/lfrc`.

`shortcutrc` is sourced by `lfrc`; it is currently an empty bookmark placeholder
kept so `lf` starts cleanly.

| Binding  | Action                           |
| -------- | -------------------------------- |
| `Ctrl+f` | Run `fzf-select`                 |
| `J`      | Jump                             |
| `Ctrl+h` | Go home                          |
| `g`      | Go top                           |
| `d`      | Move to directory                |
| `D`      | Trash selected file              |
| `E`      | Extract archive                  |
| `C`      | Copy to directory                |
| `M`      | Move to directory                |
| `N`      | Start `mkdir` prompt             |
| `Ctrl+r` | Reload                           |
| `H`      | Toggle hidden files              |
| `Enter`  | Shell/open                       |
| `x`      | Execute file                     |
| `X`      | Execute file and wait            |
| `o`      | Open with `mimeopen`             |
| `O`      | Open with `mimeopen --ask`       |
| `A`      | Rename at end                    |
| `c`      | Rename from cleared prompt       |
| `I`      | Rename at beginning              |
| `i`      | Rename before extension          |
| `a`      | Rename after extension           |
| `B`      | Bulk rename                      |
| `b`      | Set wallpaper                    |
| `Ctrl+n` | Move down                        |
| `Ctrl+p` | Move up                          |
| `V`      | Start `nvim` prompt              |
| `W`      | Open `doomterm`                  |
| `U`      | Copy full path                   |
| `u`      | Copy file name                   |
| `.`      | Copy YouTube URL                 |
| `>`      | Copy Piped URL                   |
| `T`      | Open thumbnail view with `nsxiv` |
| `Ctrl+l` | Unselect                         |

### qutebrowser

Source: `DoomDots/.config/qutebrowser/config.py`.

| Binding | Action                                                   |
| ------- | -------------------------------------------------------- |
| `xt`    | Toggle tab bar between always visible and switching mode |
| `xs`    | Toggle status bar between always visible and in-mode     |

### mpv

Sources: `DoomDots/.config/mpv/inputrc` and
`DoomDots/.config/mpv/scripts/playlistmanager.lua`.

| Binding        | Action                   |
| -------------- | ------------------------ |
| `h`            | Seek back 5 seconds      |
| `l`            | Seek forward 5 seconds   |
| `j`            | Seek back 60 seconds     |
| `k`            | Seek forward 60 seconds  |
| `S`            | Cycle subtitles          |
| `Ctrl+p`       | Sort playlist            |
| `Ctrl+Shift+p` | Shuffle playlist         |
| `P`            | Load files into playlist |
| `p`            | Save playlist            |
| `Shift+Enter`  | Toggle playlist view     |

When the playlist is visible, the playlist manager forces these bindings:

| Binding           | Action                    |
| ----------------- | ------------------------- |
| `Up`              | Move playlist cursor up   |
| `Down`            | Move playlist cursor down |
| `Right` or `Left` | Select file               |
| `Enter`           | Play file                 |
| `Backspace`       | Remove file               |
| `Esc`             | Close playlist            |

### ncmpcpp

Source: `DoomDots/.config/ncmpcpp/bindings`.

| Binding  | Action                                                                       |
| -------- | ---------------------------------------------------------------------------- |
| `+`      | Show clock                                                                   |
| `=`      | Volume up                                                                    |
| `j`      | Scroll down                                                                  |
| `k`      | Scroll up                                                                    |
| `Ctrl+u` | Page up                                                                      |
| `Ctrl+d` | Page down                                                                    |
| `u`      | Page up                                                                      |
| `d`      | Page down                                                                    |
| `h`      | Previous column; also jump to parent directory where applicable              |
| `l`      | Next column; also enter directory, run action, or play item where applicable |
| `.`      | Show lyrics                                                                  |
| `n`      | Next found item                                                              |
| `N`      | Previous found item                                                          |
| `J`      | Move sort order down                                                         |
| `K`      | Move sort order up                                                           |
| `m`      | Show media library; also toggle media library columns mode                   |
| `t`      | Show tag editor                                                              |
| `v`      | Show visualizer                                                              |
| `G`      | Move end                                                                     |
| `g`      | Move home                                                                    |
| `U`      | Update database                                                              |
| `s`      | Reset search engine; also show search engine                                 |
| `f`      | Show browser; also change browse mode                                        |
| `x`      | Delete playlist items                                                        |
| `P`      | Show playlist                                                                |

Some ncmpcpp keys are intentionally repeated for different contexts.

### nsxiv

Source: `DoomDots/.config/sxiv/exec/key-handler`.

These are handled by the custom sxiv/nsxiv key-handler script.

| Binding | Action                                                             |
| ------- | ------------------------------------------------------------------ |
| `w`     | Set selected image as wallpaper                                    |
| `c`     | Copy selected file to a bookmark directory chosen through DoomMenu |
| `m`     | Move selected file to a bookmark directory chosen through DoomMenu |
| `r`     | Rotate image 90 degrees                                            |
| `R`     | Rotate image -90 degrees                                           |
| `f`     | Flop image                                                         |
| `y`     | Copy selected path text to clipboard                               |
| `Y`     | Copy absolute path to clipboard                                    |
| `d`     | Confirm through DoomMenu, then delete file                         |
| `g`     | Open selected file in GIMP when installed                          |
| `i`     | Show file information with `mediainfo`                             |

### Alacritty, Ghostty, Zathura, Glow, And Peaclock

The checked configs for these tools do not define custom keybindings in this
repo. They keep upstream/default keyboard behavior, with these relevant input
settings:

- Alacritty enables URL hints with the alphabet `jfkdls;ahgurieowpq` and mouse
  hint opening through `xdg-open`.
- Glow has mouse support enabled.
- Peaclock comments note its built-in `hjkl;'` adjustment keys, but no custom
  binding is defined here.

## DoomStatus

DoomStatus does not define interactive keybindings. It exposes keyboard-related
status components for keyboard indicators and current keymap.

## DoomLock

DoomLock does not define configurable keybindings in this repo. It grabs the
keyboard while locked, accepts password input, and its manual warns that
`Ctrl+Alt+Backspace` can kill the X server when enabled by the X configuration.
