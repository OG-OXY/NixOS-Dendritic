#systemModules.nix
{
  ...
}:
{
  imports = [
    ./modules/system/hardware.nix
    ./modules/system/nvidia.nix
  ];
}
