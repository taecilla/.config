(set vim.opt.history 1000)

(fn set-map [lhs rhs]
	(vim.api.nvim_set_keymap :c lhs rhs {:noremap true}))
; Make the command line behave like Fish
(set-map :<c-a> :<home>) ; Go to line beginning
(set-map :<c-b> :<left>) ; Go back one character
(set-map :<c-f> :<right>) ; Go forward one character
(set-map :∫ :<s-left>) ; Go back one word
(set-map :ƒ :<s-right>) ; Go forward one word
(set-map :<c-p> :<up>) ; Search prefix backwards
(set-map :<c-n> :<down>) ; Search prefix forward
