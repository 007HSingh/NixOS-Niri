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

		lint.linters.luacheck = vim.tbl_deep_extend("force", lint.linters.luacheck, {
			args = {
				"--config",
				vim.fn.stdpath("config") .. "/.luacheckrc",
				"--formatter",
				"plain",
				"--codes",
				"--ranges",
				"-",
			},
		})

		local lint_timer = nil
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
			callback = function()
				if lint_timer then
					lint_timer:stop()
				end
				lint_timer = vim.defer_fn(function()
					lint.try_lint()
				end, 300)
			end,
		})
	end,
}
