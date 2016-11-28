{ ... }:
{
  users.extraUsers.badi = {
    isNormalUser = true;
    initialHashedPassword = "$6$.YFrPdd1$/nViiUzPHuKOUYwDd3hZdG6HVm9zUOp49cv4bJkZ/InUop97mQ8HT3l7TlCWJpbN0rL0x7weVHZlSTNl0rBA11";
    createHome = true;
    extraGroups = [ "wheel" "yubikey" "networkmanager" "docker" "libvirtd" "vboxusers" "lp" ];
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2LfEdkqN4WMjeeAPy34asxsWJ5DW6+VUG005h1uBq7zIoa1/DYzYgk+QTYqnWvJs6hJqRoVp3Yf0TRH0XuoZYVizxK2YMq7DCYMyk7ELxxCIf9hkKBkyNygH05Ds0SOXcvM2GSImUb7PgwuN3mb38tJaKeRi7v9u4bSlYL00Riy/SutsJFa6A2Hf3Z3ZYIyay2RHyJMQFHINJ/1b3aGB605E2Tx7NhxE03T7OTC7ISlBSbb85AE7WdRMygxX1TzmQTBQ8Etu41Xt/Ed+Wkg6/QvlJk7ej69xIMCJkTlk1dmQXKvFbEn7xfVTPY/FQtg41QITlJ2NFLCUezeMMaEs9"
      # badi@gambit
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqoNyVmzGibqaa0rTLN5OdrVlczLrEULHJdynesL9eIOcJujYkmfZxPfd/lun9T8eopjpODVMiBqjQI8Sf9S76lgihY5c2KQcXMj+S6OgNFQJa8ve7e8cUS2KQtrcPpMcmpm62/5kB7CYP1I61TfLQfPSkoxkQ408hZ4sj1O4xYujbZIaWlSokcedoh7HjIkRcqUeeoxspyxPV9ftaFuCFcXVlDC7wSe9+SoeTmU8BygmgpAy19nezf24VDe1dVnpOMDqB7Qqa5nXABv5ZwUXMlU1uw5fPw05DkCB0bc5TqaMHcwT/U9IwSJunRXepXIFfvnBakScUGkq9Uld0RpJT"
      # badi@fangorn
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0AiBoBgua3YZTBfOgQk5JLdqzoY7e9ywRU3481mV2W9PRAJpkwTJ9l2vgfMt4Pj5xLJFzhwYRlZ607blXt/3pmxjfDHhsi00iXmxpkY3OLb0Fqpzeia0ibezO+7unHjb7/EhvQHX7ZBLGSsWQxDTwRhtTQF1SSrUqej1JJ+IfT6t7o+VZMIiPPswRa1pDCymI/gk9sW2RGDZr0CpTecgAEF+94Bfu6lckYLSJzIyqGzC650oqA21ubrmN7XkbgIY3jrCl13DAOArRsSlSsRMwsp8JbrJXShLnTDNxGNY/9FvEBDr3VDuDCa/lyTwdoyqn1Ev0wwy3EiQLSNdSEJ3dw=="
      # badi@irmo
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXOgmmh7lzXpVokYnuNuUM2TRQDliQDAzEjeGlR/88z580ktTfqFj+BLlRULc52OUaq5/wLL9fVQqQHdWv0FslgSwW9wrqKuYo3ZyazP7Qz41daqiaEH2pVLTCfiqD2qVYwbVJHPcYwY3VBLSi5HwzlcZrM+jQR1lbLUpLm0w02brFVJr393q7p6prWjcRsiItI2Nimbx7rj4uLUMydQTXTiW92QiQ3eKOIX1Zb+8hx0AMdB9jCevdVojUbQ3wTdGN0Swf2371jSzS1PqGwH0nFi1QmwPj0OFlYU/OeXMOR/usHz5v8bFjPwpL3opC2eIfnTxR84hXE1hjWraxK2C1"
    ];
  };
}
