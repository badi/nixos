{ pkgs
, name
, command
, Type ? "forking"
, User ? "badi"
, RemainAfterExit ? "yes"
}:

{
  Type = Type;
  User = User;
  RemainAfterExit = RemainAfterExit;
  ExecStart = ''
    ${pkgs.tmux}/bin/tmux new-session -d -s ${name} ${command}
  '';
  ExecStop = ''
    ${pkgs.tmux}/bin/tmux kill-session -t ${name}
  '';
}
