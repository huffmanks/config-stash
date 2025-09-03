{ config, pkgs, specialArgs, ... }:

let
  home = specialArgs.home;
in
{
  imports = [
    ./system.nix
  ];

  # Nix configuration
  system.stateVersion = 6;
  nix.enable = false;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.hostPlatform = "x86_64-darwin";

  # System packages
  # environment.systemPackages = with pkgs; [
  #   ffmpeg
  #   jq
  #   bat
  #   gh
  #   pipx
  # ];

  # # zsh
  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   enableFastSyntaxHighlighting = true;
  #   shellInit = ''
  #     source ${home}/.nix-config/.dotfiles/.zshrc
  #   '';
  # };

}
