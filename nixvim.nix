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

    # Color scheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        integrations = {
          cmp = true;
          gitsigns = true;
          treesitter = true;
          notify = true;
          telescope = true;
          which_key = true;
        };
      };
    };

    # Global options
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
      expandtab = true;
      autoindent = true;
      smartindent = true;

      # Line wrapping
      wrap = false;

      # Search settings
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;

      # Cursor line
      cursorline = true;
      cursorlineopt = "both";

      # Appearance
      termguicolors = true;
      background = "dark";
      signcolumn = "yes";
      cmdheight = 1;
      scrolloff = 8;
      sidescrolloff = 8;

      # Backspace
      backspace = "indent,eol,start";

      # Clipboard
      clipboard = "unnamedplus";

      # Split windows
      splitright = true;
      splitbelow = true;

      # Swapfile
      swapfile = false;
      backup = false;
      writebackup = false;

      # Undo
      undofile = true;
      undolevels = 10000;

      # Update time
      updatetime = 200;
      timeoutlen = 200;

      # Completion
      completeopt = "menu,menuone,noselect";
      pumheight = 10;

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
      foldexpr = "nvim_treesitter#foldexpr()";
      foldenable = false;
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;

      # Window title
      title = true;

      # Grep program
      grepprg = "rg --vimgrep --smart-case --hidden";
      grepformat = "%f:%l:%c:%m";

      # Better diff
      diffopt = "filler,iwhite,internal,linematch:60";

      # Better formatting
      formatoptions = "jcroqlnt";
    };

    # Keymaps
    keymaps = [
      # General
      {
        mode = "n";
        key = ";";
        action = ":";
        options.desc = "CMD enter command mode";
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
        action = "<cmd>noh<cr>";
        options.desc = "Clear highlights";
      }

      # Window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Window left";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Window right";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Window down";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Window up";
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

      # Better indenting
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options.desc = "Indent left and reselect";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options.desc = "Indent right and reselect";
      }

      # Move lines
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options.desc = "Move line down";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options.desc = "Move line up";
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
        mode = "v";
        key = "p";
        action = ''"_dP'';
        options.desc = "Paste without yanking";
      }
      {
        mode = "x";
        key = "p";
        action = ''"_dP'';
        options.desc = "Paste without yanking";
      }

      # Center when scrolling
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
        options.desc = "Next search result and center";
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options.desc = "Previous search result and center";
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
        action = "<cmd>bd<cr>";
        options.desc = "Delete buffer";
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
        options.desc = "Make splits equal size";
      }
      {
        mode = "n";
        key = "<leader>sx";
        action = "<cmd>close<cr>";
        options.desc = "Close current split";
      }

      # Quick save and quit
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<cr>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<cr>";
        options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>Q";
        action = "<cmd>qa!<cr>";
        options.desc = "Quit all without saving";
      }

      # Terminal
      {
        mode = "t";
        key = "<C-x>";
        action = "<C-\\><C-N>";
        options.desc = "Escape terminal mode";
      }
      {
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-N>";
        options.desc = "Escape terminal mode";
      }

      # Select all
      {
        mode = "n";
        key = "<C-a>";
        action = "ggVG";
        options.desc = "Select all";
      }

      # Better increment/decrement
      {
        mode = "n";
        key = "+";
        action = "<C-a>";
        options.desc = "Increment number";
      }
      {
        mode = "n";
        key = "-";
        action = "<C-x>";
        options.desc = "Decrement number";
      }

      # Toggle options
      {
        mode = "n";
        key = "<leader>tn";
        action = "<cmd>set nu!<cr>";
        options.desc = "Toggle line numbers";
      }
      {
        mode = "n";
        key = "<leader>tr";
        action = "<cmd>set rnu!<cr>";
        options.desc = "Toggle relative numbers";
      }
      {
        mode = "n";
        key = "<leader>tw";
        action = "<cmd>set wrap!<cr>";
        options.desc = "Toggle line wrap";
      }
    ];

    # Autocommands
    autoGroups = {
      highlight_yank = {
        clear = true;
      };
      resize_splits = {
        clear = true;
      };
      close_with_q = {
        clear = true;
      };
      auto_create_dir = {
        clear = true;
      };
      restore_cursor = {
        clear = true;
      };
      conceallevel = {
        clear = true;
      };
    };

    autoCmd = [
      # Highlight on yank
      {
        event = "TextYankPost";
        group = "highlight_yank";
        callback.__raw = ''
          function()
            vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
          end
        '';
      }

      # Resize splits on window resize
      {
        event = "VimResized";
        group = "resize_splits";
        command = "tabdo wincmd =";
      }

      # Close certain filetypes with 'q'
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
        ];
        callback.__raw = ''
          function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
          end
        '';
      }

      # Auto create directory when saving
      {
        event = "BufWritePre";
        group = "auto_create_dir";
        callback.__raw = ''
          function(event)
            if event.match:match("^%w%w+://") then
              return
            end
            local file = vim.loop.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
          end
        '';
      }

      # Restore cursor position
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

      # Fix conceallevel for json/markdown
      {
        event = "FileType";
        group = "conceallevel";
        pattern = [
          "json"
          "jsonc"
          "json5"
          "markdown"
        ];
        command = "setlocal conceallevel=0";
      }
    ];

    # Plugins
    plugins = {
      # LSP
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                diagnostics = {
                  globals = [ "vim" ];
                };
                workspace = {
                  library = [
                    "\${3rd}/luv/library"
                  ];
                  checkThirdParty = false;
                };
                telemetry.enable = false;
              };
            };
          };
          pyright = {
            enable = true;
            settings = {
              python.analysis = {
                autoSearchPaths = true;
                diagnosticMode = "workspace";
                useLibraryCodeForTypes = true;
                typeCheckingMode = "basic";
              };
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
              };
              javascript.inlayHints = {
                includeInlayParameterNameHints = "all";
                includeInlayFunctionParameterTypeHints = true;
                includeInlayVariableTypeHints = true;
              };
            };
          };
          jsonls = {
            enable = true;
            settings = {
              json = {
                schemas.__raw = "require('schemastore').json.schemas()";
                validate.enable = true;
              };
            };
          };
          yamlls = {
            enable = true;
            settings = {
              yaml = {
                schemas.__raw = "require('schemastore').yaml.schemas()";
              };
            };
          };
        };
        keymaps = {
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>d" = "open_float";
            "<leader>q" = "setloclist";
          };
          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "gi" = "implementation";
            "gr" = "references";
            "K" = "hover";
            "<leader>ca" = "code_action";
            "<leader>rn" = "rename";
            "<leader>sh" = "signature_help";
          };
        };
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
            java = [ "google-java-format" ];
          };
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
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
            };
          };
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          lua
          vim
          vimdoc
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
          json
          yaml
          toml
          markdown
          markdown_inline
        ];
      };

      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 3;
        };
      };

      treesitter-textobjects.enable = true;

      # Telescope
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
        settings = {
          defaults = {
            selection_caret = " ";
            path_display = [ "truncate" ];
            file_ignore_patterns = [
              "node_modules"
              ".git/"
              "dist/"
              "build/"
            ];
            mappings = {
              i = {
                "<C-j>" = "move_selection_next";
                "<C-k>" = "move_selection_previous";
              };
            };
          };
          pickers = {
            find_files = {
              hidden = true;
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
          "<leader>fo" = {
            action = "oldfiles";
            options.desc = "Recent files";
          };
          "<leader>fw" = {
            action = "grep_string";
            options.desc = "Find word under cursor";
          };
          "<leader>fc" = {
            action = "commands";
            options.desc = "Find commands";
          };
          "<leader>fk" = {
            action = "keymaps";
            options.desc = "Find keymaps";
          };
          "<leader>fs" = {
            action = "lsp_document_symbols";
            options.desc = "Document symbols";
          };
          "<leader>fS" = {
            action = "lsp_workspace_symbols";
            options.desc = "Workspace symbols";
          };
          "<leader>gc" = {
            action = "git_commits";
            options.desc = "Git commits";
          };
          "<leader>gs" = {
            action = "git_status";
            options.desc = "Git status";
          };
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
        };
      };

      # Auto-pairs
      nvim-autopairs = {
        enable = true;
        settings = {
          fast_wrap = { };
          disable_filetype = [
            "TelescopePrompt"
            "vim"
          ];
        };
      };

      # Comments
      comment = {
        enable = true;
      };

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
            tab_char = "│";
          };
          scope.enabled = false;
          exclude = {
            filetypes = [
              "help"
              "alpha"
              "dashboard"
              "nvdash"
              "neo-tree"
              "Trouble"
              "lazy"
              "mason"
            ];
          };
        };
      };

      # Todo comments
      todo-comments = {
        enable = true;
      };

      # Trouble (diagnostics)
      trouble = {
        enable = true;
      };

      # File explorer
      neo-tree = {
        enable = true;
        filesystem = {
          followCurrentFile.enabled = true;
          hijackNetrwBehavior = "open_current";
          filteredItems = {
            visible = true;
            hideDotfiles = false;
            hideGitignored = false;
          };
        };
        window = {
          width = 30;
          mappings = {
            "l" = "open";
            "h" = "close_node";
          };
        };
      };

      # Which-key
      which-key = {
        enable = true;
        settings = {
          preset = "modern";
          delay = 200;
        };
      };

      # Notifications
      notify = {
        enable = true;
        timeout = 3000;
      };

      # Smooth scrolling
      neoscroll.enable = true;

      # Surround
      nvim-surround.enable = true;

      # Color highlighter
      nvim-colorizer = {
        enable = true;
        userDefaultOptions = {
          RGB = true;
          RRGGBB = true;
          names = false;
          RRGGBBAA = true;
          rgb_fn = true;
          hsl_fn = true;
          css = true;
          css_fn = true;
        };
      };

      # Better code folding
      nvim-ufo = {
        enable = true;
      };

      # Lualine (statusline)
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
          };
        };
      };

      # Bufferline
      bufferline = {
        enable = true;
        settings = {
          options = {
            diagnostics = "nvim_lsp";
            offsets = [
              {
                filetype = "neo-tree";
                text = "File Explorer";
                highlight = "Directory";
                text_align = "left";
              }
            ];
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
                desc = "Find File";
                key = "f";
                action = "Telescope find_files";
              }
              {
                icon = "  ";
                desc = "Recent Files";
                key = "r";
                action = "Telescope oldfiles";
              }
              {
                icon = "  ";
                desc = "Find Text";
                key = "g";
                action = "Telescope live_grep";
              }
              {
                icon = "  ";
                desc = "Config";
                key = "c";
                action = "edit ~/.config/nvim/init.lua";
              }
              {
                icon = "  ";
                desc = "Quit";
                key = "q";
                action = "qa";
              }
            ];
          };
        };
      };

      # Web devicons
      web-devicons.enable = true;
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
      schemastore-nvim
    ];

    # Extra Lua configuration
    extraConfigLua = ''
      -- Additional gitsigns keymaps
      local gitsigns = require('gitsigns')
      vim.keymap.set('n', '<leader>gb', gitsigns.toggle_current_line_blame, { desc = 'Toggle git blame line' })
      vim.keymap.set('n', '<leader>gB', function() gitsigns.blame_line({ full = true }) end, { desc = 'Show git blame' })
      vim.keymap.set('n', ']h', gitsigns.next_hunk, { desc = 'Next git hunk' })
      vim.keymap.set('n', '[h', gitsigns.prev_hunk, { desc = 'Previous git hunk' })
      vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview git hunk' })
      vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset git hunk' })
      vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset git buffer' })
      vim.keymap.set('n', '<leader>ga', gitsigns.stage_hunk, { desc = 'Stage git hunk' })
      vim.keymap.set('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo stage git hunk' })

      -- Neo-tree keymaps
      vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Toggle file explorer' })
      vim.keymap.set('n', '<leader>o', '<cmd>Neotree focus<cr>', { desc = 'Focus file explorer' })

      -- Trouble keymaps
      vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
      vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
      vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
      vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })

      -- Todo-comments keymap
      vim.keymap.set('n', '<leader>ft', '<cmd>TodoTelescope<cr>', { desc = 'Find TODOs' })

      -- Persistence keymaps
      local persistence = require('persistence')
      vim.keymap.set('n', '<leader>qs', function() persistence.load() end, { desc = 'Restore Session' })
      vim.keymap.set('n', '<leader>ql', function() persistence.load({ last = true }) end, { desc = 'Restore Last Session' })
      vim.keymap.set('n', '<leader>qd', function() persistence.stop() end, { desc = "Don't Save Current Session" })

      -- Diffview keymaps
      vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Git Diff View' })
      vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<cr>', { desc = 'Git File History' })

      -- Spectre keymap
      vim.keymap.set('n', '<leader>sr', function() require('spectre').open() end, { desc = 'Replace in files (Spectre)' })

      -- Markdown preview keymap
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', { desc = 'Markdown Preview' })

      -- Vim-visual-multi settings
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
      }

      -- Set up notify as default
      vim.notify = require('notify')

      -- Quickfix and location list navigation
      vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = 'Previous quickfix' })
      vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix' })
      vim.keymap.set('n', '<leader>qo', '<cmd>copen<cr>', { desc = 'Open quickfix' })
      vim.keymap.set('n', '<leader>qc', '<cmd>cclose<cr>', { desc = 'Close quickfix' })
      vim.keymap.set('n', '[l', '<cmd>lprev<cr>', { desc = 'Previous loclist' })
      vim.keymap.set('n', ']l', '<cmd>lnext<cr>', { desc = 'Next loclist' })
      vim.keymap.set('n', '<leader>lo', '<cmd>lopen<cr>', { desc = 'Open loclist' })
      vim.keymap.set('n', '<leader>lc', '<cmd>lclose<cr>', { desc = 'Close loclist' })

      -- Tab navigation
      vim.keymap.set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
      vim.keymap.set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
      vim.keymap.set('n', '<leader><tab>n', '<cmd>tabnew<cr>', { desc = 'New Tab' })
      vim.keymap.set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
      vim.keymap.set('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
      vim.keymap.set('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })

      -- Format with conform
      vim.keymap.set('n', '<leader>fm', function() 
        require('conform').format({ lsp_fallback = true }) 
      end, { desc = 'Format file' })

      -- Setup persistence
      require('persistence').setup({
        dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/'),
        options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
      })

      -- Setup dressing for better UI
      require('dressing').setup({
        input = {
          enabled = true,
          default_prompt = '➤ ',
          win_options = {
            winblend = 0,
          },
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
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
        },
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
