-- ============================================================================
-- KEYMAPS — Translated from keymaps.nix + plugin keymaps
-- ============================================================================

local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- ============================================================================
-- GENERAL MAPPINGS
-- ============================================================================

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resizing
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("v", "<Tab>", ">gv", { desc = "Indent and stay in visual" })
map("v", "<S-Tab>", "<gv", { desc = "Unindent and stay in visual" })

-- Move lines up/down
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Clear search highlighting
map("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlight" })

-- Save and quit
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Quit all without saving" })

-- File explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Paste without yanking replaced text
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Split windows
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>sh", ":split<CR>", { desc = "Split horizontally" })
map("n", "<leader>sc", ":close<CR>", { desc = "Close split" })

-- ============================================================================
-- GIT (Neogit / Diffview)
-- ============================================================================
map("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neogit" })
map("n", "<leader>gc", ":Neogit commit<CR>", { desc = "Git commit" })
map("n", "<leader>gp", ":Neogit push<CR>", { desc = "Git push" })
map("n", "<leader>gl", ":Neogit pull<CR>", { desc = "Git pull" })
map("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open diff view" })
map("n", "<leader>gx", ":DiffviewClose<CR>", { desc = "Close diff view" })
map("n", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "File history" })

-- Gitlinker
map("n", "<leader>gy", function() require("gitlinker").get_buf_range_url("n") end, { desc = "Copy git permalink" })
map("v", "<leader>gy", function() require("gitlinker").get_buf_range_url("v") end, { desc = "Copy git permalink (selection)" })
map("n", "<leader>gY", function()
  require("gitlinker").get_buf_range_url("n", require("gitlinker.actions").open_in_browser)
end, { desc = "Open git permalink in browser" })

-- ============================================================================
-- SESSION (Persistence)
-- ============================================================================
map("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session" })
map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
map("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't save session" })

