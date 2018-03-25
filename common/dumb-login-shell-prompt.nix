{...}:

let
  simple-ps1 = ''
    case "$TERM" in
      dumb)
        PS1="> "
        return
        ;;
    esac
  '';

in
{
  programs.zsh.promptInit = simple-ps1;
  programs.bash.promptInit = simple-ps1;
}
