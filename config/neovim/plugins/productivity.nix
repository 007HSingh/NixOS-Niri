{
  plugins.vim-wakatime.enable = true;
  plugins.nvim-surround.enable = true;

  plugins.neorg = {
    enable = true;
    modules = {
      "core.defaults" = { };
      "core.dirman" = {
        config = {
          workspaces = {
            notes = "~/Documents/notes";
            work = "~/Documents/work";
          };
        };
      };
    };
  };

  plugins.zen-mode = {
    enable = true;
    settings = {
      window = {
        width = 120;
        options = {
          number = false;
          relativenumber = false;
        };
      };
    };
  };
}
