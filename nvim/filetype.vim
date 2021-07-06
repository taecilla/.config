if exists("did_load_filetypes")
	finish
endif

augroup ftdetect
	autocmd! BufRead,BufNewFile Vagrantfile setfiletype ruby
augroup END
