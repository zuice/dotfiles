return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"typescript",
			"tsx",
			"javascript",
			"lua",
		},
		highlight = {
			enable = true,
			disable = function(_, buf)
				return vim.api.nvim_buf_get_name(buf):find("node_modules", 1, true)
					or vim.api.nvim_buf_line_count(buf) > 10000
			end,
		},
		indent = { enable = true },
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
