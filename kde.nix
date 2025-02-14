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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.displayManager.defaultSession = "plasmax11";

  services.displayManager.sddm.wayland.enable = true;

  # Enable the Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {

    layout = "de";
    variant = "";
  };

  # Enable KDE Connect
  programs.kdeconnect.enable = true;

  deskenv.packages = with pkgs; [
    kdePackages.poppler
    kdePackages.kio-gdrive
    kdePackages.kaccounts-providers
    kdePackages.kaccounts-integration
  ];
}
