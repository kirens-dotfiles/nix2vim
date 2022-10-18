{
  description = "Next generation neovim configuration framework";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:NixOS/nixpkgs;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs, home-manager }:
    let
      dsl = import ./lib/dsl.nix { inherit (nixpkgs) lib; };
      dag = import ./lib/dag.nix {
        inherit (nixpkgs) lib;
        inherit (home-manager.lib) hm;
      };

      overlay = final: _: {

        nix2luaUtils = final.callPackage ./lib/utils.nix { inherit nixpkgs; };

        neovimBuilder = import ./lib/neovim-builder.nix {
          pkgs = final;
          lib = final.lib;
          inherit dsl dag;
        };

        nix2vimDemo = final.neovimBuilder {
          imports = [
            ./modules/essentials.nix
            ./modules/git.nix
            ./modules/lsp.nix
            ./modules/nvim-tree.nix
            ./modules/styling.nix
            ./modules/treesitter.nix
            ./modules/telescope.nix
            ./modules/which-key.nix
          ];

          enableViAlias = true;
          enableVimAlias = true;
        };
      };


    in
    {
      inherit overlay;
      lib = { inherit dsl dag; };
      templates.default = {
        path = ./template;
        description = "A very basic neovim configuration";
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      {
        packages.default = pkgs.nix2vimDemo;
        packages.luafile = pkgs.nix2vimDemo.passthru.config.luafile;
        apps = import ./apps.nix { inherit pkgs dsl dag; utils = flake-utils.lib; };
        checks = import ./checks { inherit pkgs dsl; check-utils = import ./check-utils.nix; };
      }
    );

}
