{
  config,
  pkgs ? import <nixpkgs> { },
  lib,
  ...
}:
let
  unstable = import <unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  imports = [ ./myModules.nix ];

  # Enable Hyprland Desktop Environment.

 # services.displayManager.sddm.enable = true;
 # services.displayManager.sddm.wayland.enable = true;

  programs.hyprland = {
    enable = true;
    #package = unstable.hyprland;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

   programs.hyprlock = {
     enable = true;
     package = unstable.hyprlock;
   };
   services.hypridle = {
     enable = true;
     package = unstable.hypridle;
   };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-kde
  #     # pkgs.xdg-desktop-portal-hyprland
  #   ];
  # };

  deskenv.packages = with pkgs; [
    hyprpaper
    hyprgui
    waybar

    dunst
    libnotify
    # alacritty
    kitty
    rofi-wayland
    nautilus

    # ml4w packages
    hyprshade
    swaynotificationcenter
    pavucontrol
    blueman
    cliphist
    gum
    oh-my-posh
    waypaper
    pywal
    bibata-cursors
    papirus-icon-theme
    grim
    grimblast
    slurp
    wlogout
    nwg-dock-hyprland
    nwg-look
    figlet
    gnused
    vim
    xdg-user-dirs
    xdg-user-dirs-gtk

    # wallust
  ];

  fonts.packages = with pkgs; [
    font-awesome
  ];
}
