# Installation

1. Clone this repository


1. Ensure contents of `/etc/nixos/configuration.nix` is like:

```nix
{ imports = [ /home/badi/nixos/<ENTRYPOINT>.nix ]; }
```

where `<ENTRYPOINT>` is the machine name eg `fangorn`, `irmo`, `gambit` etc.

1. `nixos-rebuild switch`
