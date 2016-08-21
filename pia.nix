{ ... }:

{ services.openvpn = {
    servers.pia = {
      autoStart = false;
      config = ''
        client
        dev tun
        proto udp
        remote us-west.privateinternetaccess.com 1194
        resolv-retry infinite
        nobind
        persist-key
        persist-tun
        ca /home/badi/pia/ca.crt
        tls-client
        remote-cert-tls server
        auth-user-pass /home/badi/pia/auth
        comp-lzo
        verb 1
        reneg-sec 0
        crl-verify /home/badi/pia/crl.pem
      '';
    };
  };
}
