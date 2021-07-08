(vim.cmd "augroup ftdetect")
(vim.cmd "autocmd! BufRead,BufNewFile Vagrantfile setfiletype ruby")
(vim.cmd "augroup END")
