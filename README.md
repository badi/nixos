# Installation

```
$ git clone --recursive https://github.com/badi/nixos
$ cd nixos && ln -s $(hostname).nix main.nix
$ sudo mv /etc/nixos{,.bak}
$ sudo ln -s $PWD /etc/nixos
$ nixos-rebuild switch
```
