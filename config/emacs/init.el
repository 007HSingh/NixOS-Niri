;; Basic settings
(setq inhibit-startup-message t
      backup-directory-alist `(("." . "~/.emacs.d/backups"))
      auto-save-default nil
      create-lockfiles nil)

;; UI cleanup
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Better parentheses visibility
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Use-package setup
(require 'use-package)
(setq use-package-always-ensure nil)

;; Theme
(use-package doom-themes
  :config
  (load-theme 'doom-mocha t))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; Evil mode (Vim keybindings)
(use-package evil
  :init
  (setq evil-want-C-u-scroll t
        evil-want-C-d-scroll t
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "jk") 'evil-normal-state))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Which-key
(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

;; Rainbow delimiters - essential for Lisp
(use-package rainbow-delimiters
  :hook ((emacs-lisp-mode . rainbow-delimiters-mode)
         (lisp-mode . rainbow-delimiters-mode)
         (slime-repl-mode . rainbow-delimiters-mode)))

;; Paredit - structural editing for Lisp
(use-package paredit
  :hook ((emacs-lisp-mode . paredit-mode)
         (lisp-mode . paredit-mode)
         (slime-repl-mode . paredit-mode))
  :config
  (add-hook 'paredit-mode-hook
            (lambda ()
              (define-key evil-normal-state-map (kbd "(") 'paredit-backward)
              (define-key evil-normal-state-map (kbd ")") 'paredit-forward))))

;; SLIME - Superior Lisp Interaction Mode
(use-package slime
  :config
  (setq inferior-lisp-program "sbcl"  ; or "clisp", "ccl", etc.
        slime-contribs '(slime-fancy slime-company)
        slime-complete-symbol-function 'slime-fuzzy-complete-symbol
        slime-net-coding-system 'utf-8-unix)
  
  ;; Start SLIME automatically when opening .lisp files
  (add-hook 'lisp-mode-hook
            (lambda ()
              (unless (slime-connected-p)
                (save-excursion (slime))))))

;; Company mode for auto-completion
(use-package company
  :config
  (global-company-mode)
  (setq company-minimum-prefix-length 2
        company-idle-delay 0.2
        company-show-numbers t)
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)))

(use-package slime-company
  :after (slime company)
  :config
  (slime-setup '(slime-fancy slime-company)))

;; Magit
(use-package magit
  :bind ("C-x g" . magit-status))

;; Lisp-specific settings
(setq lisp-indent-function 'common-lisp-indent-function)

;; Helper functions
(defun lisp-eval-buffer ()
  "Evaluate the entire buffer."
  (interactive)
  (slime-eval-buffer))

(defun lisp-eval-last-expression ()
  "Evaluate the expression before point."
  (interactive)
  (slime-eval-last-expression))

(defun lisp-eval-defun ()
  "Evaluate the current top-level form."
  (interactive)
  (slime-eval-defun))

;; Key bindings for Lisp mode
(evil-define-key 'normal lisp-mode-map
  ;; Evaluation
  (kbd "SPC e b") 'slime-eval-buffer
  (kbd "SPC e e") 'slime-eval-last-expression
  (kbd "SPC e f") 'slime-eval-defun
  (kbd "SPC e r") 'slime-eval-region
  
  ;; REPL
  (kbd "SPC r r") 'slime
  (kbd "SPC r c") 'slime-connect
  (kbd "SPC r q") 'slime-quit-lisp
  (kbd "SPC r s") 'slime-switch-to-output-buffer
  
  ;; Documentation
  (kbd "K") 'slime-describe-symbol
  (kbd "SPC h f") 'slime-describe-function
  (kbd "SPC h h") 'slime-documentation
  
  ;; Navigation
  (kbd "gd") 'slime-edit-definition
  (kbd "gb") 'slime-pop-find-definition-stack
  
  ;; Compilation
  (kbd "SPC c c") 'slime-compile-defun
  (kbd "SPC c f") 'slime-compile-file
  (kbd "SPC c l") 'slime-compile-and-load-file
  
  ;; Macroexpansion
  (kbd "SPC m e") 'slime-macroexpand-1
  (kbd "SPC m a") 'slime-macroexpand-all)

;; Emacs Lisp key bindings
(evil-define-key 'normal emacs-lisp-mode-map
  (kbd "SPC e b") 'eval-buffer
  (kbd "SPC e e") 'eval-last-sexp
  (kbd "SPC e f") 'eval-defun
  (kbd "SPC e r") 'eval-region
  (kbd "K") 'describe-symbol)

;; Better defaults
(setq-default
 indent-tabs-mode nil
 tab-width 2)

;; Auto-close REPL buffers when quitting
(setq slime-kill-without-query-p t)

(provide 'init)
