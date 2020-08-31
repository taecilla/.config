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
						(plug "capital-h" "tssm" "vim-capital-h")
						(plug "colorizer" "norcalli" "nvim-colorizer.lua")
						(plug "commentary" "tpope" "vim-commentary")
						(plug "difforig" "lifecrisis" "vim-difforig")
						(plug "dirvish" "justinmk" "vim-dirvish")
						(plug "editorconfig" "editorconfig" "editorconfig-vim")
						(plug "git-messenger" "rhysd" "git-messenger.vim")
						super.vimPlugins.LanguageClient-neovim
						(plug "lengthmatters" "whatyouhide" "vim-lengthmatters")
						(plug "linediff" "AndrewRadev" "linediff.vim")
						(plug "mergetool" "samoshkin" "vim-mergetool")
						(plug "mucomplete" "lifepillar" "vim-mucomplete")
						(plug "oldfiles" "gpanders" "vim-oldfiles")
						(plug "random-colors" "tssm" "nvim-random-colors")
						(plug "rooter" "airblade" "vim-rooter")
						(plug "repeat" "tpope" "vim-repeat")
						(plug "sleuth" "tpope" "vim-sleuth")
						(plug "sneak" "justinmk" "vim-sneak")
						(plug "surround" "tpope" "vim-surround")
						(plug "tectonic" "tssm" "tectonic.vim")
						(plug "template" "aperezdc" "vim-template")
						(plug "trailing-whitespace" "bronson" "vim-trailing-whitespace")
						(plug "undotree" "mbbill" "undotree")
						(plug "vista" "liuchengxu" "vista.vim")

						# FZF
						(plug "fzf" "junegunn" "fzf")
						(plug "fzf-vim" "junegunn" "fzf.vim")
						(plug "fzf-quickfix" "fszymanski" "fzf-quickfix")
						(plug "fzf-session" "dominickng" "fzf-session.vim")

						# Lexima
						(plug "lexima" "cohama" "lexima.vim")
						(plug "lexima-template-rules" "zandrmartin" "lexima-template-rules")

						# File types
						(plug "css" "JulesWang" "css.vim")
						(plug "html" "othree" "html5.vim")
						(plug "fish" "dag" "vim-fish")
						(plug "nix" "spwhitt" "vim-nix")
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
						(plug "neo-solarized" "icymind" "NeoSolarized")
						(plug "night-owl" "haishanh" "night-owl.vim")
						(plug "nord" "arcticicestudio" "nord-vim")
						(plug "nova" "trevordmiller" "nova-vim")
						(plug "oceanic-next" "mhartington" "oceanic-next")
						(plug "pink-moon" "sts10" "vim-pink-moon")
						(plug "snazzy" "connorholyday" "vim-snazzy")
						(plug "snow" "nightsense" "snow")
						(plug "strawberry" "nightsense" "strawberry")
					];
				};
			};
		};
	}
