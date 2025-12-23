# config-stash

A centralized repository designed to manage and automate the deployment of my personal development environment. It serves as a single source of truth for my system configurations and dotfiles.

---

## Get dotfiles (script)

### Quick install

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/huffmanks/config-stash/main/scripts/get-dotfiles.sh)
```

### Custom install (with exports)

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/huffmanks/config-stash/main/scripts/get-dotfiles.sh) -- --exports all
```

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/huffmanks/config-stash/main/scripts/get-dotfiles.sh) -- --exports docker nvm pnpm
```

### Config options

| Flag                | Description                    |
| ------------------- | ------------------------------ |
| --exports           | Add exports to .zshrc          |
| all                 | Enable every tool listed below |
| bun                 | Bun environment exports        |
| docker              | Docker aliases and paths       |
| go                  | Go (GOPATH/bin) exports        |
| java-android-studio | Java and Android Studio paths  |
| nvm                 | Node Version Manager config    |
| pipx                | Pipx binary paths              |
| pnpm                | PNPM home and path config      |

---

## Quick dev setup (script)

### Android

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/huffmanks/config-stash/main/scripts/dev-setup.sh) -- android
```

### Linux

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/huffmanks/config-stash/main/scripts/dev-setup.sh) -- linux
```
