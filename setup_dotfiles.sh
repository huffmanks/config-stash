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
        sudo apt install -y git gh bat jq ffmpeg || handle_error "Failed to install git, gh, bat, jq and ffmpeg"

        # Install nvm and nodejs
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r .tag_name)/install.sh | bash || handle_error "Failed to install nvm"
        nvm install --lts || handle_error "Failed to install Node.js"

        # Install yarn and pnpm
        npm i -g yarn pnpm dotenv-cli || handle_error "Failed to install yarn, pnpm and dotenv-cli"
    fi

    # Check if the system is macOS
    if [[ $(uname) == "Darwin" ]]; then
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || handle_error "Failed to install Homebrew"

        # Install necessary tools using Homebrew
        brew install gh bat jq ffmpeg watchman && brew install --cask zulu@17 || handle_error "Failed to install gh, bat, jq, ffmpeg, watchman and zulu with Homebrew"

        # Install nvm and nodejs
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r .tag_name)/install.sh | bash || handle_error "Failed to install nvm"
        nvm install --lts || handle_error "Failed to install Node.js"

        # Install yarn and pnpm
        npm i -g yarn pnpm eas-cli dotenv-cli || handle_error "Failed to install yarn, pnpm, eas-cli and dotenv-cli"

        # Download and install Google Chrome
        CHROME_URL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
        CHROME_DMG="/tmp/GoogleChrome.dmg"
        curl -L -o "$CHROME_DMG" "$CHROME_URL" || handle_error "Failed to download Google Chrome"
        hdiutil attach "$CHROME_DMG" || handle_error "Failed to mount Google Chrome DMG"
        cp -r "/Volumes/Google Chrome/Google Chrome.app" /Applications/ || handle_error "Failed to install Google Chrome"
        hdiutil detach "/Volumes/Google Chrome" || handle_error "Failed to unmount Google Chrome DMG"

        # Detect macOS architecture
        ARCHITECTURE=$(uname -m)

        # Visual Studio Code download URLs
        if [[ "$ARCHITECTURE" == "arm64" ]]; then
            # Apple Silicon (M1/M2)
            VSCODE_URL="https://update.code.visualstudio.com/latest/darwin-arm64/stable"
        else
            # Intel-based Macs
            VSCODE_URL="https://update.code.visualstudio.com/latest/darwin/stable"
        fi

        # Download and install Visual Studio Code
        VSCODE_DMG="/tmp/VisualStudioCode.dmg"
        curl -L -o "$VSCODE_DMG" "$VSCODE_URL" || handle_error "Failed to download VSCode"
        hdiutil attach "$VSCODE_DMG" || handle_error "Failed to mount VSCode DMG"
        cp -r "/Volumes/Visual Studio Code/Visual Studio Code.app" /Applications/ || handle_error "Failed to install Visual Studio Code"
        hdiutil detach "/Volumes/Visual Studio Code" || handle_error "Failed to unmount VSCode DMG"

        # Download and install the latest stable version of Postgres.app
        POSTGRES_URL="https://get.enterprisedb.com/postgresql/postgresql-$(curl -s https://api.github.com/repos/PostgresApp/PostgresApp/releases/latest | jq -r .tag_name | sed 's/^v//')-1.dmg"
        POSTGRES_DMG="/tmp/Postgres.dmg"
        curl -L -o "$POSTGRES_DMG" "$POSTGRES_URL" || handle_error "Failed to download Postgres.app"
        hdiutil attach "$POSTGRES_DMG" || handle_error "Failed to mount Postgres DMG"
        cp -r "/Volumes/PostgreSQL/Postgres.app" /Applications/ || handle_error "Failed to install Postgres.app"
        hdiutil detach "/Volumes/PostgreSQL" || handle_error "Failed to unmount Postgres DMG"

        # Download and install Postman
        POSTMAN_URL="https://dl.pstmn.io/download/latest/osx"
        POSTMAN_ZIP="/tmp/Postman.zip"
        curl -L -o "$POSTMAN_ZIP" "$POSTMAN_URL" || handle_error "Failed to download Postman"
        unzip "$POSTMAN_ZIP" -d /Applications/ || handle_error "Failed to unzip Postman"
        rm "$POSTMAN_ZIP" || handle_error "Failed to clean up Postman zip file"

        # Download and install Android Studio
        ANDROID_URL=$(curl -s https://developer.android.com/studio#downloads | grep -o 'https://dl.google.com/dl/android/studio/install/.*-mac.dmg' | head -n 1)
        ANDROID_DMG="/tmp/AndroidStudio.dmg"
        curl -L -o "$ANDROID_DMG" "$ANDROID_URL" || handle_error "Failed to download Android Studio"
        hdiutil attach "$ANDROID_DMG" || handle_error "Failed to mount Android Studio DMG"
        cp -r "/Volumes/Android Studio/Android Studio.app" /Applications/ || handle_error "Failed to install Android Studio"
        hdiutil detach "/Volumes/Android Studio" || handle_error "Failed to unmount Android Studio DMG"

        # Download and install OneDrive
        ONEDRIVE_URL="https://go.microsoft.com/fwlink/p/?linkid=823060"
        ONEDRIVE_PKG="/tmp/OneDrive.pkg"
        curl -L -o "$ONEDRIVE_PKG" "$ONEDRIVE_URL" || handle_error "Failed to download OneDrive"
        sudo installer -pkg "$ONEDRIVE_PKG" -target / || handle_error "Failed to install OneDrive"
        rm "$ONEDRIVE_PKG" || handle_error "Failed to clean up OneDrive installer"

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
