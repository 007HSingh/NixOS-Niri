;;; init.el
;;  Enable/disable Doom modules here.
;;  Run `doom sync` after changing this file.

(doom! :input

       :completion
       (corfu +orderless)          ; lightweight in-buffer completion
       (vertico +icons)             ; minibuffer completion (replaces ivy/helm)

       :ui
       doom                         ; the Doom look & feel
       doom-dashboard               ; splash screen
       (emoji +unicode)
       hl-todo                      ; highlight TODO/FIXME/HACK
       indent-guides                ; indent lines (like indent-blankline)
       minimap                      ; code minimap
       modeline                     ; doom's pretty modeline
       nav-flash                    ; flash cursor on large jumps
       ophints                      ; flash region for evil operators
       (popup +defaults)            ; managed popups
       (treemacs +lsp)              ; file tree sidebar
       (vc-gutter +pretty)          ; git gutter signs
       vi-tilde-fringe              ; tilde column (like Neovim)
       workspaces                   ; tab-based workspaces

       :editor
       (evil +everywhere)           ; vi keybindings — the whole point
       file-templates               ; snippet templates for new files
       fold                         ; code folding (like nvim-ufo)
       (format +onsave)             ; auto-format on save
       multiple-cursors             ; mc / evil-multiedit
       snippets                     ; yasnippet
       word-wrap                    ; soft-wrap long lines

       :emacs
       (dired +icons)               ; file manager (like oil/yazi)
       electric                     ; auto-indent, auto-close
       (ibuffer +icons)             ; buffer list
       undo                         ; persistent undo (like undotree)
       vc                           ; built-in version control

       :term
       vterm                        ; terminal inside Emacs

       :checkers
       (syntax +childframe)         ; flymake / flycheck inline errors
       (spell +flyspell +aspell)    ; spellcheck

       :tools
       (debugger +lsp)              ; DAP debugging
       direnv                       ; .envrc support (nix develop)
       (docker +lsp)
       editorconfig                 ; .editorconfig respect
       (eval +overlay)              ; REPL / send-to-repl
       (lookup +dictionary          ; K for docs, gd for definitions
               +docsets)
       (lsp +peek)                  ; LSP via eglot (built-in Emacs 29)
       magit                        ; Git porcelain (like Neogit)
       make                         ; Makefile integration
       (rgb)                        ; hex color highlighting
       (pass)                       ; password-store integration

       :os
       (:if IS-LINUX tty)           ; terminal support on Linux

       :lang
       emacs-lisp                   ; self-editing Emacs
       (json +lsp +tree-sitter)
       (lua +lsp +tree-sitter)
       (markdown +grip)             ; live preview
       (nix +lsp +tree-sitter)      ; NixOS configs
       (org                         ; ─── the whole reason we're here ───
        +dragndrop                  ; drag & drop images
        +hugo                       ; Hugo static site export
        +noter                      ; PDF annotation
        +pandoc                     ; rich export via pandoc
        +pomodoro                   ; built-in Pomodoro timer
        +present                    ; reveal.js presentations
        +pretty                     ; pretty symbols
        +roam2)                     ; org-roam Zettelkasten v2
       (python +lsp +tree-sitter +pyright)
       (sh +lsp +tree-sitter)       ; Bash / Zsh
       (yaml +lsp +tree-sitter)

       :config
       (default +bindings +smartparens))
