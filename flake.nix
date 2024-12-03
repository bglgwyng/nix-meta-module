{
  outputs = _:

    {
      nixosModules.default = ({ lib, config, ... }:
        let
          optionType = (lib.mkOptionType {
            name = "option-type";
            description = "option type";
            check = lib.types.isOptionType;
            merge = config.mergeTypes;
          });
        in
        {
          options.t = lib.mkOption {
            description = "type definitions";
            type = lib.types.attrsOf optionType;
          };
          config.t = lib.filterAttrs (_: lib.types.isOptionType) lib.types;

          options.mergeTypes = lib.mkOption {
            description = "merge types";
            type = lib.types.functionTo (lib.types.functionTo (lib.types.anything));
            default = loc: defs:
              let
                fold1 = op: list:
                  if list == [ ] then
                    abort "fold1: empty list"
                  else
                    builtins.foldl' op (builtins.head list)
                      (builtins.tail list);
              in
              (fold1
                (x: y:
                  let merged = lib.defaultTypeMerge x.functor y.functor; in
                  assert merged != null || abort "Cannot merge option types ${x.description} and ${y.description}";
                  merged))
                (map (def: def.value) defs);
          };
        });
    };
}
