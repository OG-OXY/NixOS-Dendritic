#home.nix
{
  ...
}:
{
  home = {
    stateVersion = "26.11";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      EDITOR = "nvf";
      VISUAL = "nvf";
    };
    file = {
      "NixOS/secretspec.toml".text = ''
        [project]
        name = "global-dev"
        revision = "1.0"

        [profiles.default]
        GITHUB_TOKEN = { description = "Global GitHub Access token" }
        GOOGLE_API_KEY = { description = "Google API Key for Aider" }
      '';
      ".config/tealdeer/config.toml".source = ./config/tealdeer/config.toml;
    };
  };

  xdg = {
    configFile = {
      "secretspec/config.toml".text = ''
        [defaults]
        provider = "keyring"
        profile = "default"
      '';
      "hypr/hyprland.lua".source = ./config/hypr/hyprland.lua;
    };
    dataFile = {
      #
    };
  };

  systemd.user = {
    sessionVariables = {
      PINENTRY_USER_DATA = "gtk";
    };
  };

  imports = [
    ./homeModules.nix
  ];

  programs = {
    waybar = {
      enable = true;
      systemd.enable = true;
    };
    herdr.enable = true;
    devenv.enable = true;
    home-manager.enable = true;
  };
}
