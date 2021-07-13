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

" Providers {{{

let g:loaded_node_provider=0
let g:loaded_perl_provider=0
let g:loaded_python_provider=0
let g:loaded_python3_provider=0
let g:loaded_ruby_provider=0

" }}}

" Packages

" Color schemes {{{

let g:ayucolor="mirage"

let g:ganymede_solid_background=1

let g:material_theme_style='palenight'

" }}}

" Dirvish {{{

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

augroup DirvishSetUp
	autocmd!
	autocmd FileType dirvish
		\ nnoremap <buffer> <cr> <nop>|
		\ nnoremap <buffer> gf <cmd>call dirvish#open('edit', 0)<cr> |
		\ nnoremap <buffer> + <cmd>lua require('procedures')['create-file'](vim.call("bufname"))<cr>
augroup END
" No space can go after <nop>

" }}}

" Editorconfig {{{

let g:EditorConfig_max_line_indicator="none"
" Lengthmatters takes care of this

" }}}

" Git Messenger {{{

let g:git_messenger_no_default_mappings=v:true

" }}}

" Lengthmatters {{{

let g:lengthmatters_on_by_default=0

function! SetupLengthmatters()
	if &textwidth > 0
		LengthmattersEnable
	else
		LengthmattersDisable
	endif
endfunction

augroup EnableLengthmatters
	autocmd!
	autocmd OptionSet * call SetupLengthmatters()
augroup END

" }}}

" MUcomplete {{{

let g:mucomplete#chains={ 'default' : [ 'omni', 'path', 'uspl' ] }

let g:mucomplete#enable_auto_at_startup=1

let g:mucomplete#minimum_prefix_length=1

let g:mucomplete#no_mappings=0

set completeopt=menuone,noinsert,noselect

" }}}

" Orgmode {{{

lua require'orgmode'.setup {}

" }}}

" Sandwich {{{

nmap s <Nop>
xmap s <Nop>

nmap sc <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap scb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
xmap sc <Plug>(operator-sandwich-replace)
" Use c as mnemonic for change

" }}}

" Signify {{{

augroup SignifySetup
	autocmd!
	autocmd User SignifySetup
		\ nmap ]h <plug>(signify-next-hunk) |
		\ nmap [h <plug>(signify-prev-hunk) |
		\ nmap ]H 9999]h |
		\ nmap [H 9999[h |
		\ nmap <localleader>df <cmd>SignifyDiff<cr>|
		\ nmap <localleader>dh <cmd>SignifyHunkDiff<cr>|
		\ nmap <localleader>uh <cmd>SignifyHunkUndo<cr>

let g:signify_priority=0

" }}}

" Random Colors {{{

command! RandomColorScheme lua require('random-colors')()

" }}}

" Reflex {{{

let g:reflex_delete_cmd='trash'

" }}}

" Rooter {{{

let g:rooter_patterns=[ '.git', '.pijul', 'shell.nix' ]

let g:rooter_resolve_links=1

let g:rooter_silent_chdir=1

" }}}

" Template {{{

let g:templates_directory=[stdpath('config') . '/templates']

let g:templates_global_name_prefix='template.'

let g:templates_no_builtin_templates=1

" }}}

" Undotree {{{

let g:undotree_HelpLine=0

let g:undotree_SetFocusWhenToggle=1

" }}}

" vim: foldenable foldmethod=marker
