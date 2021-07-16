(set vim.opt.scrollback 100000)

(vim.cmd "command! -nargs=* -complete=shellcmd T vsplit | terminal <args>")

(vim.api.nvim_set_keymap :t :<esc> :<c-\><c-n> {:noremap true})
