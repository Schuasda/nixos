{
  pkgs ? import <nixpkgs> { },
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
  # imports = [ ./myModules.nix ];

  # Enable Hyprland Desktop Environment.

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;

  programs.hyprland = {
    enable = true;
    package = unstable.hyprland;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true; # enable the graphical frontend for managing

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
  };

  services.dbus.packages = [
    pkgs.gnome-keyring
    pkgs.gcr
  ];

  services.xserver.displayManager.sessionCommands = ''
    eval $(gnome-keyring-daemon --start --daemonize --components=ssh,secrets)
    export SSH_AUTH_SOCK
  '';

  systemd.packages = with pkgs; [
    hyprpolkitagent
    swaynotificationcenter
  ];

  systemd.user.services.hyprpolkitagent = {
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
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
  #     # pkgs.kdePackages.xdg-desktop-portal-kde
  #     # pkgs.xdg-desktop-portal
  #     # pkgs.xdg-desktop-portal-hyprland
  #   ];
  #   # configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
  #   # config.common.default = "*";
  # };

  deskenv.packages = with pkgs; [
    unstable.hyprland
    hyprpaper
    # hyprgui
    waybar
    hyprpolkitagent
    hyprls

    dunst
    libnotify
    # alacritty
    # unstable.kitty
    rofi-wayland
    nautilus
    kdePackages.dolphin
    nwg-displays

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
    brightnessctl
    playerctl
    jq
    polkit_gnome
    wl-clipboard
    unstable.yay
    pacman
    killall
  ];

  fonts.packages = with pkgs; [
    font-awesome
  ];
}
