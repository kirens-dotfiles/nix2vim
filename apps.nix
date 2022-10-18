{ utils, pkgs, lib ? pkgs.lib, dsl }:
let
  generateMarkdown = optionsFile:
    let
      options = (pkgs.lib.evalModules {
        modules = [
          { _module.args = { inherit pkgs dsl; }; }
          optionsFile
        ];
      }).options;
    in
    (pkgs.nixosOptionsDoc { inherit options; }).optionsCommonMark;
  mkApp = drv: utils.mkApp { inherit drv; };
in
{
  generateDocs = mkApp (pkgs.writeShellScriptBin "create-docs.sh" ''
    mkdir docs
    cp -f ${generateMarkdown ./lib/api.options.nix} docs/api.options.md
    cp -f ${generateMarkdown ./lib/wrapper.options.nix} docs/wrapper.options.md
  '');
}
