# Zed Editor
# Uses programs.zed-editor (Home Manager module) with catppuccin/nix integration
# Package sourced from the official Zed flake (github:zed-industries/zed)
# Catppuccin Mocha theme + icons applied via catppuccin.zed options
# All LSP binaries are already on PATH via modules/home/packages/default.nix
{
  lib,
  config,
  pkgs,
  inputs,
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
      package = inputs.zed-editor.packages.${pkgs.stdenv.hostPlatform.system}.default;

      extensions = [
        "catppuccin"
        "catppuccin-icons"
        "TOML"
        "HTML"
        "Java"
        "Lua"
        "Dockerfile"
        "LaTeX"
        "Nix"
      ];

      userSettings = {
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
            format_on_save = {
              external = {
                command = "nixfmt";
                arguments = [ "{buffer_path}" ];
              };
            };
          };
          "Lua" = {
            language_servers = [ "lua-language-server" ];
            format_on_save = {
              external = {
                command = "stylua";
                arguments = [ "-" ];
              };
            };
          };
          "Python" = {
            language_servers = [ "pyright" ];
            format_on_save = {
              external = {
                command = "black";
                arguments = [ "-" ];
              };
            };
          };
          "TypeScript" = {
            language_servers = [ "typescript-language-server" ];
            format_on_save = {
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
            format_on_save = {
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
            format_on_save = {
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
            format_on_save = {
              external = {
                command = "google-java-format";
                arguments = [ "-" ];
              };
            };
          };
          "Bash" = {
            language_servers = [ "bash-language-server" ];
            format_on_save = {
              external = {
                command = "shfmt";
                arguments = [ "-" ];
              };
            };
          };
          "HTML" = {
            language_servers = [ "vscode-html-language-server" ];
            format_on_save = {
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
            format_on_save = {
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
            format_on_save = {
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
            format_on_save = {
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

        lsp = {
          nixd.binary.path_lookup = true;
          lua-language-server.binary.path_lookup = true;
          pyright.binary.path_lookup = true;
          typescript-language-server.binary.path_lookup = true;
          rust-analyzer.binary.path_lookup = true;
          jdtls.binary.path_lookup = true;
          bash-language-server.binary.path_lookup = true;
          vscode-html-language-server.binary.path_lookup = true;
          vscode-css-language-server.binary.path_lookup = true;
          vscode-json-language-server.binary.path_lookup = true;
          yaml-language-server.binary.path_lookup = true;
        };
      };
    };
  };
}
