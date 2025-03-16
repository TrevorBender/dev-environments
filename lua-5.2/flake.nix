{
  description = "lua dev env";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default =
        pkgs.mkShell
        {
          packages = with pkgs; [
            lua5_2
            lua-language-server
            luaPackages.busted
          ];
        };
    });
  };
}
