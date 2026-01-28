return {
	"mason-org/mason-lspconfig.nvim",
	opts = function()
		CAPABILITIES = require("blink.cmp").get_lsp_capabilities()
	end,
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
		"saghen/blink.cmp",
	},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({ capabilities = CAPABILITIES })

			vim.lsp.config(server_name, { capabilities = CAPABILITIES })
		end,
	},
	config = function()
		require("mason-lspconfig").setup({})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})
	end,
}
