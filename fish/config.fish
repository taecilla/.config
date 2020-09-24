set --export EDITOR nvim
set --export PAGER less --chop-long-lines --quit-if-one-screen --tabs=2

# Locale
set --export LANG en_GB.UTF-8
set --export LC_ALL $LANG

# Nix
set NIX_LINK $HOME/.nix-profile
set --export NIX_PATH nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs
set --export SSL_CERT_FILE $NIX_LINK/etc/ssl/certs/ca-bundle.crt

# XDG
if test -z $XDG_CONFIG_HOME
	set --export XDG_CONFIG_HOME $HOME/.config
	set --export XDG_DATA_HOME $HOME/.local/share
	set --export XDG_CACHE_HOME $HOME/.cache
end

# FZF
set --export FZF_DEFAULT_COMMAND 'fd --color always --exclude "*.enc" --ignore-file .pijulignore --hidden'
set --export FZF_DEFAULT_OPTS '--ansi --info inline --layout reverse --preview-window noborder'
set --export FZF_PREVIEW_COMMAND 'bat {}'

# NPM
set --export NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/config

# Postgres
set --export PSQLRC $XDG_CONFIG_HOME/psqlrc

# Readline
set --export INPUTRC $XDG_CONFIG_HOME/inputrc

set PATH $NIX_LINK/bin $NIX_LINK/sbin $PATH
set PATH ~/.local/bin $PATH
set PATH ~/.luarocks/bin $PATH
set PATH node_modules/.bin $XDG_DATA_HOME/node_modules $PATH
set --export PATH $PATH
