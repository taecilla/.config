(module procedures)

(defn create-file [path-suggestion]
	(vim.call :feedkeys (.. ":edit " path-suggestion)))
