(fn set-map [lhs rhs]
	(vim.api.nvim_buf_set_keymap 0 :n lhs rhs {:noremap true}))

(set-map :<cr> "")
(set-map :gf "<cmd>call dirvish#open('edit', 0)<cr>")
(set-map :+ "<cmd>lua require'procedures'['create-file'](vim.call('bufname'))<cr>")
