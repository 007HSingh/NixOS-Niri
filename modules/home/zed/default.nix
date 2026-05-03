# Zed Editor
{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.home.zed;
in
{
  options.modules.home.zed.enable =
    lib.mkEnableOption "Zed editor with LSP, Catppuccin theme, and settings";

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;

      extensions = [
        "TOML"
        "HTML"
        "Java"
        "Lua"
        "Dockerfile"
        "LaTeX"
        "Nix"
      ];

      userSettings = {
        auto_install_extensions = {
          "catppuccin" = true;
          "catppuccin-icons" = true;
          "TOML" = true;
          "HTML" = true;
          "Java" = true;
          "Lua" = true;
          "Dockerfile" = true;
          "LaTeX" = true;
          "Nix" = true;
        };

        assistant = {
          enabled = false;
          version = "2";
        };

        hour_format = "hour24";
        auto_update = false;

        terminal = {
          alternate_scroll = "off";
          blinking = "off";
          copy_on_select = "off";
          dock = "bottom";
          font_family = "Maple Mono NF";
          line_height = "comfortable";
          option_as_meta = false;
          button = false;
          shell = "system";
          toolbar = {
            title = true;
          };
          working_directory = "current_project_directory";
        };

        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        vim_mode = false;

        buffer_font_family = "Maple Mono NF";
        buffer_font_size = 16.0;
        buffer_font_features = {
          calt = true;
        };

        format_on_save = "on";

        load_direnv = "shell_hook";
        base_keymap = "VSCode";

        languages = {
          "Nix" = {
            language_servers = [ "nixd" ];
            formatter = {
              external = {
                command = "nixfmt";
                arguments = [ "{buffer_path}" ];
              };
            };
          };
          "Lua" = {
            language_servers = [ "lua-language-server" ];
            formatter = {
              external = {
                command = "stylua";
                arguments = [ "-" ];
              };
            };
          };
          "Python" = {
            language_servers = [ "pyright" ];
            formatter = {
              external = {
                command = "black";
                arguments = [ "-" ];
              };
            };
          };
          "TypeScript" = {
            language_servers = [ "typescript-language-server" ];
            formatter = {
              external = {
                command = "prettier";
                arguments = [
                  "--stdin-filepath"
                  "{buffer_path}"
                ];
              };
            };
          };
          "JavaScript" = {
            language_servers = [ "typescript-language-server" ];
            formatter = {
              external = {
                command = "prettier";
                arguments = [
                  "--stdin-filepath"
                  "{buffer_path}"
                ];
              };
            };
          };
          "Rust" = {
            language_servers = [ "rust-analyzer" ];
            formatter = {
              external = {
                command = "rustfmt";
                arguments = [
                  "--emit"
                  "stdout"
                ];
              };
            };
          };
          "Java" = {
            language_servers = [ "jdtls" ];
            formatter = {
              external = {
                command = "google-java-format";
                arguments = [ "-" ];
              };
            };
          };
          "Shell Script" = {
            language_servers = [ "bash-language-server" ];
            formatter = {
              external = {
                command = "shfmt";
                arguments = [ "-" ];
              };
            };
          };
          "HTML" = {
            language_servers = [ "vscode-html-language-server" ];
            formatter = {
              external = {
                command = "prettier";
                arguments = [
                  "--stdin-filepath"
                  "{buffer_path}"
                ];
              };
            };
          };
          "CSS" = {
            language_servers = [ "vscode-css-language-server" ];
            formatter = {
              external = {
                command = "prettier";
                arguments = [
                  "--stdin-filepath"
                  "{buffer_path}"
                ];
              };
            };
          };
          "JSON" = {
            language_servers = [ "vscode-json-language-server" ];
            formatter = {
              external = {
                command = "prettier";
                arguments = [
                  "--stdin-filepath"
                  "{buffer_path}"
                ];
              };
            };
          };
          "YAML" = {
            language_servers = [ "yaml-language-server" ];
            formatter = {
              external = {
                command = "prettier";
                arguments = [
                  "--stdin-filepath"
                  "{buffer_path}"
                ];
              };
            };
          };
        };

      };
    };

    catppuccin.zed = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
      italics = true;
      icons = {
        enable = true;
        flavor = "mocha";
      };
    };

    programs.zed-editor.userSettings.theme = lib.mkForce {
      dark = "Catppuccin Mocha";
      light = "Catppuccin Mocha";
    };

    xdg.configFile."zed/settings.json".text =
      builtins.toJSON config.programs.zed-editor.userSettings;
  };
}
