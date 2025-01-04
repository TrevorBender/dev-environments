{
  description = "dev environment";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/4005c3ff7505313cbc21081776ad0ce5dfd7a3ce";

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
          nodejs_22
          typescript-language-server
        ];
      };
    });
  };
}
