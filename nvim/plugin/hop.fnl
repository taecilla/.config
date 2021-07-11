; Mappings

(local mappings {
	:f "hint_char1({direction = require'hop.hint'.HintDirection.AFTER_CURSOR})"
	:F "hint_char1({direction = require'hop.hint'.HintDirection.BEFORE_CURSOR})"
	:gl "hint_lines()"
	:g/ "hint_patterns()"
	:w "hint_words({direction = require'hop.hint'.HintDirection.AFTER_CURSOR})"
	:b "hint_words({direction = require'hop.hint'.HintDirection.BEFORE_CURSOR})"})
(local modes [:n :o :x])

(each [key cmd (pairs mappings)]
	(each [_ mode (ipairs modes)]
		(vim.api.nvim_set_keymap
			mode
			key
			(string.format "<cmd>lua require'hop'.%s<cr>" cmd)
			{:noremap true})))

; Color schemes

(local cmd vim.api.nvim_command)

(local highlights [
	"HopNextKey ErrorMsg"
	"HopNextKey1 HopNextKey"
	"HopNextKey2 WarningMsg"
	"HopUnmatched Normal"])

(fn set-colors []
	(each [_ highlight (ipairs highlights)]
		(cmd (string.format "highlight! link %s" highlight))))
(set My.set_hop_colors set-colors)

(cmd "augroup FixHopColors")
(cmd "autocmd!")
(cmd "autocmd ColorScheme * call v:lua.My.set_hop_colors()")
(cmd "augroup END")
