

{ pkgs }:

let

  echo          = (pkgs.coreutils)+"/bin/echo";
  date          = (pkgs.coreutils)+"/bin/date";
  printf        = (pkgs.coreutils)+"/bin/printf";

  cronScriptHeader = pkgs.writeScript "cron-script-header" ''
    ${echo} "=================================="
    ${date}
  '';

  cronScript = shell: name: body:
    let script = pkgs.writeScript name ''
      ${echo} "=============================="
      ${date}
      ${echo} "++++++++++++++++++++++++++++++"
      ${if shell == "bash" then "set -x" else ""}
      ${body}
    '';
    in "${shell} ${script}";


  cronJob = {shell ? "bash",
             logdir ? "/tmp",
	     name, args ? [],
	     user ? "root",
	     body ? "",
	     description ? ""}:
               let script = cronScript shell name body;
                   job = toString [
		            user
		            script
			    (toString args)
			    ">>${logdir}/${name}.log 2>&1"
			  ];
               in job;


###################################################################

  zfsSnapshotKeepCount = "90";
  zfsRootPool = "tank";

  zfsSnapshotJob = cronJob {
    description = "Create a snapshot of a ZFS pool";
    name = "zfs-snapshot";
    args = [zfsRootPool zfsSnapshotKeepCount];
    body =
      ''
        pool=$1
        keep=$2

        zfs=${pkgs.linuxPackages.zfs}/sbin/zfs
        grep=${pkgs.gnugrep}/bin/grep
        sort=${pkgs.coreutils}/bin/sort
        head=${pkgs.coreutils}/bin/head
        tail=${pkgs.coreutils}/bin/tail
        xargs=${pkgs.findutils}/bin/xargs

        $zfs snapshot -r $pool@$(date +%F-%T)
        outdated=$($zfs list -t snapshot -o name \
                     | $grep $pool@ \
                     | $sort -r \
                     | $tail -n +$keep)
        if test ! -z "$outdated"; then
             ${echo} "$outdated" | $xargs -n 1 $zfs destroy -r
        fi;
        '';
    };

#-----------------------------------------------------------------#

  zfsScrubJob = cronJob {
    description = "Start a scrub of a ZFS pool";
    name="zfs-scrub";
    args = zfsRootPool;
    body =
      ''
        pool=$1
        zpool=${pkgs.linuxPackages.zfs}/sbin/zpool
        $zpool scrub $pool
      '';
    };

#-----------------------------------------------------------------#

  nixChannelUpdateJob = cronJob {
    description = "Update the NIX channels";
    name = "nix-channel-update";
    body = ''
      nixChannel=${pkgs.nix}/bin/nix-channel
      $nixChannel --update
    '';
  };

###################################################################

in

{

  enable = true;
  systemCronJobs = [

  #    /-------------------- minute
  #    | /------------------ hour
  #    | | /---------------- day of month
  #    | | | /-------------- month
  #    | | | | /------------ day of week
  #    | | | | |
  #    * * * * *

     # every day at 6am
      # "0 6 * * * ${zfsSnapshotJob}"

      # every day at 6:30 am
      "30 6 * * * ${nixChannelUpdateJob}"

      # every sunday at midnight
      "0 0 * * * ${zfsScrubJob}"

    ];

}
