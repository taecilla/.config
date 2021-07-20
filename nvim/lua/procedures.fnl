(module procedures {require {path plenary.path}})

(defn create-file [path-suggestion]
	(vim.call :feedkeys (.. ":edit " path-suggestion)))

(defn quickfix-entry-maker [entry]
	(local filename (:
		(path:new (or entry.filename (vim.api.nvim_buf_get_name entry.bufnr)))
		:make_relative
		(vim.fn.getcwd)))
	(local lnum entry.lnum)
	(local col entry.col)
	{
		:filename filename
		:ordinal filename
		:lnum lnum
		:col col
		:display (string.format "%s:%i:%i" filename lnum col)
		:ordinal filename
		:value entry})
