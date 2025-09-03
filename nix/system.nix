{ config, pkgs, specialArgs, ... }:

let
  home = specialArgs.home;
in
{
  # Global
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.trackpad.TrackpadRightClick = true;
  system.defaults.NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;
  system.defaults.NSGlobalDomain."com.apple.trackpad.trackpadCornerClickBehavior" = 1;

  # Finder
  system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder._FXSortFoldersFirst = true;
  system.defaults.finder._FXSortFoldersFirstOnDesktop = true;
  system.defaults.finder.FXDefaultSearchScope = "SCcf";
  system.defaults.finder.FXEnableExtensionChangeWarning = false;
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.ShowRemovableMediaOnDesktop = false;
  system.defaults.finder.ShowExternalHardDrivesOnDesktop = true;
  system.defaults.finder.ShowHardDrivesOnDesktop = false;
  system.defaults.finder.ShowMountedServersOnDesktop = false;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;
  system.defaults.finder.NewWindowTarget = "Other";
  system.defaults.finder.NewWindowTargetPath = "file:///${home}/Downloads";

  # Dock
  system.defaults.dock.tilesize = 64;
  system.defaults.dock.largesize = 16;
  system.defaults.dock.orientation = "right";
  system.defaults.dock.mineffect = "genie";
  system.defaults.dock.minimize-to-application = true;
  system.defaults.dock.autohide = false;
  system.defaults.dock.launchanim = true;
  system.defaults.dock.show-process-indicators = true;
  system.defaults.dock.show-recents = false;
  system.defaults.dock.persistent-others = null;

  system.defaults.dock.persistent-apps = [
    "Applications/Google Chrome.app"
    "/System/Applications/Utilities/Terminal.app"
    "/Applications/Visual Studio Code.app"
    "/System/Applications/System Settings.app"
  ];

  # Desktop & Stage manager
  system.defaults.WindowManager.StandardHideDesktopIcons = false;
  system.defaults.WindowManager.HideDesktop = true;
  system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  system.defaults.WindowManager.GloballyEnabled = false;
  system.defaults.spaces.spans-displays = false;

  # Miscellaneous
  #security.pam.services.sudo_local.touchIdAuth = true; # Enable if TouchID exists
  system.defaults.screencapture.location = "~/Documents/screenshots";
  system.defaults.controlcenter.Bluetooth = true;

  # macOS security updates
  system.defaults.CustomUserPreferences."com.apple.SoftwareUpdate".CriticalUpdateInstall = 1;
  # app store updates
  system.defaults.CustomUserPreferences."com.apple.commerce".AutoUpdate = true;

  system.activationScripts.postUserActivation.text = ''
    # Create dirs
    mkdir -p ~/Documents/screenshots ~/Documents/dev

    # Keep: Map bottom right corner to right-click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 0

    # "disable" Writing of .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Set list view as default for all folders
    defaults write com.apple.finder "SearchRecentsSavedViewStyle" -string "Nlsv"
    defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"

    # "disable" Sidebar: Recent Tags
    defaults write com.apple.finder ShowRecentTags -bool false

    # Restart Finder to apply changes
    killall Finder || true
  '';
}
