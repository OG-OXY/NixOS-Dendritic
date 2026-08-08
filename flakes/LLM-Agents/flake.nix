{
  description = "AI Agent-Hub Package with Devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, llm-agents, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      config = nixpkgs.config.allowUnfree;
    in
    {
      packages = forAllSystems (
        system:
        let
          agents = llm-agents.packages.${pkgs.system};
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          inherit config;
          default = pkgs.symlinkJoin {
            name = "numtide_llm-agents";
            paths = [
              agents.claude-code
              agents.crush
              agents.goose-cli
            ];
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          agents = llm-agents.packages.${pkgs.system};
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          inherit config;
          default = pkgs.mkShell {
            name = "numtide_llm-agents-shell";
            nativeBuildInputs = [
              agents.claude-code
              agents.crush
              agents.goose-cli

              pkgs.herdr
              pkgs.llama-cpp
              pkgs.nodejs_22
              pkgs.ripgrep
              pkgs.gawk
              pkgs.bun
              pkgs.gh
              pkgs.fd
              pkgs.fzf
              pkgs.jq
              pkgs.git
            ];
            shellHook = ''
              echo "========================================================"
              echo " 🤖 AI AGENT SANDBOX ACTIVATED                          "
              echo " System Context: ${pkgs.system}                         "
              echo " Available: claude-code, crush, goose                   "
              echo "========================================================"
              export PATH="$PWD/node_modules/.bin:$PATH"
            '';
          };
        }
      );
    };
}
