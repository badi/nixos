
let
  pkgs = import <nixpkgs> {};
  secrets = pkgs.callPackage ../secrets {};
in
{
  network = {
    description = "My Network";
    enableRollback = true;
  };

  # este = {...}: {
  #   deployment.targetHost = "este";
  #   imports = [ ../este ];
  # };

  fangorn = {...}: {
    deployment.targetHost = "localhost";
    imports = [ ../fangorn ];
  };

  unifi = {...}: {
    deployment.targetHost = "unifi";
    imports = [ ../fea ];
  };

  glaurung = {...}: {
    deployment.targetHost = "glaurung";
    imports = [ ../glaurung ];
  };

  namo = {...}: {
    deployment.targetHost = "namo";
    imports = [ ../namo ];
  };

  # terminated
  # nole = {resources, lib, ...}: {
  #   deployment.targetEnv = "ec2";
  #   imports = [ ../nole ];
  #   deployment.ec2 =
  #     let
  #       tf = (lib.head (lib.importJSON ../terraform/prod/terraform.tfstate).modules).resources;
  #   in
  #   {
  #     inherit (secrets.aws) accessKeyId region;
  #     inherit (secrets.nole) instanceType ebsOptimized ebsInitialRootDiskSize usePrivateIpAddress;
  #     subnetId = tf."aws_subnet.main".primary.id;
  #     securityGroupIds = [ tf."aws_security_group.allow_all".primary.id ];
  #     elasticIPv4 = tf."aws_eip.main".primary.attributes.public_ip;
  #     keyPair = resources.ec2KeyPairs.keypair;
  #   };
  # };

}
