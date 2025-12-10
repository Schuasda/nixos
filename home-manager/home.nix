{
  inputs,
  outputs,
  pkgs,
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
in
{
  # imports = [inputs.lazyvim.homeManagerModules.default];

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
      home.packages = with pkgs.unstable; [
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
        nomacs
        doxygen_gui
        glib
        gnome-control-center
        gnome.gvfs

        (pkgs.symlinkJoin {
          name = "signal-desktop";
          paths = [ pkgs.unstable.signal-desktop ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/signal-desktop --add-flags --password-store="gnome-keyring"
          '';
        })
        ferdium
        zapzap
        element-desktop
        zulip
        zoom-us
        gnucash
        synology-drive-client
        discord
        spotify

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
        docker-client
        podman
        grc
        fusuma
        nixfmt-rfc-style

        zenith
        zenstates
        zenmonitor

        todoist-electron
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
        bitwarden-desktop
        prusa-slicer
        orca-slicer
        inkscape
        figma-linux

        libreoffice-qt
        hunspell
        hunspellDicts.de_DE
        hunspellDicts.en_US-large
        hunspellDicts.en-gb-large

        #davinci-resolve

        zotero
        quickemu

        pdf4qt
        zathura
        kdePackages.kate
        kdePackages.okular

        syncthing
        vlc
        obs-studio
        # ungoogled-chromium
        # floorp
        ladybird
        openfortivpn
        qalculate-qt
        rquickshare

        prismlauncher

        (lutris.override {
          extraLibraries = pkgs: [

          ];
          extraPkgs = pkgs: [

          ];
        })
        protonup-qt
        wineWowPackages.stable
        bottles

        (pkgs.writeShellApplication {
          name = "ns";
          runtimeInputs = with pkgs; [
            fzf
            nix-search-tv
          ];
          text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
        })
      ];

      # Enable git
      programs.git = {
        enable = true;
        lfs.enable = true;
        #TODO: config
      };

      programs.lazygit = {
        enable = true;
        # enableFishIntegration = true;
        package = pkgs.unstable.lazygit;
      };

      programs.vscode = {
        enable = true;
        package = pkgs.unstable.vscodium-fhs;

      };

      # programs.lazyvim.enable = true;

      programs.neovim = {
        enable = true;
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
        ];

        # extraLuaConfig =
        #   let
        #     plugins = with pkgs.vimPlugins; [
        #       # LazyVim
        #       LazyVim
        #       bufferline-nvim
        #       cmp-buffer
        #       cmp-nvim-lsp
        #       cmp-path
        #       cmp_luasnip
        #       conform-nvim
        #       dashboard-nvim
        #       dressing-nvim
        #       flash-nvim
        #       friendly-snippets
        #       gitsigns-nvim
        #       indent-blankline-nvim
        #       lualine-nvim
        #       neo-tree-nvim
        #       neoconf-nvim
        #       neodev-nvim
        #       noice-nvim
        #       nui-nvim
        #       nvim-cmp
        #       nvim-lint
        #       nvim-lspconfig
        #       nvim-notify
        #       nvim-spectre
        #       nvim-treesitter
        #       nvim-treesitter-context
        #       nvim-treesitter-textobjects
        #       nvim-ts-autotag
        #       nvim-ts-context-commentstring
        #       nvim-web-devicons
        #       persistence-nvim
        #       plenary-nvim
        #       telescope-fzf-native-nvim
        #       telescope-nvim
        #       todo-comments-nvim
        #       tokyonight-nvim
        #       trouble-nvim
        #       vim-illuminate
        #       vim-startuptime
        #       which-key-nvim
        #       {
        #         name = "LuaSnip";
        #         path = luasnip;
        #       }
        #       {
        #         name = "catppuccin";
        #         path = catppuccin-nvim;
        #       }
        #       {
        #         name = "mini.ai";
        #         path = mini-nvim;
        #       }
        #       {
        #         name = "mini.bufremove";
        #         path = mini-nvim;
        #       }
        #       {
        #         name = "mini.comment";
        #         path = mini-nvim;
        #       }
        #       {
        #         name = "mini.indentscope";
        #         path = mini-nvim;
        #       }
        #       {
        #         name = "mini.pairs";
        #         path = mini-nvim;
        #       }
        #       {
        #         name = "mini.surround";
        #         path = mini-nvim;
        #       }
        #     ];
        #     mkEntryFromDrv =
        #       drv:
        #       if lib.isDerivation drv then
        #         {
        #           name = "${lib.getName drv}";
        #           path = drv;
        #         }
        #       else
        #         drv;
        #     lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
        #   in
        #   ''
        #     require("lazy").setup({
        #       defaults = {
        #         lazy = true,
        #       },
        #       dev = {
        #         -- reuse files from pkgs.vimPlugins.*
        #         path = "${lazyPath}",
        #         patterns = { "" },
        #         -- fallback to download
        #         fallback = true,
        #       },
        #       spec = {
        #         { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        #         -- The following configs are needed for fixing lazyvim on nix
        #         -- force enable telescope-fzf-native.nvim
        #         { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
        #         -- disable mason.nvim, use programs.neovim.extraPackages
        #         { "williamboman/mason-lspconfig.nvim", enabled = false },
        #         { "williamboman/mason.nvim", enabled = false },
        #         -- import/override with your plugins
        #         { import = "plugins" },
        #         -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
        #         { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
        #       },
        #     })
        #   '';
      };

      # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
      # xdg.configFile."nvim/parser".source =
      #   let
      #     parsers = pkgs.symlinkJoin {
      #       name = "treesitter-parsers";
      #       paths =
      #         (pkgs.vimPlugins.nvim-treesitter.withPlugins (
      #           plugins: with plugins; [
      #             c
      #             lua
      #           ]
      #         )).dependencies;
      #     };
      #   in
      #   "${parsers}/parser";

      # # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
      # xdg.configFile."nvim/lua".source = ./lua;

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

      programs.zellij = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;

        #attachExistingSession = true;
      };

      programs.ncspot = {
        enable = true;
      };

      programs.yazi = {
        enable = true;
        package = pkgs.unstable.yazi;
        enableFishIntegration = true;
        shellWrapperName = "y";
        initLua = ./init.lua;
        plugins = {
          git = pkgs.yaziPlugins.git;
          lazygit = pkgs.yaziPlugins.lazygit;
          mount = pkgs.yaziPlugins.mount;
        };
        settings = {
          opener = {
            edit = [
              {
                run = "nvim \"$@\"";
                block = true;
              }
            ];
            open = [
              {
                run = "zathura \"$@\"";
                orphan = true;
                desc = "Open with Zathura";
              }
              {
                run = "okular \"$@\"";
                orphan = true;
                desc = "Open with Okular";
              }
            ];
          };
          plugin.prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }

            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];
        };
        keymap = {
          mgr.prepend_keymap = [
            {
              run = "plugin lazygit";
              on = [
                "g"
                "i"
              ];
              desc = "run lazygit";
            }
            {
              run = "plugin mount";
              on = [
                "M"
                "x"
              ];
              desc = "Mount external filesystems";
            }
            {
              run = "plugin gvfs -- select-then-mount ";
              on = [
                "M"
                "m"
              ];
              desc = "Mount with GVFS";
            }
            {
              run = "plugin gvfs -- select-then-mount --jump";
              on = [
                "M"
                "M"
              ];
              desc = "Mount and jump with GVFS";
            }
            {
              on = [
                "M"
                "a"
              ];
              run = "plugin gvfs -- add-mount";
              desc = "Add a GVFS mount URI";
            }
            {
              on = [
                "M"
                "u"
              ];
              run = "plugin gvfs -- select-then-unmount --eject";
              desc = "Select device then eject";
            }
            {
              on = [
                "M"
                "e"
              ];
              run = "plugin gvfs -- edit-mount";
              desc = "Edit a GVFS mount URI";
            }
            {
              on = [
                "M"
                "r"
              ];
              run = "plugin gvfs -- remove-mount";
              desc = "Remove a GVFS mount URI";
            }
            {
              on = [
                "g"
                "m"
              ];
              run = "plugin gvfs -- jump-to-device";
              desc = "Select device then jump to its mount point";
            }
          ];
        };
      };

      programs.nh = {
        enable = true;
        clean.enable = true;
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
        };

        shellInit = ''
          set fish_greeting # Disable greeting
        '';
        loginShellInit = ''
          if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]
            # exec uwsm start -S hyprland-uwsm.desktop 
            exec start-hyprland
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
      programs.firefox.enable = true;

      # Enable Nextcloud
      services.nextcloud-client = {
        enable = true;
        startInBackground = true;
        #hostName = "cloud.fsim-ev.de";
        package = pkgs.nextcloud-client;
      };

      wayland.windowManager.hyprland = {
        enable = true;
        package = builtins.null;
        systemd.enable = false;
        systemd.variables = [ "--all" ];

        plugins = [
          inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
          inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
        ];
        extraConfig = ''
          ${builtins.readFile ./hyprland.conf}
        '';
      };

      xdg.portal.config.common.default = "*";

      programs.tex-fmt.enable = true;

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
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };
}
