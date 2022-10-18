{ lib, hm, ... }:
with lib;
let
  inherit (hm) dag;

  dagOfLinesWith =
    { prefix ? "anonymous_"
    , defaultEntry ? dag.entryAnywhere
    , defaultAnonEntry ? defaultEntry
    , merge ? r: concatStringsSep "\n" (map (v: v.data) r)
    }: mkOptionType {
      name = "dagOfLines";
      description = "concatenated lines from DAG of strings.";
      check = x: isAttrs x || isString x;
      merge = loc: defs:
        let
          # Ensure prefix is avalable
          hasIllegalKey = d:
            isAttrs d.value && any (hasPrefix prefix) (attrNames d.value);
          illegalKey = findFirst hasIllegalKey null defs;

          # Normalize to definitions to [ { <names> = Def (DAG.Entry String) } ]
          dagEntries = imap normalizeDef defs;
          normalizeDef = i: d:
            let
              toDef = value: d // { inherit value; };
              attrValToDef = n: v:
                if isString v then
                  toDef (defaultEntry v)
                else if dag.isEntry v then
                  toDef v
                else
                  abort ''
                    In file ${d.file}
                    Not a proper dag entry: '${concatStringsSep "." loc}.${name}'.
                  '';
              val = d.value;
            in
              if isString val then
                { "${prefix}${toString i}" = toDef (defaultAnonEntry val); }
              else
                mapAttrs attrValToDef val;

          # Ensure no conflicting options exist
          finalDag = zipAttrsWith (name: mergeEqualOption (loc ++ [name])) dagEntries;
          topoResult = dag.topoSort finalDag;
        in
          if ! isNull illegalKey then
            abort ''
              In file ${illegalKey.file}
              a value is assigned to the reserved prefix `${prefix}' of the option `${
                concatStringsSep "." loc
              }'.
              Please rename it to something else.
            ''
          else if ! topoResult ? result then
            abort ("Dependency cycle in lua: " + builtins.toJSON sorted)
          else
            merge topoResult.result;
    };

in dag // rec {
  between = b: a: dag.entryBetween [b] [a];
  before = b: dag.entryBefore [b];
  after = a: dag.entryAfter [a];

  types = hm.types // {
    inherit dagOfLinesWith;
  };
}
