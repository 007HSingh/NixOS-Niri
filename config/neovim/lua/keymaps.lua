local map = function(mode, lhs, rhs, opts)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true }, opts or {}))
end

-- suppress; do not remove
map({ "n", "v" }, "<Space>", "<Nop>")

-- window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- window splits (under <leader>w)
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
map("n", "<leader>wh", "<cmd>split<cr>", { desc = "Split horizontal" })
map("n", "<leader>wc", "<cmd>close<cr>", { desc = "Close split" })

-- window resize
map("n", "<C-Up>", "<cmd>resize -2<cr>", { desc = "Shrink height" })
map("n", "<C-Down>", "<cmd>resize +2<cr>", { desc = "Grow height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Shrink width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Grow width" })

-- buffer navigation
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- indenting (stay in visual)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("v", "<Tab>", ">gv", { desc = "Indent right" })
map("v", "<S-Tab>", "<gv", { desc = "Indent left" })

-- move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- search
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear search" })
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- file
map("n", "<leader>W", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all" })

-- paste without yanking
map("v", "p", '"_dP', { desc = "Paste no-yank" })
map("x", "<leader>p", '"_dP', { desc = "Paste no-yank (x)" })

-- disable Q
map("n", "Q", "<nop>")

-- git
map("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
map("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit" })
map("n", "<leader>gp", "<cmd>Neogit push<cr>", { desc = "Git push" })
map("n", "<leader>gl", "<cmd>Neogit pull<cr>", { desc = "Git pull" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diff view" })
map("n", "<leader>gx", "<cmd>DiffviewClose<cr>", { desc = "Close diff" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "File history" })

-- session (persistence)
map("n", "<leader>qs", function()
	require("persistence").load()
end, { desc = "Restore session" })
map("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end, { desc = "Last session" })
map("n", "<leader>qd", function()
	require("persistence").stop()
end, { desc = "Stop session" })

-- harpoon
map("n", "<leader>ha", function()
	require("harpoon"):list():add()
end, { desc = "Harpoon add" })
map("n", "<leader>hm", function()
	require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end, { desc = "Harpoon menu" })
map("n", "<leader>1", function()
	require("harpoon"):list():select(1)
end, { desc = "Harpoon 1" })
map("n", "<leader>2", function()
	require("harpoon"):list():select(2)
end, { desc = "Harpoon 2" })
map("n", "<leader>3", function()
	require("harpoon"):list():select(3)
end, { desc = "Harpoon 3" })
map("n", "<leader>4", function()
	require("harpoon"):list():select(4)
end, { desc = "Harpoon 4" })

-- diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>xq", vim.diagnostic.setloclist, { desc = "Diagnostics loclist" })

-- trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
map("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP refs" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Loclist" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix" })

-- format
map("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- toggles (all global toggles live here)
map("n", "<leader>tf", function()
	vim.g.disable_format_on_save = not vim.g.disable_format_on_save
	vim.notify("Format on save: " .. (vim.g.disable_format_on_save and "off" or "on"))
end, { desc = "Toggle format on save" })
map("n", "<leader>tl", function()
	local cur = vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_lines = not cur })
end, { desc = "Toggle diagnostic virtual lines" })
