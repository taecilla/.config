nnoremap <cr> <nop>
let mapleader="\<Enter>"

nnoremap <space> <nop>
let maplocalleader="\<Space>"

lua My = {}

source ~/.config/nvim/filetype.lua
source ~/.config/nvim/lua/configs/behaviour.lua
source ~/.config/nvim/lua/configs/command-line.lua
source ~/.config/nvim/lua/configs/lsp.lua
source ~/.config/nvim/lua/configs/mappings.lua
source ~/.config/nvim/lua/configs/search-and-replace.lua
source ~/.config/nvim/lua/configs/status-line.lua
source ~/.config/nvim/lua/configs/terminal.lua
source ~/.config/nvim/lua/configs/text.lua
source ~/.config/nvim/lua/configs/ui.lua

" Disable features {{{

let g:loaded_netrw=1
let g:loaded_netrwPlugin=1

let g:loaded_node_provider=0
let g:loaded_perl_provider=0
let g:loaded_python_provider=0
let g:loaded_python3_provider=0
let g:loaded_ruby_provider=0

" }}}

" vim: foldenable foldmethod=marker
