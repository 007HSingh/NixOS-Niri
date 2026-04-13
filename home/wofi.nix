_:

{
  programs.wofi = {
    enable = true;
    settings = {
      width = 500;
      height = 300;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 24;
      gtk_dark = true;
    };

    # Custom CSS — Glassmorphism style (Catppuccin Mocha palette, no hardcoded greys)
    # All RGBA values are derived from Catppuccin Mocha constants:
    #   crust    #11111b  →  rgba(17,  17,  27,  α)
    #   surface0 #313244  →  rgba(49,  50,  68,  α)
    #   surface1 #45475a  →  rgba(69,  71,  90,  α)
    #   lavender #b4befe  →  rgba(180, 190, 254, α)
    #   text     #cdd6f4  →  rgba(205, 214, 244, α)
    style = ''
      window {
        /* Frosted glass: crust colour at 72% so wallpaper bleeds through.
           backdrop-filter: blur is honoured by GTK4 + wlroots compositors. */
        background-color: rgba(17, 17, 27, 0.72);
        backdrop-filter: blur(20px);
        -gtk-backdrop-filter: blur(20px);
        border: 1px solid rgba(180, 190, 254, 0.35);
        border-radius: 16px;
        margin: 0px;
        font-family: "JetBrainsMono Nerd Font";
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.45);
      }

      #input {
        /* Semi-transparent search bar — surface0 at 65% */
        margin: 8px 8px 4px 8px;
        padding: 6px 12px;
        border: 1px solid rgba(180, 190, 254, 0.25);
        border-radius: 10px;
        color: rgba(205, 214, 244, 1.0);
        background-color: rgba(49, 50, 68, 0.65);
        caret-color: rgba(180, 190, 254, 0.9);
      }

      #input:focus {
        border-color: rgba(180, 190, 254, 0.6);
        background-color: rgba(49, 50, 68, 0.8);
      }

      #inner-box {
        margin: 4px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 4px;
        padding: 4px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 2px 6px;
        border: none;
        color: rgba(205, 214, 244, 0.92);
      }

      #entry {
        padding: 4px 8px;
        border-radius: 10px;
        transition: background-color 80ms ease;
      }

      #entry:selected {
        /* Pill highlight — surface1 at 80% + lavender left accent strip */
        background-color: rgba(69, 71, 90, 0.80);
        border-radius: 10px;
        border-left: 3px solid rgba(180, 190, 254, 0.85);
        outline: none;
      }

      #text:selected {
        color: rgba(180, 190, 254, 1.0);
      }
    '';
  };
}
