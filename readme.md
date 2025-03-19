# Setup

1. Install xcode

```sh
xcode-select --install
```

2. Install nvm

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
```

3. Install pnpm

```sh
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

4. Install chrome, docker, vscode

- [https://www.google.com/chrome/dr/download](https://www.google.com/chrome/dr/download)
- [https://docs.docker.com/desktop/setup/install/mac-install/](https://docs.docker.com/desktop/setup/install/mac-install/)
- [https://code.visualstudio.com/download](https://code.visualstudio.com/download)

5. Homebrew

   1. Install

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

   2. Add packages

   ```sh
   brew install ffmpeg jq bat gh pipx zsh-autosuggestions zsh-syntax-highlighting
   ```

   3. Update .zshrc

   ```sh
   source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
   ```

   ```sh
   echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
   ```

6. Clone repo

```sh
git clone https://github.com/huffmanks/config-stash.git .nix-config && cd .nix-config
```

7. Copy .gitconfig and .gitignore

```sh
cp ./.dotfiles/.gitignore ~/.gitignore && cp ./.dotfiles/.gitconfig ~/.gitconfig
```

8. Install Determinate Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```

9. Build

```sh
nix run nix-darwin/master#darwin-rebuild -- switch --flake .#ok-mac-pro
```

```sh
darwin-rebuild switch --flake .#ok-mac-pro
```

## Remove unused profiles

```sh
nix-collect-garbage --delete-old
```

## Uninstall nix-darwin

```sh
nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
```

## Uninstall nix

```sh
/nix/nix-installer uninstall
```

## Remove nix artifacts

1. Edit /etc/zshrc, /etc/bashrc, and /etc/bash.bashrc to remove the lines sourcing nix-daemon.sh.

2. If these files haven't been altered since installing Nix you can simply put the backups back in place:

```sh
sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
sudo mv /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc
```

3. Stop and remove the Nix daemon services:

```sh
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist
sudo rm /Library/LaunchDaemons/org.nixos.darwin-store.plist
```

4. Remove the nixbld group and the \_nixbuildN users:

```sh
sudo dscl . -delete /Groups/nixbld
for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete /Users/$u; done
```

5. Edit fstab using sudo vifs to remove the line mounting the Nix Store volume on /nix, which looks like UUID=<uuid> /nix apfs rw,noauto,nobrowse,suid,owners or LABEL=Nix\040Store /nix apfs rw,nobrowse. This will prevent automatic mounting of the Nix Store volume.

6. Edit /etc/synthetic.conf to remove the nix line. If this is the only line in the file you can remove it entirely, sudo rm /etc/synthetic.conf. This will prevent the creation of the empty /nix directory to provide a mountpoint for the Nix Store volume.

7. Remove the files Nix added to your system:

```sh
sudo rm -rf /etc/nix ~/.nix-profile ~/.nix-defexpr ~/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels ~/.cache/nix ~/.local/state/nix
```

8. Remove the Nix Store volume:

```sh
sudo diskutil apfs deleteVolume /nix
```

9. Look for a "Nix Store" volume in the output of the following command:

```sh
diskutil list
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

- Allow notifications when the screen is locked > ==false==

### Desktop & Dock

- Default web browser

### Lock Screen

- When Switching User > Login window shows > ==Name and password==

### Trackpad

- Secondary click > ==Click in Bottom Right Corner==

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
- Group By: ==None==
- Sort By: ==Date Modified==

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
