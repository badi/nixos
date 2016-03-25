{ config, pkgs, ... }:
{
  services.collectd.enable = true;
  services.collectd.autoLoadPlugin = true;
  services.collectd.extraConfig = ''
    Interval 30

    Timeout 2
    FQDNLookup false

    <Plugin battery>
      ValuesPercentage true
      ReportDegraded true
    </Plugin>

    <Plugin cpu>
      ReportByCpu false
    </Plugin>

    LoadPlugin ContextSwitch
    LoadPlugin CPUFreq

    <Plugin df>
      MountPoint "/"
      MountPoint "/home"
      ValuesPercentage true
      ReportReserved false
    </Plugin>

    LoadPlugin disk

    <Plugin ethstat>
      Interface "enp2s0f0"
      Interface "wlp3s0"
    </Plugin>

    <Plugin memory>
      ValuesPercentage true
    </Plugin>

    <Plugin swap>
      ReportByDevice true
      ReportBytes true
      ValuesPercentage true
    </Plugin>

    LoadPlugin Wireless


    <Plugin network>
      Server "localhost" "8096"
    </Plugin>

  '';

  # <Plugin sensors>
    # <Plugin smart>
    #   Disk "sda"
    # </Plugin>



  services.grafana.enable = true;
  services.influxdb.enable = true;
  services.influxdb.extraConfig = {
    collectd = {
      enabled = true;
      bind-address = "localhost:8096";
      database = "${config.networking.hostName}";
      typesdb = "${pkgs.collectd}/share/collectd/types.db";
    };
  };
  # services.influxdb.meta.bind-address = "127.0.0.0:8088";
}
