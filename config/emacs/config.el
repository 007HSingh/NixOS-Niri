;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")
(setq user-full-name    "Harsh Singh"
      user-mail-address (getenv "GIT_EMAIL"))   ; populated by SOPS at runtime

;;; ── Encoding — always UTF-8 everywhere ──────────────────────────────────────
(set-charset-priority 'unicode)
(prefer-coding-system        'utf-8)
(set-default-coding-systems  'utf-8)
(set-terminal-coding-system  'utf-8)
(set-keyboard-coding-system  'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font              (font-spec :family "Maple Mono NF" :size 13)
      doom-variable-pitch-font (font-spec :family "Nunito"        :size 13)
      doom-big-font          (font-spec :family "Maple Mono NF" :size 18)
      doom-symbol-font       (font-spec :family "Maple Mono NF"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Transparent background — lets Niri's blur show through (same as kitty/nvim)
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; No title bar decorations (Niri manages window chrome)
(add-to-list 'default-frame-alist '(undecorated . t))

;; Maximise on open (remove if you prefer windowed)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;;; ── Doom modeline — status bar ───────────────────────────────────────────────
(after! doom-modeline
  (setq doom-modeline-height              28
        doom-modeline-bar-width           4
        doom-modeline-icon                t
        doom-modeline-major-mode-icon     t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-state-icon   t
        doom-modeline-buffer-modification-icon t
        doom-modeline-unicode-fallback    nil
        doom-modeline-minor-modes         nil   ; keep it terse
        doom-modeline-enable-word-count   t     ; useful in org / prose
        doom-modeline-buffer-encoding     nil   ; UTF-8 everywhere; no need
        doom-modeline-indent-info         nil
        doom-modeline-checker-simple-format t
        doom-modeline-vcs-max-length      15))

;;; ── Doom dashboard — splash screen ──────────────────────────────────────────
(after! doom-dashboard
  ;; Show project list and recent files at startup
  (setq +doom-dashboard-functions
        '(doom-dashboard-widget-banner
          doom-dashboard-widget-shortmenu
          doom-dashboard-widget-loaded
          doom-dashboard-widget-footer)))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

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

  ;; Cursor-to-edge padding (Neovim's scrolloff = 8).
  ;; NOTE: scroll-margin must stay 0 for ultra-scroll's glitch-free smooth
  ;; scrolling. evil-scroll-offset gives the same visual behaviour without
  ;; touching scroll-margin.
  (setq evil-scroll-offset 8)


  ;; Undo more granular — closer to Neovim's undo behaviour
  (setq evil-want-fine-undo t))

;;; ── evil-snipe — f/t/s motions across the buffer (like flash.nvim) ──────────
(after! evil-snipe
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  (setq evil-snipe-scope 'buffer          ; search whole buffer, not just line
        evil-snipe-repeat-keys t))

;;; ── evil-surround — sa/sd/sr (like nvim-surround) ───────────────────────────
(after! evil-surround
  (global-evil-surround-mode +1))

;;; ── Avy — jump-to-char / jump-to-word (leap / hop equivalent) ───────────────
(after! avy
  (setq avy-all-windows t        ; jump across all visible windows
        avy-background  t        ; dim background while jumping
        avy-style       'at-full ; show keys inline at target
        avy-timeout-seconds 0.4))

;;; ── ace-window — SPC w w to pick window by letter ───────────────────────────
(after! ace-window
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-background t
        aw-scope 'frame))

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

;;; ── Vertico — vertical minibuffer completion (replaces Helm/Ivy) ─────────────
(after! vertico
  (setq vertico-count   15        ; show 15 candidates
        vertico-resize  t         ; shrink when fewer items
        vertico-cycle   t))       ; wrap around at ends

;;; ── Orderless — fuzzy / space-separated matching (like Telescope's fzf) ──────
(after! orderless
  ;; Use orderless as the primary style; fall back to partial-completion
  ;; so file-name expansion (e.g. ~/Do<TAB>) still works.
  (setq completion-styles         '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles basic partial-completion)))))

;;; ── Marginalia — richer annotations in the minibuffer ────────────────────────
(after! marginalia
  (setq marginalia-align 'right)
  (marginalia-mode +1))

;;; ── Consult — Telescope-equivalent search / navigation ───────────────────────
(after! consult
  ;; Preview delay — show preview after 0.3 s of idle (avoids flickering)
  (setq consult-preview-key (kbd "M-."))

  ;; Narrow key for consult-buffer source selection
  (setq consult-narrow-key "<")

  ;; Ripgrep as the backend for consult-ripgrep
  (when (executable-find "rg")
    (setq consult-ripgrep-args
          "rg --null --line-buffered --color=never --max-columns=1000 \
              --path-separator / --smart-case --no-heading --line-number \
              --hidden --glob '!.git/'"))

  ;; Register useful async sources on the consult-buffer list
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file
   :preview-key '(:debounce 0.4 any)))

;;; ── Embark — contextual actions at point (like nvim's code-action UI) ───────
(after! embark
  ;; Show a completing-read menu instead of the pop-up (cleaner with vertico)
  (setq embark-prompter        #'embark-completing-read-prompter
        embark-indicators      '(embark-minimal-indicator
                                 embark-highlight-indicator
                                 embark-isearch-highlight-indicator)))

;;; ── Projectile — project management (Telescope project equivalent) ───────────
(after! projectile
  (setq projectile-project-search-path
        '("~/code/" "~/projects/" "~/work/")   ; tweak to your layout
        projectile-sort-order      'recentf     ; most-recently visited first
        projectile-enable-caching  t
        projectile-ignored-projects '("~/" "/tmp")
        projectile-auto-discover    t))

;;; ── LSP (eglot, Emacs 29 built-in) ──────────────────────────────────────────
(after! eglot
  ;; Tell Nix's nixd where the flake lives
  (setq eglot-workspace-configuration
        '((nixd . ((formatting . ((command . ["nixfmt"])))))))

  ;; Inlay hints (equivalent to your Neovim inlay hint setup)
  (add-hook 'eglot-managed-mode-hook #'eglot-inlay-hints-mode)

  ;; How long before eglot gives up connecting to the server
  (setq eglot-connect-timeout 30)

  ;; Report progress in the modeline (default), but don't open a log buffer
  (setq eglot-events-buffer-size 0))

;;; ── Diagnostics — flycheck ───────────────────────────────────────────────────
(after! flycheck
  (setq flycheck-idle-change-delay    1.0   ; wait 1 s after edits before checking
        flycheck-display-errors-delay 0.3   ; show error at point quickly
        flycheck-check-syntax-automatically '(save idle-change mode-enabled)
        flycheck-indication-mode    'left-fringe))

;;; ── Auto-format on save ──────────────────────────────────────────────────────
;; Requires the +format module in init.el.
;; format-all is used by Doom's +format layer under the hood.
(setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode          ; elisp is auto-formatted by paredit
        sql-mode                 ; SQL formatting is often opinionated
        tex-mode                 ; LaTeX: format manually
        latex-mode))

;;; ── Whitespace — remove trailing whitespace on save ──────────────────────────
(after! ws-butler
  ;; ws-butler is gentler than delete-trailing-whitespace:
  ;; it only cleans lines you actually edited.
  (ws-butler-global-mode +1))

;;; ── Smartparens — auto-pair brackets/quotes ──────────────────────────────────
(after! smartparens
  (smartparens-global-mode +1)
  ;; Disable in minibuffer — it fights with vertico
  (add-hook 'minibuffer-setup-hook #'turn-off-smartparens-mode))

;;; ── Rainbow delimiters — colour-matched parens/brackets ─────────────────────
(after! rainbow-delimiters
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;;; ── Highlight indent guides — show indentation levels ───────────────────────
(after! highlight-indent-guides
  (setq highlight-indent-guides-method       'character  ; '│' style
        highlight-indent-guides-character    ?│
        highlight-indent-guides-responsive   'top        ; highlight current level
        highlight-indent-guides-auto-enabled  nil)       ; we set colours via theme
  (add-hook 'prog-mode-hook #'highlight-indent-guides-mode))

;;; ── Spell checking — flyspell for prose, off for code ────────────────────────
(after! ispell
  (setq ispell-program-name "aspell"
        ispell-dictionary   "en_GB"    ; change to en_US if preferred
        ispell-extra-args   '("--sug-mode=ultra" "--lang=en_GB")))

(after! flyspell
  ;; Enable in text/org/markdown; leave prog-mode clean
  (add-hook 'text-mode-hook #'flyspell-mode)
  (add-hook 'org-mode-hook  #'flyspell-mode)
  ;; Quick correction with C-; (evil-friendly, doesn't clash with SPC)
  (define-key flyspell-mode-map (kbd "C-;") #'flyspell-correct-wrapper))

;;; ── Helpful — richer *Help* buffers ─────────────────────────────────────────
;; helpful replaces the built-in *Help* with richer, more navigable pages.
;; See 'C-h o' (describe-symbol) for the built-in equivalent.
(after! helpful
  (global-set-key [remap describe-function] #'helpful-callable)
  (global-set-key [remap describe-variable] #'helpful-variable)
  (global-set-key [remap describe-key]      #'helpful-key)
  (global-set-key [remap describe-command]  #'helpful-command))

;;; ── ibuffer — better buffer list (SPC b i) ───────────────────────────────────
(after! ibuffer
  (setq ibuffer-expert t                    ; skip confirmation on delete
        ibuffer-show-empty-filter-groups nil ; hide empty groups
        ibuffer-formats
        '((mark modified read-only locked " "
           (name 30 30 :left :elide) " "
           (size 9 9 :right) " "
           (mode 16 16 :left :elide) " "
           filename-and-process)
          (mark " " (name 16 -1) " " filename)))

  ;; Group buffers by projectile project
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-projectile-set-filter-groups)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic)))))

;;; ── Auto-save and backups — never lose work ──────────────────────────────────
;; Keep all auto-save and backup files in XDG cache, not next to your files.
(let ((auto-save-dir (expand-file-name "emacs/auto-save/" (or (getenv "XDG_CACHE_HOME") "~/.cache")))
      (backup-dir    (expand-file-name "emacs/backups/"   (or (getenv "XDG_CACHE_HOME") "~/.cache"))))
  (make-directory auto-save-dir t)
  (make-directory backup-dir    t)
  (setq auto-save-file-name-transforms `((".*" ,auto-save-dir t))
        backup-directory-alist         `(("." . ,backup-dir))))

(setq backup-by-copying      t    ; don't clobber symlinks
      delete-old-versions    t    ; silently delete excess backups
      kept-new-versions      6
      kept-old-versions      2
      version-control        t    ; numbered backups
      auto-save-default      t
      auto-save-timeout      30   ; idle seconds before auto-save
      auto-save-interval     300) ; keystrokes between auto-saves

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
(after! org
  ;;── Directory layout ────────────────────────────────────────────────────────
  (setq org-agenda-files          (list org-directory)
        org-default-notes-file    (expand-file-name "inbox.org" org-directory)
        org-archive-location      (expand-file-name "archive/%s_archive::" org-directory))

  ;;── Appearance ─────────────────────────────────────────────────────────────
  (setq org-startup-indented      t      ; indent headlines visually
        org-startup-folded        t      ; start files folded (like Neovim folds)
        org-hide-emphasis-markers t      ; hide *bold*, /italic/ markers
        org-pretty-entities       t      ; render LaTeX symbols as unicode
        org-ellipsis              " ▾"
        org-fontify-whole-heading-line t
        org-image-actual-width    nil    ; respect #+ATTR_ORG: :width N
        org-cycle-separator-lines 2)     ; blank lines between headings

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
        org-agenda-window-setup           'current-window
        org-agenda-time-grid
        '((daily today require-timed)
          (800 1000 1200 1400 1600 1800 2000)
          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
        org-agenda-current-time-string
        "◀── now ─────────────────────────────────────────────────")

  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-agenda-span 7)))
            (todo "NEXT"    ((org-agenda-overriding-header "⚡ Next Actions")))
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
  (setq org-pomodoro-length           25
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

      ;; Avy jump motions (leap/flash equivalent)
      (:prefix ("j" . "jump")
       :desc "Jump to char"   "j" #'avy-goto-char-2
       :desc "Jump to word"   "w" #'avy-goto-word-0
       :desc "Jump to line"   "l" #'avy-goto-line
       :desc "Jump to window" "W" #'ace-window)

      ;; Consult — Telescope-style pickers
      (:prefix ("s" . "search")
       :desc "Ripgrep"        "r" #'consult-ripgrep
       :desc "Find file"      "f" #'consult-find
       :desc "Buffer lines"   "l" #'consult-line
       :desc "Recent files"   "R" #'consult-recent-file
       :desc "Git grep"       "g" #'consult-git-grep
       :desc "Mark ring"      "m" #'consult-mark
       :desc "Imenu"          "i" #'consult-imenu)

      ;; Quick project jump (like Harpoon)
      (:prefix ("TAB" . "workspace")
       :desc "Switch workspace" "." #'+workspace/switch-to))

;;; ── Dired (file manager) ─────────────────────────────────────────────────────
(after! dired
  (setq dired-listing-switches "-lah --group-directories-first"
        dired-kill-when-opening-new-dired-buffer t
        dired-dwim-target t         ; suggest other open dired window as target
        dired-auto-revert-buffer t  ; refresh on revisit
        dired-hide-details-hide-symlink-targets nil))

;;; ── vterm ────────────────────────────────────────────────────────────────────
(after! vterm
  (setq vterm-shell (executable-find "zsh")
        vterm-max-scrollback 10000
        vterm-kill-buffer-on-exit t    ; close buffer when the shell exits
        vterm-copy-exclude-prompt t))  ; don't copy the prompt in copy mode

;;; ── Performance tweaks ───────────────────────────────────────────────────────
(setq gc-cons-threshold        (* 64 1024 1024)   ; 64 MB — reduce GC pauses
      read-process-output-max  (* 1 1024 1024)    ; 1 MB — faster LSP reads
      bidi-inhibit-bpa         t                   ; disable bidi for perf
      bidi-paragraph-direction 'left-to-right)
