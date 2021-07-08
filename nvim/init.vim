source ~/.config/nvim/filetype.lua
source ~/.config/nvim/lua/configs/behaviour.lua
source ~/.config/nvim/lua/configs/command-line.lua
source ~/.config/nvim/lua/configs/lsp.lua
source ~/.config/nvim/lua/configs/search-and-replace.lua
source ~/.config/nvim/lua/configs/terminal.lua
source ~/.config/nvim/lua/configs/text.lua

" Mappings {{{

nnoremap <cr> <nop>
let mapleader="\<Enter>"

nnoremap <space> <nop>
let maplocalleader="\<Space>"

noremap d "_d
noremap dd "_dd
noremap D "_D
noremap x "_x
noremap X "_X

noremap c "_c
noremap cc "_cc
noremap C "_C

noremap yd d
noremap yD D
noremap ydd dd

xnoremap p "_dP

nnoremap Y y$
" Makes Y behaves like C and D.

nnoremap ZQ <cmd>confirm qall<cr>
nnoremap ZZ <cmd>confirm wqall<cr>
nnoremap gs <cmd>confirm wall<cr>

function! GetGitBranch() abort
	let l:branchCmd='git symbolic-ref --short HEAD 2> /dev/null | tr -d "\n" ||'
		\ . 'git rev-parse --short HEAD 2> /dev/null | tr -d "\n"'
	let l:branch=system(l:branchCmd)

	return (len(l:branch) > 0)
		\ ? ('   ⌥ ' . l:branch)
		\ : ''
endfunction

function! GetCurrentDir() abort
	return substitute(getcwd(), $HOME, "~", "")
endfunction
nnoremap <c-g> <cmd>execute 'echo "' . GetCurrentDir() . GetGitBranch() '"'<cr>

noremap! <c-\> <esc>
tnoremap <c-\> <c-\><c-n>
tnoremap <esc> <c-\><c-n>

