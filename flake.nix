#flake.nix
{
  description = "System Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "path:./flakes/NVF";
    llm-agents.url = "path:./flakes/LLM-Agents";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      flake-parts,
      import-tree,
      wrappers,
      chaotic,
      home-manager,
      sops,
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
          import-tree.nixosModules.import-tree
          wrappers.nixosModules.wrappers
          chaotic.nixosModules.default
          sops.nixosModules.sops
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
