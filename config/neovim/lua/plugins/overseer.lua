return {
	"stevearc/overseer.nvim",
	cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild" },
	keys = {
		{ "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer: toggle panel" },
		{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: run task" },
		{ "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer: build" },
		{ "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Overseer: task action" },
	},
	config = function()
		require("overseer").setup({
			task_list = {
				direction = "bottom",
				min_height = 12,
				max_height = 20,
				default_detail = 1,
			},
			templates = { "builtin" },
		})
	end,
}
