return {
	"chentoast/marks.nvim",
	event = "BufReadPost",
	config = function()
		require("marks").setup({
			default_mappings = true, -- mx, m', m[ m] etc.
			signs = true,
			mappings = {},
		})
	end,
}
