{
  pkgs,
  ...
}:
{
  home.file = {
    "./NixOS/Dendritic/config/hypr/.luarc.json".text = builtins.toJSON {
      workspace = {
        library = [
          "${pkgs.hyprland}/share/hypr/stubs"
        ];
      };
      diagnostics = {
        globals = [ "hl" ];
      };
    };
  };
}
