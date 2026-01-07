{
  inputs,
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # Enable Hyprland Desktop Environment.

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    # withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  programs.uwsm = {
    enable = false;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };

  services.gnome = {
    gnome-keyring.enable = true;
    # Gnome online accounts (Google Drive, Nextcloud, etc.)
    gnome-online-accounts.enable = true;
  };
  programs.seahorse.enable = true; # enable the graphical frontend for managing

  security.pam.services = {
    # greetd.enableGnomeKeyring = true;
    # greetd-password.enableGnomeKeyring = true;
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
    package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;
  };

  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle;
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [
  #       pkgs.xdg-desktop-portal-gnome
  #   ];
  # };

  deskenv.packages = with pkgs; [
    hyprpaper
    swww
    # hyprgui
    waybar
    hyprpolkitagent
    hyprls

    dunst
    libnotify
    # alacritty
    # kitty
    rofi
    nautilus
    kdePackages.dolphin
    nwg-displays

    # ml4w packages
    # hyprshade
    # swaynotificationcenter
    # pavucontrol
    # blueman
    # cliphist
    # gum
    oh-my-posh
    # waypaper
    # pywal
    # bibata-cursors
    # papirus-icon-theme
    # material-icons
    # grim
    # grimblast
    # slurp
    # wlogout
    # nwg-dock-hyprland
    # nwg-look
    # figlet
    # gnused
    # # vim
    # xdg-user-dirs
    # xdg-user-dirs-gtk
    # brightnessctl
    # playerctl
    # jq
    # polkit
    # wl-clipboard
    # # yay
    # pacman
    # killall

    # ml4w dependencies
    wget
    unzip
    gum
    rsync
    git
    figlet
    xdg-user-dirs
    hyprland
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    libnotify
    kitty
    # qt5-wayland
    libsForQt5.qt5ct
    # qt6-wayland
    kdePackages.qt6ct
    fastfetch
    eza
    python313Packages.pip
    python313Packages.pygobject3
    python313Packages.screeninfo
    xfce.tumbler
    brightnessctl
    # nm-connection-editor
    # network-manager-applet
    networkmanagerapplet
    imagemagick
    jq
    xclip
    kitty
    neovim
    htop
    blueman
    grim
    slurp
    cliphist
    nwg-look
    qt6Packages.qt6ct
    waybar
    rofi
    polkit_gnome
    zsh
    zsh-completions
    fzf
    pavucontrol
    papirus-icon-theme
    kdePackages.breeze
    flatpak
    swaynotificationcenter
    gvfs
    wlogout
    waypaper
    grimblast
    bibata-cursors
    font-awesome
    fira-sans
    fira-code
    # firacode-nerd
    nerd-fonts.fira-code
    nwg-dock-hyprland
    power-profiles-daemon
    pywalfox-native
    vlc
    material-icons
    colloid-icon-theme
  ];

  fonts.packages = with pkgs; [
    font-awesome
  ];
}
