let secrets = import ../secrets {};
in
{
  resources.ec2KeyPairs.keypair = { inherit (secrets.aws) region accessKeyId; };
}
