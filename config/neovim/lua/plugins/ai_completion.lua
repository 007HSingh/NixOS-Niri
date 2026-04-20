-- ============================================================================
-- AI COMPLETIONS — Supermaven (fast, free tier available)
-- ============================================================================
-- Supermaven uses a purpose-built transformer model with a 1M token context
-- window. It's significantly faster than Copilot (sub-50ms on most hardware)
-- and integrates cleanly into nvim-cmp as a source.
--
-- FREE TIER: Full-speed completions, no login required for basic use.
-- PRO TIER:  Chat, longer context, priority inference ($10/mo).
--
-- ============================================================================
return {
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		config = function()
			require("supermaven-nvim").setup({
				disable_inline_completion = true,
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
				ignore_filetypes = {
					"TelescopePrompt",
					"alpha",
					"lazy",
					"mason",
					"help",
					"log",
				},
				-- Log level: "off" | "warn" | "error"
				log_level = "warn",
			})
		end,
	},
}
