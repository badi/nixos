{
  network = {
    description = "My Network";
    enableRollback = true;
  };

  fea = {...}: {
    deployment.targetHost = "10.0.0.106";
    imports = [ ./fea ];
  };
}
