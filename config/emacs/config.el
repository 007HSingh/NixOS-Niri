;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

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
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Nunito" :size 17)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 22)
      doom-symbol-font (font-spec :family "Noto Color Emoji" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

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

(after! org
  ;; babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((scheme . t)
     (emacs-lisp . t)
     (python . t)))
  (setq org-babel-scheme-cmd "mit-scheme")

  ;; files
  (setq org-default-notes-file (concat org-directory "inbox.org")
        org-agenda-files (list (concat org-directory "agenda/")))

  ;; visual
  (setq org-startup-indented t
        org-startup-folded 'content
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-ellipsis " ▾"
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-fontify-quote-and-verse-blocks t
        org-image-actual-width '(500))

  ;; behaviour
  (setq org-return-follows-link t
        org-log-done 'time
        org-log-into-drawer t
        org-use-fast-todo-selection t)

  ;; TODO states — matches Catppuccin Mocha colours
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "IN-PROGRESS(p!)" "WAITING(w@/!)" "|"
                    "DONE(d!)" "CANCELLED(k@)")))

  (setq org-todo-keyword-faces
        '(("TODO"        :foreground "#f38ba8" :weight bold)
          ("NEXT"        :foreground "#89b4fa" :weight bold)
          ("IN-PROGRESS" :foreground "#a6e3a1" :weight bold)
          ("WAITING"     :foreground "#f9e2af" :weight bold)
          ("DONE"        :foreground "#6c7086" :weight bold)
          ("CANCELLED"   :foreground "#585b70" :weight bold)))

  ;; tags
  (setq org-tag-alist
        '((:startgroup)
          ("@study" . ?s) ("@reference" . ?r) ("@review" . ?v)
          (:endgroup)
          ("course" . ?c) ("book" . ?b) ("math" . ?m)
          ("cs" . ?p) ("important" . ?i)))

  ;; capture templates
  (setq org-capture-templates
        '(("i" "Inbox" entry
           (file org-default-notes-file)
           "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n"
           :prepend t :empty-lines 1)

          ("c" "Course note" entry
           (file+olp+datetree
            (lambda () (read-file-name "Course: " (concat org-directory "courses/"))))
           "* %^{Topic}\n:PROPERTIES:\n:CREATED: %U\n:SOURCE: %^{Source/Lecture}\n:END:\n\n%?"
           :empty-lines 1)

          ("b" "Book note" entry
           (file+olp+datetree
            (lambda () (read-file-name "Book: " (concat org-directory "books/"))))
           "* %^{Chapter/Section}\n:PROPERTIES:\n:CREATED: %U\n:PAGE: %^{Page}\n:END:\n\n%?"
           :empty-lines 1)

          ("t" "Task" entry
           (file+headline org-default-notes-file "Tasks")
           "* TODO %?\nDEADLINE: %^{Deadline}t\n"
           :prepend t)

          ("j" "Journal" entry
           (file+olp+datetree (concat org-directory "journal.org"))
           "* %U\n%?" :prepend t)))

  ;; agenda
  (setq org-agenda-span 'week
        org-agenda-start-on-weekday 1  ; Monday
        org-agenda-block-separator ?─
        org-agenda-time-grid
        '((daily today require-timed)
          (800 1000 1200 1400 1600 1800 2000)
          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"))

  ;; .scm files as scheme
  (add-to-list 'auto-mode-alist '("\\.sld\\'" . scheme-mode))

(after! org-modern
  (setq org-modern-star '("◉" "○" "◈" "◇" "▸")
        org-modern-table t
        org-modern-block-fringe nil
        org-modern-keyword t
        org-modern-checkbox '((88 . "󰄵") (45 . "󰡖") (32 . "󰄱")))
  (global-org-modern-mode))

(after! valign
  (add-hook 'org-mode-hook #'valign-mode))

(after! org-roam
  (setq org-roam-directory (concat org-directory "roam/")
        org-roam-db-location (concat org-directory ".org-roam.db")
        org-roam-completion-everywhere t
        org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:20}" 'face 'org-tag)))

  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "${slug}.org"
                              "#+TITLE: ${title}\n#+CREATED: %U\n#+FILETAGS: \n\n")
           :unnarrowed t)

          ("c" "course" plain
           "#+FILETAGS: :course:\n\n* Overview\n%?\n\n* Key Concepts\n\n* Questions\n"
           :target (file+head "courses/${slug}.org"
                              "#+TITLE: ${title}\n#+CREATED: %U\n#+COURSE: %^{Course name}\n\n")
           :unnarrowed t)

          ("b" "book" plain
           "#+FILETAGS: :book:\n\n* Summary\n%?\n\n* Key Ideas\n\n* Quotes\n\n* Actions\n"
           :target (file+head "books/${slug}.org"
                              "#+TITLE: ${title}\n#+AUTHOR: %^{Author}\n#+CREATED: %U\n\n")
           :unnarrowed t)))

  (org-roam-db-autosync-mode))

(after! org-noter
  (setq org-noter-notes-window-location 'vertical-split
        org-noter-always-create-frame nil
        org-noter-hide-other-windows t
        org-noter-auto-save-last-location t
        org-noter-default-notes-file-names '("notes.org")
        org-noter-notes-search-path (list (concat org-directory "roam/books/"))))

(after! geiser-mode
  (setq geiser-active-implementations '(mit))
  (setq geiser-repl-use-other-window t)
  (setq geiser-mit-binary "mit-scheme"))

(defvar my/geiser-started nil)

(add-hook 'geiser-mode-hook
          (lambda ()
            (unless my/geiser-started
              (setq my/geiser-started t)
              (save-window-excursion
                (geiser-mit)))))

(after! scheme-mode
  (add-hook 'scheme-mode-hook #'paredit-mode)
  (add-hook 'geiser-repl-mode-hook #'paredit-mode)
  (setq show-paren-style 'mixed
        show-paren-delay 0))

(after! geiser-repl
  (setq geiser-repl-history-filename
        (expand-file-name "geiser-history" doom-cache-dir)))

(add-to-list 'default-frame-alist '(alpha-background . 85))

(set-frame-parameter nil 'alpha-background 85)

(after! org-pomodoro
  (setq org-pomodoro-length 50
        org-pomodoro-short-break-length 10
        org-pomodoro-long-break-length 30
        org-pomodoro-long-break-frequency 4)
