#fastfetch.nix
{
  ...
}:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        type = "auto";
        color = {
          "1" = "blue";
          "2" = "cyan";
        };
        padding = {
          top = 0;
          left = 0;
          right = 2;
        };
      };
      display = {
        separator = "➜ ";
        color = {
          keys = "blue";
          title = "blue";
        };
        percent = {
          type = 3;
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        #"de"
        "wm"
        #"wmtheme",
        #"theme"
        #"icons"
        #"font"
        #"cursor"
        "terminal"
        #"terminalfont"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "localip"
        #"battery"
        #"poweradapter"
        #"locale"
        #"break"
        "colors"
      ];
    };
  };
}
