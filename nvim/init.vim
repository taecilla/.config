" Common utility functions {{{

function! EditFile(path) abort
	try
		call inputsave()
		let l:dest = input("Filename: ", a:path, "file")
		call inputrestore()
		execute 'edit' l:dest
	catch | endtry
endfunction

" }}}

" Behavior {{{

augroup AutoLoadVimrcChanges
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

augroup RestoreCursorShapeOnExit
	autocmd!
	autocmd VimLeave * set guicursor=a:ver35-blinkon1
augroup END

set clipboard=unnamed,unnamedplus
" Uses the clipboard as the unnamed register

set diffopt+=vertical

set hidden
" Allows hidden buffers without writing them

set inccommand=nosplit

set iskeyword-=_

set mouse=a

set nojoinspaces
" Use only 1 space after '.' when joining lines

set noshowmode
" Because Neovim's cursor shape

augroup ResizeWindowsProportionally
	autocmd!
	autocmd VimResized * :wincmd =
augroup END

set shortmess=csF

set visualbell
" Turns off annoying sound

set wildignorecase
" Use case-insensitive file search in the wildmenu

" }}}

" Command line {{{

cnoremap <C-A> <Home>
" Go to the beginning of the line
cnoremap <C-B> <Left>
" Go back one character
cnoremap <C-F> <Right>
" Go forward one character
cnoremap ∫ <S-Left>
" Go back one word
cnoremap ƒ <S-Right>
" Go forward one word
cnoremap <C-P> <Up>
" Search prefix backwards
cnoremap <C-N> <Down>
" Search prefix forward
" Makes the command line behave like Fish

" }}}

" Folding {{{

set foldmethod=syntax
" Create folds based on files's syntax

set nofoldenable
" Open folds by default

" }}}

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

" Indentation {{{

set tabstop=2
" Number of spaces that a <Tab> in the file counts for

set shiftwidth=0
" Number of spaces to use for each step of indent. 0 = tabstop

" }}}

" Providers {{{

let g:loaded_node_provider=0
let g:loaded_python_provider=0
let g:loaded_python3_provider=0
let g:loaded_ruby_provider=0

" }}}

" Search and replace {{{

nnoremap n nzz
nnoremap N Nzz
vnoremap n nzz
vnoremap N Nzz

nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
" Replace the word under cursor.

set gdefault
" Substitutes all matches on a line by default

set ignorecase
" Ignore case in a pattern

set smartcase
" Override the ignorecase option if the search pattern contains upper case characters

augroup ToggleSearchHighlighting
	autocmd!
	autocmd InsertEnter * setlocal nohlsearch
	autocmd InsertLeave * setlocal hlsearch
augroup END
" Toggles search highlighting off/on according to current mode. Source: http://blog.sanctum.geek.nz/vim-search-highlighting/

" }}}

" Sessions {{{

set sessionoptions=curdir,help,tabpages,winsize

" }}}

" Status line {{{

function! GetCursorPosition()
	if &buftype == ''
		let l:position = getcurpos()
		return l:position[1] . 'Ⲷ ' . l:position[2] . 'Ⲽ'
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
		\ &filetype ==# 'vista_kind' ? 'Vista' :
		\ IsDadbodBuffer() ? DadbodQuery() :
		\ len(expand('%')) > 0 ? expand('%:t') : '🆕'
endfunction

function! TerminalTitle()
	if b:term_title ==# bufname()
		return get(split(bufname(), ':'), 2)
	endif

	return b:term_title
endfunction

function! NearestMethodOrFunction() abort
	let l:f = get(b:, 'vista_nearest_method_or_function', '')
	return len(l:f) > 0 ? ('ƒ ' . l:f . '   ') : ''
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
		\ &filetype !=# 'undotree' &&
		\ &filetype !=# 'vista_kind'
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
		setlocal statusline+=%{NearestMethodOrFunction()}
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

" Tab pages {{{

set splitbelow
" Creates new horizontal windows at the bottom

set splitright
" Creates new vertical windows at the right

" }}}

" Terminal {{{

command! -nargs=* -complete=shellcmd T vsplit | terminal <args>
" Open the terminal in a vertical split

set scrollback=100000

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

" Wrap {{{

