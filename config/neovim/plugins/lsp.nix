{ config, lib, ... }:

{
  programs.nixvim = {
    # ============================================================================
    # LSP CONFIGURATION
    # ============================================================================
    plugins.lsp = {
      enable = lib.mkDefault true;

      servers = {
        # Nix
        nil = {
          enable = lib.mkDefault true;
        };

        # Lua
        lua_ls = {
          enable = lib.mkDefault true;
          settings = {
            telemetry.enable = false;
            diagnostics = {
              globals = [ "vim" ];
            };
          };
        };

        # TypeScript/JavaScript
        ts_ls = {
          enable = lib.mkDefault true;
        };

        eslint = {
          enable = lib.mkDefault true;
        };

        # HTML/CSS/JSON
        html = {
          enable = lib.mkDefault true;
        };

        cssls = {
          enable = lib.mkDefault true;
        };

        jsonls = {
          enable = lib.mkDefault true;
        };

        # YAML
        yamlls = {
          enable = lib.mkDefault true;
        };

        # Docker
        dockerls = {
          enable = lib.mkDefault true;
        };

        docker_compose_language_service = {
          enable = lib.mkDefault true;
        };

        # Python
        pyright = {
          enable = lib.mkDefault true;
        };

        # Rust
        rust_analyzer = {
          enable = lib.mkDefault true;
          installCargo = false;
          installRustc = false;
        };

        # Bash
        bashls = {
          enable = lib.mkDefault true;
        };

        # Java
        jdtls = {
          enable = lib.mkDefault true;
        };

        # C/C++
        clangd = {
          enable = lib.mkDefault true;
        };

        # Markdown
        marksman = {
          enable = lib.mkDefault true;
        };
      };

      # LSP keymaps
      keymaps = {
        diagnostic = {
          "<leader>cd" = {
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
          "<leader>xq" = {
            action = "setloclist";
            desc = "Diagnostics to loclist";
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
          "go" = {
            action = "type_definition";
            desc = "Go to type definition";
          };
          "gr" = {
            action = "references";
            desc = "Show references";
          };
          "gs" = {
            action = "signature_help";
            desc = "Signature help";
          };
          "K" = {
            action = "hover";
            desc = "Hover documentation";
          };
          "<leader>ca" = {
            action = "code_action";
            desc = "Code action";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename symbol";
          };
          "<leader>cf" = {
            action = "format";
            desc = "Format buffer";
          };
        };
      };
    };

    # ============================================================================
    # LSP-LINES - Better diagnostic display
    # ============================================================================
    plugins.lsp-lines = {
      enable = lib.mkDefault true;
    };

    # ============================================================================
    # LSP-FORMAT - Formatting integration
    # ============================================================================
    plugins.lsp-format = {
      enable = lib.mkDefault true;
    };

    # ============================================================================
    # FIDGET - LSP progress indicator
    # ============================================================================
    plugins.fidget = {
      enable = lib.mkDefault true;
      settings = {
        notification = {
          window = {
            winblend = 0;
          };
        };
      };
    };

    # ============================================================================
    # TROUBLE - Better diagnostics list
    # ============================================================================
    plugins.trouble = {
      enable = lib.mkDefault true;
      settings = {
        auto_close = false;
        auto_open = false;
        auto_preview = true;
        auto_fold = false;
      };
    };

    # Add trouble keymaps
    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = ":Trouble diagnostics toggle<CR>";
        options = {
          silent = true;
          desc = "Toggle diagnostics (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xw";
        action = ":Trouble diagnostics toggle filter.buf=0<CR>";
        options = {
          silent = true;
          desc = "Buffer diagnostics (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xs";
        action = ":Trouble symbols toggle focus=false<CR>";
        options = {
          silent = true;
          desc = "Symbols (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xl";
        action = ":Trouble lsp toggle focus=false win.position=right<CR>";
        options = {
          silent = true;
          desc = "LSP Definitions / references (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xL";
        action = ":Trouble loclist toggle<CR>";
        options = {
          silent = true;
          desc = "Location List (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xQ";
        action = ":Trouble qflist toggle<CR>";
        options = {
          silent = true;
          desc = "Quickfix List (Trouble)";
        };
      }
    ];

    # ============================================================================
    # CONFORM - Formatting
    # ============================================================================
    plugins.conform-nvim = {
      enable = lib.mkDefault true;
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
          kdl = [ "knufmt" ];
        };
      };
    };

    # ============================================================================
    # LINT - Linting
    # ============================================================================
    plugins.lint = {
      enable = lib.mkDefault true;
      lintersByFt = {
        python = [ "pylint" ];
        javascript = [ "eslint" ];
        typescript = [ "eslint" ];
        sh = [ "shellcheck" ];
        bash = [ "shellcheck" ];
      };
    };
  };
}
