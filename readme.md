## Install Determinate Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install --determinate
```

## Init build

```sh
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#ok-mac-pro
```

##

```sh
darwin-rebuild switch
```

## Reset finder preferences

```sh
rm ~/Library/Preferences/com.apple.finder.plist
defaults delete com.apple.finder
killall Finder
```
