(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(defvar np/packages-refreshed nil)
(defun np/refresh-packages-once ()
  (when (not np/packages-refreshed)
    (setq np/packages-refreshed t)
    (package-refresh-contents)))

(defun np/install-package (name)
  (when (not (package-installed-p name))
    (condition-case nil
        (package-install name t)
      (error (np/refresh-packages-once)
             (package-install name t)))))

(mapcar #'np/install-package '(magit expand-region paredit))

;;; TODO: Take a look at this. I don't remember what this was about...
(let ((custom-temporary-file-directory
       (concat temporary-file-directory "emacs-np/")))
  (ignore-errors
    (make-directory custom-temporary-file-directory))
  (setq custom-file (expand-file-name "custom.el" custom-temporary-file-directory)
        auto-save-file-name-transforms `((".*" ,custom-temporary-file-directory t))
        backup-directory-alist `(("." . ,custom-temporary-file-directory))))

(let ((coding-system 'utf-8-unix))
  (prefer-coding-system coding-system)
  (set-default-coding-systems coding-system)
  (set-terminal-coding-system coding-system)
  (set-keyboard-coding-system coding-system)
  (setq-default buffer-file-coding-system coding-system))

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(column-number-mode)
(global-auto-revert-mode)
(show-paren-mode)

(when (equal (system-name) "sanguinius")
  (display-battery-mode))

(let ((theme-name 'deeper-blue))
  (when (member theme-name (custom-available-themes))
    (load-theme theme-name t)))

(let ((font "Iosevka Fixed")
      (font-size "11"))
  (when (member font (font-family-list))
      (set-frame-font (concat font "-" font-size) t t)))

(setq-default cursor-type 'bar
              fill-column 80
              indent-tabs-mode nil
              indicate-empty-lines t
              show-trailing-whitespace t
              truncate-lines t)

(setq backup-by-copying t
      delete-old-versions t
      inhibit-startup-screen t
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(5)
      org-adapt-indentation nil         ; no paragraph indentation
      sentence-end-double-space nil
      vc-handled-backends nil           ; disable VC altogether
      version-control t)

(add-hook 'git-commit-setup-hook #'flyspell-mode)
(add-hook 'org-mode-hook #'flyspell-mode)

(ido-mode 1)
(ido-everywhere)
(setq ido-enable-flex-matching t
      ido-create-new-buffer 'always)

(global-set-key (kbd "C-=") #'er/expand-region)
(global-set-key (kbd "<f5>") #'recompile)

(add-hook 'compilation-mode-hook
          #'(lambda () (setq truncate-lines nil
                             show-trailing-whitespace nil)))

(defun knr-style ()
  (c-set-style "k&r")
  (c-toggle-comment-style 1)            ; use C-style comments
  (setq-local c-basic-offset 4))

(add-hook 'c-mode-common-hook #'knr-style)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-mode-hook #'enable-paredit-mode)
