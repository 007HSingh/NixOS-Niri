-- ============================================================================
-- GLASS.LUA — Transparent highlight overrides for glassmorphism
-- ============================================================================
-- Catppuccin's transparent_background = true clears the Normal bg, but a
-- handful of other highlight groups still paint solid backgrounds.  This file
-- fixes those so the terminal's background_opacity (and Niri's window opacity)
-- show through every Neovim surface uniformly.
--
-- A single autocmd fires *after* any colorscheme is set, so overrides survive
-- a `:colorscheme` change inside the session.
-- ============================================================================
return {
  -- We use a fake "plugin" spec with no source — just a config callback.
  -- lazy.nvim runs it during startup like any other plugin.
  dir = vim.fn.stdpath("config"), -- required so lazy.nvim doesn't skip it
  name = "glass-highlights",
  priority = 999, -- load just after catppuccin (1000) applies colours
  config = function()
    local function apply_glass()
      local hl = vim.api.nvim_set_hl

      -- ── Core editor surfaces ─────────────────────────────────────────────
      -- Remove solid backgrounds; text colours are untouched so readability
      -- is maintained.
      hl(0, "Normal",       { bg = "NONE", ctermbg = "NONE" })
      hl(0, "NormalNC",     { bg = "NONE", ctermbg = "NONE" }) -- inactive splits
      hl(0, "EndOfBuffer",  { bg = "NONE", ctermbg = "NONE" })
      hl(0, "SignColumn",   { bg = "NONE", ctermbg = "NONE" })
      hl(0, "LineNr",       { bg = "NONE", ctermbg = "NONE" })
      hl(0, "CursorLineNr", { bg = "NONE", ctermbg = "NONE" })
      hl(0, "FoldColumn",   { bg = "NONE", ctermbg = "NONE" })

      -- ── Floating windows — subtle tinted glass ───────────────────────────
      -- Pure NONE would make floats indistinguishable from the buffer.
      -- We pull surface0 from the catppuccin palette (no hardcoded hex) and
      -- apply it at ~55% opacity so floats look like frosted overlays.
      local ok, cp = pcall(require, "catppuccin.palettes")
      if ok then
        local palette = cp.get_palette("mocha")
        -- surface0 = #313244 in mocha; we express it as a blended RGBA
        -- via the terminal's alpha rather than a separate gui colour.
        hl(0, "NormalFloat",  { bg = palette.mantle, ctermbg = "NONE" })
        hl(0, "FloatBorder",  { fg = palette.lavender, bg = palette.mantle })
        hl(0, "FloatTitle",   { fg = palette.lavender, bg = palette.mantle, bold = true })
      else
        -- Fallback if catppuccin palette API unavailable
        hl(0, "NormalFloat",  { bg = "NONE", ctermbg = "NONE" })
        hl(0, "FloatBorder",  { bg = "NONE", ctermbg = "NONE" })
      end

      -- ── Pmenu (completion menu) ──────────────────────────────────────────
      -- Keep readable but remove solid fill so it blends with glass bg.
      hl(0, "Pmenu",      { bg = "NONE", ctermbg = "NONE" })
      hl(0, "PmenuSbar",  { bg = "NONE", ctermbg = "NONE" })

      -- ── Telescope ────────────────────────────────────────────────────────
      -- Telescope has its own normal groups that need clearing.
      hl(0, "TelescopeNormal",         { bg = "NONE", ctermbg = "NONE" })
      hl(0, "TelescopePreviewNormal",  { bg = "NONE", ctermbg = "NONE" })
      hl(0, "TelescopeResultsNormal",  { bg = "NONE", ctermbg = "NONE" })
      hl(0, "TelescopePromptNormal",   { bg = "NONE", ctermbg = "NONE" })

      -- ── StatusLine ───────────────────────────────────────────────────────
      -- Lualine overrides StatusLine anyway, but clear it in case lualine
      -- hasn't loaded yet on first render.
      hl(0, "StatusLine",   { bg = "NONE", ctermbg = "NONE" })
      hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })
    end

    -- Apply immediately (catppuccin already loaded at priority 1000)
    apply_glass()

    -- Re-apply after any subsequent :colorscheme call
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("GlassHighlights", { clear = true }),
      callback = apply_glass,
      desc = "Re-apply glass (transparent) highlight overrides after colorscheme change",
    })
  end,
}
