let secrets = import ../secrets {};
in
{
  network = {
    description = "My Network";
    enableRollback = true;
  };

  este = {...}: {
    deployment.targetHost = "este";
    imports = [ ../este ];
  };

  fangorn = {...}: {
    deployment.targetHost = "localhost";
    imports = [ ../fangorn ];
  };

  fea = {...}: {
    deployment.targetHost = "fea";
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

  nole = {resources, lib, ...}: {
    deployment.targetEnv = "ec2";
    imports = [ ../nole ];
    deployment.ec2 =
      let
        tf = (lib.head (lib.importJSON ../terraform/prod/terraform.tfstate).modules).resources;
    in
    {
      inherit (secrets.aws) accessKeyId region;
      inherit (secrets.nole) instanceType ebsOptimized ebsInitialRootDiskSize usePrivateIpAddress;
      subnetId = tf."aws_subnet.main".primary.id;
      securityGroupIds = [ tf."aws_security_group.allow_all".primary.id ];
      elasticIPv4 = tf."aws_eip.main".primary.attributes.public_ip;
      keyPair = resources.ec2KeyPairs.keypair;
    };
  };

  # nole-dev = { resource, lib, ...}: {
  #   imports = [ ../nole ];
  #   deployment.targetEnv = "virtualbox";
  #   deployment.virtualbox.headless = true;
  # };

}
