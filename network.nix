{
  network = {
    description = "My Network";
    enableRollback = true;
  };

  fea = {...}: {
    deployment.targetHost = "fea";
    imports = [ ./fea ];
  };

  namo = {...}: {
    deployment.targetHost = "10.0.0.2";
    imports = [ ./namo ];
  };
}
