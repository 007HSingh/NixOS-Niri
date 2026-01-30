# Zathura PDF Viewer
# Document viewer with Catppuccin theme
{ ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      # Colors managed by Stylix

      # Functional options

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
