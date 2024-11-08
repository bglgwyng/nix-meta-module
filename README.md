# nix-meta-module

This is a module for Nix that allows you to define types using the NixOS module system. Types can be defined in separate modules and then merged together.

In the NixOS module system, while options are extendable, types are not. This module fills that gap by providing a type system.
You would first define your types with nix-meta-module, and then use them to define options in your NixOS modules.
For more details, please refer to the [example](./example/flake.nix).

This module was primarily developed to make it easier to extend types that describe Kubernetes resources in [kubenix](https://kubenix.org/).
However, it can be applied to any similar use case where the NixOS module system is used to render structured data.




