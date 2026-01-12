{ config, lib, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    
    # ============================================================================
    # COLORSCHEME - Catppuccin Mocha for consistency with your system theme
    # ============================================================================
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha"; # Dark, warm, minimal aesthetic
        transparent_background = false;
        term_colors = true;
        dim_inactive = {
          enabled = false;
          percentage = 0.15;
        };
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          telescope.enabled = true;
          lsp_trouble = true;
          which_key = true;
          indent_blankline = {
            enabled = true;
            colored_indent_levels = false;
          };
          native_lsp = {
            enabled = true;
            virtual_text = {
              errors = [ "italic" ];
              hints = [ "italic" ];
              warnings = [ "italic" ];
              information = [ "italic" ];
            };
            underlines = {
              errors = [ "underline" ];
              hints = [ "underline" ];
              warnings = [ "underline" ];
              information = [ "underline" ];
            };
          };
        };
      };
    };

    # ============================================================================
    # GENERAL SETTINGS - Sensible defaults for modern editing
    # ============================================================================
    opts = {
      # Line numbers
      number = true;
      relativenumber = true;
      
      # Tabs and indentation
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;
      smartindent = true;
      
      # Search
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;
      
      # UI/UX
      termguicolors = true;
      cursorline = true;
      scrolloff = 8;
      sidescrolloff = 8;
      signcolumn = "yes";
      wrap = false;
      splitbelow = true;
      splitright = true;
      
      # Performance
      updatetime = 250;
      timeoutlen = 300;
      
      # Backup and undo
      backup = false;
      writebackup = false;
      swapfile = false;
      undofile = true;
      
      # Completion
      completeopt = [ "menu" "menuone" "noselect" ];
      
      # Mouse support
      mouse = "a";
      
      # Clipboard
      clipboard = "unnamedplus";
    };

    # ============================================================================
    # GLOBALS - Leader key and other global settings
    # ============================================================================
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # ============================================================================
    # WEB DEVICONS - Explicitly enable to avoid deprecation warning
    # ============================================================================
    plugins.web-devicons.enable = true;

    # ============================================================================
    # FILE EXPLORER - nvim-tree for minimal sidebar navigation
    # ============================================================================
    plugins.nvim-tree = {
      enable = true;
      openOnSetup = false;
      settings = {
        auto_reload_on_write = true;
        disable_netrw = true;
        hijack_cursor = true;
        update_focused_file = {
          enable = true;
          update_root = false;
        };
        view = {
          width = 35;
          side = "left";
          preserve_window_proportions = true;
        };
        renderer = {
          highlight_git = true;
          indent_markers = {
            enable = true;
          };
          icons = {
            git_placement = "after";
            show = {
              file = true;
              folder = true;
              folder_arrow = true;
              git = true;
            };
          };
        };
        filters = {
          dotfiles = false;
          custom = [ ".git" "node_modules" ".cache" ];
        };
      };
    };

    # ============================================================================
    # FUZZY FINDER - Telescope for files, symbols, and project search
    # ============================================================================
    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native = {
          enable = true;
          settings = {
            case_mode = "smart_case";
            fuzzy = true;
            override_file_sorter = true;
            override_generic_sorter = true;
          };
        };
        ui-select.enable = true;
      };
      settings = {
        defaults = {
          prompt_prefix = " 🔍 ";
          selection_caret = " ▶ ";
          path_display = [ "truncate" ];
          file_ignore_patterns = [
            "node_modules"
            ".git/"
            "*.o"
            "*.a"
            "*.out"
            "*.class"
            "*.pdf"
            "*.mkv"
            "*.mp4"
            "*.zip"
          ];
          mappings = {
            i = {
              "<C-j>" = {
                __raw = "require('telescope.actions').move_selection_next";
              };
              "<C-k>" = {
                __raw = "require('telescope.actions').move_selection_previous";
              };
            };
          };
        };
      };
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Find files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Live grep";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Find buffers";
        };
        "<leader>fh" = {
          action = "help_tags";
          options.desc = "Help tags";
        };
        "<leader>fr" = {
          action = "oldfiles";
          options.desc = "Recent files";
        };
        "<leader>fs" = {
          action = "lsp_document_symbols";
          options.desc = "Document symbols";
        };
        "<leader>fw" = {
          action = "lsp_workspace_symbols";
          options.desc = "Workspace symbols";
        };
      };
    };

    # ============================================================================
    # TREESITTER - Advanced syntax highlighting and text objects
    # ============================================================================
    plugins.treesitter = {
      enable = true;
      nixvimInjections = true;
      folding = {
        enable = false;
      };
      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<CR>";
            node_incremental = "<CR>";
            node_decremental = "<BS>";
            scope_incremental = "<TAB>";
          };
        };
      };
    };

    # ============================================================================
    # LSP CONFIGURATION - Language servers for IDE features
    # ============================================================================
    plugins.lsp = {
      enable = true;
      
      # Automatic server installation and management
      servers = {
        # Nix
        nixd.enable = true;
        
        # Lua
        lua_ls = {
          enable = true;
          settings.telemetry.enable = false;
        };
        
        # TypeScript/JavaScript
        ts_ls.enable = true;
        eslint.enable = true;
        
        # HTML/CSS/JSON
        html.enable = true;
        cssls.enable = true;
        jsonls.enable = true;
        
        # YAML
        yamlls.enable = true;
        
        # Docker
        dockerls.enable = true;
        docker_compose_language_service.enable = true;
        
        # Python
        pyright.enable = true;
        
        # Rust
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        
        # Bash
        bashls.enable = true;
        
        # Java
        jdtls.enable = true;
        
        # C/C++
        clangd.enable = true;
        
        # Markdown
        marksman.enable = true;
      };

      # LSP keymaps - accessible when LSP is attached
      keymaps = {
        diagnostic = {
          "<leader>e" = {
            action = "open_float";
            desc = "Show diagnostic";
          };
          "[d" = {
            action = "goto_prev";
            desc = "Previous diagnostic";
          };
          "]d" = {
            action = "goto_next";
            desc = "Next diagnostic";
          };
        };
        lspBuf = {
          "gd" = {
            action = "definition";
            desc = "Go to definition";
          };
          "gD" = {
            action = "declaration";
            desc = "Go to declaration";
          };
          "gi" = {
            action = "implementation";
            desc = "Go to implementation";
          };
          "gr" = {
            action = "references";
            desc = "Show references";
          };
          "K" = {
            action = "hover";
            desc = "Hover documentation";
          };
          "<leader>ca" = {
            action = "code_action";
            desc = "Code action";
          };
          "<leader>rn" = {
            action = "rename";
            desc = "Rename symbol";
          };
          "<leader>f" = {
            action = "format";
            desc = "Format buffer";
          };
        };
      };
    };

    # LSP UI improvements
    plugins.lsp-lines = {
      enable = true;
    };

    plugins.lsp-format.enable = true;

    # ============================================================================
    # COMPLETION - nvim-cmp with icons and snippet support
    # ============================================================================
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      
      settings = {
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
        
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif require('luasnip').expand_or_jumpable() then
                require('luasnip').expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' })
          '';
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require('luasnip').jumpable(-1) then
                require('luasnip').jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' })
          '';
        };
        
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        
        formatting = {
          fields = [ "kind" "abbr" "menu" ];
          format = ''
            function(entry, vim_item)
              local kind_icons = {
                Text = "󰊄",
                Method = "",
                Function = "󰊕",
                Constructor = "",
                Field = "",
                Variable = "󰫧",
                Class = "",
                Interface = "",
                Module = "󰕳",
                Property = "",
                Unit = "",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",
              }
              vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
            end
          '';
        };
        
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
          };
          documentation = {
            border = "rounded";
          };
        };
      };
    };

    # Snippet engine
    plugins.luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
    };

    # ============================================================================
    # GIT INTEGRATION - Gitsigns for inline git status
    # ============================================================================
    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add.text = "│";
          change.text = "│";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
          untracked.text = "┆";
        };
        current_line_blame = true;
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "eol";
          delay = 300;
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
            end, {expr=true, desc = 'Next hunk'})
            
            map('n', '[c', function()
              if vim.wo.diff then return '[c' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end, {expr=true, desc = 'Previous hunk'})
            
            -- Actions
            map('n', '<leader>hs', gs.stage_hunk, {desc = 'Stage hunk'})
            map('n', '<leader>hr', gs.reset_hunk, {desc = 'Reset hunk'})
            map('n', '<leader>hu', gs.undo_stage_hunk, {desc = 'Undo stage hunk'})
            map('n', '<leader>hp', gs.preview_hunk, {desc = 'Preview hunk'})
            map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = 'Blame line'})
            map('n', '<leader>hd', gs.diffthis, {desc = 'Diff this'})
          end
        '';
      };
    };

    # ============================================================================
    # STATUS LINE - Lualine for minimal, informative status
    # ============================================================================
    plugins.lualine = {
      enable = true;
      settings = {
        options = {
          icons_enabled = true;
          theme = "catppuccin";
          component_separators = {
            left = "";
            right = "";
          };
          section_separators = {
            left = "";
            right = "";
          };
          globalstatus = true;
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "branch" "diff" "diagnostics" ];
          lualine_c = [ "filename" ];
          lualine_x = [ "encoding" "fileformat" "filetype" ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
      };
    };

    # ============================================================================
    # BUFFER LINE - Tabline for open buffers
    # ============================================================================
    plugins.bufferline = {
      enable = true;
      settings = {
        options = {
          mode = "buffers";
          numbers = "none";
          diagnostics = "nvim_lsp";
          separator_style = "thin";
          show_buffer_close_icons = false;
          show_close_icon = false;
          always_show_bufferline = true;
          offsets = [
            {
              filetype = "NvimTree";
              text = "File Explorer";
              text_align = "center";
              separator = true;
            }
          ];
        };
      };
    };

    # ============================================================================
    # TEXT EDITING HELPERS
    # ============================================================================
    
    # Auto-pairs for brackets, quotes, etc.
    plugins.nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
        disable_filetype = [ "TelescopePrompt" ];
      };
    };

    # Comment toggle with gc/gcc
    plugins.comment = {
      enable = true;
      settings = {
        toggler = {
          line = "gcc";
          block = "gbc";
        };
        opleader = {
          line = "gc";
          block = "gb";
        };
      };
    };

    # Indent guides
    plugins.indent-blankline = {
      enable = true;
      settings = {
        indent = {
          char = "│";
        };
        scope = {
          enabled = true;
          show_start = false;
          show_end = false;
        };
        exclude = {
          filetypes = [
            "help"
            "alpha"
            "dashboard"
            "nvim-tree"
            "Trouble"
            "lazy"
            "mason"
          ];
        };
      };
    };

    # Which-key for keybinding help
    plugins.which-key = {
      enable = true;
      settings = {
        delay = 300;
        icons = {
          breadcrumb = "»";
          separator = "➜";
          group = "+";
        };
        spec = [
          {
            __unkeyed-1 = "<leader>f";
            group = "Find";
          }
          {
            __unkeyed-1 = "<leader>h";
            group = "Git Hunk";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
          }
          {
            __unkeyed-1 = "<leader>b";
            group = "Buffer";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "Terminal";
          }
        ];
      };
    };

    # Surround text objects
    plugins.nvim-surround.enable = true;

    # Highlight todo comments
    plugins.todo-comments = {
      enable = true;
      settings = {
        signs = true;
      };
    };

    # ============================================================================
    # FORMATTING - conform.nvim for auto-formatting
    # ============================================================================
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          lua = [ "stylua" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          json = [ "prettier" ];
          yaml = [ "prettier" ];
          markdown = [ "prettier" ];
          html = [ "prettier" ];
          css = [ "prettier" ];
          python = [ "black" ];
          rust = [ "rustfmt" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
        };
      };
    };

    # ============================================================================
    # ADDITIONAL UTILITIES
    # ============================================================================
    
    # Better quickfix list
    plugins.trouble = {
      enable = true;
    };

    # Smooth scrolling
    plugins.nvim-scrollbar = {
      enable = true;
    };

    # Color highlighter
    plugins.nvim-colorizer = {
      enable = true;
      userDefaultOptions = {
        RGB = true;
        RRGGBB = true;
        names = false;
        mode = "background";
      };
    };

    # Terminal toggle
    plugins.toggleterm = {
      enable = true;
      settings = {
        direction = "float";
        float_opts = {
          border = "curved";
        };
        open_mapping = "[[<C-\\>]]";
      };
    };

    # ============================================================================
    # CUSTOM KEYMAPS - Ergonomic navigation and actions
    # ============================================================================
    keymaps = [
      # File explorer
      {
        mode = "n";
        key = "<leader>e";
        action = ":NvimTreeToggle<CR>";
        options = {
          silent = true;
          desc = "Toggle file explorer";
        };
      }
      
      # Buffer navigation
      {
        mode = "n";
        key = "<S-l>";
        action = ":bnext<CR>";
        options = {
          silent = true;
          desc = "Next buffer";
        };
      }
      {
        mode = "n";
        key = "<S-h>";
        action = ":bprevious<CR>";
        options = {
          silent = true;
          desc = "Previous buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = ":bdelete<CR>";
        options = {
          silent = true;
          desc = "Delete buffer";
        };
      }
      
      # Window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options = {
          silent = true;
          desc = "Move to left window";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options = {
          silent = true;
          desc = "Move to below window";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options = {
          silent = true;
          desc = "Move to above window";
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options = {
          silent = true;
          desc = "Move to right window";
        };
      }
      
      # Window resizing
      {
        mode = "n";
        key = "<C-Up>";
        action = ":resize +2<CR>";
        options = {
          silent = true;
          desc = "Increase window height";
        };
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = ":resize -2<CR>";
        options = {
          silent = true;
          desc = "Decrease window height";
        };
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = ":vertical resize -2<CR>";
        options = {
          silent = true;
          desc = "Decrease window width";
        };
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = ":vertical resize +2<CR>";
        options = {
          silent = true;
          desc = "Increase window width";
        };
      }
      
      # Clear search highlighting
      {
        mode = "n";
        key = "<Esc>";
        action = ":noh<CR>";
        options = {
          silent = true;
          desc = "Clear search highlight";
        };
      }
      
      # Better indenting
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options = {
          silent = true;
          desc = "Indent left";
        };
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options = {
          silent = true;
          desc = "Indent right";
        };
      }
      
      # Move lines up/down
      {
        mode = "n";
        key = "<A-j>";
        action = ":m .+1<CR>==";
        options = {
          silent = true;
          desc = "Move line down";
        };
      }
      {
        mode = "n";
        key = "<A-k>";
        action = ":m .-2<CR>==";
        options = {
          silent = true;
          desc = "Move line up";
        };
      }
      {
        mode = "v";
        key = "<A-j>";
        action = ":m '>+1<CR>gv=gv";
        options = {
          silent = true;
          desc = "Move selection down";
        };
      }
      {
        mode = "v";
        key = "<A-k>";
        action = ":m '<-2<CR>gv=gv";
        options = {
          silent = true;
          desc = "Move selection up";
        };
      }
      
      # Save and quit shortcuts
      {
        mode = "n";
        key = "<leader>w";
        action = ":w<CR>";
        options = {
          silent = true;
          desc = "Save file";
        };
      }
      {
        mode = "n";
        key = "<leader>q";
        action = ":q<CR>";
        options = {
          silent = true;
          desc = "Quit";
        };
      }
      
      # Trouble (diagnostics)
      {
        mode = "n";
        key = "<leader>xx";
        action = ":Trouble diagnostics toggle<CR>";
        options = {
          silent = true;
          desc = "Toggle diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>xw";
        action = ":Trouble workspace_diagnostics<CR>";
        options = {
          silent = true;
          desc = "Workspace diagnostics";
        };
      }
    ];

    # ============================================================================
    # EXTRA PACKAGES - Additional tools available in Neovim environment
    # ============================================================================
    extraPackages = with pkgs; [
      # Formatters (already in your home.nix but ensuring they're available)
      nixfmt # Use nixfmt instead of nixfmt-rfc-style
      stylua
      prettier
      black
      rustfmt
      shfmt
      
      # Additional tools
      ripgrep # Required for telescope live_grep
      fd # Better find for telescope
      tree-sitter
    ];

    # ============================================================================
    # PERFORMANCE - Lazy loading disabled by default in NixVim, but optimized
    # ============================================================================
    performance = {
      byteCompileLua = {
        enable = true;
        configs = true;
        initLua = true;
        nvimRuntime = true;
        plugins = true;
      };
    };
  };
}
