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
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    nixfmt-rfc-style
    zoxide
    wget
    zip
    unzip
    rsync
    cheese
    thunderbird
    gcc
    gdb
    fprintd
    nix-update
    htop
    gparted
    gh
    touchegg
    grub2
  ];

  users.users.schuasda.packages =
    with pkgs;
    [
      keepassxc

      signal-desktop
      whatsapp-for-linux
      zulip
      discord
      spotify
      unstable.vscode-fhs

      fishPlugins.grc
      fishPlugins.fzf-fish
      fishPlugins.forgit
      fzf
      grc

      todoist-electron
      #unstable.planify
      unstable.ticktick

      jetbrains.webstorm
      dbeaver-bin
      jellyfin-media-player
      nodejs
      ungit # doesn't work
      just
      gittyup
      insomnia
      texliveFull
      bitwarden
      unstable.prusa-slicer

      libreoffice-qt
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US-large
      hunspellDicts.en-gb-large

      zotero
      quickemu

      # kdePackages.poppler
      # kdePackages.kio-gdrive
      # kdePackages.kaccounts-providers
      # kdePackages.kaccounts-integration

      syncthing
      vlc
      obs-studio
      ungoogled-chromium
      unstable.floorp
      openfortivpn
      qalculate-qt
      nextcloud-client
      rquickshare
      fastfetch

      (lutris.override {
        extraLibraries = pkgs: [

        ];
        extraPkgs = pkgs: [

        ];
      })
      protonup-qt
      unstable.wineWowPackages.stable
      # winetricks

      # hyprland
      # (waybar.overrideAttrs (oldAttrs: {
      #   mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      # }))
      # dunst
      # libnotify
      # kitty
      # # alacritty
      # kitty
      # rofi-wayland
      # nautilus

      #vivaldi
    ]
    ++ config.deskenv.packages;

  # Enable git
  programs.git = {
    enable = true;
    #TODO: config
  };

  programs.fish = {
    enable = true;
    shellInit = "zoxide init fish | source";
  };
  programs.bash = {
    interactiveShellInit = ''
      	    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      	    then
      	      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      	      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      	    fi
      	  '';

  };

  # Enable firefox
  programs.firefox.enable = true;

  # Enable and configure Steam
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.gamemode = {
    enable = true;
    settings.general.inhibit_screensaver = 0;
  };

  # Enable Ausweisapp and open firewall
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    loadModels = [ "deepseek-r1:8b" ];
  };
  services.open-webui = {
    #enable = true;
    package = unstable.open-webui;
  };
}
