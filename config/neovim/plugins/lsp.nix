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
        nixd = {
          enable = lib.mkDefault true;
          settings = {
            nixpkgs = {
              expr = "import <unstable> { }";
            };
            formatting = {
              command = [ "nixfmt" ];
            };
            options = {
              nixos = {
                expr = "(builtins.getFlake \"${config.home.homeDirectory}/nixos-config\").nixosConfigurations.nixos.options";
              };
              home_manager = {
                expr = "(builtins.getFlake \"${config.home.homeDirectory}/nixos-config\").homeConfigurations.nixos.options";
              };
            };
          };
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
          settings = {
            checkOnSave = true;
            procMacro = {
              enable = true;
            };
            hover = {
              actions = {
                enable = true;
                references = true;
              };
            };
          };
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
    # RENDER-MARKDOWN - Beautiful docs
    # ============================================================================
    plugins.render-markdown = {
      enable = true;
      settings = {
        render_modes = [
          "n"
          "c"
          "i"
          "v"
        ];
        win_options = {
          conceallevel = {
            default = 2;
          };
        };
      };
    };

    # ============================================================================
    # LSPSAGA - Beautiful LSP UI
    # ============================================================================
    plugins.lspsaga = {
      enable = lib.mkDefault true;
      settings = {
        beacon.enable = true;
        ui = {
          border = "rounded";
          code_action = "󰌵";
        };
        hover = {
          open_cmd = "!firefox";
          open_link = "gx";
        };
        lightbulb.enable = false;
        outline = {
          auto_preview = true;
          close_after_jump = true;
          layout = "float";
          win_width = 30;
        };
      };
    };

    # Override standard LSP keymaps with Saga when available
    keymaps = [
      # LSPSAGA Keymaps
      {
        mode = "n";
        key = "K";
        action = ":Lspsaga hover_doc<CR>";
        options = {
          silent = true;
          desc = "Hover documentation (Saga)";
        };
      }
      {
        mode = "n";
        key = "gh";
        action = ":Lspsaga finder<CR>";
        options = {
          silent = true;
          desc = "LSP Finder (Saga)";
        };
      }
      {
        mode = "n";
        key = "gp";
        action = ":Lspsaga peek_definition<CR>";
        options = {
          silent = true;
          desc = "Peek definition (Saga)";
        };
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = ":Lspsaga code_action<CR>";
        options = {
          silent = true;
          desc = "Code action (Saga)";
        };
      }
      {
        mode = "v";
        key = "<leader>ca";
        action = ":<C-U>Lspsaga code_action<CR>";
        options = {
          silent = true;
          desc = "Code action (Saga)";
        };
      }
      {
        mode = "n";
        key = "<leader>cr";
        action = ":Lspsaga rename<CR>";
        options = {
          silent = true;
          desc = "Rename (Saga)";
        };
      }
      {
        mode = "n";
        key = "<leader>cl";
        action = ":Lspsaga show_line_diagnostics<CR>";
        options = {
          silent = true;
          desc = "Line diagnostics (Saga)";
        };
      }
      {
        mode = "n";
        key = "<leader>co";
        action = ":Lspsaga outline<CR>";
        options = {
          silent = true;
          desc = "Toggle outline (Saga)";
        };
      }

      # TROUBLE Keymaps
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
          kdl = [ "kdlfmt" ];
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
