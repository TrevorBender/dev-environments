{
  description = "dev environment";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/8be1843237fd7dcc5e5db4814ccf24dafc620ff9";

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
          (zls.override {inherit zig_0_13;})
        ];
      };
    });
  };
}
