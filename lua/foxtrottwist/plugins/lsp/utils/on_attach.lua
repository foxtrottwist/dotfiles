return function(_, bufnr)
	-- A function to easily define mappings specific to LSP related items.
	-- It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { noremap = true, silent = true, buffer = bufnr, desc = desc })
	end

	nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
	nmap("gd", "<cmd>Glance definitions<CR>", "Peek definition and edit in window")
	nmap("gi", vim.lsp.buf.implementation, "Go to implementation")
	nmap("K", vim.lsp.buf.hover, "Show documentation for what is under cursor")
	nmap("<leader>ca", vim.lsp.buf.code_action, "See available code actions")
	nmap("<leader>fr", "<cmd>Telescope lsp_references<CR>", "Show definition references")
	nmap("<leader>ld", vim.diagnostic.open_float, "show diagnostics for line")
	nmap("<leader>d", vim.diagnostic.open_float, "show diagnostics for cursor")
	nmap("[d", vim.diagnostic.goto_prev, "jump to previous diagnostic in buffer")
	nmap("]d", vim.diagnostic.goto_next, "jump to next diagnostic in buffer")
	nmap("<leader>rn", ":IncRename ", "Smart rename")
	nmap("<leader>sd", "<cmd>Telescope lsp_document_symbols<CR>", "Show current document symbols")
	nmap("<leader>sw", "<cmd>Telescope lsp_workspace_symbols<CR>", "Show workspace symbols")
end
