{ config, ... }:

let secrets = import ../secrets {};
in

{
  imports = [
    (builtins.fetchTarball "https://github.com/r-raymond/nixos-mailserver/archive/master.tar.gz")
  ];

  mailserver = {
    enable = true;
    fqdn = "${config.networking.hostName}.badi.sh";
    domains = secrets.mailserver.options.domains;

    loginAccounts = secrets.mailserver.options.loginAccounts;
    extraVirtualAliases = secrets.mailserver.options.extraVirtualAliases;

    # Let's Encrypt
    certificateScheme = 3;

    enableImap = true;
    enablePop3 = false;
    enableImapSsl = true;
    enablePop3Ssl = false;

    enableManageSieve = true;

  };


}
