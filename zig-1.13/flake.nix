{
  description = "dev environment";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-25.05";

  outputs = {nixpkgs, ...}: let
    supportedSustems = ["x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSustems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          zig_0_13
          zls
          # (zls.override {inherit zig_0_13;})
        ];
      };
    });
  };
}
