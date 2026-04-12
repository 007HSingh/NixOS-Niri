{ pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      # ============================================================================
      # DAP - Debug Adapter Protocol client
      # ============================================================================
      dap = {
        enable = true;

        extensions = {
          # ---- DAP UI ----
          dap-ui = {
            enable = true;
            settings = {
              icons = {
                expanded = "";
                collapsed = "";
                current_frame = "";
              };
              controls = {
                enabled = true;
                element = "repl";
                icons = {
                  pause = "";
                  play = "";
                  step_into = "";
                  step_over = "";
                  step_out = "";
                  step_back = "";
                  run_last = "";
                  terminate = "";
                };
              };
              layouts = [
                {
                  elements = [
                    {
                      id = "scopes";
                      size = 0.25;
                    }
                    {
                      id = "breakpoints";
                      size = 0.25;
                    }
                    {
                      id = "stacks";
                      size = 0.25;
                    }
                    {
                      id = "watches";
                      size = 0.25;
                    }
                  ];
                  position = "left";
                  size = 40;
                }
                {
                  elements = [
                    {
                      id = "repl";
                      size = 0.5;
                    }
                    {
                      id = "console";
                      size = 0.5;
                    }
                  ];
                  position = "bottom";
                  size = 10;
                }
              ];
              floating = {
                max_height = null;
                max_width = null;
                border = "rounded";
                mappings = {
                  close = [
                    "q"
                    "<Esc>"
                  ];
                };
              };
              render = {
                max_type_length = null;
                max_value_lines = 100;
              };
            };
          };

          # ---- DAP Virtual Text ----
          dap-virtual-text = {
            enable = true;
            settings = {
              enabled = true;
              enabled_commands = true;
              highlight_changed_variables = true;
              highlight_new_as_changed = false;
              show_stop_reason = true;
              commented = false;
              virt_text_pos = "eol";
              all_frames = false;
            };
          };

          # ---- DAP Python ----
          dap-python = {
            enable = true;
            # Use a python interpreter that has debugpy available
            adapterPythonPath = "${pkgs.python3.withPackages (ps: [ ps.debugpy ])}/bin/python";
          };
        };
      };
    };

    # ============================================================================
    # DAP KEYMAPS
    # ============================================================================
    keymaps = [
      # Open/close DAP UI
      {
        mode = "n";
        key = "<leader>du";
        action.__raw = ''
          function()
            require("dapui").toggle()
          end
        '';
        options = {
          silent = true;
          desc = "Toggle DAP UI";
        };
      }
      # Continue / Start
      {
        mode = "n";
        key = "<leader>dc";
        action.__raw = ''
          function()
            require("dap").continue()
          end
        '';
        options = {
          silent = true;
          desc = "Continue / Start";
        };
      }
      # Step over
      {
        mode = "n";
        key = "<leader>dO";
        action.__raw = ''
          function()
            require("dap").step_over()
          end
        '';
        options = {
          silent = true;
          desc = "Step over";
        };
      }
      # Step into
      {
        mode = "n";
        key = "<leader>di";
        action.__raw = ''
          function()
            require("dap").step_into()
          end
        '';
        options = {
          silent = true;
          desc = "Step into";
        };
      }
      # Step out
      {
        mode = "n";
        key = "<leader>do";
        action.__raw = ''
          function()
            require("dap").step_out()
          end
        '';
        options = {
          silent = true;
          desc = "Step out";
        };
      }
      # Toggle breakpoint
      {
        mode = "n";
        key = "<leader>db";
        action.__raw = ''
          function()
            require("dap").toggle_breakpoint()
          end
        '';
        options = {
          silent = true;
          desc = "Toggle breakpoint";
        };
      }
      # Conditional breakpoint
      {
        mode = "n";
        key = "<leader>dB";
        action.__raw = ''
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end
        '';
        options = {
          silent = true;
          desc = "Conditional breakpoint";
        };
      }
      # Log point
      {
        mode = "n";
        key = "<leader>dL";
        action.__raw = ''
          function()
            require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
          end
        '';
        options = {
          silent = true;
          desc = "Log point";
        };
      }
      # Open REPL
      {
        mode = "n";
        key = "<leader>dr";
        action.__raw = ''
          function()
            require("dap").repl.open()
          end
        '';
        options = {
          silent = true;
          desc = "Open REPL";
        };
      }
      # Run last
      {
        mode = "n";
        key = "<leader>dl";
        action.__raw = ''
          function()
            require("dap").run_last()
          end
        '';
        options = {
          silent = true;
          desc = "Run last";
        };
      }
      # Terminate
      {
        mode = "n";
        key = "<leader>dq";
        action.__raw = ''
          function()
            require("dap").terminate()
            require("dapui").close()
          end
        '';
        options = {
          silent = true;
          desc = "Terminate session";
        };
      }
      # Hover / inspect variable
      {
        mode = "n";
        key = "<leader>dh";
        action.__raw = ''
          function()
            require("dap.ui.widgets").hover()
          end
        '';
        options = {
          silent = true;
          desc = "Inspect variable (hover)";
        };
      }
      {
        mode = "v";
        key = "<leader>dh";
        action.__raw = ''
          function()
            require("dap.ui.widgets").hover()
          end
        '';
        options = {
          silent = true;
          desc = "Inspect selection";
        };
      }
      # Preview (floating scopes)
      {
        mode = "n";
        key = "<leader>dp";
        action.__raw = ''
          function()
            local widgets = require("dap.ui.widgets")
            widgets.centered_float(widgets.scopes)
          end
        '';
        options = {
          silent = true;
          desc = "Preview scopes";
        };
      }
    ];
  };
}
