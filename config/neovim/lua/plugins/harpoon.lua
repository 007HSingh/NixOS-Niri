-- ============================================================================
-- HARPOON — Quick file navigation
-- ============================================================================
return {
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	config = function()
		require("harpoon").setup({})
	end,
}
