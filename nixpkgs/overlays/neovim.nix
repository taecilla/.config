self: super:

let
  plug = name: user: repo: super.vimUtils.buildVimPlugin {
    name = name;
    src = fetchGit "https://github.com/${user}/${repo}";
    buildPhase = ":";
  };
in
{
  neovim = super.neovim.override {
    configure = {
      customRC = "source ~/.config/nvim/init.vim";
      packages.myVimPackages = {
        start = [
          # General
          (plug "bbye" "moll" "vim-bbye")
          (plug "capital-h" "tssm" "vim-capital-h")
          (plug "colorizer" "norcalli" "nvim-colorizer.lua")
          (plug "commentary" "tpope" "vim-commentary")
          (plug "difforig" "lifecrisis" "vim-difforig")
          (plug "editorconfig" "editorconfig" "editorconfig-vim")
          (plug "git-messenger" "rhysd" "git-messenger.vim")
          (plug "lengthmatters" "whatyouhide" "vim-lengthmatters")
          (plug "linediff" "AndrewRadev" "linediff.vim")
          (plug "mergetool" "samoshkin" "vim-mergetool")
          (plug "mucomplete" "lifepillar" "vim-mucomplete")
          (plug "random-colors" "tssm" "nvim-random-colors")
          (plug "rooter" "airblade" "vim-rooter")
          (plug "reflex" "tssm" "nvim-reflex")
          (plug "repeat" "tpope" "vim-repeat")
          (plug "sandwich" "machakann" "vim-sandwich")
          (plug "signify" "mhinz" "vim-signify")
          (plug "sleuth" "tpope" "vim-sleuth")
          (plug "sneak" "justinmk" "vim-sneak")
          (plug "template" "aperezdc" "vim-template")
          (plug "trailing-whitespace" "bronson" "vim-trailing-whitespace")
          (plug "undotree" "mbbill" "undotree")

          # Dadbod
          (plug "dadbod" "tpope" "vim-dadbod")
          (plug "dadbod-completion" "kristijanhusak" "vim-dadbod-completion")

          # Dirvish
          (plug "dirvish" "justinmk" "vim-dirvish")
          (plug "dirvish-git" "kristijanhusak" "vim-dirvish-git")

          # Lexima
          (plug "lexima" "cohama" "lexima.vim")
          (plug "lexima-template-rules" "zandrmartin" "lexima-template-rules")

          # LSP
          (plug "lspconfig" "neovim" "nvim-lspconfig")
          (plug "lspsaga" "glepnir" "lspsaga.nvim")

          # Telescope
          (plug "plenary" "nvim-lua" "plenary.nvim")
          (plug "popup" "nvim-lua" "popup.nvim")
          (plug "telescope" "nvim-telescope" "telescope.nvim")

          # File types
          (plug "css" "JulesWang" "css.vim")
          (plug "dhall" "vmchale" "dhall-vim")
          (plug "html" "othree" "html5.vim")
          (plug "fish" "dag" "vim-fish")
          (plug "nix" "LnL7" "vim-nix")
          (plug "pgsql" "lifepillar" "pgsql.vim")
          (plug "purescript" "purescript-contrib" "purescript-vim")
          (plug "rust" "rust-lang" "rust.vim")
          (plug "swift" "keith" "swift.vim")

          # Fennel
          (plug "aniseed" "Olical" "aniseed")
          (plug "conjure" "Olical" "conjure")
          (plug "fennel" "bakpakin" "fennel.vim")

          # Haskell
          (plug "haskell-unicode" "zenzike" "vim-haskell-unicode")
          (plug "shakespeare" "pbrisbin" "vim-syntax-shakespeare")
        ];
        opt = [
          # Color schemes
          (plug "ayu" "ayu-theme" "ayu-vim")
          (plug "blueprint" "thenewvu" "vim-colors-blueprint")
          (plug "c64" "tssm" "c64-vim-color-scheme")
          (plug "challenger-deep" "challenger-deep-theme" "vim")
          (plug "chito" "Jimeno0" "vim-chito")
          (plug "dogrun" "wadackel" "vim-dogrun")
          (plug "fairyfloos" "tssm" "fairyfloss.vim")
          (plug "ganymede" "charlespeters" "ganymede")
          (plug "gotham" "whatyouhide" "vim-gotham")
          (plug "gruvbox" "morhetz" "gruvbox")
          (plug "material" "kaicataldo" "material.vim")
          (plug "miramare" "franbach" "miramare")
          (plug "neo-solarized" "icymind" "NeoSolarized")
          (plug "night-owl" "haishanh" "night-owl.vim")
          (plug "nord" "arcticicestudio" "nord-vim")
          (plug "nova" "trevordmiller" "nova-vim")
          (plug "oceanic-next" "mhartington" "oceanic-next")
          (plug "pink-moon" "sts10" "vim-pink-moon")
          (plug "snazzy" "connorholyday" "vim-snazzy")
          (plug "snow" "nightsense" "snow")
          (plug "strawberry" "nightsense" "strawberry")
          (plug "toast" "jsit" "toast.vim")
        ];
      };
    };
  };

  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (
    oldAttrs: {
      src = fetchGit https://github.com/neovim/neovim;
      buildInputs = oldAttrs.buildInputs ++ [ super.pkgs.tree-sitter ];
      version = "head";
    }
  );
}
