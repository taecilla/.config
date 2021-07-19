(local cmd vim.cmd)
(cmd "augroup DefaultBehaviour")
(cmd "autocmd!")
(cmd "autocmd VimEnter * clearjumps")
; Neovim remote
(cmd "autocmd BufRead,BufNewFile addp-hunk-edit.diff setlocal bufhidden=wipe")
(cmd "autocmd FileType gitcommit,gitrebase,help setlocal bufhidden=wipe")
; Restore cursor shape on exit
(cmd "autocmd VimLeave * set guicursor=a:ver35-blinkon1")
; Resize windows proportionally
(cmd "autocmd VimResized * :wincmd =")
(cmd "augroup END")

(local opt vim.opt)
(set opt.clipboard [:unnamed :unnamedplus])
(opt.diffopt:append :vertical)
(set opt.foldmethod :syntax)
(set opt.hidden true)
(set opt.mouse :a)
(set opt.sessionoptions [:curdir :help :tabpages :winsize])
(set opt.shada "'100,rman:,rterm:")
(set opt.shortmess :csF)
(set opt.spelloptions :camel)
(set opt.visualbell true)
(set opt.wildignorecase true)

; Tab pages
(set opt.splitbelow true)
(set opt.splitright true)
