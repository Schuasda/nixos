{
  config,
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
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
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
    # touchegg
    grub2

    mesa
    libGLU
    libsecret
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-32.3.3"
  ];

  users.users.schuasda.packages =
    # with pkgs;
    [
    ] ++ config.deskenv.packages;

  programs.bash = {
    interactiveShellInit = ''
      	    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      	    then
      	      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      	      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      	    fi
    '';

  };

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
    # enable = true;
    acceleration = "rocm";
    loadModels = [ "deepseek-r1:8b" ];
  };
  services.open-webui = {
    #enable = true;
    package = unstable.open-webui;
  };
}
