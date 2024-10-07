# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ 
  config, 
  pkgs ? import <nixpkgs> {},
  ... 
}:

let
    unstable = import <unstable> { config = { allowUnfree = true; }; };
in {
  nix.settings.experimental-features = [ "nix-command" ];

  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/framework/16-inch/7040-amd>
      ./hardware-configuration.nix
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

  # Enable garbage collection in the NixStore
  nix.gc = {
  	automatic = true;
  	dates = "16:00";
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
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.defaultSession = "plasmax11";

#  services.displayManager.sddm.wayland.enable = true;
  
  # Enable the Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;


  # Enable fingerprint reader
  services.fprintd.enable = true;
    
  # Configure keymap in X11
  services.xserver.xkb = {

    layout = "de";
    variant = "";
  };

  # Configure console keymap0
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
	enable = true;
  	nssmdns4 = true;
  	openFirewall = true;
  };


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable Mopidy msuic server
  services.mopidy = {
	enable = true;
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
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.schuasda = {
    isNormalUser = true;
    description = "Simon Lehmair";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
	keepassxc

	signal-desktop
	whatsapp-for-linux
	zulip
	discord
	spotify
	unstable.vscode-fhs
	
	unstable.todoist-electron
	unstable.planify
	
	jetbrains.webstorm
	dbeaver-bin
	jellyfin-media-player
	nodejs_22
	just
	gittyup
	insomnia
	texliveFull

	libreoffice-qt
		hunspell
		hunspellDicts.de_DE
		hunspellDicts.en_US-large
		hunspellDicts.en-gb-large

	zotero
	quickemu
		
	kdePackages.poppler
	syncthing
	fish
	vlc
	obs-studio
	ungoogled-chromium
	openfortivpn
	qalculate-qt
	nextcloud-client
	rquickshare

	(lutris.override 
	 {
	   extraLibraries = pkgs: [
		
	   ];
	   extraPkgs = pkgs: [
	   	
	   ];
	 })

	#vivaldi
    ];
  };

  # Disable automatic login for the user.
  services.displayManager.autoLogin.enable = false;
  services.displayManager.autoLogin.user = "schuasda";


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	neovim
	zoxide
	wget
	gnome.cheese
	thunderbird
	gcc
	gdb
	fprintd
	nix-update
	gparted
	gh
	touchegg
  ];


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

  # Enable git
  programs.git = {
	enable = true;
	#TODO: config	
  };

  #test

  # Enable firefox
  programs.firefox.enable = true;

  # Enable and configure Steam
  programs.steam = {
  	enable = true;
  	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Enable Ausweisapp and open firewall
  programs.ausweisapp = {
	enable = true;
	openFirewall = true;
  };

  # Enable KDE Connect
  programs.kdeconnect.enable = true;


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
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
