{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
  };
  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        cargo
        rustc
        rust-analyzer
        rustfmt
      ];
    };
  };
}
