{ pkgs, lib, dsl, dag }:

with lib;
config:
let
  result = evalModules {
    modules = [
      {
        _module.args = lib.mapAttrs (_: lib.mkDefault) { inherit pkgs dsl dag; };
      }
      ./api.options.nix
      ./wrapper.options.nix
      config
    ];
  };
in
result.config.drv.overrideAttrs (attrs: {
  passthru = attrs.passthru // {
    inherit (result) config options;
  };
})
