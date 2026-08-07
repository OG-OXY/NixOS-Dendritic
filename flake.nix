#flake.nix
{
  description = "System and Home Manager configuration flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/567a49d1913ce81ac6e9582e3553dd90a955875f";
    flake-parts.url = "github:hercules-ci/flake-parts";
    chaotic.url = "github:chaotic-cx/nyx";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nvf.url = "path:./flakes/NVF";
    llm-agents.url = "path:./flakes/LLM-Agents";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      flake-parts,
      chaotic,
      home-manager,
      stylix,
      ...
    }@inputs:
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [
          {
            nixpkgs = {
              hostPlatform = "x86_64-linux";
              config = {
                allowUnfree = true;
                cudaSupport = true;
                cudaCapabilities = [ "6.1" ];
                permittedInsecurePackages = [
                  "electron-39.8.10"
                ];
              };
              overlays = [
                (
                  final: prev:
                  let
                    stable = import nixpkgs-stable {
                      inherit (prev) system;
                      config = prev.config;
                    };
                  in
                  {
                    #package = packagename.stable
                  }
                )
              ];
            };
            hardware.enableRedistributableFirmware = true;
          }
          ./config.nix
          chaotic.nixosModules.default
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = ".bak";
              users = {
                root = import ./modules/home/root-home.nix;
                ty = import ./modules/home/ty-home.nix;
              };
              extraSpecialArgs = { inherit inputs self; };
            };
          }
        ];
      };
    };
}
