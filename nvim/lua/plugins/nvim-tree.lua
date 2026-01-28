return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("nvim-tree").setup({
			hijack_netrw = true,
			hijack_cursor = false,
			update_focused_file = { enable = true, update_cwd = false },
			diagnostics = { enable = false },
			view = { width = 30, side = "left", number = false, relativenumber = false },
			actions = { open_file = { quit_on_open = false } },
		})

		-- useful keymap: toggle tree
		vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
	end,
}
