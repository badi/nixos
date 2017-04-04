# Installation

```
$ git clone --recursive https://github.com/badi/nixos
```

Ensure contents of `/etc/nixos/configuration.nix` is like:

```nix
{ imports = [ /home/badi/nixos/<ENTRYPOINT>.nix ]; }
```

where `<ENTRYPOINT>` is the machine name eg `fangorn`, `irmo`, `gambit` etc.

```
$ nixos-rebuild switch
```
