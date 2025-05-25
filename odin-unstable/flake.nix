{
  description = "Odin lang - latest unstable";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    ...
  }: {
    devShells = let
      system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};
      unstable-pkgs = import nixpkgs-unstable {inherit system;};
    in {
      ${system}.default = pkgs.mkShell {
        packages = with unstable-pkgs; [
          odin
          ols
        ];
      };
    };
  };
}
