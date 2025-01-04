{
  description = "A Nix-flake-based Go 1.23 development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/4005c3ff7505313cbc21081776ad0ce5dfd7a3ce";

  outputs = {
    self,
    nixpkgs,
  }: let
    goVersion = 23;

    supportedSystems = ["x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [self.overlays.default];
          };
        });
  in {
    overlays.default = final: prev: {
      go = final."go_1_${toString goVersion}";
    };

    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          go
          gotools
          golangci-lint
          gofumpt

          # LSP
          golangci-lint-langserver
          gopls

          # Debugger
          delve
        ];
      };
    });
  };
}
