# Zed Editor
# Uses programs.zed-editor (Home Manager module) with catppuccin/nix integration
# Catppuccin Mocha theme + icons are applied via catppuccin.zed options
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

      # ── Extra extensions (catppuccin-icons added automatically by catppuccin.zed) ──
      extensions = [
        "nix"
      ];

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
          nixd.binary.path = "nixd";
          lua-language-server.binary.path = "lua-language-server";
          pyright.binary.path = "pyright";
          typescript-language-server.binary.path = "typescript-language-server";
          rust-analyzer.binary.path = "rust-analyzer";
          jdt.binary.path = "jdt-language-server";
          bash-language-server.binary.path = "bash-language-server";
          vscode-html-language-server.binary.path = "vscode-html-language-server";
          vscode-css-language-server.binary.path = "vscode-css-language-server";
          vscode-json-language-server.binary.path = "vscode-json-language-server";
          yaml-language-server.binary.path = "yaml-language-server";
        };
      };
    };
  };
}
