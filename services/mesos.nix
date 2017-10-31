{ ... }:
{

  services.zookeeper.enable = true;
  services.zookeeper.servers = "server.0=localhost:2888:3888\n";

  services.mesos.master.enable = true;
  services.mesos.master.quorum = 1;
  services.mesos.master.zk = "zk://localhost:2181/mesos";
  services.mesos.master.extraCmdLineOptions = [
    "--ip=127.0.0.1"
    "--no-hostname_lookup"
  ];

  services.mesos.slave.enable = true;
  services.mesos.slave.master = "zk://localhost:2181/mesos";
  services.mesos.slave.ip = "127.0.0.1";
  services.mesos.slave.withDocker = true;

  services.marathon.enable = true;

  services.marathon.extraCmdLineOptions = [
    "--hostname localhost"
  ];

}
