;;; config.el
;;; Commentary:
;;  Tuned for a Neovim emigrant:
;;  • Evil everywhere (vi keys in all buffers including org)
;;  • Catppuccin Mocha to match the system theme
;;  • Org-mode as the primary productivity tool
;;  • Minimalist UI (no menu/toolbar/scrollbar)

;;; ── Identity ─────────────────────────────────────────────────────────────────
(setq user-full-name    "Harsh Singh"
      user-mail-address (getenv "GIT_EMAIL"))   ; populated by SOPS at runtime

;;; ── Theme — Catppuccin Mocha ─────────────────────────────────────────────────
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha)

;;; ── Fonts — matches system Maple Mono NF + Nunito ────────────────────────────
(setq doom-font              (font-spec :family "Maple Mono NF" :size 13)
      doom-variable-pitch-font (font-spec :family "Nunito"        :size 13)
      doom-big-font          (font-spec :family "Maple Mono NF" :size 18)
      doom-symbol-font       (font-spec :family "Maple Mono NF"))

;;; ── UI ───────────────────────────────────────────────────────────────────────
(setq display-line-numbers-type 'relative)        ; like Neovim relativenumber

;; Transparent background — lets Niri's blur show through (same as kitty/nvim)
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; No title bar decorations (Niri manages window chrome)
(add-to-list 'default-frame-alist '(undecorated . t))

;; Maximise on open (remove if you prefer windowed)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;;; ── Evil (vi keybindings) ────────────────────────────────────────────────────
;; Doom ships evil; +everywhere already enables it globally.
;; Fine-tune a few things for Neovim muscle memory:

(after! evil
  ;; Keep visual selection after indent — like Neovim's `>gv`
  (define-key evil-visual-state-map (kbd ">") 'evil-shift-right-line)
  (define-key evil-visual-state-map (kbd "<") 'evil-shift-left-line)

  ;; Move through wrapped lines like in Neovim (gj/gk)
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

  ;; Scroll offsets — keep cursor away from edges (scrolloff = 8)
  (setq scroll-margin 8
        scroll-conservatively 101)

  ;; Undo more granular — closer to Neovim's undo behaviour
  (setq evil-want-fine-undo t))

;;; ── which-key — delay tuned like your Neovim timeoutlen ────────────────────
(after! which-key
  (setq which-key-idle-delay 0.3))

;;; ── Completion (Corfu + Vertico) ─────────────────────────────────────────────
(after! corfu
  (setq corfu-auto          t
        corfu-auto-delay    0.2
        corfu-auto-prefix   1
        corfu-cycle         t
        corfu-quit-no-match t))

;;; ── LSP (eglot, Emacs 29 built-in) ──────────────────────────────────────────
(after! eglot
  ;; Tell Nix's nixd where the flake lives
  (setq eglot-workspace-configuration
        '((nixd . ((formatting . ((command . ["nixfmt"])))))))

  ;; Inlay hints (equivalent to your Neovim inlay hint setup)
  (add-hook 'eglot-managed-mode-hook #'eglot-inlay-hints-mode))

;;; ── Treemacs — file tree (replaces nvim-tree for this setup) ─────────────────
(after! treemacs
  (setq treemacs-width 30
        treemacs-show-hidden-files t
        treemacs-git-mode 'deferred))

;;; ── Magit — the Neogit equivalent ───────────────────────────────────────────
(after! magit
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1
        magit-diff-refine-hunk 'all))

;;; ── Org-mode ─────────────────────────────────────────────────────────────────
(setq org-directory "~/Notes/")

(after! org
  ;;── Directory layout ────────────────────────────────────────────────────────
  (setq org-agenda-files          (list org-directory)
        org-default-notes-file    (expand-file-name "inbox.org" org-directory)
        org-archive-location      (expand-file-name "archive/%s_archive::" org-directory))

  ;;── Appearance ─────────────────────────────────────────────────────────────
  (setq org-startup-indented     t      ; indent headlines visually
        org-startup-folded       t      ; start files folded (like Neovim folds)
        org-hide-emphasis-markers t     ; hide *bold*, /italic/ markers
        org-pretty-entities      t      ; render LaTeX symbols as unicode
        org-ellipsis             " ▾"
        org-fontify-whole-heading-line t)

  ;; Variable-pitch in org buffers (Nunito for prose, mono for code)
  (add-hook 'org-mode-hook #'variable-pitch-mode)
  (add-hook 'org-mode-hook #'visual-line-mode)

  ;;── TODO keywords ──────────────────────────────────────────────────────────
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")
          (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")))

  (setq org-todo-keyword-faces
        '(("TODO"      . (:foreground "#f38ba8" :weight bold))  ; Catppuccin red
          ("NEXT"      . (:foreground "#89dceb" :weight bold))  ; sky
          ("WAITING"   . (:foreground "#f9e2af" :weight bold))  ; yellow
          ("DONE"      . (:foreground "#a6e3a1" :weight bold))  ; green
          ("CANCELLED" . (:foreground "#6c7086" :weight bold))  ; overlay0
          ("[-]"       . (:foreground "#fab387" :weight bold))  ; peach
          ("[?]"       . (:foreground "#f9e2af" :weight bold)))) ; yellow

  ;;── Tags ───────────────────────────────────────────────────────────────────
  (setq org-tag-alist
        '((:startgroup)
          ("@home"    . ?h) ("@work"   . ?w) ("@errands" . ?e)
          (:endgroup)
          ("inbox"    . ?i) ("project" . ?p) ("note"     . ?n)
          ("review"   . ?r) ("idea"    . ?d)))

  ;;── Capture templates ──────────────────────────────────────────────────────
  (setq org-capture-templates
        `(("t" "Task" entry
           (file ,(expand-file-name "inbox.org" org-directory))
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n"
           :empty-lines 1)

          ("n" "Note" entry
           (file ,(expand-file-name "inbox.org" org-directory))
           "* %? :note:\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n"
           :empty-lines 1)

          ("j" "Journal" entry
           (file+datetree ,(expand-file-name "journal.org" org-directory))
           "* %<%H:%M> %?\n%i\n"
           :empty-lines 1)

          ("p" "Project" entry
           (file ,(expand-file-name "projects.org" org-directory))
           "* %? [/] :project:\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n** TODO First task\n"
           :empty-lines 1)))

  ;;── Agenda ─────────────────────────────────────────────────────────────────
  (setq org-agenda-span               'week
        org-agenda-start-on-weekday   1       ; Monday
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done  t
        org-agenda-include-deadlines      t
        org-agenda-block-separator        ?─
        org-agenda-window-setup           'current-window)

  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-agenda-span 7)))
            (todo "NEXT"  ((org-agenda-overriding-header "⚡ Next Actions")))
            (todo "WAITING" ((org-agenda-overriding-header "⏳ Waiting")))
            (tags-todo "+inbox" ((org-agenda-overriding-header "📥 Inbox")))))

          ("n" "Next actions" todo "NEXT")
          ("w" "Waiting"     todo "WAITING")))

  ;;── Export backends ────────────────────────────────────────────────────────
  (setq org-export-backends '(ascii html icalendar latex md odt))

  ;;── Refile targets — up to 3 levels deep in agenda files ──────────────────
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3))
        org-refile-use-outline-path        'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm)

  ;;── Logging ────────────────────────────────────────────────────────────────
  (setq org-log-done       'time
        org-log-into-drawer t)

  ;;── Babel — source block languages ─────────────────────────────────────────
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell      . t)
     (python     . t)
     (lua        . t))))

;;── org-roam (Zettelkasten) ──────────────────────────────────────────────────
(after! org-roam
  (setq org-roam-directory (expand-file-name "roam/" org-directory)
        org-roam-db-autosync-mode t
        org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "${slug}.org" "#+title: ${title}\n#+date: %U\n")
           :unnarrowed t))))

;;── Pomodoro ─────────────────────────────────────────────────────────────────
(after! org-pomodoro
  (setq org-pomodoro-length         25
        org-pomodoro-short-break-length 5
        org-pomodoro-long-break-length  20))

;;; ── Keybindings — SPC-leader style (Doom default) ────────────────────────────
;; Doom already gives you SPC as leader and , as local leader.
;; Add a few Org-specific extras inspired by your Neovim Obsidian mappings:
(map! :leader
      ;; Org capture / agenda
      (:prefix ("o" . "org")
       :desc "Capture"          "c" #'org-capture
       :desc "Agenda"           "a" #'org-agenda
       :desc "Agenda dashboard" "d" (cmd! (org-agenda nil "d"))
       :desc "Roam find"        "f" #'org-roam-node-find
       :desc "Roam insert link" "i" #'org-roam-node-insert
       :desc "Roam buffer"      "b" #'org-roam-buffer-toggle
       :desc "Store link"       "l" #'org-store-link
       :desc "Toggle checkbox"  "x" #'org-toggle-checkbox
       :desc "Schedule"         "s" #'org-schedule
       :desc "Deadline"         "D" #'org-deadline
       :desc "Refile"           "r" #'org-refile
       :desc "Archive"          "A" #'org-archive-subtree
       :desc "Export dispatch"  "e" #'org-export-dispatch
       :desc "Pomodoro"         "p" #'org-pomodoro)

      ;; Quick project jump (like Harpoon)
      (:prefix ("TAB" . "workspace")
       :desc "Switch workspace" "." #'+workspace/switch-to))

;;; ── Dired (file manager) ─────────────────────────────────────────────────────
(after! dired
  (setq dired-listing-switches "-lah --group-directories-first"
        dired-kill-when-opening-new-dired-buffer t))

;;; ── vterm ────────────────────────────────────────────────────────────────────
(after! vterm
  (setq vterm-shell (executable-find "zsh")
        vterm-max-scrollback 10000))

;;; ── Performance tweaks ───────────────────────────────────────────────────────
(setq gc-cons-threshold         (* 64 1024 1024)   ; 64 MB — reduce GC pauses
      read-process-output-max   (* 1 1024 1024)    ; 1 MB — faster LSP reads
      bidi-inhibit-bpa          t                   ; disable bidi for perf
      bidi-paragraph-direction  'left-to-right)
