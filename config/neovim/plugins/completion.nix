{ config, lib, ... }:

{
  programs.nixvim = {
    # ============================================================================
    # CMP - Completion engine
    # ============================================================================
    plugins.cmp = {
      enable = lib.mkDefault true;
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
          {
            name = "nvim_lsp";
            priority = 1000;
          }
          {
            name = "nvim_lsp_signature_help";
            priority = 1000;
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "path";
            priority = 500;
          }
          {
            name = "buffer";
            priority = 250;
          }
        ];

        formatting = {
          expandable_indicator = true;
          fields = [
            "kind"
            "abbr"
            "menu"
          ];
        };

        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
          };
          documentation = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
          };
        };

        experimental = {
          ghost_text = true;
        };
      };
    };

    # ============================================================================
    # LUASNIP - Snippet engine
    # ============================================================================
    plugins.luasnip = {
      enable = lib.mkDefault true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      fromVscode = [
        {
          lazyLoad = true;
        }
      ];
    };

    # ============================================================================
    # FRIENDLY-SNIPPETS - Snippet collection
    # ============================================================================
    plugins.friendly-snippets = {
      enable = lib.mkDefault true;
    };
  };

  # Enable signature help plugin
  programs.nixvim.plugins.cmp-nvim-lsp-signature-help.enable = true;
}
