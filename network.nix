{
  network = {
    description = "My Network";
    enableRollback = true;
  };

  este = {...}: {
    deployment.targetHost = "este";
    imports = [ ./este ];
  };

  fangorn = {...}: {
    deployment.targetHost = "localhost";
    imports = [ ./fangorn ];
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
