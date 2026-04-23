# Profile: harsh
# Enables all home modules for the harsh user.
# Imported by users/harsh/default.nix via inputs.self.homeManagerModules.profile-harsh.
_:

{
  modules.home = {
    audio.enable = true;
    bar.enable = true;
    browser.enable = true;
    clipboard.enable = true;
    editor.enable = true;
    git.enable = true;
    idle.enable = true;
    media.enable = true;
    notes.enable = true;
    packages.enable = true;
    quickshell.enable = true;
    shell.enable = true;
    termipedia.enable = true;
    theming.enable = true;
    vscode.enable = true;
    wofi.enable = true;
    xdg.enable = true;
  };
}
