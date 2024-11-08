{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    meta-module.url = "github:bglgwyng/nix-meta-module";
  };
  outputs = { nixpkgs, meta-module, ... }: rec {
    # Define types first
    petTypes = (nixpkgs.lib.evalModules {
      modules = [
        meta-module.nixosModules.default
        ({ lib, config, ... }: with lib; {
          t = {
            dog = lib.types.submodule (_: {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Name of the dog";
                };
                age = lib.mkOption {
                  type = lib.types.int;
                  description = "Age of the dog in years";
                };
                species = lib.mkOption {
                  type = config.t.species;
                  description = "Species of the dog";
                };
              };
            });
            species = lib.types.enum [ "yorkie" "poodle" ];
          };
        })
        # Extend the types with additional options
        ({ lib, ... }: with lib; {
          t = {
            dog = lib.types.submodule ({ config, ... }: {
              options = {
                isVaccinated = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Whether the dog has been vaccinated";
                };
              };
            });
            species = lib.types.enum [ "husky" ];
          };
        })
      ];
    }).config.t;

    # Define configuration using the types defined above
    pet = nixpkgs.lib.evalModules {
      modules = [
        ({ lib, ... }: with lib; {
          options.dog = lib.mkOption { type = petTypes.dog; };

          config.dog = {
            name = "Thompson";
            age = 9;
            isVaccinated = true;
            species = "yorkie";
          };
        })
      ];
    };
  };
}

