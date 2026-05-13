# Arch Linux

The installer supports Arch Linux through `pacman`.

```sh
curl -fsSL https://raw.githubusercontent.com/iamb4uc/DOOMSDAY_SYSTEM/main/install.sh | sh -s -- --yes --all
```

Dependency install includes:

```text
git base-devel pkgconf libx11 libxext libxft libxinerama libxrandr
libxrender fontconfig freetype2 pam ncurses
```

Skip package installation if the system is already prepared:

```sh
./install.sh --yes --all --no-deps
```

