{ config, pkgs, ... }:

{
  imports = [
    ./modules/system.nix
  ];

  # Nix configuration
  system.stateVersion = 6;

  nix.enable = false;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.hostPlatform = "x86_64-darwin";

  # Programs
  programs.zsh.enable = true;

  # Homebrew
  #homebrew = {
    #enable = true;
    #onActivation.autoUpdate = true;
    #onActivation.cleanup = "zap";
  #};
}
