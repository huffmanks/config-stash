{ config, ... }:

{
  # Global
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.trackpad.TrackpadRightClick = true;
  system.defaults.trackpad.TrackpadCornerSecondaryClick = 2;

  # Finder
  system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder._FXSortFoldersFirst = true;
  system.defaults.finder._FXSortFoldersFirstOnDesktop = true;
  system.defaults.finder._FXShowPosixPathInTitle = false; # remove
  system.defaults.finder.FXDefaultSearchScope = "SCcf";
  system.defaults.finder.FXEnableExtensionChangeWarning = false;
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.ShowExternalHardDrivesOnDesktop = false;
  system.defaults.finder.ShowHardDrivesOnDesktop = false;
  system.defaults.finder.ShowMountedServersOnDesktop = false;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;
  system.defaults.finder.NewWindowTarget = "Other";
  system.defaults.finder.NewWindowTargetPath = "file:///Users/huffmanks/Downloads";

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

  system.defaults.dock.persistent-apps = [
    "/System/Applications/Google Chrome.app"
    "/System/Applications/Utilities/Terminal.app"
    "/System/Applications/System Settings.app"
  ];

  # Desktop & Stage manager
  system.defaults.WindowManager.StandardHideDesktopIcons = false;
  system.defaults.WindowManager.HideDesktop = true;
  system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  system.defaults.WindowManager.GloballyEnabled = false;
  system.defaults.spaces.spans-displays = false;

  # Miscellaneous
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults.screencapture.location = "~/Documents/screenshots";

  # Avoid creating .DS_Store files on network or USB volumes
  # targets.darwin.defaults."com.apple.desktopservices".DSDontWriteNetworkStores = true;
  # targets.darwin.defaults."com.apple.desktopservices".DSDontWriteUSBStores = true;

  # macOS security updates
  system.defaults.CustomUserPreferences."com.apple.SoftwareUpdate".CriticalUpdateInstall = 1;
  # app store updates
  system.defaults.CustomUserPreferences."com.apple.commerce".AutoUpdate = true;


  system.activationScripts.postUserActivation.text = ''
    # Set list view as default for all folders
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Create screenshots directory if it doesn't exist, then set location
    mkdir -p ~/Documents/screenshots
    defaults write com.apple.screencapture location ~/Documents/screenshots

    # Configure Finder list view settings (columns, order, and behavior)
    for domain in StandardViewSettings ComputerViewSettings NetworkViewSettings; do
      # First ensure ListViewSettings exists with default values
      defaults write com.apple.finder $domain -dict-add "ListViewSettings" '{}'

      # Now set the individual properties
      defaults write com.apple.finder $domain.ListViewSettings.columns.Name -dict visible -bool true
      defaults write com.apple.finder $domain.ListViewSettings.columns."Date Modified" -dict visible -bool true
      defaults write com.apple.finder $domain.ListViewSettings.columns."Date Created" -dict visible -bool true
      defaults write com.apple.finder $domain.ListViewSettings.columns.Size -dict visible -bool true
      defaults write com.apple.finder $domain.ListViewSettings.columns.Kind -dict visible -bool true

      # Set column order as array
      defaults write com.apple.finder $domain.ListViewSettings.columnOrder -array "Name" "Date Modified" "Date Created" "Size" "Kind"

      # Set other list view properties
      defaults write com.apple.finder $domain.ListViewSettings.sortColumn -string "Date Modified"
      defaults write com.apple.finder $domain.ListViewSettings.useRelativeDates -bool true
      defaults write com.apple.finder $domain.ListViewSettings.calculateAllSizes -bool true
    done

    # Restart Finder to apply changes
    killall Finder || true
  '';
}
