(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)








;; Användbarhet!
(use-package helm
  :config
  (setq helm-split-window-in-side-p t
	helm-move-to-line-cycle-in-source t
	helm-autoresize-min-height 30
	helm-autoresize-mode t
	helm-mode-fuzzy-match t)
  :bind
  (("M-x"     . helm-M-x)
   ("C-x C-f" . helm-find-files)
   ("C-x b"   . helm-mini)
   ("M-y"     . helm-show-kill-ring)
   :map helm-map
   ("<tab>" . helm-execute-persistent-action)
   ("C-z"   . helm-select-action)))
(use-package helm-swoop
  :bind
  ("C-s" . helm-swoop))
(use-package company
  :init
  (global-company-mode)
  :bind
  ("<tab>" . company-complete))
(use-package zygospore
  :bind
  ("C-x 1" . zygospore-toggle-delete-other-windows))
(use-package ws-butler
  :init
  (ws-butler-mode))







;; Projectile
(use-package projectile
  :config
  (projectile-mode))
(use-package helm-projectile
  :config
  (helm-projectile-on))










;; Look & Feel
(use-package zenburn-theme
  :init
  (load-theme 'zenburn t))
(windmove-default-keybindings)
(menu-bar-mode   -1)
(tool-bar-mode   -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)
(defalias 'yes-or-no-p 'y-or-n-p)
(set-default-font "Inconsolata-14")

(use-package smartparens-config
  :ensure smartparens
  :config
  (electric-pair-mode))
(use-package spaceline-config
  :ensure spaceline
  :config
  (spaceline-emacs-theme)
  (spaceline-toggle-minor-modes-off))








;; Jobb
(use-package tex
  :ensure auctex
  :config
  (setq TeX-command-extra-options "-shell-escape")
  (setq LaTeX-biblatex-use-Biber t))
(eval-after-load "tex"
  '(progn
     (add-to-list
      'TeX-engine-alist
      '(default-shell-escape "Default with shell escape"
     "pdftex -shell-escape"
     "pdflatex -shell-escape"
     ConTeXt-engine))
     (setq-default TeX-engine 'default-shell-escape)))
(use-package rtags
  :bind
  ("M-." . rtags-find-symbol-at-point)
  ("M-," . rtags-location-stack-back))
(use-package cc-mode
  :init
  (add-hook 'c-mode-common-hook 'rtags-start-process-unless-running)
  (push 'company-rtags company-backends)
  :config
  (setq rtags-autostart-diagnostics t
	rtags-completions-enabled t)
  :ensure rtags
  :ensure company)
(use-package matlab-mode)
(use-package flycheck
  :init
  (global-flycheck-mode))
(use-package flycheck-rtags
  :ensure flycheck)
;(use-package flycheck-rtags)
