{ config, lib, ... }:

{
  programs.nixvim = {
    # ============================================================================
    # GENERAL SETTINGS - Sensible defaults for modern editing
    # ============================================================================
    opts = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Tabs and indentation
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      autoindent = true;
      smartindent = true;
      breakindent = true;

      # Search
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;

      # UI/UX
      termguicolors = true;
      cursorline = true;
      scrolloff = 8;
      sidescrolloff = 8;
      signcolumn = "yes";
      wrap = false;
      splitbelow = true;
      splitright = true;
      showmode = false;

      # Performance
      updatetime = 250;
      timeoutlen = 300;
      lazyredraw = false;

      # Backup and undo
      backup = false;
      writebackup = false;
      swapfile = false;
      undofile = true;
      undolevels = 10000;

      # Completion
      completeopt = [
        "menu"
        "menuone"
        "noselect"
      ];
      pumheight = 10;

      # Mouse support
      mouse = "a";

      # Clipboard
      clipboard = "unnamedplus";

      # Folding
      foldmethod = "expr";
      foldexpr = "nvim_treesitter#foldexpr()";
      foldenable = false;
      foldlevel = 99;

      # Misc
      conceallevel = 0;
      fileencoding = "utf-8";
      iskeyword = "@,48-57,_,192-255,-";
      showtabline = 2;
      cmdheight = 1;
      ruler = false;
    };
  };
}
