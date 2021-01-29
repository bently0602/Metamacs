;;
;; METAMACS
;; 	 METAMACS
;; 		METAMACS
;; 			METAMACS
;; 				METAMACS
;; 					METAMACS
;;

;;
;; packages
;;

;; add melpa to package repo
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(setq use-package-always-pin  "melpa-stable")
(package-initialize)

;; download use-package
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
      (package-install 'use-package))

;; reduce load time
(eval-when-compile (require 'use-package))

;;
;; splash
;;

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message ";; Welcome to Metamacs")
(defun display-startup-echo-area-message ()
	(message "NUM NUM NUM"))
  
;;
;; packages
;;

(use-package paredit :ensure t)
(use-package neotree :ensure t)
(use-package doom-themes :ensure t)
(use-package doom-modeline
	:ensure t
	:hook (after-init . doom-modeline-mode))
(use-package hydra :ensure t)

;;
;; hydras
;;

(defhydra hydra-toggle ()
	"^METAMACS^"
	("\\"  my-vsplit  "vertical"    :color pink   :column "Split")
	("-"   my-hsplit  "horizontal"  :color pink   :column "Split")
	
	("W"   shrink-window  						"shrink vertical"  :color green   :column "Window")
	("S"   enlarge-window  						"enlarge veritcal"  :color green   :column "Window")
	("A"   shrink-window-horizontally  			"shrink horizontal"  :color green   :column "Window")
	("D"   enlarge-window-horizontally  		"enlarge horizontal"  :color green   :column "Window")
	;;
	("S-<up>"     shrink-window  				"shrink vertical"  :color green   :column "Window")
	("S-<down>"   enlarge-window  				"enlarge veritcal"  :color green   :column "Window")
	("S-<left>"   shrink-window-horizontally  	"shrink horizontal"  :color green   :column "Window")
	("S-<right>"  enlarge-window-horizontally  	"enlarge horizontal"  :color green   :column "Window")
	;;
	("r"   delete-window  "remove"  :color blue   :column "Window")

	("n"   xah-new-empty-buffer     "new"       :color blue   :column "Buffer")
	("o"   find-file                "open"   :color blue   :column "Buffer")
	("l"   ibuffer                  "list"      :color blue   :column "Buffer")
	("s"   save-buffer              "save"      :color blue   :column "Buffer")
	
	("w"   windmove-up  	"up"  :color purple   :column "Focus")
	("s"   windmove-down  	"down"  :color purple   :column "Focus")
	("a"   windmove-left  	"left"  :color purple   :column "Focus")
	("d"   windmove-right  	"right"  :color purple   :column "Focus")
	;;
	("<up>"     windmove-up  	"up"  :color purple   :column "Focus")
	("<down>"   windmove-down  	"down"  :color purple   :column "Focus")
	("<left>"   windmove-left  	"left"  :color purple   :column "Focus")
	("<right>"  windmove-right  "right"  :color purple   :column "Focus")

	("C-q" save-buffers-kill-terminal 	"quit EMACS..."  :color purple   :column "App")
	("1"   neotree-toggle 				"toggle neotree"  :color purple   :column "App")
	("2"   eshell 						"launch eshell"  :color purple   :column "App")
	("3"   ansi-term 					"launch ansi-term"  :color purple   :column "App")
	
	("ESC"  nil "cancel" :color red :column "Split")
	("<f1>" nil "cancel" :color red :column "Split")
	("q"    nil "cancel" :color red :column "Split")
)

;;
;; theme
;;
(setq 
	doom-themes-enable-bold t
	doom-themes-enable-italic t)
(load-theme 'doom-one t)
(doom-themes-visual-bell-config)
(doom-themes-neotree-config)

;; line #s
(when (version<= "26.0.50" emacs-version )
	(global-display-line-numbers-mode))

;; turn off word wrap
(toggle-truncate-lines ())

;; turn off toolbar
(tool-bar-mode -1)
(menu-bar-mode -1)

;;
;; mouse
;;
(xterm-mouse-mode 1)
(setq mouse-drag-copy-region t)

;;
;; some default settings
;;

;; default mode to text
(setq initial-major-mode (quote text-mode))

;; make neotree toggle a little better
(setq neo-window-fixed-size nil)

;; Set the neo-window-width to the current width of the
;; neotree window, to trick neotree into resetting the
;; width back to the actual window width.
;; Fixes: https://github.com/jaypei/emacs-neotree/issues/262
(eval-after-load "neotree"
    '(add-to-list 'window-size-change-functions
        (lambda (frame)
            (let ((neo-window (neo-global--get-window)))
                (unless (null neo-window)
					(setq neo-window-width (window-width neo-window)))))))

;; this determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; disable line-numbers minor mode for neotree
(add-hook 'neo-after-create-hook
	(lambda (&rest _) (display-line-numbers-mode -1)))

(add-hook 'term-mode-hook
	(lambda (&rest _) (display-line-numbers-mode -1)))

;; Every time when the neotree window is opened, let it find current
;; file and jump to node.
(setq neo-smart-open t)

;; track ‘projectile-switch-project’ (C-c p p),
(setq projectile-switch-project-action 'neotree-projectile-action)

;;
;; easy mode (cua + shift select)
;;

(delete-selection-mode t)
(cua-mode t)
(setq shift-selection-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;; C-c, C-v, C-x
;; C-z == undo
;; C-Y == redo

;;
;; tabs
;;

(setq-default indent-tabs-mode t)
(setq tab-width 4) ; or any other preferred value
(defvaralias 'c-basic-offset 'tab-width)

;;
;; custom keys
;;

(global-set-key (kbd "M-S-<up>")    'shrink-window)
(global-set-key (kbd "M-S-<down>")  'enlarge-window)
(global-set-key (kbd "M-S-<left>")  'shrink-window-horizontally)
(global-set-key (kbd "M-S-<right>") 'enlarge-window-horizontally)

(global-set-key [M-up]    'windmove-up)
(global-set-key [M-down]  'windmove-down)
(global-set-key [M-left]  'windmove-left)
(global-set-key [M-right] 'windmove-right)

(global-set-key (kbd "M-\\") 'my-vsplit)
(global-set-key (kbd "M--") 'my-hsplit)

(global-set-key (kbd "M-d") 'delete-window)
(global-set-key (kbd "M-l") 'ibuffer) ;; or buffer-menu
(global-set-key (kbd "M-k") 'kill-buffer)

;; standards
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-q") 'save-buffers-kill-terminal)
;; C-s == search, then repeat to keep searching for term
(global-set-key (kbd "C-f") 'isearch-forward)
(global-set-key (kbd "C-n") 'xah-new-empty-buffer)
(global-set-key (kbd "C-o") 'find-file)
(global-set-key (kbd "C-g") 'keyboard-quit)

;; hydras
(global-set-key (kbd "<f1>") 'hydra-toggle/body)

;; term specific
(global-set-key (kbd "<f2>")  'term-line-mode)
(global-set-key (kbd "<f12>") 'my-saycrap)
(global-set-key (kbd "<f3>")  'term-char-mode)
(add-hook 'term-mode-hook
  (lambda () 
    (define-key term-raw-map (kbd "M-j") 'my-saycrap)
	(define-key term-raw-map (kbd "M-c") 'kill-ring-save)
	(define-key term-raw-map (kbd "M-v") 'term-paste)
    (define-key term-raw-map (kbd "M-k") 'kill-buffer)))

;;
;; library functions
;;

(defun xah-new-empty-buffer ()
	"Create a new empty buffer.
	New buffer will be named “untitled” or “untitled<2>”, “untitled<3>”, etc.
	It returns the buffer (for elisp programing).
	URL `http://ergoemacs.org/emacs/emacs_new_empty_buffer.html'
	Version 2017-11-01"
	(interactive)
	(let (($buf (generate-new-buffer "untitled")))
		(switch-to-buffer $buf)
		(funcall initial-major-mode)
		(setq buffer-offer-save t)
		$buf
	)
)

(defun my-vsplit ()
	""
	(interactive)
	(split-window-below)
	(other-window 1)
	(xah-new-empty-buffer)
)

(defun my-hsplit ()
	""
	(interactive)
	(split-window-right)
	(other-window 1)
	(xah-new-empty-buffer)
)

;;
;; TODO
;;

(defun shift-text (distance)
  (if (use-region-p)
      (let ((mark (mark)))
        (save-excursion
          (indent-rigidly (region-beginning)
                          (region-end)
                          distance)
          (push-mark mark t t)
          (setq deactivate-mark nil)))
    (indent-rigidly (line-beginning-position)
                    (line-end-position)
                    distance)))

(defun shift-right (count)
  (interactive "p")
  (shift-text count))

(defun shift-left (count)
  (interactive "p")
  (shift-text (- count)))

(defun x-shift-left ()
	(interactive)
	(shift-text -1))

(defun x-shift-right ()
	(interactive)
	(shift-text 1))
	
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (base16-theme use-package paredit neotree))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