set linebreak
" When wrap is set use the value of breakat to break lines

set breakat=\	\ 
" Break lines only at whitespace

set breakindent
" Indents wrapped text

set nowrap

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
		\ nnoremap <buffer> + <cmd>call EditFile(bufname())<cr>
augroup END
" No space can go after <nop>

" }}}

" Editorconfig {{{

let g:EditorConfig_max_line_indicator="none"
" Lengthmatters takes care of this

" }}}

" FZF {{{

function! FzfEditFile(lines)
	let l:line = a:lines[0]
	call EditFile(l:line)
endfunction

function! PopulateQuickfix(lines)
	call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
endfunction

let g:fzf_action={
	\ 'ctrl-e': function('FzfEditFile'),
	\ 'ctrl-q': function('PopulateQuickfix'),
	\ 'ctrl-t': 'tab split',
	\ 'ctrl-s': 'split',
	\ 'ctrl-v': 'vsplit'
	\ }

let g:fzf_history_dir='~/.cache/fzf-history'

let g:fzf_layout={'window': {'border': 'sharp', 'width': 1, 'height': 0.3, 'yoffset': 1}}

nnoremap <silent> <leader>c :History:<cr>

nnoremap <silent> <leader>b :Buffers<cr>

function! CleanAndMove(dest) abort
	%bdelete
	execute 'cd' a:dest
endfunction

let g:findDirectories='fd --color always --hidden --type d --max-depth 10'
function! Explore(dest) abort
	call CleanAndMove(a:dest)
	edit .
endfunction
nnoremap <silent> <leader>e :call fzf#run(fzf#wrap('explore', {
	\ 'dir': '~',
	\ 'options': '--prompt "Explore> "',
	\ 'sink': function('Explore'),
	\ 'source': g:findDirectories
	\ }))<cr>

nnoremap <silent> <leader>f :call fzf#vim#files('', fzf#vim#with_preview())<cr>

function! RipgrepFzf() abort
	let l:command_fmt = 'rg --color always --fixed-strings --trim --vimgrep '
		\ . '--glob "!*.enc" --glob !.git/ --glob !.pijul/ --hidden --ignore-file .pijulignore --smart-case'
		\ . ' %s || true'
	let l:initial_command = printf(l:command_fmt, '')
	let l:reload_command = printf(l:command_fmt, '{q}')
	let l:spec = {'options': ['--phony', '--bind', 'change:reload:' . l:reload_command]}
	call fzf#vim#grep(l:initial_command, 1, fzf#vim#with_preview(l:spec))
endfunction
nnoremap <silent> <leader>g :call RipgrepFzf()<cr>

function! Terminal(dest) abort
	call CleanAndMove(a:dest)
	terminal
endfunction
nnoremap <silent> <leader>t :call fzf#run(fzf#wrap('terminal', {
	\ 'dir': '~',
	\ 'options': '--prompt "Terminal> "',
	\ 'sink': function('Terminal'),
	\ 'source': g:findDirectories
	\ }))<cr>

nnoremap <silent> <leader>h :History<cr>

nnoremap <silent> <leader>q :Quickfix<cr>

let g:fzf_session_path=stdpath('data') . '/session'
nnoremap <silent> <leader>s :Sessions<cr>

" }}}

" Git Messenger {{{

let g:git_messenger_no_default_mappings=v:true

" }}}

" {{{ Language Client

function! SetUpLanguageClient() abort
	if has_key(g:LanguageClient_serverCommands, &filetype)
		call vista#RunForNearestMethodOrFunction()

		augroup LanguageClientBufferAutocommand
			autocmd! * <buffer>
			autocmd BufWritePre <buffer> :call LanguageClient#textDocument_formatting()
			autocmd InsertEnter <buffer> :call LanguageClient#clearDocumentHighlight()
		augroup END

		nnoremap <buffer> <silent> <c-]> :call LanguageClient#textDocument_definition()<cr>
		nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
		nnoremap <buffer> <silent> <localleader>* :call LanguageClient#textDocument_documentHighlight()<cr>
		nnoremap <buffer> <silent> <localleader>a :call LanguageClient#textDocument_codeAction()<cr>
		nnoremap <buffer> <silent> <localleader>e :call LanguageClient#explainErrorAtPoint()<cr>
		nnoremap <buffer> <silent> <localleader>r :call LanguageClient#textDocument_rename()<cr>
		nnoremap <buffer> <silent> <localleader>ds :call LanguageClient#textDocument_documentSymbol()<cr>
		nnoremap <buffer> <silent> <localleader>ws :call LanguageClient#workspace_symbol()<cr>

		setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
	endif
