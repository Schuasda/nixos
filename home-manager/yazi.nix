{ pkgs, ... }:
{
  home-manager.users.schuasda = {
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
        ouch = pkgs.yaziPlugins.ouch;
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
              run = "xdg-open %s1";
              desc = "Open";
              for = "linux";
            }
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
          extract = [
            {
              run = "ouch d -y %*";
              desc = "Extract here with ouch";
              for = "windows";
            }
            {
              run = "ouch d -y \"$@\"";
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
  };
}

# [opener]
# edit = [
# 	{ run = "${EDITOR:-vi} %s", desc = "$EDITOR",      for = "unix", block = true },
# 	{ run = "code %s",          desc = "code",         for = "windows", orphan = true },
# 	{ run = "code -w %s",       desc = "code (block)", for = "windows", block = true },
# ]
# play = [
# 	{ run = "xdg-open %s1",                desc = "Play", for = "linux" },
# 	{ run = "open %s",                     desc = "Play", for = "macos" },
# 	{ run = 'start "" %s1', orphan = true, desc = "Play", for = "windows" },
# 	{ run = "termux-open %s1",             desc = "Play", for = "android" },
# 	{ run = "mediainfo %s1; echo 'Press enter to exit'; read _", block = true, desc = "Show media info", for = "unix" },
# 	{ run = "mediainfo %s1 & pause", block = true, desc = "Show media info", for = "windows" },
# ]
# open = [
# 	{ run = "xdg-open %s1",    desc = "Open", for = "linux" },
# 	{ run = "open %s",         desc = "Open", for = "macos" },
# 	{ run = 'start "" %s1',    desc = "Open", for = "windows", orphan = true },
# 	{ run = "termux-open %s1", desc = "Open", for = "android" },
# ]
# reveal = [
# 	{ run = "xdg-open %d1",         desc = "Reveal", for = "linux" },
# 	{ run = "open -R %s1",          desc = "Reveal", for = "macos" },
# 	{ run = "explorer /select,%s1", desc = "Reveal", for = "windows", orphan = true },
# 	{ run = "termux-open %d1",      desc = "Reveal", for = "android" },
# 	{ run = "clear; exiftool %s1; echo 'Press enter to exit'; read _", desc = "Show EXIF", for = "unix", block = true },
# ]
# extract = [
# 	{ run = "ya pub extract --list %s", desc = "Extract here" },
# ]
# download = [
# 	{ run = "ya emit download --open %S", desc = "Download and open" },
# 	{ run = "ya emit download %S",        desc = "Download" },
# ]

# [open]
# rules = [
# 	# Folder
# 	{ url = "*/", use = [ "edit", "open", "reveal" ] },
# 	# Text
# 	{ mime = "text/*", use = [ "edit", "reveal" ] },
# 	# Image
# 	{ mime = "image/*", use = [ "open", "reveal" ] },
# 	# Media
# 	{ mime = "{audio,video}/*", use = [ "play", "reveal" ] },
# 	# Archive
# 	{ mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", use = [ "extract", "reveal" ] },
# 	# JSON
# 	{ mime = "application/{json,ndjson}", use = [ "edit", "reveal" ] },
# 	{ mime = "*/javascript", use = [ "edit", "reveal" ] },
# 	# Empty file
# 	{ mime = "inode/empty", use = [ "edit", "reveal" ] },
# 	# Virtual file system
# 	{ mime = "vfs/{absent,stale}", use = "download" },
# 	# Fallback
# 	{ url = "*", use = [ "open", "reveal" ] },
# ]
