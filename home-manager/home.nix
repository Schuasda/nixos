{
  inputs,
  outputs,
  pkgs,
  config,
  # lib,
  ...
}:

let
  mytex = import ./tex.nix { inherit pkgs; };

  tex = (
    pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-full;
      inherit (mytex) latex-oth;
    }
  );
  insecureNixPkg = import <nixos> {
    config = {
      permittedInsecurePackages = [
        "electron-39.8.10"
      ];
    };
  };
in
{
  # imports = [inputs.lazyvim.homeManagerModules.default];
  imports = [
    ./yazi.nix
  ];

  nixpkgs.overlays = [ outputs.overlays.unstable-packages ];
  home-manager = {
    backupFileExtension = "backup";
    users.schuasda = {
      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      home.username = "schuasda";
      home.homeDirectory = "/home/schuasda";

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "24.11"; # Please read the comment before changing.

      # The home.packages option allows you to install Nix packages into your
      # environment.
      home.packages = with pkgs; [
        # # Adds the 'hello' command to your environment. It prints a friendly
        # # "Hello, world!" when run.
        # pkgs.hello

        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
        keepassxc
        nixd
        # nomacs
        # doxygen_gui
        glib
        gnome-control-center
        gnome.gvfs
        ouch

        (pkgs.symlinkJoin {
          name = "signal-desktop";
          paths = [ pkgs.unstable.signal-desktop ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/signal-desktop --add-flags --password-store="gnome-keyring"
          '';
        })
        ferdium
        # zapzap
        # element-desktop
        # zulip
        zoom-us
        gnucash
        synology-drive-client
        discord
        spotify
        nextcloud-client

        # vscodium

        devenv
        direnv
        uv
        # godot_4
        google-cloud-sdk
        gnumake
        libGLU
        freeglut
        mesa
        tex

        uutils-coreutils-noprefix
        dust
        dua
        fzf
        # docker-client
        podman
        grc
        fusuma
        nixfmt
        clipboard-jh

        zenith
        zenstates
        zenmonitor

        # todoist-electron
        #planify
        ticktick

        # jetbrains.webstorm
        dbeaver-bin
        # jellyfin-media-player
        delfin
        nodejs
        ungit
        jujutsu
        just
        gittyup
        insomnia
        insecureNixPkg.bitwarden-desktop
        prusa-slicer
        orca-slicer
        inkscape
        figma-linux
        termius

        libreoffice-qt
        hunspell
        hunspellDicts.de_DE
        hunspellDicts.en_US-large
        hunspellDicts.en-gb-large

        #davinci-resolve

        unstable.zotero
        quickemu

        # pdf4qt
        # zathura
        # kdePackages.kate
        kdePackages.okular

        syncthing
        vlc
        obs-studio
        ungoogled-chromium
        # floorp
        ladybird
        openfortivpn
        qalculate-qt
        unstable.rquickshare
        # localsend
        inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default

        unstable.gemini-cli

        prismlauncher

        (lutris.override {
          extraLibraries = pkgs: [

          ];
          extraPkgs = pkgs: [

          ];
        })
        protonup-qt
        wineWow64Packages.stable
        bottles

        # (pkgs.writeShellApplication {
        #   name = "ns";
        #   runtimeInputs = with pkgs; [
        #     fzf
        #     nix-search-tv
        #   ];
        #   text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
        # })
      ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
          "text/html" = "zen-beta.desktop";
          "x-scheme-handler/http" = "zen-beta.desktop";
          "x-scheme-handler/https" = "zen-beta.desktop";
          "x-scheme-handler/about" = "zen-beta.desktop";
          "x-scheme-handler/unknown" = "zen-beta.desktop";
        };
      };

      # Enable git
      programs.git = {
        enable = true;
        lfs.enable = true;
        #TODO: config
      };

      programs.lazygit = {
        enable = true;
        enableFishIntegration = true;
        package = pkgs.unstable.lazygit;
      };

      programs.vscode = {
        # enable = true;
        package = pkgs.unstable.vscodium-fhs;
      };

      programs.vscodium = {
        enable = true;
        package = pkgs.unstable.vscodium-fhs;
      };

      # programs.lazyvim.enable = true;

      programs.neovim = {
        enable = true;
        withRuby = false;
        withPython3 = false;
        defaultEditor = true;
        # extraPackages = with pkgs; [
        #   lua-language-server
        #   stylua
        #   ripgrep
        # ];

        plugins = with pkgs.vimPlugins; [
          # lazy-nvim
          telescope-nvim
          telescope-zoxide
          vim-ghost
        ];

      };

      programs.kitty = {
        enable = true;
        package = pkgs.unstable.kitty;
        shellIntegration.enableFishIntegration = true;

        font = {
          size = 12;
          name = "JetBrains Mono Nerd Font";
        };

        settings = {
          remember_window_size = false;
          initial_window_width = 950;
          initial_window_height = 500;
          cursor_blink_interval = 0.5;
          cursor_stop_blinking_after = 1;
          scrollback_lines = 2000;
          wheel_scroll_min_lines = 1;
          enable_audio_bell = false;
          window_padding_width = 10;
          hide_window_decorations = true;
          background_opacity = 0.7;
          dynamic_background_opacity = true;
          confirm_os_window_close = 0;
        };

        extraConfig = ''
          bold_font             auto;
          italic_font           auto;
          bold_italic_font      auto;
          #selection_foreground  none;
          #selection_background  none;

          # Include pywal colors
          include $HOME/.cache/wal/colors-kitty.conf

          # Include Custom Configuration
          # Create the file custom.conf in ~/.config/kitty to overwrite the default configuration
          include ./custom.conf
        '';
      };

      services.remmina = {
        enable = true;
      };

      programs.rclone = {
        enable = true;
        remotes = {
          # gdrive = {

          # };
        };
      };

      programs.fastfetch = {
        enable = true;
      };

      programs.ripgrep = {
        enable = true;
      };

      programs.ripgrep-all = {
        enable = true;
      };

      programs.fd = {
        enable = true;
      };

      programs.eza = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        git = true;
      };

      programs.gitui = {
        enable = true;
      };

      programs.oh-my-posh = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        configFile = ./ohmyposh/zen.toml;
      };

      programs.zellij = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
      };

      programs.ncspot = {
        enable = true;
      };

      programs.zathura = {
        enable = true;
        options = {
          selection-clipboard = "clipboard";
        };
      };

      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 7d --keep 5";
        flake = "/home/schuasda/nixos-conf";
      };

      programs.bat = {
        enable = true;
      };

      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
      };

      programs.fish = {
        enable = true;
        shellAbbrs = {
          gs = "git status";
          rgf = "rga-fzf";
        };

        shellInit = ''
          set fish_greeting # Disable greeting
        '';
        loginShellInit = ''
          if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]
            # exec uwsm start -S hyprland-uwsm.desktop 
            exec Hyprland
          end
        '';
        interactiveShellInit = ''
          if [ "$TERM" = "xterm-kitty" ] 
            alias ssh="TERM=xterm-256color command ssh"
          end
        '';

        plugins = [
          {
            name = "grc";
            src = pkgs.fishPlugins.grc.src;
          }
          {
            name = "fzf";
            src = pkgs.fishPlugins.fzf-fish.src;
          }
          {
            name = "forgit";
            src = pkgs.fishPlugins.forgit.src;
          }
          {
            name = "pisces";
            src = pkgs.fishPlugins.pisces.src;
          }
          {
            name = "you-should-use";
            src = pkgs.fishPlugins.fish-you-should-use.src;
          }
          {
            name = "done";
            src = pkgs.fishPlugins.done.src;
          }
          {
            name = "colored-man";
            src = pkgs.fishPlugins.colored-man-pages.src;
          }
        ];
      };

      services.kdeconnect = {
        enable = true;
        package = pkgs.kdePackages.kdeconnect-kde;
        indicator = true;
      };

      # Enable firefox
      programs.firefox = {
        enable = true;
        configPath = "$HOME/mozilla/firefox";
      };

      # Enable Nextcloud
      services.nextcloud-client = {
        enable = true;
        startInBackground = true;
        package = pkgs.nextcloud-client;
      };

      wayland.windowManager.hyprland = {
        configType = "hyprlang";
        enable = true;
        # package = builtins.null;
        # portalPackage = builtins.null;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

        systemd.enable = false;
        systemd.variables = [ "--all" ];

        plugins = [
          # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
          # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
        ];
        extraConfig = ''
          ${builtins.readFile ./hyprland.conf}
        '';
      };

      services.hyprpolkitagent = {
        enable = true;
      };

      xdg.portal.config.common.default = "*";

      programs.tex-fmt = {
        enable = true;
        settings = {
          wrap = true;
          wraplen = 200;
          wrap-chars = [
            "."
            ","
          ];
        };
      };

      # Home Manager is pretty good at managing dotfiles. The primary way to manage
      # plain files is through 'home.file'.
      home.file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';

        # ".local/share/texmf".source = ../Dokumente/OTH/Sonstiges/OTH_R_tex/texmf_OTHR;
      };

      # Home Manager can also manage your environment variables through
      # 'home.sessionVariables'. If you don't want to manage your shell through Home
      # Manager then you have to manually source 'hm-session-vars.sh' located at
      # either
      #
      #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  /etc/profiles/per-user/schuasda/etc/profile.d/hm-session-vars.sh
      #
      home.sessionVariables = {
        EDITOR = "nvim";
        XDG_RUNTIME_DIR = "/run/user/$UID";
        # DEFAULT_BROWSER = "${pkgs.zen}/bin/qutebrowser";
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };
}