endfunction

augroup LanguageClientSetUp
	autocmd!
	autocmd FileType * call SetUpLanguageClient()
	autocmd User LanguageClientStarted set signcolumn=yes
	autocmd User LanguageClientStopped set signcolumn=auto
augroup END

let g:LanguageClient_diagnosticsDisplay = {
	\ 1: {
		\ "name": "Error",
		\ "signText": "»",
		\ "signTexthl": "ErrorMsg",
		\ "virtualTexthl": "ErrorMsg",
	\ },
	\ 2: {
		\ "name": "Warning",
		\ "signText": "»",
		\ "signTexthl": "WarningMsg",
		\ "virtualTexthl": "WarningMsg",
	\ },
	\ 3: {
		\ "name": "Information",
		\ "signText": "»",
		\ "signTexthl": "Comment",
		\ "virtualTexthl": "Comment",
	\ },
	\ 4: {
		\ "name": "Hint",
		\ "signText": "»",
		\ "signTexthl": "Comment",
		\ "virtualTexthl": "Comment",
	\ }
\ }

let g:LanguageClient_diagnosticsList="Disabled"

let g:LanguageClient_rootMarkers = {
	\ 'haskell': ['*.cabal'],
	\ 'lua': ['.luacompleterc'],
	\ 'purescript': ['psc-package.json', 'spago.dhall'],
	\ 'rust': ['Cargo.toml'],
	\ 'scala': ['*.sbt']
	\ }

let g:LanguageClient_serverCommands = {
	\ 'dhall': ['dhall-lsp-server'],
	\ 'haskell': ['haskell-language-server-wrapper', '--lsp'],
	\ 'lua': ['lua-lsp'],
	\ 'nix': ['rnix-lsp'],
	\ 'purescript': ['purescript-language-server', '--stdio', '--config', '{}'],
	\ 'rust': ['rls'],
	\ 'scala': ['metals-vim-lsc']
\ }

let g:LanguageClient_useVirtualText='All'

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

" }}}

" Sneak {{{

let g:sneak#use_ic_scs=1

nnoremap <silent> f :call sneak#wrap('',           1, 0, 1, 2)<cr>
nnoremap <silent> F :call sneak#wrap('',           1, 1, 1, 2)<cr>
onoremap <silent> f :call sneak#wrap(v:operator,   1, 0, 1, 2)<cr>
onoremap <silent> F :call sneak#wrap(v:operator,   1, 1, 1, 2)<cr>
xnoremap <silent> f :call sneak#wrap(visualmode(), 1, 0, 1, 2)<cr>
xnoremap <silent> F :call sneak#wrap(visualmode(), 1, 1, 1, 2)<cr>

nnoremap <silent> t :call sneak#wrap('',           1, 0, 0, 2)<cr>
nnoremap <silent> T :call sneak#wrap('',           1, 1, 0, 2)<cr>
onoremap <silent> t :call sneak#wrap(v:operator,   1, 0, 0, 2)<cr>
onoremap <silent> T :call sneak#wrap(v:operator,   1, 1, 0, 2)<cr>
xnoremap <silent> t :call sneak#wrap(visualmode(), 1, 0, 0, 2)<cr>
xnoremap <silent> T :call sneak#wrap(visualmode(), 1, 1, 0, 2)

" }}}

" Random Colors {{{

command! RandomColorScheme lua require('random-colors')()

" }}}

" Rooter {{{

let g:rooter_patterns=[ '.git', '.git/', '.pijul/' ]

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

" Vista {{{

let g:vista_close_on_jump=1

let g:vista_default_executive="lcn"

let g:vista_sidebar_position='vertical topleft'

let g:vista_disable_statusline=1

let g:vista_sidebar_width=80

nnoremap <silent> <f6> :Vista!!<cr>

" }}}

" vim: foldenable foldmethod=marker
