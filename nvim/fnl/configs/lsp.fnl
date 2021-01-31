(module plugins.lsp {:require {
	lspconfig lspconfig
	lsputil	lspconfig/util}})

(def- api vim.api)
(def- cmd api.nvim_command)

(cmd "highlight! link LspReferenceRead Search")

(defn set-up [client buffer-number]
	; Buffer auto commands

	(cmd "augroup LspSetUp")
	(cmd "autocmd!")
	(cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	(cmd "autocmd InsertEnter <buffer> lua vim.lsp.buf.clear_references()")
	(cmd "augroup END")

	; Buffer mappings

	(fn set-map [lhs func]
		(api.nvim_buf_set_keymap
			buffer-number
			:n
			lhs
			(string.format "<cmd>lua vim.lsp.buf.%s()<cr>" func)
			{:noremap true :silent true}))

	(set-map "<c-]>" :definition)
	(set-map :K :hover)
	(set-map :<localleader>* :document_highlight)
	(set-map :<localleader>a :code_action)
	(set-map :<localleader>r :rename)
	(set-map :<localleader>ds :document_symbol)
	(set-map :<localleader>ws :workspace_symbol)

	; Buffer options

	(fn set-option [option value]
		(api.nvim_buf_set_option
			buffer-number
			option
			(string.format "v:lua.vim.lsp.%s" value)))

	(set-option :omnifunc :omnifunc))

; Attach configuration to every server

(def- servers [
	:dhall_lsp_server
	:hls
	:metals
	:purescriptls
	:rls
	:rnix
	:sumneko_lua])

(each [_ name (ipairs servers)]
	(local server (. lspconfig name))
	(server.setup {:on_attach set-up}))
