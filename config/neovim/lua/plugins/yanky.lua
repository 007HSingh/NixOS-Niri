return {
  "gbprod/yanky.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("yanky").setup({
      ring = { history_length = 100 },
      highlight = { on_put = true, on_yank = true, timer = 150 },
    })
  end,
}