-- ============================================================================
-- TELESCOPE
-- ============================================================================
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
map("n", "<leader>fw", ":Telescope lsp_workspace_symbols<CR>", { desc = "Workspace symbols" })
map("n", "<leader>fd", ":Telescope diagnostics<CR>", { desc = "Diagnostics" })
map("n", "<leader>fc", ":Telescope commands<CR>", { desc = "Commands" })
map("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>fm", ":Telescope marks<CR>", { desc = "Marks" })
map("n", "<leader>fo", ":Telescope vim_options<CR>", { desc = "Vim options" })
map("n", "<leader>ft", ":Telescope colorscheme<CR>", { desc = "Colorscheme" })
map("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find projects" })
map("n", "<leader>fe", ":Telescope file_browser<CR>", { desc = "File browser" })
map("n", "<leader>/", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Search in current buffer" })
map("n", "<leader><space>", ":Telescope find_files<CR>", { desc = "Find files" })

-- ============================================================================
-- LSP (set in lsp.lua on_attach, but Saga keymaps are global)
-- ============================================================================
map("n", "K", ":Lspsaga hover_doc<CR>", { desc = "Hover documentation (Saga)" })
map("n", "gh", ":Lspsaga finder<CR>", { desc = "LSP Finder (Saga)" })
map("n", "gp", ":Lspsaga peek_definition<CR>", { desc = "Peek definition (Saga)" })
map("n", "<leader>ca", ":Lspsaga code_action<CR>", { desc = "Code action (Saga)" })
map("v", "<leader>ca", ":<C-U>Lspsaga code_action<CR>", { desc = "Code action (Saga)" })
map("n", "<leader>cr", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename (IncRename)" })
map("n", "<leader>cl", ":Lspsaga show_line_diagnostics<CR>", { desc = "Line diagnostics (Saga)" })
map("n", "<leader>co", ":Lspsaga outline<CR>", { desc = "Toggle outline (Saga)" })
map("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format buffer" })

-- Diagnostics (standard)
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>xq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- LSP buf actions (set globally; also set per-buffer in on_attach)
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "go", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
map("n", "gs", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- ============================================================================
-- TROUBLE
-- ============================================================================
map("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { desc = "Toggle diagnostics (Trouble)" })
map("n", "<leader>xw", ":Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics (Trouble)" })
map("n", "<leader>xs", ":Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
map("n", "<leader>xl", ":Trouble lsp toggle focus=false win.position=right<CR>", { desc = "LSP Definitions / references (Trouble)" })
map("n", "<leader>xL", ":Trouble loclist toggle<CR>", { desc = "Location List (Trouble)" })
map("n", "<leader>xQ", ":Trouble qflist toggle<CR>", { desc = "Quickfix List (Trouble)" })

-- ============================================================================
-- HARPOON 2
-- ============================================================================
map("n", "<leader>ha", function() require("harpoon"):list():add() end, { desc = "Harpoon add file" })
map("n", "<leader>hm", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, { desc = "Harpoon menu" })
map("n", "<leader>1", function() require("harpoon"):list():select(1) end, { desc = "Harpoon file 1" })
map("n", "<leader>2", function() require("harpoon"):list():select(2) end, { desc = "Harpoon file 2" })
map("n", "<leader>3", function() require("harpoon"):list():select(3) end, { desc = "Harpoon file 3" })
map("n", "<leader>4", function() require("harpoon"):list():select(4) end, { desc = "Harpoon file 4" })

-- ============================================================================
-- SPECTRE (search & replace)
-- ============================================================================
map("n", "<leader>sr", function() require("spectre").open() end, { desc = "Search and replace" })
map("n", "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, { desc = "Search current word" })
map("v", "<leader>sw", function() require("spectre").open_visual() end, { desc = "Search selection" })
map("n", "<leader>sp", function() require("spectre").open_file_search({ select_word = true }) end, { desc = "Search in current file" })

-- ============================================================================
-- MISC PLUGINS
-- ============================================================================
map("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Markdown preview" })
map("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "Stop markdown preview" })
map("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Toggle undotree" })
map("n", "<leader>o", ":Oil<CR>", { desc = "Open oil" })

-- UFO (folding)
map("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
map("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })

-- ============================================================================
-- DAP (debugger)
-- ============================================================================
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue / Start" })
map("n", "<leader>dO", function() require("dap").step_over() end, { desc = "Step over" })
map("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step into" })
map("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step out" })
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Conditional breakpoint" })
map("n", "<leader>dL", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, { desc = "Log point" })
map("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Open REPL" })
map("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run last" })
map("n", "<leader>dq", function() require("dap").terminate(); require("dapui").close() end, { desc = "Terminate session" })
map("n", "<leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "Inspect variable (hover)" })
map("v", "<leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "Inspect selection" })
map("n", "<leader>dp", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end, { desc = "Preview scopes" })

-- ============================================================================
-- OBSIDIAN
-- ============================================================================
map("n", "<leader>on", ":Obsidian new<CR>", { desc = "New note" })
map("n", "<leader>oo", ":Obsidian open<CR>", { desc = "Open in Obsidian app" })
map("n", "<leader>of", ":Obsidian quick_switch<CR>", { desc = "Find note" })
map("n", "<leader>os", ":Obsidian search<CR>", { desc = "Search notes" })
map("n", "<leader>ob", ":Obsidian backlinks<CR>", { desc = "Show backlinks" })
map("n", "<leader>ol", ":Obsidian links<CR>", { desc = "Show links" })
map("n", "<leader>od", ":Obsidian today<CR>", { desc = "Daily note (today)" })
map("n", "<leader>oy", ":Obsidian yesterday<CR>", { desc = "Daily note (yesterday)" })
map("n", "<leader>ot", ":Obsidian template<CR>", { desc = "Insert template" })
map("n", "<leader>op", ":Obsidian paste_img<CR>", { desc = "Paste image" })
map("n", "<leader>or", ":Obsidian rename<CR>", { desc = "Rename note" })
map("n", "<leader>oc", ":Obsidian toggle_checkbox<CR>", { desc = "Toggle checkbox" })
map("v", "<leader>ol", ":Obsidian link<CR>", { desc = "Link selection" })
map("v", "<leader>on", ":Obsidian link_new<CR>", { desc = "Link to new note" })
map("n", "gf", ":Obsidian follow_link<CR>", { desc = "Follow Obsidian link" })
