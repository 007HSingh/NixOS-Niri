{ config, lib, ... }:

{
  programs.nixvim = {
    # ============================================================================
    # GITSIGNS - Git integration in gutter
    # ============================================================================
    plugins.gitsigns = {
      enable = lib.mkDefault true;
      settings = {
        signs = {
          add = {
            text = "│";
          };
          change = {
            text = "│";
          };
          delete = {
            text = "_";
          };
          topdelete = {
            text = "‾";
          };
          changedelete = {
            text = "~";
          };
          untracked = {
            text = "┆";
          };
        };
        signcolumn = true;
        numhl = false;
        linehl = false;
        word_diff = false;
        current_line_blame = true;
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "eol";
          delay = 300;
          ignore_whitespace = false;
        };
        watch_gitdir = {
          interval = 1000;
          follow_files = true;
        };
        attach_to_untracked = true;
        sign_priority = 6;
        update_debounce = 100;
        status_formatter = null;
        max_file_length = 40000;
        preview_config = {
          border = "rounded";
          style = "minimal";
          relative = "cursor";
          row = 0;
          col = 1;
        };
        on_attach = ''
          function(bufnr)
            local gs = package.loaded.gitsigns
            
            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end
            
            -- Navigation
            map('n', ']c', function()
              if vim.wo.diff then return ']c' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end, {expr=true, desc = 'Next git hunk'})
            
            map('n', '[c', function()
              if vim.wo.diff then return '[c' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end, {expr=true, desc = 'Previous git hunk'})
            
            -- Actions
            map('n', '<leader>hs', gs.stage_hunk, {desc = 'Stage hunk'})
            map('n', '<leader>hr', gs.reset_hunk, {desc = 'Reset hunk'})
            map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Stage hunk'})
            map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Reset hunk'})
            map('n', '<leader>hS', gs.stage_buffer, {desc = 'Stage buffer'})
            map('n', '<leader>hu', gs.undo_stage_hunk, {desc = 'Undo stage hunk'})
            map('n', '<leader>hR', gs.reset_buffer, {desc = 'Reset buffer'})
            map('n', '<leader>hp', gs.preview_hunk, {desc = 'Preview hunk'})
            map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = 'Blame line'})
            map('n', '<leader>tb', gs.toggle_current_line_blame, {desc = 'Toggle line blame'})
            map('n', '<leader>hd', gs.diffthis, {desc = 'Diff this'})
            map('n', '<leader>hD', function() gs.diffthis('~') end, {desc = 'Diff this ~'})
            map('n', '<leader>td', gs.toggle_deleted, {desc = 'Toggle deleted'})
            
            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc = 'Select hunk'})
          end
        '';
      };
    };

    # ============================================================================
    # NEOGIT - Git client
    # ============================================================================
    plugins.neogit = {
      enable = lib.mkDefault true;
      settings = {
        disable_signs = false;
        disable_hint = false;
        disable_context_highlighting = false;
        disable_commit_confirmation = false;
        auto_refresh = true;
        sort_branches = "-committerdate";
        disable_builtin_notifications = false;
        use_magit_keybindings = false;
        commit_popup = {
          kind = "split";
        };
        preview_buffer = {
          kind = "split";
        };
        popup = {
          kind = "split";
        };
        signs = {
          section = [
            ""
            ""
          ];
          item = [
            ""
            ""
          ];
          hunk = [
            ""
            ""
          ];
        };
        integrations = {
          telescope = true;
          diffview = true;
        };
      };
    };

    # ============================================================================
    # DIFFVIEW - Git diff viewer
    # ============================================================================
    plugins.diffview = {
      enable = lib.mkDefault true;
    };
  };
}
