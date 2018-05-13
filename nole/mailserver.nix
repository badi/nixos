{ config, ... }:

let secrets = import ../secrets {};
in

{
  imports = [
    (builtins.fetchTarball "https://github.com/r-raymond/nixos-mailserver/archive/v2.1.3.tar.gz")
  ];

  services.rmilter.extraConfig = "bind_socket = unix:/run/rmilter/rmilter.sock";

  mailserver = {
    enable = true;
    fqdn = "${config.networking.hostName}.${secrets.mailserver.domain}";

    domains = secrets.mailserver.options.domains;

    loginAccounts = secrets.mailserver.options.loginAccounts;
    # extraVirtualAliases = secrets.mailserver.options.extraVirtualAliases;

    # Let's Encrypt
    certificateScheme = 3;

    enableImap = true;
    enablePop3 = false;
    enableImapSsl = true;
    enablePop3Ssl = false;

    enableManageSieve = true;

  };


}
