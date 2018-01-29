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
    deployment.targetHost = "glaurung";
    imports = [ ./glaurung ];
  };

  namo = {...}: {
    deployment.targetHost = "namo";
    imports = [ ./namo ];
  };
}
