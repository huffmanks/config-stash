# Script install

```sh
curl -sSL https://raw.githubusercontent.com/huffmanks/config-stash/main/install.sh | bash
```

# Manual install

1. Install xcode

```sh
xcode-select --install
```

2. Clone repo

```sh
git clone https://github.com/huffmanks/config-stash.git .nix-config && cd .nix-config
```

3. Copy .gitconfig and .gitignore

```sh
cp ./.dotfiles/.gitignore ~/.gitignore && cp ./.dotfiles/.gitconfig ~/.gitconfig
```

4. Install Determinate Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install --determinate
```

5. Build

```sh
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#ok-mac-pro
```

## Remove unused profiles

```sh
nix-collect-garbage -d
```

## Reset finder preferences

```sh
rm ~/Library/Preferences/com.apple.finder.plist
defaults delete com.apple.finder
killall Finder
sudo reboot
```

## Defaults that aren't configurable with nix-darwin

### Notifications

- Allow notifications when the screen is locked > ===false===

### Desktop & Dock

- Default web browser

### Lock Screen

- When Switching User > Login window shows > ===Name and password===

### Trackpad

- Secondary click > ===Click in Bottom Right Corner===

### Finder

#### Sidebar

**Favorites**

- [x] Recents
- [x] AirDrop
- [x] Applications
- [x] Desktop
- [x] Documents
- [x] Downloads
- [ ] Movies
- [ ] Music
- [ ] Pictures
- [x] $USER

**iCloud**

- [ ] iCloud Drive
- [ ] Shared

**Locations**

- [ ] Device
- [x] Hard disks
- [x] External disks
- [ ] CDs, DVDs, and iOS Devices
- [ ] Cloud Storage
- [ ] Bonjour computers
- [ ] Connected servers

**Tags**

- [ ] Recent Tags

#### View Options

- [x] Always open in list view
  - [x] Browse in list view
- Group By: ===None===
- Sort By: ===Date Modified===

**Show Columns:**

- [x] Date Modified
- [x] Date Created
- [ ] Date Last Opened
- [ ] Date Added
- [x] Size
- [x] Kind
- [ ] Version
- [ ] Comments
- [ ] Tags

**Misc**

- [x] Use relative dates
- [x] Calculate all sizes
- [x] Show icon preview

Click "Use as Defaults"
