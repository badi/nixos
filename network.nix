{
  network = {
    description = "My Network";
    enableRollback = true;
  };

  fea = {...}: {
    deployment.targetHost = "fea";
    imports = [ ./fea ];
  };

  glaurung = {...}: {
    deployment.targetHost = "10.0.0.10";
    imports = [ ./glaurung ];
  };

  namo = {...}: {
    deployment.targetHost = "10.0.0.2";
    imports = [ ./namo ];
  };
}
