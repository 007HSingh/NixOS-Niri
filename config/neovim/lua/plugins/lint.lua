return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			python = { "ruff" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			lua = { "luacheck" },
			bash = { "shellcheck" },
			markdown = { "markdownlint-cli2" },
			nix = { "statix", "deadnix" },
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

		local lint_timer = vim.uv.new_timer()
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
			callback = function()
				lint_timer:stop()
				lint_timer:start(
					300,
					0,
					vim.schedule_wrap(function()
						lint.try_lint()
					end)
				)
			end,
		})
	end,
}
