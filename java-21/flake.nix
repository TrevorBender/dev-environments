{
  description = "A Nix-flake-based java 21 development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-25.05";

  outputs = {nixpkgs, ...}: let
    supportedSystems = ["x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          jdk21_headless

          # LSP
          jdt-language-server
        ];
      };
    });
  };
}
