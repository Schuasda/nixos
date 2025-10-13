# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  nix.settings = {
    experimental-features = [ "nix-command flakes" ];
    trusted-users = [ "schuasda" ];

  };

  imports = [
    # Include the results of the hardware scan.
    <nixos-hardware/framework/16-inch/7040-amd>
    <home-manager/nixos>
    ./hardware-configuration.nix

    ./myModules.nix

    ./hypr.nix
    # ./kde.nix

    ./packages.nix

    ./home.nix
  ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    grub = {
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      # set $FS_UUID to the UUID of the EFI partition
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root $FS_UUID
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  services.logrotate.checkConfig = false;

  # Enable auto upgrade
  system.autoUpgrade.enable = true;

  virtualisation.docker.enable = true;

  # Enable garbage collection in the NixStore
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Systemd-timers
  systemd.timers."downloads-cleanup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      Unit = "downloads-cleanup.service";
    };
  };

  # Systemd-services
  systemd.services."downloads-cleanup" = {
    script = ''
      		find ~/Downloads/ -type f -mtime +60 -delete
      		find ~/Downloads/ -type d -empty -delete
      	  '';
    serviceConfig = {
      Type = "oneshot";
      User = "schuasda";
    };
  };

  networking.hostName = "SchuasdaNix"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  #  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  #
  #  services.resolved = {
  #    enable = true;
  #    dnssec = "true";
  #    domains = [ "~." ];
  #    fallbackDns = [
  #      "1.1.1.1#one.one.one.one"
  #      "1.0.0.1#one.one.one.one"
  #    ];
  #    dnsovertls = "true";
  #  };

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Use local time for RTC to fix windows time
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable Firmware Update through fwupd
  services.fwupd.enable = true;

  # Enable fingerprint reader
  services.fprintd.enable = true;

  services.envfs.enable = true;

  # Configure console keymap0
  console.keyMap = "de";

  # Remap Capslock to Esc on click and Ctrl on hold. Map L_Ctrl+Capslock to still toggle Capslock
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
          };
          "control:C" = {
            capslock = "capslock";
          };
        };
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable printer autodiscovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable flatpak
  services.flatpak.enable = true;

  # Enable sound with pipewire.
  #  sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # security = {
  #   pam.services.kwallet = {
  #     name = "kwallet";
  #     enableKwallet = true;
  #   };
  # };

  # Enable Mopidy msuic server
  services.mopidy = {
    enable = false;
    extensionPackages = with pkgs; [
      mopidy-local
      mopidy-iris
      mopidy-spotify
      mopidy-soundcloud
    ];
    configuration = ''
      		[file]
      		enabled = true
      		media_dirs =
      		    home/schuasda/Music/ |Music
      		show_dotfiles = false
      		excluded_file_extensions =
      		  .directory
      		  .html
      		  .jpeg
      		  .jpg
      		  .log
      		  .nfo
      		  .pdf
      		  .png
      		  .txt
      		  .zip
      		follow_symlinks = false
      		metadata_timeout = 1000

      		[spotify]
      		username = simon@fonto.de	
      		password = 
      		client_id = 9961d79b-c6e6-49c7-80fd-e0276a840b37
      		client_secret = O7_T_Fi4N53HAm2Q1hFrLBSo5-alIz7UOSchiM8QswA=
      	'';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable installation of programs with unfree an licnese.
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.schuasda = {
    isNormalUser = true;
    description = "Simon Lehmair";
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "video"
      "gamemode"
      "wireshark"
      "docker"
    ];
  };

  services.getty.autologinUser = "schuasda";

  # Disable automatic login for the user.
  services.displayManager.sddm = {
    enable = false;
    wayland.enable = true;

    # autoLogin = {
    #   enable = false;
    #   user = "schuasda";
    # };
  };

  # Prevent wake up in backpack
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0018", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
  '';

  # Configure other environment parameters
  environment.etc = {
    # touchpad palm rejection
    "libinput/local-overrides.quirks".text = ''
      	  [Keyboard]
      	  MatchUdevType=keyboard
      	  MatchName=Framework Laptop 16 Keyboard Module - ANSI Keyboard
      	  AttrKeyboardIntegration=internal
      	'';
  };

  environment.localBinInPath = true;

  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -la";
  };

  programs.nix-ld.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable power-profiles-daemon
  services.power-profiles-daemon.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };

  networking.wg-quick.interfaces.kicc = {
    configFile = "/home/schuasda/kicc.conf";

    autostart = false;

  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
