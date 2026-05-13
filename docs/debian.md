# Debian and Ubuntu

The installer supports Debian and Ubuntu through `apt-get`.

```sh
curl -fsSL https://raw.githubusercontent.com/iamb4uc/DOOMSDAY_SYSTEM/main/install.sh | sh -s -- --yes --all
```

Dependency install includes:

```text
git build-essential pkg-config libx11-dev libxext-dev libxft-dev
libxinerama-dev libxrandr-dev libxrender-dev libfontconfig1-dev
libfreetype6-dev libpam0g-dev ncurses-bin
```

Skip package installation if the system is already prepared:

```sh
./install.sh --yes --all --no-deps
```