xnoremap <expr> v
	\ (mode() ==# 'v' ? "\<C-V>"
	\ : mode() ==# 'V' ? 'v' : 'V')

" }}}

" Providers {{{

let g:loaded_node_provider=0
let g:loaded_python_provider=0
let g:loaded_python3_provider=0
let g:loaded_ruby_provider=0

" }}}

" Status line {{{

function! GetCursorPosition()
	if &buftype == ''
		let l:position = getcurpos()
		return l:position[1] . '≡' . ' ' . l:position[2] . '∥'
	endif

	return &buftype ==# 'quickfix'
		\ ? line('.') . '/' . line('$')
		\ : ''
endfunction

function! IsDadbodBuffer() abort
	return match(expand('%'), '.*\.dbout$') > -1
endfunction

function! GetFileStatus()
	if &buftype != '' || IsDadbodBuffer()
		return ''
	endif

	let l:file = expand('%:p')
	let l:status =
		\ (&readonly || (filereadable(l:file) && !filewritable(l:file))
			\ ? ' 🔒'
			\ : '')
		\ . (&modified ? ' 💡' : '')
	return len(l:status) > 0 ? ' ' . l:status : ''
endfunction

function! GetFileDir()
	if &buftype != ''
		return ''
	endif

	if IsDadbodBuffer()
		return ''
	endif

	let l:path = expand('%:h')
	return (len(l:path) > 0 && l:path != '.') ? l:path . '/' : ''
endfunction

function! DadbodQuery() abort
	let l:queryFile = expand('%:r') . '.sql'
	if filereadable(l:queryFile)
		return join(readfile(l:queryFile))
	endif

	return ''
endfunction

function! GetFilename()
	return
		\ &buftype ==# 'help' ? expand('%:t:r') :
		\ &buftype ==# 'quickfix' ? get(w:, 'quickfix_title', 'Quckfix list') :
		\ &buftype ==# 'terminal' ? TerminalTitle() :
		\ &filetype ==# 'diff' ? 'Diff' :
		\ &filetype ==# 'dirvish' ? bufname() :
		\ &filetype ==# 'man' ? get(split(bufname(), '//'), 1) :
		\ &filetype ==# 'undotree' ? 'Undotree' :
		\ IsDadbodBuffer() ? DadbodQuery() :
		\ len(expand('%')) > 0 ? expand('%:t') : '🆕'
endfunction

function! TerminalTitle()
	if b:term_title ==# bufname()
		return get(split(bufname(), ':'), 2)
	endif

	return b:term_title
endfunction

function! UnicodeWindowNumber() abort
	return nr2char(9461 + winnr() - 1)
endfunction

function! StatusLine(active) abort
	if &buftype != '' &&
		\ &buftype !=# 'help' &&
		\ &buftype !=# 'quickfix' &&
		\ &buftype !=# 'terminal' &&
		\ &filetype !=# 'diff' &&
		\ &filetype !=# 'dirvish' &&
		\ &filetype !=# 'man' &&
		\ &filetype !=# 'undotree'
		return
	endif

	setlocal statusline=
	if a:active
		setlocal statusline+=%#StatusLineNC#
	else
		setlocal statusline+=%#StatusLine#
		setlocal statusline+=%{UnicodeWindowNumber()}
		setlocal statusline+=%#StatusLineNC#
		setlocal statusline+=\ \ 
	endif

	setlocal statusline+=%{GetFileDir()}

	if a:active
		setlocal statusline+=%#StatusLine#
	endif
	setlocal statusline+=%{GetFilename()}
	if a:active
		setlocal statusline+=%#StatusLineNC#
	endif
	if &buftype ==# 'help'
		setlocal statusline+=\ help
	elseif &filetype ==# 'man'
		setlocal statusline+=\ manual
	endif

	setlocal statusline+=%{GetFileStatus()}
	setlocal statusline+=\ \ \ %=

	if a:active
		setlocal statusline+=%#StatusLine#
		setlocal statusline+=%{GetCursorPosition()}
	endif
endfunction

augroup SetStatusline
	autocmd!
	autocmd BufEnter,TermOpen,WinEnter * call StatusLine(v:true)
	autocmd WinLeave * call StatusLine(v:false)
augroup END

call StatusLine(v:true)

" }}}

" User interface {{{

augroup FixColorSchemes
	autocmd!
	autocmd ColorScheme *
		\ highlight CursorLineNr guibg=bg guifg=bg |
		\ highlight! link EndOfBuffer CursorLineNr |
		\ highlight FoldColumn guibg=bg |
		\ highlight! link Folded FoldColumn |
		\ highlight! link LineNr FoldColumn |
		\ highlight SignColumn guibg=bg |
		\ highlight SpecialKey guibg=bg |
		\ highlight TermCursorNC guibg=bg guifg=bg |
		\ let s:highlight = execute('highlight StatusLineNC') |
		\ let s:reverse = matchstr(s:highlight, 'inverse\|reverse') |
		\ let s:split_color = matchstr(s:highlight,
			\ 'gui' . (s:reverse == '' ? 'bg' : 'fg') . '=\zs\S*') |
		\ execute 'highlight! VertSplit guibg=bg guifg='
			\ . s:split_color . ' gui=NONE cterm=NONE'
augroup END

set fillchars=fold:\ 
" Hides the decoration of folds

set guicursor=n-v:block,i-c-ci-ve:ver35,r-cr:hor20,o:hor50
	\,a:blinkwait700-blinkoff400-blinkon600-Cursor

set list listchars=extends:…,precedes:…,tab:\ \ 

set showmatch
" Highlight matching braces when cursor is over one of them

set showtabline=0
" Never show the tabline

set termguicolors
" Enable true color

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

" Hop {{{

nmap f <cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>
omap f <cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>
xmap f <cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>

nmap F <cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>
omap F <cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>
xmap F <cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>

nmap gl <cmd>lua require'hop'.hint_lines()<cr>
omap gl <cmd>lua require'hop'.hint_lines()<cr>
xmap gl <cmd>lua require'hop'.hint_lines()<cr>

nmap g/ <cmd>lua require'hop'.hint_patterns()<cr>
omap g/ <cmd>lua require'hop'.hint_patterns()<cr>
xmap g/ <cmd>lua require'hop'.hint_patterns()<cr>

nmap w <cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>
omap w <cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>
xmap w <cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>

nmap b <cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>
omap b <cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>
xmap b <cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>

augroup FixHopColors
	autocmd!
	autocmd ColorScheme *
		\ highlight! link HopNextKey ErrorMsg |
		\ highlight! link HopNextKey1 HopNextKey |
		\ highlight! link HopNextKey2 WarningMsg |
		\ highlight! link HopUnmatched Normal
augroup END

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

lua My = {}
" Global table to store personal functions

" vim: foldenable foldmethod=marker
