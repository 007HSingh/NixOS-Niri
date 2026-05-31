;;; packages.el
;; Packages here supplement Doom's own modules
;;  After adding one, run `doom sync`.

;; ── Theming ────────────────────────────────────────────────────────────────
(package! catppuccin-theme)           ; system-matching Catppuccin Mocha

;; ── Org extras ─────────────────────────────────────────────────────────────
(package! org-super-agenda)           ; group agenda items (like todo-comments)
(package! org-modern)                 ; modern org aesthetics (replaces org-bullets)
(package! org-appear)                 ; show/hide emphasis markers on cursor
(package! org-download)               ; drag & drop / paste images into org
(package! org-noter)                  ; PDF annotation tied to org headlines
(package! ox-hugo)                    ; Hugo export backend

;; ── Evil extras ────────────────────────────────────────────────────────────
(package! evil-exchange)              ; cx / cX to exchange text objects
(package! evil-lion)                  ; gl / gL to align (like :EasyAlign)
(package! evil-textobj-tree-sitter)   ; tree-sitter text objects in evil

;; ── Navigation / search ────────────────────────────────────────────────────
(package! avy)                        ; like flash.nvim — jump to any char
(package! consult-org-roam)           ; consult source for org-roam nodes

;; ── Editing ────────────────────────────────────────────────────────────────
(package! jinx)                       ; fast spell checker (Enchant backend)
(package! apheleia)                   ; async formatter (replaces conform.nvim)

;; ── UI ─────────────────────────────────────────────────────────────────────
(package! nerd-icons)                 ; icon set matching your Maple Mono NF
(package! nerd-icons-dired)           ; icons in dired
(package! nerd-icons-ibuffer)         ; icons in ibuffer
(package! rainbow-delimiters)         ; like rainbow-delimiters.nvim
(package! indent-bars)                ; like indent-blankline.nvim

;; ── Tools ──────────────────────────────────────────────────────────────────
(package! envrc)                      ; better direnv integration (per-buffer)
