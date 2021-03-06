{config, ...}:
{

  # fastmail details at https://www.fastmail.com/help/technical/servernamesandports.html
  services.ssmtp = with config.networking; {
    enable = true;
    domain = "${hostName}.${domain}";
    hostName = "smtp.fastmail.com:465";
    authUser = "io@badi.sh";
    authPassFile = "/run/keys/ssmtp-authpass";
    useTLS = true;
    useSTARTTLS = false;
    setSendmail = true;
    root = "root@${domain}";
  };

}
