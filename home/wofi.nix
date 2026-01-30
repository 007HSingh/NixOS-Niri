{ pkgs, ... }:

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
      insensitivy = true;
      allow_images = true;
      image_size = 24;
      gtk_dark = true;
    };

    # Custom CSS for extra aesthetics
    style = ''
      window {
        margin: 0px;
        border: 2px solid #b4befe;
        background-color: rgba(30, 30, 46, 0.9);
        border-radius: 12px;
        font-family: "JetBrainsMono Nerd Font";
      }

      #input {
        margin: 5px;
        border: none;
        color: #cdd6f4;
        background-color: #313244;
        border-radius: 8px;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4;
      }

      #entry:selected {
        background-color: #45475a;
        border-radius: 8px;
        outline: none;
      }

      #text:selected {
        color: #b4befe;
      }
    '';
  };

  # Enable catppuccin theme for wofi
  catppuccin.wofi.enable = true;
  catppuccin.wofi.flavor = "mocha";
}
