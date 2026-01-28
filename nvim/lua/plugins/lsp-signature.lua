return {
	"ray-x/lsp_signature.nvim",
	event = "VeryLazy",
	opts = {
		bind = true,
		handler_opts = {
			border = "rounded",
		},
		hint_enable = true,
		floating_window = true,
		hi_parameter = "LspSignatureActiveParameter", -- Color for the current param
	},
	config = function(_, opts)
		require("lsp_signature").setup(opts)
	end,
}
