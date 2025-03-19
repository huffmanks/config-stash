#!/bin/bash

# Step 1: Check if Xcode Command Line Tools are installed, and install if not
if ! xcode-select -p &>/dev/null; then
  echo "Xcode Command Line Tools not installed. Installing..."
  xcode-select --install
  # Wait for the user to finish installation
  echo "Please complete the installation of Xcode Command Line Tools and re-run the script."
  exit 1
fi

# Step 2: Clone the config-stash repo
echo "Cloning the config-stash repository..."
git clone https://github.com/huffmanks/config-stash.git .nix-config
cd .nix-config

# Step 3: Copy .gitignore and .gitconfig to the home directory
echo "Copying .gitignore and .gitconfig to home directory..."
cp ./.dotfiles/.gitignore ~/.gitignore
cp ./.dotfiles/.gitconfig ~/.gitconfig

# Step 4: Check if nix is installed, install if not
if ! command -v nix &>/dev/null; then
  echo "Nix is not installed. Installing..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install
else
  echo "Nix is already installed."
fi

# Step 5: Run the nix command to rebuild with the specified flake
echo "Running nix rebuild with flake..."
nix run nix-darwin/master#darwin-rebuild --switch --flake .#ok-mac-pro
