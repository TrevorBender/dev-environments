{
  description = "development environments and templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    supportedSystems = ["x86_64-linux"];
    eachSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
    forEachDir = exec: ''
      for dir in */; do
        (
          cd "''${dir}"
          ${exec}
        )
      done
    '';
    scripts = eachSystem ({pkgs}: {
      format = pkgs.writeShellApplication {
        name = "format";
        runtimeInputs = with pkgs; [alejandra];
        text = ''
          shopt -s globstar

          alejandra -- **/*.nix
        '';
      };
      check = pkgs.writeShellApplication {
        name = "check";
        text = forEachDir ''
          echo "checking ''${dir}"
          nix flake check --all-systems --no-build
        '';
      };
    });
  in
    {
      devShells = eachSystem ({pkgs}: {
        default = pkgs.mkShell {
          packages = with scripts.${pkgs.system}; [
            check
            format
          ];
        };
      });

      packages = eachSystem ({pkgs}: {
        default = pkgs.writeShellApplication {
          name = "dvt";
          bashOptions = ["errexit" "pipefail"];
          text = ''
            if [ -z "''${1}"]; then
              echo "no template specified"
              exit 1
            fi
            TEMPLATE=$1

            nix --experimental-features 'nix-command flakes' \
              flake init --template "github:TrevorBender/dev-environments.git#''${TEMPLATE}"
          '';
        };
      });
    }
    // {
      templates = {
        cmake_ninja = {
          path = ./cmake-ninja;
          description = "cmake dev env";
        };
        exercism = {
          path = ./exercism;
          description = "exercism";
        };
        gleam = {
          path = ./gleam;
          description = "gleam dev env";
        };
        go_1_23 = {
          path = ./go-1.23;
          description = "Go dev env";
        };
        java_21 = {
          path = ./java-21;
          description = "java dev env";
        };
        jupyter = {
          path = ./jupyter;
          description = "jupyter notebooks with python";
        };
        lua_5_2 = {
          path = ./lua-5.2;
          description = "lua dev env";
        };
        node_22 = {
          path = ./node-22;
          description = "node 22 dev env";
        };
        odin_unstable = {
          path = ./odin-unstable;
          description = "odin dev env";
        };
        rust = {
          path = ./rust;
          description = "rust dev env";
        };
        zig_1_13 = {
          path = ./zig-1.13;
          description = "zig 1.13 dev env";
        };
        zig_1_14 = {
          path = ./zig-1.14;
          description = "zig 1.14 dev env";
        };
        zig = {
          path = ./zig;
          description = "zig (latest) dev env";
        };
      };
    };
}
