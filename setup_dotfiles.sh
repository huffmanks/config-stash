#!/bin/bash

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Check if the script should skip OS-specific installation
if [[ "$1" == "--skip-install" ]]; then
    echo "Skipping OS-specific installation..."
else
    # Check if the system is Linux
    if [[ $(uname) == "Linux" ]]; then
        # Update package list and install necessary tools
        sudo apt update && sudo apt upgrade -y || handle_error "Failed to update or upgrade packages"
        sudo apt install -y git gh bat || handle_error "Failed to install git, gh and bat"

        # Install nvm and nodejs
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash || handle_error "Failed to install nvm"
        nvm install --lts || handle_error "Failed to install Node.js"

        # Install yarn and pnpm
        npm i -g yarn pnpm || handle_error "Failed to install yarn and pnpm"
    fi

    # Check if the system is macOS
    if [[ $(uname) == "Darwin" ]]; then
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || handle_error "Failed to install Homebrew"

        # Install necessary tools using Homebrew
        brew install gh bat node || handle_error "Failed to install gh, bat and node with Homebrew"

        # Install yarn and pnpm
        npm i -g yarn pnpm || handle_error "Failed to install yarn and pnpm"
    fi
fi

# Setup zsh
cat ./dotfiles/zsh/.zprofile > ~/.zprofile
cat ./dotfiles/zsh/.zshrc > ~/.zshrc

# Setup global git config
cat ./dotfiles/git/.gitignore > ~/.gitignore
git config --global core.excludesfile ~/.gitignore
cat ./dotfiles/git/.gitconfig > ~/.gitconfig

echo "Dotfiles setup complete."
