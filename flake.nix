{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    emacsNg-src.url = "github:emacs-ng/emacs-ng";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs = { nixpkgs, emacsNg-src, emacs-overlay, neovim-nightly-overlay, ... }@inputs: {
    nixosConfigurations = {
      shaunsingh-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { _module.args = inputs; }
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              emacs-overlay.overlay
	      neovim-nightly-overlay.overlay
            ];
          })
        ];
      };
    };
  };
}