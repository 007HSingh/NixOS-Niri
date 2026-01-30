# Zathura PDF Viewer
# Document viewer with Catppuccin theme
{ ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      notification-error-bg = "#1e1e2e";
      notification-error-fg = "#f38ba8";
      notification-warning-bg = "#1e1e2e";
      notification-warning-fg = "#fab387";
      notification-bg = "#1e1e2e";
      notification-fg = "#cdd6f4";

      completion-bg = "#1e1e2e";
      completion-fg = "#cdd6f4";
      completion-group-bg = "#313244";
      completion-group-fg = "#89b4fa";
      completion-highlight-bg = "#45475a";
      completion-highlight-fg = "#cdd6f4";

      inputbar-bg = "#1e1e2e";
      inputbar-fg = "#cdd6f4";

      statusbar-bg = "#1e1e2e";
      statusbar-fg = "#cdd6f4";

      highlight-color = "#f9e2af";
      highlight-active-color = "#a6e3a1";

      default-bg = "#1e1e2e";
      default-fg = "#cdd6f4";
      render-loading = true;
      render-loading-bg = "#1e1e2e";
      render-loading-fg = "#cdd6f4";

      recolor-lightcolor = "#1e1e2e";
      recolor-darkcolor = "#cdd6f4";
      recolor = false;
      recolor-keephue = true;

      adjust-open = "width";
      pages-per-row = 1;
      scroll-page-aware = true;
      zoom-min = 10;
      guioptions = "sv";
      font = "JetBrainsMono Nerd Font 11";
      selection-clipboard = "clipboard";
    };
    extraConfig = ''
      map u scroll half-up
      map d scroll half-down
      map D toggle_page_mode
      map r reload
      map R rotate
      map K zoom in
      map J zoom out
      map i recolor
      map p print
      map g goto top
    '';
  };
}
