{
  pkgs,
  ...
}:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Performance optimizations
    performance = {
      byteCompileLua = {
        enable = true;
        configs = true;
        initLua = true;
        nvimRuntime = true;
        plugins = true;
      };
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "nvim-treesitter"
          "hmts.so"
        ];
      };
    };

    # Color scheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        term_colors = true;
        dim_inactive = {
          enabled = false;
          shade = "dark";
          percentage = 0.15;
        };
        styles = {
          comments = [ "italic" ];
          conditionals = [ "italic" ];
          loops = [ ];
          functions = [ ];
          keywords = [ ];
          strings = [ ];
          variables = [ ];
          numbers = [ ];
          booleans = [ ];
          properties = [ ];
          types = [ ];
          operators = [ ];
        };
        integrations = {
          cmp = true;
          gitsigns = true;
          treesitter = true;
          notify = true;
          telescope.enabled = true;
          which_key = true;
          fidget = true;
          mason = true;
          neotest = true;
          noice = true;
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

    # Global settings
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # Vim options
    opts = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Tabs & indentation
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      autoindent = true;
      smartindent = true;
      breakindent = true;

      # Line wrapping
      wrap = false;
      linebreak = true;

      # Search settings
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;

      # Cursor
      cursorline = true;
      cursorlineopt = "both";
      guicursor = "";

      # Appearance
      termguicolors = true;
      background = "dark";
      signcolumn = "yes";
      cmdheight = 1;
      scrolloff = 8;
      sidescrolloff = 8;
      colorcolumn = "120";
      showmode = false;

      # Backspace
      backspace = "indent,eol,start";

      # Clipboard
      clipboard = "unnamedplus";

      # Split windows
      splitright = true;
      splitbelow = true;
      splitkeep = "screen";

      # Swap and backup
      swapfile = false;
      backup = false;
      writebackup = false;

      # Undo
      undofile = true;
      undolevels = 10000;

      # Update time
      updatetime = 200;
      timeoutlen = 300;

      # Completion
      completeopt = "menu,menuone,noselect";
      pumheight = 15;
      pumblend = 10;

      # File encoding
      fileencoding = "utf-8";

      # Mouse
      mouse = "a";

      # Performance
      lazyredraw = false;
      ttyfast = true;

      # Status line
      laststatus = 3;

      # Show invisible characters
      list = true;
      listchars = "tab:→ ,trail:·,nbsp:␣,extends:▶,precedes:◀";

      # Folding
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldenable = false;
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;

      # Window title
      title = true;
      titlestring = "%<%F%=%l/%L - nvim";

      # Grep
      grepprg = "rg --vimgrep --smart-case --hidden";
      grepformat = "%f:%l:%c:%m";

      # Better diff
      diffopt = "filler,iwhite,internal,linematch:60,algorithm:patience";

      # Formatting
      formatoptions = "jcroqlnt";

      # Better experience
      conceallevel = 2;
      concealcursor = "nc";
      virtualedit = "block";
      inccommand = "split";
      jumpoptions = "view";

      # Session
      sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds";

      # Spelling
      spell = false;
      spelllang = "en_us";

      # Wildmenu
      wildmode = "longest:full,full";
      wildoptions = "pum";

      # Preview substitutions
      icm = "split";
    };

    keymaps = [
      # General
      {
        mode = "n";
        key = ";";
        action = ":";
        options.desc = "Command mode";
      }
      {
        mode = "i";
        key = "jk";
        action = "<ESC>";
        options.desc = "Exit insert mode";
      }
      {
        mode = "n";
        key = "<C-s>";
        action = "<cmd>w<cr>";
        options.desc = "Save file";
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<cr>";
        options.desc = "Clear search highlights";
      }

      # Better navigation
      {
        mode = "n";
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          desc = "Move down (wrapped lines)";
        };
      }
      {
        mode = "n";
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          desc = "Move up (wrapped lines)";
        };
      }

      # Window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Move to left window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Move to right window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Move to bottom window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Move to top window";
      }

      # Resize windows
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options.desc = "Increase window height";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options.desc = "Decrease window height";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options.desc = "Decrease window width";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options.desc = "Increase window width";
      }

      # Buffer navigation
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options.desc = "Delete buffer";
      }
      {
        mode = "n";
        key = "<leader>bD";
        action = "<cmd>%bdelete|edit#|bdelete#<cr>";
        options.desc = "Delete all buffers except current";
      }

      # Better indenting
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options.desc = "Indent left";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options.desc = "Indent right";
      }

      # Move lines
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options.desc = "Move selection down";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options.desc = "Move selection up";
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<cmd>m .+1<cr>==";
        options.desc = "Move line down";
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<cmd>m .-2<cr>==";
        options.desc = "Move line up";
      }

      # Better paste
      {
        mode = [
          "v"
          "x"
        ];
        key = "p";
        action = ''"_dP'';
        options.desc = "Paste without yanking";
      }

      # Center cursor
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
        options.desc = "Scroll down and center";
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
        options.desc = "Scroll up and center";
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
        options.desc = "Next search result";
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options.desc = "Previous search result";
      }

      # Split management
      {
        mode = "n";
        key = "<leader>sv";
        action = "<cmd>vsplit<cr>";
        options.desc = "Split vertically";
      }
      {
        mode = "n";
        key = "<leader>sh";
        action = "<cmd>split<cr>";
        options.desc = "Split horizontally";
      }
      {
        mode = "n";
        key = "<leader>se";
        action = "<C-w>=";
        options.desc = "Equal splits";
      }
      {
        mode = "n";
        key = "<leader>sx";
        action = "<cmd>close<cr>";
        options.desc = "Close split";
      }

      # Quick actions
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<cr>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>confirm q<cr>";
        options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>Q";
        action = "<cmd>qa!<cr>";
        options.desc = "Quit all (no save)";
      }

      # Terminal
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }
      {
        mode = "t";
        key = "<C-h>";
        action = "<cmd>wincmd h<cr>";
        options.desc = "Move to left window";
      }
      {
        mode = "t";
        key = "<C-j>";
        action = "<cmd>wincmd j<cr>";
        options.desc = "Move to bottom window";
      }
      {
        mode = "t";
        key = "<C-k>";
        action = "<cmd>wincmd k<cr>";
        options.desc = "Move to top window";
      }
      {
        mode = "t";
        key = "<C-l>";
        action = "<cmd>wincmd l<cr>";
        options.desc = "Move to right window";
      }

      # Select all
      {
        mode = "n";
        key = "<C-a>";
        action = "ggVG";
        options.desc = "Select all";
      }

      # Toggle options
      {
        mode = "n";
        key = "<leader>uw";
        action = "<cmd>set wrap!<cr>";
        options.desc = "Toggle wrap";
      }
      {
        mode = "n";
        key = "<leader>us";
        action = "<cmd>set spell!<cr>";
        options.desc = "Toggle spell";
      }
      {
        mode = "n";
        key = "<leader>un";
        action = "<cmd>set number!<cr>";
        options.desc = "Toggle line numbers";
      }
      {
        mode = "n";
        key = "<leader>ur";
        action = "<cmd>set relativenumber!<cr>";
        options.desc = "Toggle relative numbers";
      }

      # Diagnostic
      {
        mode = "n";
        key = "<leader>cd";
        action = "vim.diagnostic.open_float";
        lua = true;
        options.desc = "Line diagnostics";
      }

      # Lazygit
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<cr>";
        options.desc = "LazyGit";
      }
    ];

    # Autocommands
    autoGroups = {
      highlight_yank.clear = true;
      resize_splits.clear = true;
      close_with_q.clear = true;
      auto_create_dir.clear = true;
      restore_cursor.clear = true;
      conceallevel.clear = true;
      checktime.clear = true;
    };

    autoCmd = [
      {
        event = "TextYankPost";
        group = "highlight_yank";
        callback.__raw = ''
          function()
            vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
          end
        '';
      }
      {
        event = "VimResized";
        group = "resize_splits";
        command = "tabdo wincmd =";
      }
      {
        event = "FileType";
        group = "close_with_q";
        pattern = [
          "qf"
          "help"
          "man"
          "notify"
          "lspinfo"
          "checkhealth"
          "query"
        ];
        callback.__raw = ''
          function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
          end
        '';
      }
      {
        event = "BufWritePre";
        group = "auto_create_dir";
        callback.__raw = ''
          function(event)
            if event.match:match("^%w%w+://") then return end
            local file = vim.loop.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
          end
        '';
      }
      {
        event = "BufReadPost";
        group = "restore_cursor";
        callback.__raw = ''
          function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end
        '';
      }
      {
        event = "FileType";
        group = "conceallevel";
        pattern = [
          "json"
          "jsonc"
          "json5"
        ];
        command = "setlocal conceallevel=0";
      }
      {
        event = [
          "FocusGained"
          "TermClose"
          "TermLeave"
        ];
        group = "checktime";
        command = "checktime";
      }
    ];

    # Plugin configurations
    plugins = {
      # LSP
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nil_ls.enable = true;
          lua_ls = {
            enable = true;
            settings.Lua = {
              runtime.version = "LuaJIT";
              diagnostics.globals = [ "vim" ];
              workspace = {
                library = [ "\${3rd}/luv/library" ];
                checkThirdParty = false;
              };
              telemetry.enable = false;
              completion.callSnippet = "Replace";
            };
          };
          pyright = {
            enable = true;
            settings.python.analysis = {
              autoSearchPaths = true;
              diagnosticMode = "workspace";
              useLibraryCodeForTypes = true;
              typeCheckingMode = "basic";
            };
          };
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            settings = {
              cargo.allFeatures = true;
              checkOnSave.command = "clippy";
              procMacro.enable = true;
              inlayHints = {
                bindingModeHints.enable = true;
                closingBraceHints.minLines = 10;
                closureReturnTypeHints.enable = "with_block";
                discriminantHints.enable = "fieldless";
                lifetimeElisionHints.enable = "skip_trivial";
                typeHints.hideClosureInitialization = false;
              };
            };
          };
          bashls.enable = true;
          clangd = {
            enable = true;
            cmd = [
              "clangd"
              "--background-index"
              "--clang-tidy"
              "--header-insertion=iwyu"
              "--completion-style=detailed"
              "--function-arg-placeholders"
            ];
          };
          jdtls.enable = true;
          ts_ls = {
            enable = true;
            settings = {
              typescript.inlayHints = {
                includeInlayParameterNameHints = "all";
                includeInlayFunctionParameterTypeHints = true;
                includeInlayVariableTypeHints = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
              };
              javascript.inlayHints = {
                includeInlayParameterNameHints = "all";
                includeInlayFunctionParameterTypeHints = true;
                includeInlayVariableTypeHints = true;
                includeInlayPropertyDeclarationTypeHints = true;
                includeInlayFunctionLikeReturnTypeHints = true;
              };
            };
          };
          jsonls = {
            enable = true;
            settings.json = {
              schemas.__raw = "require('schemastore').json.schemas()";
              validate.enable = true;
            };
          };
          yamlls = {
            enable = true;
            settings.yaml.schemas.__raw = "require('schemastore').yaml.schemas()";
          };
          dockerls.enable = true;
          docker_compose_language_service.enable = true;
          marksman.enable = true;
        };
        keymaps = {
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>e" = "open_float";
            "<leader>qf" = "setloclist";
          };
          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "gi" = "implementation";
            "gr" = "references";
            "gt" = "type_definition";
            "K" = "hover";
            "<leader>ca" = "code_action";
            "<leader>cr" = "rename";
            "<C-k>" = "signature_help";
          };
        };
      };

      # Completion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require('luasnip').expand_or_jumpable() then
                  require('luasnip').expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" })
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
              end, { "i", "s" })
            '';
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          window = {
            completion.border = "rounded";
            documentation.border = "rounded";
          };
          formatting = {
            fields = [
              "kind"
              "abbr"
              "menu"
            ];
            format = ''
              function(_, vim_item)
                local icons = {
                  Text = "󰉿", Method = "󰆧", Function = "󰊕",
                  Constructor = "", Field = "󰜢", Variable = "󰀫",
                  Class = "󰠱", Interface = "", Module = "",
                  Property = "󰜢", Unit = "󰑭", Value = "󰎠",
                  Enum = "", Keyword = "󰌋", Snippet = "",
                  Color = "󰏘", File = "󰈙", Reference = "󰈇",
                  Folder = "󰉋", EnumMember = "", Constant = "󰏿",
                  Struct = "󰙅", Event = "", Operator = "󰆕",
                  TypeParameter = "",
                }
                vim_item.kind = string.format('%s %s', icons[vim_item.kind], vim_item.kind)
                return vim_item
              end
            '';
          };
          experimental.ghost_text = {
            hl_group = "CmpGhostText";
          };
        };
      };

      # Snippets
      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
          store_selection_keys = "<Tab>";
        };
        fromVscode = [
          { paths = "${pkgs.vimPlugins.friendly-snippets}"; }
        ];
      };

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            python = [ "black" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
            markdown = [ "prettier" ];
            rust = [ "rustfmt" ];
            sh = [ "shfmt" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
          };
          format_on_save = {
            timeout_ms = 500;
            lsp_format = "fallback";
          };
        };
      };

      # Linting
      lint = {
        enable = true;
        lintersByFt = {
          python = [ "pylint" ];
          javascript = [ "eslint_d" ];
          typescript = [ "eslint_d" ];
          sh = [ "shellcheck" ];
        };
      };

      # Treesitter
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "<C-space>";
              node_incremental = "<C-space>";
              node_decremental = "<bs>";
              scope_incremental = false;
            };
          };
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          lua
          vim
          vimdoc
          query
          nix
          bash
          python
          rust
          c
          cpp
          java
          html
          css
          javascript
          typescript
          tsx
          json
          yaml
          toml
          markdown
          markdown_inline
          dockerfile
          gitignore
          git_config
          git_rebase
          gitcommit
          gitattributes
          diff
        ];
      };

      # Telescope
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
        settings = {
          defaults = {
            prompt_prefix = "   ";
            selection_caret = " ";
            entry_prefix = "  ";
            sorting_strategy = "ascending";
            layout_strategy = "horizontal";
            layout_config = {
              horizontal = {
                prompt_position = "top";
                preview_width = 0.55;
              };
              width = 0.87;
              height = 0.80;
              preview_cutoff = 120;
            };
            path_display = [ "truncate" ];
            file_ignore_patterns = [
              "^.git/"
              "^node_modules/"
              "^target/"
              "^dist/"
              "^build/"
            ];
            mappings = {
              i = {
                "<C-j>" = "move_selection_next";
                "<C-k>" = "move_selection_previous";
                "<C-n>" = "cycle_history_next";
                "<C-p>" = "cycle_history_prev";
              };
            };
            borderchars = [
              "─"
              "│"
              "─"
              "│"
              "╭"
              "╮"
              "╯"
              "╰"
            ];
          };
          pickers = {
            find_files = {
              hidden = true;
              find_command = [
                "rg"
                "--files"
                "--hidden"
                "--glob"
                "!**/.git/*"
              ];
            };
          };
        };
        keymaps = {
          "<leader><space>" = {
            action = "find_files";
            options.desc = "Find files";
          };
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
          "<leader>fo" = {
            action = "oldfiles";
            options.desc = "Recent files";
          };
          "<leader>fw" = {
            action = "grep_string";
            options.desc = "Find word";
          };
          "<leader>fc" = {
            action = "commands";
            options.desc = "Commands";
          };
          "<leader>fk" = {
            action = "keymaps";
            options.desc = "Keymaps";
          };
          "<leader>fs" = {
            action = "lsp_document_symbols";
            options.desc = "Document symbols";
          };
          "<leader>fS" = {
            action = "lsp_workspace_symbols";
            options.desc = "Workspace symbols";
          };
          "<leader>fd" = {
            action = "diagnostics";
            options.desc = "Diagnostics";
          };
          "<leader>gc" = {
            action = "git_commits";
            options.desc = "Git commits";
          };
          "<leader>gs" = {
            action = "git_status";
            options.desc = "Git status";
          };
          "<leader>gb" = {
            action = "git_branches";
            options.desc = "Git branches";
          };
        };
      };

      # File explorer
      neo-tree = {
        enable = true;
        settings.close_if_last_window = true;
        settings.window = {
          width = 35;
        };
        filesystem = {
          follow_current_file = {
            enabled = true;
            leave_dirs_open = false;
          };
          hijack_netrw_behavior = "open_current";
          use_libuv_file_watcher = true;
          filtered_items = {
            visible = true;
            hide_dotfiles = false;
            hide_gitignored = false;
            hide_by_name = [
              ".git"
              "node_modules"
            ];
          };
        };
        buffers = {
          follow_current_file = {
            enabled = true;
            leave_dirs_open = false;
          };
        };
        gitStatus = {
          window.position = "float";
        };
      };

      # Git integration
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = false;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 300;
          };
          signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
            untracked.text = "▎";
          };
        };
      };

      # LazyGit integration
      lazygit.enable = true;

      # Auto-pairs
      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
          ts_config = {
            lua = [ "string" ];
            javascript = [ "template_string" ];
          };
          fast_wrap = { };
        };
      };

      # Comments
      comment = {
        enable = true;
        settings = {
          opleader.line = "gc";
          opleader.block = "gb";
          toggler = {
            line = "gcc";
            block = "gbc";
          };
        };
      };

      # Todo comments
      todo-comments = {
        enable = true;
        settings = {
          signs = true;
          keywords = {
            FIX = {
              icon = " ";
              color = "error";
              alt = [
                "FIXME"
                "BUG"
                "FIXIT"
                "ISSUE"
              ];
            };
            TODO = {
              icon = " ";
              color = "info";
            };
            HACK = {
              icon = " ";
              color = "warning";
            };
            WARN = {
              icon = " ";
              color = "warning";
              alt = [
                "WARNING"
                "XXX"
              ];
            };
            PERF = {
              icon = " ";
              alt = [
                "OPTIM"
                "PERFORMANCE"
                "OPTIMIZE"
              ];
            };
            NOTE = {
              icon = " ";
              color = "hint";
              alt = [ "INFO" ];
            };
            TEST = {
              icon = "⏲ ";
              color = "test";
              alt = [
                "TESTING"
                "PASSED"
                "FAILED"
              ];
            };
          };
        };
      };

      # Trouble
      trouble = {
        enable = true;
        settings = {
          auto_close = true;
          focus = true;
        };
      };

      # Which-key
      which-key = {
        enable = true;
        settings = {
          delay = 300;
          preset = "modern";
          spec = [
            {
              __unkeyed-1 = "<leader>b";
              group = "buffer";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "code";
            }
            {
              __unkeyed-1 = "<leader>f";
              group = "find";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "git";
            }
            {
              __unkeyed-1 = "<leader>q";
              group = "quit/session";
            }
            {
              __unkeyed-1 = "<leader>s";
              group = "split";
            }
            {
              __unkeyed-1 = "<leader>u";
              group = "ui";
            }
            {
              __unkeyed-1 = "<leader>x";
              group = "diagnostics";
            }
            {
              __unkeyed-1 = "[";
              group = "prev";
            }
            {
              __unkeyed-1 = "]";
              group = "next";
            }
            {
              __unkeyed-1 = "g";
              group = "goto";
            }
          ];
          icons = {
            mappings = false;
          };
        };
      };

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
            tab_char = "│";
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
              "neo-tree"
              "Trouble"
              "lazy"
              "mason"
              "notify"
              "toggleterm"
              "lazyterm"
            ];
          };
        };
      };

      # Notifications
      notify = {
        enable = true;
        settings = {
          background_colour = "#000000";
          fps = 60;
          render = "compact";
          timeout = 3000;
          top_down = true;
        };
      };

      # UI enhancements
      noice = {
        enable = true;
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = false;
          lsp_doc_border = true;
        };
      };

      # Statusline
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "catppuccin";
            globalstatus = true;
            component_separators = {
              left = "|";
              right = "|";
            };
            section_separators = {
              left = "";
              right = "";
            };
            disabled_filetypes = {
              statusline = [
                "dashboard"
                "alpha"
              ];
            };
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [
              "branch"
              "diff"
              "diagnostics"
            ];
            lualine_c = [ "filename" ];
            lualine_x = [
              "encoding"
              "fileformat"
              "filetype"
            ];
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };
        };
      };

      # Bufferline
      bufferline = {
        enable = true;
        settings = {
          options = {
            mode = "buffers";
            diagnostics = "nvim_lsp";
            always_show_bufferline = false;
            offsets = [
              {
                filetype = "neo-tree";
                text = "File Explorer";
                highlight = "Directory";
                text_align = "left";
              }
            ];
            separator_style = "slant";
            show_buffer_close_icons = true;
            show_close_icon = false;
          };
        };
      };

      # Dashboard
      dashboard = {
        enable = true;
        settings = {
          theme = "doom";
          config = {
            header = [
              "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
              "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
              "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
              "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
              "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
              "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];
            center = [
              {
                icon = "  ";
                desc = "Find File           ";
                key = "f";
                action = "Telescope find_files";
              }
              {
                icon = "  ";
                desc = "Recent Files        ";
                key = "r";
                action = "Telescope oldfiles";
              }
              {
                icon = "  ";
                desc = "Find Text           ";
                key = "g";
                action = "Telescope live_grep";
              }
              {
                icon = "  ";
                desc = "Config              ";
                key = "c";
                action = "edit ~/.config/nvim/init.lua";
              }
              {
                icon = "  ";
                desc = "LazyGit             ";
                key = "l";
                action = "LazyGit";
              }
              {
                icon = "  ";
                desc = "Quit                ";
                key = "q";
                action = "qa";
              }
            ];
            footer = [
              ""
              "🚀 Happy Coding!"
            ];
          };
        };
      };

      # Color highlighter
      nvim-colorizer = {
        enable = true;
        settings = {
          user_default_options = {
            RGB = true;
            RRGGBB = true;
            names = false;
            RRGGBBAA = true;
            rgb_fn = true;
            hsl_fn = true;
            css = true;
            css_fn = true;
            mode = "background";
          };
        };
      };

      # Surround
      nvim-surround.enable = true;

      # Smooth scrolling
      neoscroll.enable = true;

      # Better code folding
      nvim-ufo = {
        enable = true;
        settings = {
          provider_selector = ''
            function()
              return {'treesitter', 'indent'}
            end
          '';
        };
      };

      # Web devicons
      web-devicons.enable = true;

      # Fidget (LSP progress)
      fidget = {
        enable = true;
        settings = {
          notification = {
            window = {
              winblend = 0;
              border = "rounded";
            };
          };
        };
      };

      # Illuminate (highlight word under cursor)
      illuminate = {
        enable = true;
        settings = {
          under_cursor = true;
          filetypes_denylist = [
            "neo-tree"
            "Trouble"
            "alpha"
            "dashboard"
          ];
        };
      };

      # Flash (enhanced navigation)
      flash = {
        enable = true;
        settings = {
          modes.search.enabled = true;
        };
      };
    };

    # Extra plugins not available in nixvim
    extraPlugins = with pkgs.vimPlugins; [
      vim-visual-multi
      diffview-nvim
      nvim-spectre
      nvim-bqf
      markdown-preview-nvim
      persistence-nvim
      dressing-nvim
      SchemaStore-nvim
    ];

    # Extra Lua configuration
    extraConfigLua = ''
      -- Additional gitsigns keymaps
      local gitsigns = require('gitsigns')
      vim.keymap.set('n', '<leader>gB', gitsigns.toggle_current_line_blame, { desc = 'Toggle blame line' })
      vim.keymap.set('n', '<leader>gbl', function() gitsigns.blame_line({ full = true }) end, { desc = 'Show blame' })
      vim.keymap.set('n', ']h', gitsigns.next_hunk, { desc = 'Next hunk' })
      vim.keymap.set('n', '[h', gitsigns.prev_hunk, { desc = 'Prev hunk' })
      vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
      vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
      vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
      vim.keymap.set('n', '<leader>ga', gitsigns.stage_hunk, { desc = 'Stage hunk' })
      vim.keymap.set('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })

      -- Neo-tree keymaps
      vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Toggle explorer' })
      vim.keymap.set('n', '<leader>o', '<cmd>Neotree focus<cr>', { desc = 'Focus explorer' })

      -- Trouble keymaps
      vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
      vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer diagnostics' })
      vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location list' })
      vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix list' })

      -- Todo-comments keymap
      vim.keymap.set('n', '<leader>ft', '<cmd>TodoTelescope<cr>', { desc = 'Find TODOs' })

      -- Persistence keymaps
      local persistence = require('persistence')
      vim.keymap.set('n', '<leader>qs', function() persistence.load() end, { desc = 'Restore session' })
      vim.keymap.set('n', '<leader>ql', function() persistence.load({ last = true }) end, { desc = 'Restore last' })
      vim.keymap.set('n', '<leader>qd', function() persistence.stop() end, { desc = "Don't save session" })

      -- Diffview keymaps
      vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Diff view' })
      vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<cr>', { desc = 'File history' })

      -- Spectre keymap
      vim.keymap.set('n', '<leader>sr', function() require('spectre').open() end, { desc = 'Replace (Spectre)' })

      -- Markdown preview
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', { desc = 'Markdown preview' })

      -- Flash keymaps
      vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
      vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash treesitter' })

      -- Vim-visual-multi
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
      }

      -- Set up notify
      vim.notify = require('notify')

      -- Quickfix navigation
      vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = 'Prev quickfix' })
      vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix' })
      vim.keymap.set('n', '<leader>qo', '<cmd>copen<cr>', { desc = 'Open quickfix' })
      vim.keymap.set('n', '<leader>qc', '<cmd>cclose<cr>', { desc = 'Close quickfix' })

      -- Location list navigation
      vim.keymap.set('n', '[l', '<cmd>lprev<cr>', { desc = 'Prev loclist' })
      vim.keymap.set('n', ']l', '<cmd>lnext<cr>', { desc = 'Next loclist' })

      -- Tab navigation
      vim.keymap.set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last tab' })
      vim.keymap.set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First tab' })
      vim.keymap.set('n', '<leader><tab>n', '<cmd>tabnew<cr>', { desc = 'New tab' })
      vim.keymap.set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next tab' })
      vim.keymap.set('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Prev tab' })
      vim.keymap.set('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close tab' })

      -- Format with conform
      vim.keymap.set('n', '<leader>fm', function()
        require('conform').format({ lsp_fallback = true })
      end, { desc = 'Format file' })

      -- Setup persistence
      require('persistence').setup({
        dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/'),
        options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
      })

      -- Setup dressing
      require('dressing').setup({
        input = {
          enabled = true,
          default_prompt = '➤ ',
          win_options = { winblend = 0 },
        },
        select = {
          enabled = true,
          backend = { 'telescope', 'builtin' },
        },
      })

      -- Setup diffview
      require('diffview').setup({})

      -- Setup spectre
      require('spectre').setup({})

      -- Setup nvim-bqf
      require('bqf').setup({})

      -- LSP diagnostic configuration
      local signs = { Error = " ", Warn = " ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 4 },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- LSP handlers with borders
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
      }

      for method, handler in pairs(handlers) do
        vim.lsp.handlers[method] = handler
      end

      -- Additional LSP workspace keymaps
      vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Add workspace folder' })
      vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Remove workspace folder' })
      vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, { desc = 'List workspace folders' })

      -- Telescope additional find all files keymap
      vim.keymap.set('n', '<leader>fa', function()
        require('telescope.builtin').find_files({
          follow = true,
          no_ignore = true,
          hidden = true,
        })
      end, { desc = 'Find all files' })

      -- Quick source current file
      vim.keymap.set('n', '<leader><leader>', function()
        vim.cmd('source %')
        vim.notify('Config sourced!', vim.log.levels.INFO)
      end, { desc = 'Source current file' })
    '';
  };
}
