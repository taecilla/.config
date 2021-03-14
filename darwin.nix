{ config, pkgs, ... }: {
  environment.darwinConfig = "$HOME/.config/darwin.nix";
  environment.systemPackages = [
    pkgs.bat
    pkgs.cabal-install
    pkgs.darwin.trash
    pkgs.dhall
    pkgs.dhall-json
    pkgs.dhall-lsp-server
    pkgs.diffr
    pkgs.fd
    pkgs.fish
    pkgs.ghc
    pkgs.git
    pkgs.haskellPackages.haskell-language-server
    pkgs.metals
    pkgs.neovim
    pkgs.neovim-remote
    pkgs.pijul
    pkgs.ripgrep
    pkgs.rnix-lsp
    pkgs.sumneko-lua-language-server
    pkgs.tree
  ];

  fonts.enableFontDir = true;
  fonts.fonts = [ pkgs.jetbrains-mono ];

  nix.buildCores = 8; # $ sysctl -n hw.ncpu
  nix.maxJobs = 8; # $ sysctl -n hw.ncpu
  nix.trustedUsers = [ "@admin" ];

  nixpkgs.config = { allowUnfree = true; };
  nixpkgs.overlays = [ (import nixpkgs/overlays/neovim.nix) ];

  services.nix-daemon.enable = true;

  users.nix.configureBuildUsers = true;
}
