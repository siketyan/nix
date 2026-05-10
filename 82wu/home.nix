{ config, pkgs, ... }:

{
  home = {
    username = "siketyan";
    homeDirectory = "/home/siketyan";

    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  programs.vscode = {
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
        nromal = {
          size = 10;
          family = "Noto Sans";
        };
      };
      launcher_window = {
        opacity = 0.90;
      };
    };
  };

  gtk = {
    enable = true;
    iconTheme.name = "Papirus-Dark";
  };
}
