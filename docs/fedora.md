# Fedora

The installer supports Fedora through `dnf`.

```sh
curl -fsSL https://raw.githubusercontent.com/iamb4uc/DOOMSDAY_SYSTEM/main/install.sh | sh -s -- --yes --all
```

Dependency install includes:

```text
git make gcc pkgconf-pkg-config libX11-devel libXext-devel libXft-devel
libXinerama-devel libXrandr-devel libXrender-devel fontconfig-devel
freetype-devel pam-devel ncurses
```

Skip package installation if the system is already prepared:

```sh
./install.sh --yes --all --no-deps
```

