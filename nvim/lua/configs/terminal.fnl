(set vim.opt.scrollback 100000)

(vim.cmd "command! -nargs=* -complete=shellcmd T vsplit | terminal <args>")
