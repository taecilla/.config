(local cmd vim.cmd)
(cmd "augroup ToggleSearchHighlighting")
(cmd "autocmd!")
(cmd "autocmd InsertEnter * setlocal nohlsearch")
(cmd "autocmd InsertLeave * setlocal hlsearch")
(cmd "augroup END")

(local opt vim.opt)
(set opt.gdefault true) ; Substitutes all matches on a line by default
(set opt.ignorecase true)
(set opt.inccommand :nosplit)
(set opt.smartcase true)

(fn set-map [mode lhs rhs]
	(vim.api.nvim_set_keymap mode lhs rhs {:noremap true}))
(set-map :n :n :nzz)
(set-map :n :N :Nzz)
(set-map :v :n :nzz)
(set-map :v :N :Nzz)
(set-map :n :<leader>s ":%s/\\<<C-r><C-w>\\>/")
