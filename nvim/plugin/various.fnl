(local cmd vim.api.nvim_command)
(local g vim.g)

(fn set-map [mode lhs rhs]
	(vim.api.nvim_set_keymap mode lhs rhs {}))

; Editorconfig

(set g.EditorConfig_max_line_indicator :none)

; Git Messenger

(set g.git_messenger_no_default_mappings true)

; MUcomplete

(set g.mucomplete#chains {:default [:omni :path :uspl]})
(set g.mucomplete#enable_auto_at_startup true)
(set g.mucomplete#minimum_prefix_length 1)
(set g:mucomplete#no_mappings false)
(set vim.opt.completeopt [:menuone :noinsert :noselect])

; Orgmode

(let [orgmode (require :orgmode)] (orgmode.setup {}))

; Random colors

(cmd "command! RandomColorScheme lua require'random-colors'()")

; Reflex

(set g.reflex_delete_cmd :trash)

; Rooter

(set g.rooter_patterns [ :.git :.pijul :shell.nix ])
(set g.rooter_resolve_links true)
(set g.rooter_silent_chdir true)

; Sandwich

(set-map :n :s "")
(set-map :x :s "")
; Use c as mnemonic for change
(set-map :n :sc
	"<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)")
(set-map :n :scb
	"<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
(set-map :x :sc "<Plug>(operator-sandwich-replace)")

; Signify

(fn set-up-signify-mappings []
	(set-map :n "]h" "<plug>(signify-next-hunk)")
	(set-map :n "[h" "<plug>(signify-prev-hunk)")
	(set-map :n "]H" "9999]h")
	(set-map :n "[H" "9999[h")
	(set-map :n :<localleader>df :<cmd>SignifyDiff<cr>)
	(set-map :n :<localleader>dh :<cmd>SignifyHunkDiff<cr>)
	(set-map :n :<localleader>uh :<cmd>SignifyHunkUndo<cr>))
(set My.signify_mappings set-up-signify-mappings)

(cmd "augroup SignifySetup")
(cmd "autocmd!")
(cmd "autocmd User SignifySetup call v:lua.My.signify_mappings()")
(cmd "augroup END")

(set g.signify_priority 0)

; Templates

(set g.templates_directory [(.. (vim.fn.stdpath :config) :/templates)])
(set g.templates_global_name_prefix :template.)
(set g.templates_no_builtin_templates true)

; Undotree

(set g.undotree_HelpLine false)
(set g.undotree_SetFocusWhenToggle true)
