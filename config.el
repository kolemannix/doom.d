;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Koleman Nix"
      user-mail-address "koleman@hey.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq! doom-theme 'doom-one)
;; (load-theme 'doom-homage-white)
;; (load-theme 'doom-city-lights)
;; (load-theme 'doom-homage-white)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! lsp-mode
  (setq lsp-ui-doc-enable nil)
  (setq lsp-symbol-highlighting-skip-current t)
  (setq lsp-signature-render-documentation t)
  (setq lsp-signature-auto-activate t)
  (setq! lsp-metals-super-method-lenses-enabled t)
  (custom-set-faces!
    ;; Quiet down that highlighting
    '(lsp-face-highlight-textual :underline nil)
    )
  )

;; Clear C-s
(map! :after isearch
      :map isearch-mode-map
      [C-s] nil)

(defun save-and-escape () (interactive) (save-buffer) (evil-escape))

(map! :desc "Navigate codebases using Enter and Delete"
      :n [return] 'xref-find-definitions
      :n "<DEL>" 'xref-pop-marker-stack
      :n [tab] 'next-error
      :i "C-s" 'save-and-escape
      :n "C-s" 'save-buffer
      )

(map! :leader
      :desc "Magit push" "g p" #'magit-push)

(map! (:prefix ("," . "common")
       :desc "Format buffer or region" :n [tab] '+format/region-or-buffer
       :desc "Kill buffer"             :n "x" 'kill-buffer
       :desc "Show quickdoc"           :n "d" '+lookup/documentation
       (:when (featurep! :tools lsp)
        (:map lsp-mode-map
         :desc "Show signature"          :n "p" 'lsp-signature-activate
         :desc "Find references"         :n "f" '+lookup/references
         ))
       (:when (featurep! :ui treemacs)
        :desc "Toggle Treemacs"          :n "t" 'treemacs
        )
       ))
