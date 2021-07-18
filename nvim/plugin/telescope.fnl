(local aniseed (require :aniseed.core))
(local pickers (require :telescope.builtin))
(local actions (require :telescope.actions))
(local procedures (require :procedures))
(local sorters (require :telescope.sorters))
(local telescope (require :telescope))

; Custom actions

(fn change-directory? [directory]
	(when (and
		(= (vim.fn.isdirectory directory) 1)
		(= (vim.fn.getcwd) (os.getenv :HOME)))
			(vim.cmd (.. "cd " directory))))

(fn create-file []
	(procedures.create-file (aniseed.first (actions.get_selected_entry))))

(fn edit-command []
	(vim.call :feedkeys (.. ":" (aniseed.first (actions.get_selected_entry)))))

(fn edit-first [prompt-buffer-number]
	(local
		prompt-title
		(. (actions.get_current_picker prompt-buffer-number) :prompt_title))
	(actions.close prompt-buffer-number)
	(match prompt-title
		"Command History" (edit-command)
		"Find Files" (create-file)
		"Oldfiles" (create-file)))

(fn open-file [prompt-buffer-number]
	(actions.select_default prompt-buffer-number)
	(change-directory? (aniseed.first (actions.get_selected_entry))))

(fn open-terminal [prompt-buffer-number]
	(local selected-entry (aniseed.first (actions.get_selected_entry)))
	(local directory (if (= (vim.fn.isdirectory selected-entry) 1)
		selected-entry
		(vim.fn.fnamemodify selected-entry ":h")))
	(print directory)
	(actions.close prompt-buffer-number)
	; termopen destroys the current buffer and cannot be called from a modified
	; one so before calling it a new empty and unchanged buffer is created
	(vim.cmd :enew)
	(vim.fn.termopen (os.getenv :SHELL) {:cwd directory})
	(change-directory? directory))

(telescope.setup {:defaults {
	:borderchars ["─" "│" "─" "│" "┌" "┐" "┘" "└"]
	:file_sorter (. sorters :get_fzy_sorter)
	:layout_config {:prompt_position :top}
	:mappings {:i {
		:<cr> open-file
		:<c-e> edit-first
		:<c-j> actions.move_selection_next
		:<c-k> actions.move_selection_previous
		:<c-q> actions.send_selected_to_qflist
		:<c-s> actions.select_horizontal
		:<c-x> false
		:<c-z> open-terminal
		:<tab> (+ actions.toggle_selection actions.move_selection_next)
		:<s-tab> (+ actions.toggle_selection actions.move_selection_previous)}}
	:sorting_strategy :ascending}})

; Custom finders

(fn add-pijulignore? [tbl]
	; Both fd and rg rise an error if --file-ignore doesn't exist so it must be
	; added conditionally
	(when (= (vim.fn.filereadable :.pijulignore) true)
		(table.insert tbl :--file-ignore=.pijulignore)))

(fn find-files []
	(local
		find-command
		(if (= (vim.fn.getcwd) (os.getenv :HOME))
			[:fd :--color=never :--hidden :--type=d]
			[:fd :--color=never :--exclude=*.enc :--hidden]))
	(add-pijulignore? find-command)
	(pickers.find_files {:find_command find-command}))

(fn grep []
	(if (= (vim.fn.getcwd) (os.getenv :HOME))
		(print "Do not live grep from ~")
		(let [grep-command [:rg :--vimgrep]]
			(add-pijulignore? grep-command)
			(pickers.live_grep {:vimgrep_arguments grep-command}))))

; Mappings

(fn set-map [lhs rhs]
	(vim.api.nvim_set_keymap
		:n
		(string.format :<leader>%s lhs)
		(string.format "<cmd>lua %s()<cr>" rhs)
		{:noremap true :silent true}))

(set-map :b "require'telescope.builtin'.buffers")
(set-map :c "require'telescope.builtin'.command_history")

(set My.find_files find-files)
(set-map :f :My.find_files)

(set My.grep grep)
(set-map :g :My.grep)

(set-map :h "require'telescope.builtin'.oldfiles")
(set-map :q "require'telescope.builtin'.quickfix")
(set-map :s "require'session-lens'.search_session")
(vim.api.nvim_set_keymap
	:n :z=
	"<cmd>lua require'telescope.builtin'.spell_suggest(require'telescope.themes'.get_dropdown())<cr>"
	{})
