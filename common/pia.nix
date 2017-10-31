{ config, pkgs, ... }:

let
  inherit (builtins) readFile toFile replaceStrings;

  pia-files = pkgs.fetchzip {
    url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
    stripRoot = false;
    sha256 = "10cqspa1imaammlb1av5z192fxzppcmkw01ljrxxjm8xgxdc5mpr";
  };

  pia_cert =
    toFile "pia_ca.crt"
    (readFile "${pia-files}/ca.rsa.2048.crt");

  pia_pem =
    toFile "pia_crl.pem"
    (readFile "${pia-files}/crl.rsa.2048.pem");

  pia =
    { server ? "us-midwest.privateinternetaccess.com",
      port   ? 1198,
      auth   ? /root/.pia/auth,
      cert   ? pia_cert,
      pem    ? pia_pem
    }:
    ''
      client
      dev tun
      proto udp
      remote ${server} ${builtins.toString port}
      resolv-retry infinite
      nobind
      persist-key
      persist-tun
      cipher aes-128-cbc
      auth sha1
      tls-client
      remote-cert-tls server
      auth-user-pass ${auth}
      comp-lzo
      verb 1
      reneg-sec 0
      crl-verify ${pem}
      ca ${cert}
      disable-occ
    '';

in

{ services.openvpn.servers.pia.config = pia {}; }
