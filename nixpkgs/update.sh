#!/usr/bin/env bash

set -e -o pipefail

my_loc="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

set -x

cd "$my_loc"

# nix-prefetch-git \
#     git://github.com/nixos/nixpkgs \
#     refs/heads/release-18.09 \
#   | tee release.json

nix-prefetch-url \
    --unpack \
    "https://github.com/NixOS/nixpkgs/archive/$(jq -r '.rev' release.json).tar.gz" \
  | tee release-tarball.sha256
