return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		local parsers = {
			"lua",
			"vim",
			"vimdoc",
			"javascript",
			"typescript",
			"python",
			"html",
			"css",
			"json",
			"markdown",
		}

		ts.install(parsers)
	end,
}
