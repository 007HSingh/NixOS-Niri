return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			python = { "flake8" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			lua = { "luacheck" },
			bash = { "shellcheck" },
			markdown = { "markdownlint-cli2" },
			nix = { "statix" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
