;; Get packages set up.
(when (< emacs-major-version 27)
  (package-initialize))
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://melpa.org/packages/") t)
(setq package-check-signature nil)
;; TODO: I suspect this is broken for Emacs 24.

;; Workaround for some input manager shenanigans causing tilde keys
;; etc to malfunction.
(require 'iso-transl)

;(set-default-font "DejaVu Sans Mono 12")
;(set-default-font "Inconsolata 12")

(setq inhibit-startup-screen t)
(setq custom-file (concat user-emacs-directory "/custom.el"))
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(electric-pair-mode)
(show-paren-mode)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

(use-package windmove
  :config
  (windmove-default-keybindings))

(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode)
  (add-to-list 'projectile-globally-ignored-directories ".ccls-cache"))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
	 ("C-x b" . helm-mini)
	 ("C-x C-f" . helm-find-files)
         ("C-s" . helm-occur))
  :bind (:map helm-map
	      ("<tab>" . helm-execute-persistent-action)
	      ("C-i" . helm-execute-persistent-action)
	      ("C-z" . helm-select-action))
  :config
  (helm-mode 1)
  (setq helm-buffer-max-length nil))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package helm-ag
  :ensure t)

(use-package magit
  :ensure t
  :bind (("C-c C-g" . magit-status))
  :config
  (transient-append-suffix 'magit-push "u" '("G" "Gerrit" magit-push-to-gerrit)))

(defun magit-push-to-gerrit ()
    "Pushes the current branch to Gerrit for code review."
    (interactive)
    (magit-git-command "git push origin HEAD:refs/for/master --dry-run"))


(setq tab-always-indent 'complete)

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package smartparens
  :ensure t
  :bind (:map smartparens-mode-map
	      ("M-<right>" . sp-forward-slurp-sexp)
	      ("M-<left>" . sp-forward-barf-sexp))
  :config
  (smartparens-global-mode))

(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-enable-file-watchers nil)
  (setq lsp-prefer-flymake nil))
(use-package company-lsp
  :ensure t
  :config
  (push 'company-lsp company-backends))
(use-package ccls
  :ensure t
  :hook
  ((c-mode c++-mode) . (lambda ()
			 (require 'ccls)
			 (lsp)))
  :config
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
  (setq-default indent-tabs-mode nil)
  (setq-default c-basic-offset 2))

(use-package yasnippet
  :ensure t)

;; (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
;; (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
(defalias 'yes-or-no-p 'y-or-n-p)

(global-display-line-numbers-mode 1)

(use-package comment-dwim-2
  :ensure t
  :bind
  (("M-;" . comment-dwim-2)))

(use-package zygospore
  :ensure t
  :bind
  (("C-x 1" . zygospore-toggle-delete-other-windows)))

(global-subword-mode t)
(setq compilation-scroll-output 'first-error)

(use-package ws-butler
  :ensure t
  :config
  (ws-butler-global-mode))

(use-package json-mode
  :ensure t)

;; Explicitly load this one to make it overload the default gdb-mi.
;; (load-file "~/.emacs.d/lisp/gdb-mi.el")

;; GDB spits out errors. This might help.
(setenv "PYTHONPATH" "")

;; Spaceline is nice, but Emacs got rebuilt without xpm support, so
;; it's rather broken. Even the UTF-8 fallback doesn't work correctly.
;; (use-package spaceline
;;   :ensure t
;;   :config
;;   (setq-default powerline-default-separator 'utf-8))
;; (use-package spaceline-config
;;   :ensure spaceline
;;   :config
;;   (spaceline-helm-mode 1)
;;   (spaceline-spacemacs-theme))

;;(gdb-many-windows t)
(use-package cov
  :ensure t)
