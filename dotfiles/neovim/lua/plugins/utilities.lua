return {
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		init = function()
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			dir = vim.fn.stdpath("state") .. "/sessions/",
			need = 1,
			branch = true,
		},
	},

	{
		"kevinhwang91/nvim-ufo",
		event = "BufReadPost",
		dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
		opts = {
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		},
	},

	{ "smjonas/inc-rename.nvim", cmd = "IncRename", opts = {} },

	--- Discord rich presence.
	{ "vyfor/cord.nvim", build = false, event = "VeryLazy", opts = {} },

	{
		"luukvbaal/statuscol.nvim",
		event = "BufReadPost",
		config = function()
			local b = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = true,
				segments = {
					{ text = { b.foldfunc }, click = "v:lua.ScFa" },
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{ text = { b.lnumfunc, " " }, click = "v:lua.ScLa" },
				},
			})
		end,
	},
}
