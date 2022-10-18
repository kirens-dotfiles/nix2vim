{ pkgs, lib, dsl }:

with lib;
config:
let
  result = evalModules {
    modules = [
      {
        _module.args = lib.mapAttrs (_: lib.mkDefault) { inherit pkgs dsl; };
      }
      ./api.options.nix
      ./wrapper.options.nix
      config
    ];
  };
in
result.config.drv
