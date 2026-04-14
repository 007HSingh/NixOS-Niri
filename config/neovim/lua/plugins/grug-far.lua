return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	keys = {
		{
			"<leader>sr",
			function()
				require("grug-far").open()
			end,
			desc = "Search and replace (grug-far)",
		},
		{
			"<leader>sw",
			function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end,
			desc = "Search current word",
		},
		{
			"<leader>sw",
			function()
				require("grug-far").with_visual_selection()
			end,
			mode = "v",
			desc = "Search selection",
		},
	},
	config = function()
		require("grug-far").setup({
			headerMaxWidth = 80,
		})
	end,
}
