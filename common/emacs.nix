{ pkgs ? import <nixpkgs> {} }:

rec {
  my-emacs-with-packages = pkgs.emacsWithPackages (ps: with ps; [

    # (pkgs.runCommand "default.el" {} ''
    #   mkdir -p $out/share/emacs/site-lisp
    #   cp ${my-emacs-config} $out/share/emacs/site-lisp/default.el
    # '')

    (magit-org-todos.overrideDerivation (old: { buildInputs = old.buildInputs ++ [ pkgs.git ]; }))
    ag
    avy
    bm
    cargo
    diminish
    dired-filetype-face
    direnv
    elpy
    erlang
    exec-path-from-shell
    flycheck
    flycheck-color-mode-line
    flycheck-inline
    flycheck-plantuml
    flycheck-rust
    # flyspell
    helm
    helm-ag
    helm-descbinds
    helm-flx
    helm-projectile
    helm-rg
    helm-xref
    hungry-delete
    link-hint
    magit
    magit-filenotify
    magit-todos
    multiple-cursors
    naquadah-theme
    org-brain
    org-plus-contrib
    powerline
    projectile
    projectile-ripgrep
    projectile-speedbar
    quick-peek
    rainbow-delimiters
    rainbow-identifiers
    ranger
    use-package

    csv-mode
    d-mode
    dockerfile-mode
    graphviz-dot-mode
    haskell-mode
    json-mode
    lua-mode
    markdown-mode
    nix-mode
    plantuml-mode
    rust-mode
    terraform-mode
    toml-mode
    yaml-mode


  ]);

  my-emacs-config = pkgs.copyPathToStore ./emacs.el;

}
