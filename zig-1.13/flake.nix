{
  description = "zig 0.13 dev environment";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
  inputs.nixpkgs-24_11.url = "github:nixos/nixpkgs/release-24.11";

  outputs = {
    nixpkgs,
    nixpkgs-24_11,
    ...
  }: let
    supportedSustems = ["x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSustems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
          pkgs-24_11 = import nixpkgs-24_11 {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({
      pkgs,
      pkgs-24_11,
    }: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          zig_0_13
          pkgs-24_11.zls
          # zls
          # (zls.override {inherit zig_0_13;})
        ];
      };
    });
  };
}
