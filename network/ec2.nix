let
  pkgs = import <nixpkgs> {};
  secrets = pkgs.callPackage ../secrets {};
in
{
  resources.ec2KeyPairs.keypair = { inherit (secrets.aws) region accessKeyId; };
}
