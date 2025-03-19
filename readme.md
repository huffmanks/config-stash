## Install Determinate Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install --determinate
```

## Build

```sh
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#ok-mac-pro
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

- Allow notifications when the screen is locked > false

### Desktop & Dock

- Default web browser

### Lock Screen

- When Switching User > Login window shows > Name and password

### Trackpad

- Secondary click > Click in Bottom Right Corner
