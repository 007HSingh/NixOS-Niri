# Profile: harsh
# Enables all home modules for the harsh user.
# Imported by users/harsh/default.nix via inputs.self.homeManagerModules.profile-harsh.
_:

{
  modules.home = {
    bar.enable = true;
    browser.enable = true;
    clipboard.enable = true;
    neovim.enable = true;
    zed.enable = true;
    git.enable = true;
    media.enable = true;
    notes.enable = true;
    packages.enable = true;
    shell.enable = true;
    termipedia.enable = true;
    theming.enable = true;
    utilties.enable = true;
    wofi.enable = true;
    xdg.enable = true;
    zathura.enable = true;
  };
}
