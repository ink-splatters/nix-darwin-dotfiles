{ pkgs
, lib
, inputs
, config
, isWayland
, ...
}: {
  imports = [
    ./bat.nix
    ./exa.nix
    ./fish.nix
    ./git.nix
    ./starship.nix
    ./zoxide.nix
    ./tmux.nix
  ];

  home.packages = with pkgs;
    [
      # coreutils
      uutils-coreutils
      # grep
      (ripgrep.override {
        withPCRE2 = true;
      })
      # rm
      rip
      # fuzzy finder
      skim
      # git client
      gitoxide
      # editor
      neovim-nightly
    ]
    ++ lib.optionals isWayland [
      # clipboard
      wl-clipboard
    ];
}
