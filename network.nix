{
  network = {
    description = "My Network";
    enableRollback = true;
  };

  fea = {...}: {
    deployment.targetHost = "fea";
    imports = [ ./fea ];
  };
}
