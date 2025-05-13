{
  description = "Odin lang - latest unstable";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs-unstable, ...}: {
    devShells = let
      system = "x86_64-linux";
      pkgs = import nixpkgs-unstable {inherit system;};
    in {
      ${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          odin
          ols
        ];
      };
    };
  };
}
