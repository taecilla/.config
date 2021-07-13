(local call vim.fn)
(local fnmodify call.fnamemodify)
(local aniseed (require :aniseed.core))
(local opt vim.opt)
(local edit-patch :addp-hunk-edit.diff)

(fn cursor-position [buftype]
	(if
		(= buftype "") (let [position (call.getcurpos)]
			(string.format "%i≡ %i∥" (. position 2) (. position 3)))
		(= buftype :quickfix) (string.format "%s/%s" (call.line :.) (call.line :$))
		""))

(fn dadbod-buffer? [bufname]
	(> (call.match bufname ".*\\.dbout$") -1))

(fn dadbod-query [bufname]
	(local query-file (.. (fnmodify bufname ":r") :.sql))
	(if (call.filereadable query-file)
		(call.join (call.readfile query-file))
		""))

(fn directory [bufname]
	(if
		(or
			(not= (opt.buftype:get) "")
			(dadbod-buffer?)
			(vim.endswith bufname edit-patch)) ""
		(let [path (fnmodify bufname ":h")]
			(if (and (not= path "") (not= path :.)) (string.format "%s/" path) ""))))

(fn file-status [bufname]
	(if
		(or (not= (opt.buftype:get) "") (dadbod-buffer?)) ""
		(let [
			file (fnmodify bufname ":p")
			read-only (or
				(opt.readonly:get)
				(and (call.filereadable file) (not (call.filewritable file))))
			modified (opt.modified:get)
			icons (.. (if read-only "🔒" "") (if modified "💡" ""))]
			(if (not= icons "") (.. " " icons) ""))))

(fn terminal-title [bufname]
	(local term-title vim.b.term_title)
	(if
		(= term-title bufname) (aniseed.last (call.split bufname ":"))
		term-title))

(fn buffer [bufname buftype filetype]
	(if
		(= buftype :help) (fnmodify bufname ":t:r")
		(= buftype :quickfix) vim.w.quickfix_title
		(= buftype :terminal) (terminal-title bufname)
		(= filetype :dirvish) bufname
		(= filetype :man) (call.substitute bufname "^man://" "" "")
		(= filetype :undotree) :Undotree
		(dadbod-buffer? bufname) (dadbod-query bufname)
		(vim.endswith bufname edit-patch) "Edit patch"
		(vim.startswith bufname :diffpanel_) :Diff
		(not= bufname "") (fnmodify bufname ":t")
		"🆕"))

(fn unicode-window-number []
	(call.nr2char (- (+ 9461 (call.winnr)) 1)))

(fn status-line [active?]
	(local bufname (call.bufname))
	(local buftype (opt.buftype:get))
	(local filetype (opt.filetype:get))
	(string.format "%s%s%s%s%s%s   %%=%s"
		; Left
		(if active?
			:%#StatusLineNC#
			(string.format "%s%s%s  " :%#StatusLine# (unicode-window-number) :%#StatusLineNC#))
		(directory bufname)
		(string.format "%s%s%s"
			(if active? :%#StatusLine# "")
			(buffer bufname buftype filetype)
			(if active? :%#StatusLineNC# ""))
		(if (= (opt.buftype:get) :help) " help" "")
		(if (= (opt.buftype:get) :man) " man" "")
		(file-status bufname)
		; Right
		(if active? (.. :%#StatusLine# (cursor-position buftype)) "")))
(set My.status_line status-line)

(local cmd vim.api.nvim_command)
(cmd "augroup SetStatusline")
(cmd "autocmd!")
(cmd "autocmd BufEnter,TermOpen,WinEnter * setlocal statusline=%{%v:lua.My.status_line(v:true)%}")
(cmd "autocmd BufLeave,WinLeave * setlocal statusline=%{%v:lua.My.status_line(v:false)%}")
(cmd "augroup END")
