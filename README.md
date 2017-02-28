# Installation

```
$ git clone --recursive https://github.com/badi/nixos
$ nixos-rebuild switch
```

Ensure contents of `/etc/nixos/configuration.nix` is like:

```nix
{ imports = [ /home/badi/nixos/<ENTRYPOINT>.nix ]; }
```

where `<ENTRYPOINT>` is the machine name eg `fangorn`, `irmo`, `gambit` etc.
