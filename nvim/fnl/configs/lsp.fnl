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
			(string.format "<cmd>lua %s()<cr>" func)
			{:noremap true :silent true}))

	(set-map "<c-]>" :vim.lsp.buf.definition)
	(set-map :K "require'lspsaga.hover'.render_hover_doc")
	(set-map :<localleader>* :vim.lsp.buf.document_highlight)
	(set-map :<localleader>a :vim.lsp.buf.code_action)
	(set-map :<localleader>r "require'lspsaga.rename'.rename")
	(set-map :<localleader>ds :vim.lsp.buf.document_symbol)
	(set-map :<localleader>ws :vim.lsp.buf.workspace_symbol)
	(set-map :<localleader>s "require'lspsaga.diagnostic'.show_line_diagnostics")
	(set-map "[d" "require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev")
	(set-map "]d" "require'lspsaga.diagnostic'.lsp_jump_diagnostic_next")

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
