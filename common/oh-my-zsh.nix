{ ... }:

{

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "junkfood";
    plugins = [

      "autopep8"
      "cabal"
      "docker"
      "git"
      "git-extras"
      "pep8"
      "pip"
      "python"
      "systemd"
      "vagrant"

    ];
    };
}
