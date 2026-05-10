{ pkgs, ... }:

{
  home = {
    username = "siketyan";
    homeDirectory = "/home/siketyan";

    packages = with pkgs; [
      gcc
      gnumake
      protonmail-desktop
      rustup
    ];

    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Naoki Ikeguchi";
        email = "me@s6n.jp";
      };
      commit = {
        gpgsign = true;
      };
      credential = {
        "https://github.com" = {
          helper = "!/etc/profiles/per-user/siketyan/bin/gh auth git-credential";
        };
      };
    };
  };

  programs.ashell = {
    enable = true;
    settings = {
      modules = {
        left = [
          "Workspaces"
        ];
        center = [
          "Window Title"
        ];
        right = [
          "Media Player"
          "SystemInfo"
          "Tray"
          [
            "Privacy"
            "Settings"
            "Tempo"
          ]
        ];
      };
    };
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    systemd.enable = true;
    settings = {
      theme = "Atom One Dark";
      font-size = 10;
    };
  };

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
  };

  programs.discord = {
    enable = true;
  };

  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
        NIXOS_OZONE_WL = 1;
      };
    };
    settings = {
      font = {
        normal = {
          size = 10;
          family = "Noto Sans";
        };
      };
      launcher_window = {
        opacity = 0.90;
      };
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        "color-scheme" = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    iconTheme.name = "Papirus-Dark";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [ pkgs.fcitx5-mozc ];
      settings = {
        globalOptions = {
          Behavior = {
            ActiveByDefault = false;
            DefaultPageSize = 5;
            PreeditEnabledByDefault = true;
            PreloadInputMethod = true;
            ShowFirstInputMethodInformation = true;
            ShowInputMethodInformation = true;
          };

          HotKey = {
            ModifierOnlyKeyTimeout = 250;
          };

          # Activate/Deactive IME by Super L/R
          "HotKey/ActivateKeys"."0" = "Super_R";
          "HotKey/DeactivateKeys"."0" = "Super_L";

          "HotKey/PrevPage"."0" = "Up";
          "HotKey/NextPage"."0" = "Down";
          "HotKey/PrevCandidate"."0" = "Shift+Tab";
          "HotKey/NextCandidate"."0" = "Tab";
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            DefaultIM = "mozc";
            "Default Layout" = "us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";

          GroupOrder = {
            "0" = "Default";
          };
        };
      };
    };
  };
}
