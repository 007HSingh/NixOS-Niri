-- ============================================================================
-- HARPOON — Quick file navigation
-- ============================================================================
return {
	"ThePrimeagen/harpoon",
  branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	config = function()
		require("harpoon").setup()
	end,
}
