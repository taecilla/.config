(fn set-map [mode lhs rhs]
	(vim.api.nvim_set_keymap mode lhs rhs {:noremap true}))

(set-map "" :d "\"_d")
(set-map "" :dd "\"_dd")
(set-map "" :D "\"_D")
(set-map "" :x "\"_x")
(set-map "" :X "\"_X")

(set-map "" :c "\"_c")
(set-map "" :cc "\"_cc")
(set-map "" :C "\"_C")

(set-map "" :yd :d)
(set-map "" :yD :D)
(set-map "" :ydd :dd)

(set-map :x :p "\"_dP")

(set-map :n :Y :y$)

(set-map :n :<c-\> :<esc>)

(set-map :n :ZQ "<cmd>confirm qall<cr>")
(set-map :n :ZZ "<cmd>confirm wqall<cr>")
(set-map :n :gs "<cmd>confirm wall<cr>")

(vim.api.nvim_set_keymap
	:x :v
	"mode() is# 'v' ? \"\\<C-V>\" : mode() is# 'V' ? 'v' : 'V'"
	{:expr true})

(local call vim.fn)

(fn current-dir []
	(string.gsub (call.getcwd) (os.getenv :HOME) "~"))

(fn git-ref []
	(let [
		branch "git symbolic-ref --short HEAD 2> /dev/null | tr -d \"\\n\""
		commit "git rev-parse --short HEAD 2> /dev/null | tr -d \"\\n\""]
		(local ref (call.system (string.format "%s || %s" branch ref)))
		(if (= ref "") "" (string.format "   ⌥ %s" ref))))

(fn c-g []
	(vim.api.nvim_command
		(string.format "echo '%s' '%s'" (current-dir) (git-ref))))
(set My.c_g c-g)

(set-map :n :<c-g> "<cmd>call v:lua.My.c_g()<cr>")
