;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;;
(setq exec-path-from-shell-debug t)

(setq doom-font (font-spec :family "Jetbrains Mono Medium" :height 22)
      doom-variable-pitch-font (font-spec :family "sans-serif" :height 1.0))

(setq fcitx-remote-command "fcitx5-remote")

(setq ispell-dictionary "en_US")

(after! apheleia
  (push '(
          juliaformatter
          "julia"
          "--startup-file=no" "--history-file=no" "--project" "--quiet"
          "-e"
          "using JuliaFormatter; print(format_text(read(stdin, String), margin=80));"
          )
        apheleia-formatters)
  (push '(julia-mode . juliaformatter
          )
        apheleia-mode-alist))




(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(after! org
  (setq my-org-latex-preview-scale 1.0)   ; depends on the font used in emacs or just on user preference
  (defun org-latex-preview-advice (orig-func &rest args)
    (let ((old-val (copy-tree org-format-latex-options)))     ; plist-put is maybe-destructive, weird. So, we have to restore old value ourselves
      (setq org-format-latex-options (plist-put org-format-latex-options
                                                :scale
                                                (* my-org-latex-preview-scale (expt text-scale-mode-step text-scale-mode-amount))))
      (apply orig-func args)
      (setq org-format-latex-options old-val)))
  (advice-add 'org-latex-preview :around #'org-latex-preview-advice)
  (plist-put org-format-latex-options :scale 1.5)
  (setq org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-item-bullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        org-todo-keywords
        '((sequence
           "TODO(t)"
           "PROJ(p)"
           "EXAM(e)"
           "WAIT(w)"
           "|"
           "DONE(d)"
           "CANCELLED(c)"))
        )
  ;; (let ((default-directory org-directory))
  ;;   (setq
  ;;    org-attach-id-dir (expand-file-name "attach/")
  ;;    org-cite-global-bibliography (mapcar #'expand-file-name '("ref.bib"))
  ;;    org-agenda-files (mapcar #'expand-file-name '("agenda/" "./"))
  ;;    org-roam-directory (expand-file-name "roam")
  ;;    org-default-notes-file (expand-file-name "notes.org")
  ;;    ))
  (setq org-mobile-directory "~/webdav/orgmobile/")
  (setq org-mobile-files '("chengdu.org"))
  (setq org-mobile-inbox-for-pull "~/.cache/org-mobile-inbox-for-pull.org")
  )
(after! org
  (add-to-list 'org-file-apps
               '("\\.pdf\\'" . "zathura \"%s\""))
  )
(defun my-org-babel-execute:julia (body params)
  (let ((in-file (org-babel-temp-file "n" ".jl")))
    (with-temp-file in-file
      (insert body))
    (org-babel-eval
     (format "julia %s"
             (org-babel-process-file-name in-file))
     "")))
(after! org
  ;; active Babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)))
  (advice-add 'org-babel-execute:julia :override #'my-org-babel-execute:julia)
  )

(after! ox-latex
  (setq org-latex-listings 'minted)
  (setq org-latex-minted-options '(("breaklines" "true")
                                   ("breakanywhere" "true")))
  )
(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))

(setq +latex-viewers '(zathura))


(setq TeX-save-query nil
      TeX-show-compilation t
      TeX-command-extra-options "-shell-escape")

(setq TeX-engine 'xetex)

(setq-default TeX-master nil) ; Query for master file.

(setq-default evil-escape-key-sequence "jj")
(setq-default evil-escape-delay 0.2)

;; company-mode
(company-tng-configure-default)
(setq company-idle-delay 0)

(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :height 1.4))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
 )

(setq lsp-rust-server 'rust-analyzer)

(setq-default anki-editor-use-math-jax t)

(setq langtool-java-classpath
      "/usr/share/languagetool:/usr/share/java/languagetool/*")

(add-to-list 'auto-mode-alist
             '("\\.v\\'" . verilog-mode))

;; Verilog mode disable auto formatting
(defun my-verilog-hook ()
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (setq verilog-indent-level 4)
  (setq verilog-indent-level-behavioral 4)
  (setq verilog-indent-level-declaration 4)
  (setq verilog-indent-level-directive 4)
  (setq verilog-indent-level-module 4)
  (define-key verilog-mode-map (kbd ";") 'self-insert-command)
  (define-key verilog-mode-map (kbd ":") 'self-insert-command)
  (define-key verilog-mode-map (kbd "RET") 'evil-ret-and-indent)
  (define-key verilog-mode-map (kbd "TAB") 'tab-to-tab-stop))
(add-hook 'verilog-mode-hook 'my-verilog-hook)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
;; (setq doom-theme 'doom-palenight)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/docs/org/")

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

;; auto-dark
(after! doom-themes
  ;; set  your favorite themes
  (setq! auto-dark-dark-theme 'doom-palenight
         auto-dark-light-theme 'leuven)
  (auto-dark-mode 1))

;; (after!
;;   (let ((default-directory org-directory))
;;     (setq rmh-elfeed-org-files (mapcar #'expand-file-name '("elfeed.org")))
;;     ))
