# Yazi File Manager
# Terminal file manager with Catppuccin theme
{ ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
      preview = {
        tab_size = 2;
        max_width = 1000;
        max_height = 1000;
      };
    };
    # theme = { ... }; # Managed by Stylix
  };
}
