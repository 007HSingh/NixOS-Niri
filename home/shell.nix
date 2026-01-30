# Shell Configuration
# Zsh, Starship, Zoxide integration
{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
            if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
              compinit
            else
              compinit -C
            fi
            zstyle ':completion:*' menu select
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '';
    initContent = ''
      eval "$(zoxide init zsh --no-cmd)"
      alias cd='__zoxide_z'
      alias cdi='__zoxide_zi'
      eval "$(direnv hook zsh)"

      bindkey -r '^T'
      bindkey -r '^R'
      function __load_fzf() {
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        source ${pkgs.fzf}/share/fzf/completion.zsh
        zle reset-prompt
      }
      zle -N __load_fzf
      bindkey '^T' __load_fzf
    '';
    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };
    shellAliases = {
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };

    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };

    syntaxHighlighting = {
      enable = true;
    };

    oh-my-zsh.enable = false;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
