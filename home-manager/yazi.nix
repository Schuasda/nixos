{ pkgs, inputs, ... }:
{
  # imports = [
  #   (inputs.nix-yazi-plugins.packages.${pkgs.stdenv.hostPlatform.system}.homeManagerModules.default)
  # ];
  home-manager.users.schuasda = {
    programs.yazi = {
      enable = true;
      package = pkgs.unstable.yazi;
      enableFishIntegration = true;
      shellWrapperName = "y";
      initLua = ./init.lua;
      plugins = with pkgs; {
        git = yaziPlugins.git;
        lazygit = yaziPlugins.lazygit;
        mount = yaziPlugins.mount;
        ouch = yaziPlugins.ouch;
        system-clipboard =
          inputs.nix-yazi-plugins.packages.${pkgs.stdenv.hostPlatform.system}.system-clipboard;
        bunny = "${inputs.bunny-yazi}";
        # system-clipboard.enable = true;
      };
      settings = {
        opener = {
          edit = [
            {
              run = "nvim %s";
              block = true;
            }
          ];
          open = [
            {
              run = "xdg-open %s1";
              desc = "Open";
              for = "linux";
            }
            {
              run = "zathura %s";
              orphan = true;
              desc = "Open with Zathura";
            }
            {
              run = "okular %s";
              orphan = true;
              desc = "Open with Okular";
            }
          ];
          extract = [
            {
              run = "ouch d -y %*";
              desc = "Extract here with ouch";
              for = "windows";
            }
            {
              run = "ouch d -y %s";
              desc = "Extract here with ouch";
              for = "unix";
            }
          ];
        };

        open = {
          rules = [
            # Folder
            {
              url = "*/";
              use = [
                "edit"
                "open"
                "reveal"
              ];
            }
            # Text
            {
              mime = "text/*";
              use = [
                "edit"
                "reveal"
              ];
            }
            # Image
            {
              mime = "image/*";
              use = [
                "open"
                "reveal"
              ];
            }
            # Media
            {
              mime = "{audio,video}/*";
              use = [
                "play"
                "reveal"
              ];
            }
            # Archive
            {
              mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
              use = [
                "extract"
                "reveal"
              ];
            }
            # JSON
            {
              mime = "application/{json,ndjson}";
              use = [
                "edit"
                "reveal"
              ];
            }
            {
              mime = "*/javascript";
              use = [
                "edit"
                "reveal"
              ];
            }
            # Empty file
            {
              mime = "inode/empty";
              use = [
                "edit"
                "reveal"
              ];
            }
            # Virtual file system
            {
              mime = "vfs/{absent,stale}";
              use = [ "download" ];
            }
            # Fallback
            {
              url = "*";
              use = [
                "open"
                "reveal"
              ];
            }
          ];
        };

        plugin.prepend_previewers = [
          {
            id = "ouch";
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch";
          }
        ];
        plugin.prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
            group = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "Z";
            run = "plugin fzf";
            desc = "Jump to a file/directory via fzf";
          }
          {
            on = "z";
            run = "plugin zoxide";
            desc = "Jump to a directory via zoxide";
          }
          {
            on = "<C-h>";
            run = "tab_switch -1 --relative";
            desc = "Switch to previous tab";
          }
          {
            on = "<C-l>";
            run = "tab_switch 1 --relative";
            desc = "Switch to next tab";
          }
          # bunny (bookmarks)
          {
            on = "b";
            run = "plugin bunny";
            desc = "Start bunny.yazi";
          }
          {
            on = "B";
            run = "plugin bunny fuzzy";
            desc = "Start bunny.yazi fuzzy search";
          }
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
          {
            on = [
              "<C-y>"
            ];
            run = "plugin system-clipboard";
            desc = "Copy selection to system clipboard";
          }
        ];
      };
    };
  };
}
