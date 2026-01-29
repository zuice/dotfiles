return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- null_ls.builtins.formatting.stylua,
				-- null_ls.builtins.completion.spell,
				require("none-ls.diagnostics.eslint"),
			},
			on_attach = function(client, bufnr)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
				vim.keymap.set("n", "gv", function()
					vim.cmd([[ vsplit ]])
					vim.lsp.buf.definition()
				end, { buffer = bufnr, desc = "Go to definition (vsplit)" })
				vim.keymap.set("n", "gD", function()
					vim.cmd([[ tabnew ]])
					vim.lsp.buf.definition()
				end, { buffer = bufnr, desc = "Go to definition (new tab)" })

				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
	end,
}
