(set vim.opt.scrollback 100000)

(vim.cmd "command! -nargs=* -complete=shellcmd T vsplit | terminal <args>")

(fn set-map [mode lhs rhs]
	(vim.api.nvim_set_keymap mode lhs rhs {:noremap true}))
(set-map :t :<c-\> :<c-\><c-n>)
(set-map :t :<esc> :<c-\><c-n>)
