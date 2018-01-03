{
  network = {
    description = "My Network";
    enableRollback = true;
  };

  fea = {...}: {
    deployment.targetHost = "10.0.0.105";
    imports = [ ./fea ];
  };
}
