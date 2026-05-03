# Zed Editor
# Uses programs.zed-editor (Home Manager module) with catppuccin/nix integration
# Package sourced from the official Zed flake (github:zed-industries/zed)
# Catppuccin Mocha theme + icons applied via catppuccin.zed options
# All LSP binaries are already on PATH via modules/home/packages/default.nix
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
    # ── Catppuccin Mocha theme + icons via catppuccin/nix ────────────────────
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

    programs.zed-editor = {
      enable = true;

      # ── Extensions ──────────────────────────────────────────────────────────
      # catppuccin-icons is added automatically by catppuccin.zed.icons.enable
      extensions = [ "nix" ];

      userSettings = {
        # ── AI / telemetry ──────────────────────────────────────────────────
        assistant = {
          enabled = false;
          version = "2";
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        # ── UI ──────────────────────────────────────────────────────────────
        vim_mode = false;

        # Override Stylix's theme injection — catppuccin.zed sets the real theme
        # but Stylix also sets theme = "Base16 untitled"; mkForce wins both
        theme = lib.mkForce {
          dark = "Catppuccin Mocha";
          light = "Catppuccin Mocha";
        };

        # ── Typography ──────────────────────────────────────────────────────
        buffer_font_family = "Maple Mono NF";
        buffer_font_size = lib.mkForce 13;
        buffer_font_features = {
          calt = true; # ligatures
        };

        # ── Editor behaviour ────────────────────────────────────────────────
        format_on_save = "on";

        # ── Language → LSP wiring ───────────────────────────────────────────
        # Binaries are on PATH via modules/home/packages/default.nix
        languages = {
          Nix = {
            language_servers = [ "nixd" ];
          };
          Lua = {
            language_servers = [ "lua-language-server" ];
          };
          Python = {
            language_servers = [ "pyright" ];
          };
          TypeScript = {
            language_servers = [ "typescript-language-server" ];
          };
          JavaScript = {
            language_servers = [ "typescript-language-server" ];
          };
          Rust = {
            language_servers = [ "rust-analyzer" ];
          };
          Java = {
            language_servers = [ "jdt" ];
          };
          Bash = {
            language_servers = [ "bash-language-server" ];
          };
          HTML = {
            language_servers = [ "vscode-html-language-server" ];
          };
          CSS = {
            language_servers = [ "vscode-css-language-server" ];
          };
          JSON = {
            language_servers = [ "vscode-json-language-server" ];
          };
          YAML = {
            language_servers = [ "yaml-language-server" ];
          };
        };

        # ── LSP binary paths (all on PATH, referenced by name) ───────────────
        lsp = {
          nixd.binary.path_lookup = true;
          lua-language-server.binary.path_lookup = true;
          pyright.binary.path_lookup = true;
          typescript-language-server.binary.path_lookup = true;
          rust-analyzer.binary.path_lookup = true;
          jdt.binary.path = "jdt-language-server";
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
