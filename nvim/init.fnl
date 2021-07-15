; Disable unused features
(local g vim.g)
(set g.loaded_netrw true)
(set g.loaded_netrwPlugin true)
(set g.loaded_node_provider false)
(set g.loaded_perl_provider false)
(set g.loaded_python_provider false)
(set g.loaded_python3_provider false)
(set g.loaded_ruby_provider false)

; Leaders
(fn set-map [lhs rhs]
	(vim.api.nvim_set_keymap :n lhs rhs {:noremap true}))
(set-map :<cr> "")
(set g.mapleader "\r")
(set-map :<space> "")
(set g.maplocalleader " ")

; Load scripts
(global My {})
(require :configs.filetype)
(require :configs.behaviour)
(require :configs.command-line)
(require :configs.lsp)
(require :configs.mappings)
(require :configs.search-and-replace)
(require :configs.status-line)
(require :configs.terminal)
(require :configs.text)
(require :configs.ui)
