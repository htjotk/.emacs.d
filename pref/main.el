;; 共通する設定


;; 言語を日本語にする
(set-language-environment 'Japanese)
;; 極力UTF-8とする
(prefer-coding-system 'utf-8)

;; elpaのパッケージを増やす
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; C-hでバックスペース
(keyboard-translate ?\C-h ?\C-?)

;; ;; C-hにバックスペースを割り当てる
;; (define-key global-map (kbd "C-h") 'backward-delete-char-untabify)
;; 別のキーバインドにヘルプを割り当てる
(define-key global-map (kbd "C-c DEL") 'help-command)

;; 行番号
(require 'linum)
(global-linum-mode)

;; インデントをスペースではなくタブに
(setq-default indent-tabs-mode t)
;; tab 幅を 4 に設定
(setq-default tab-width 4)
(setq default-tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                        64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))

;; auto-complete
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete-1.3.1/dict")
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'html-mode)
(add-to-list 'ac-modes 'asy-mode)

;; 括弧の補完
(require 'flex-autopair)
(flex-autopair-mode 1)

;; 最後に改行を入れる
(setq require-final-newline t)

;; バッファ終端の無駄な空行を削除する関数
(defun trim-eob ()
  "バッファの最後に溜った空行を消去"
  (interactive)
  (save-excursion
    (progn
      (goto-char (point-max))
      (delete-blank-lines)
      nil)))

;; セーブ時に行末の空白を削除 & 空行を削除
;; 無駄な行末の空白を削除する(Emacs Advent Calendar jp:2010) - tototoshiの日記
;; http://d.hatena.ne.jp/tototoshi/20101202/1291289625
(add-hook 'before-save-hook
          'delete-trailing-whitespace
          'trim-eob)

;; バックアップファイルの保存先変更
;; create backup file in ~/.emacs.d/backup
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
            backup-directory-alist))
;; create auto-save file in ~/.emacs.d/backup
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backup/") t)))

;; バックアップファイルを複数世代残す
(setq version-control t)     ; 複数のバックアップを残します。世代。
(setq kept-new-versions 5)   ; 新しいものをいくつ残すか
(setq kept-old-versions 5)   ; 古いものをいくつ残すか
(setq delete-old-versions t) ; 確認せずに古いものを消す。
(setq vc-make-backup-files t) ; バージョン管理下のファイルもバックアップを作る。

;; 矩形選択モード (C-Enter)
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; タブと全角スペースに色を付ける
(require 'whitespace)
;; see whitespace.el for more details
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
(setq whitespace-space-regexp "\\(\u3000+\\)")
;;(set-face-foreground 'whitespace-tab "#adff2f")
(set-face-foreground 'whitespace-tab "gray25")
(set-face-background 'whitespace-tab 'nil)
(set-face-underline  'whitespace-tab t)
(set-face-foreground 'whitespace-space "#7cfc00")
(set-face-background 'whitespace-space 'nil)
(set-face-bold-p 'whitespace-space t)
(global-whitespace-mode 1)
(global-set-key (kbd "C-x w") 'global-whitespace-mode)

;; ;; 行末の空白を表示
;; (setq-default show-trailing-whitespace t)
;; ;;(set-face-background 'trailing-whitespace "purple4")

;; scrachバッファを消さない設定
;; "*scratch*" を作成して buffer-list に放り込む
(defun my-make-scratch (&optional arg)
  (interactive)
  (progn
    (set-buffer (get-buffer-create "*scratch*"))
    (funcall initial-major-mode)
    (erase-buffer)
    (when (and initial-scratch-message (not inhibit-startup-message))
      (insert initial-scratch-message))
    (or arg (progn (setq arg 0)
                   (switch-to-buffer "*scratch*")))
    (cond ((= arg 0) (message "*scratch* is cleared up."))
          ((= arg 1) (message "another *scratch* is created")))))
;; *scratch* バッファで kill-buffer したら内容を消去するだけにする
(add-hook 'kill-buffer-query-functions
          (lambda ()
            (if (string= "*scratch*" (buffer-name))
                (progn (my-make-scratch 0) nil)
              t)))
;; *scratch* バッファの内容を保存したら *scratch* バッファを新しく作る
(add-hook 'after-save-hook
          (lambda ()
            (unless (member (get-buffer "*scratch*") (buffer-list))
              (my-make-scratch 1))))

;; ispellの設定 (スペルチェッカ)
(setq-default ispell-program-name "aspell")

;; ;; 全角space、tabを可視化する。
;; ;; Emacs で全角スペース/タブ文字を可視化 | Weboo! Returns.
;; ;; http://yamashita.dyndns.org/blog/emacs-shows-double-space-and-tab/
;; (setq whitespace-style
;; 	  '(tabs tab-mark spaces space-mark))
;; (setq whitespace-space-regexp "\\(\x3000+\\)")
;; (setq whitespace-display-mappings
;; 	  '((space-mark ?\x3000 [?\□])
;; 		(tab-mark	?\t	  [?\xBB ?\t])
;; 		))
;; (require 'whitespace)
;; (global-whitespace-mode 1)
;; (set-face-foreground 'whitespace-space "LightSlateGray")
;; ;; (set-face-background 'whitespace-space "DarkSlateGray")
;; (set-face-foreground 'whitespace-tab "LightSlateGray")
;; ;; (set-face-background 'whitespace-tab "DarkSlateGray")

;; ;; タブ, 全角スペース、改行直前の半角スペースを表示する
;; (when (require 'jaspace nil t)
;;   (when (boundp 'jaspace-modes)
;;     (setq jaspace-modes (append jaspace-modes
;;                                 (list 'php-mode
;;                                       'yaml-mode
;;                                       'javascript-mode
;;                                       'ruby-mode
;;                                       'text-mode
;;                                       'fundamental-mode
;;                                       'emacs-lisp-mode
;;                                       'c-mode))))
;;   (when (boundp 'jaspace-alternate-jaspace-string)
;;     (setq jaspace-alternate-jaspace-string "□"))
;;   (when (boundp 'jaspace-highlight-tabs)
;;     (setq jaspace-highlight-tabs ?^))
;;   (add-hook 'jaspace-mode-off-hook
;;             (lambda()
;;               (when (boundp 'show-trailing-whitespace)
;;                 (setq show-trailing-whitespace nil))))
;;   (add-hook 'jaspace-mode-hook
;;             (lambda()
;;               (progn
;;                 (when (boundp 'show-trailing-whitespace)
;;                   (setq show-trailing-whitespace t))
;;                 (face-spec-set 'jaspace-highlight-jaspace-face
;;                                '((((class color) (background light))
;;                                   (:foreground "blue"))
;;                                  (t (:foreground "green"))))
;;                 (face-spec-set 'jaspace-highlight-tab-face
;;                                '((((class color) (background light))
;;                                   (:foreground "red"
;;                                                :background "unspecified"
;;                                                :strike-through nil
;;                                                :underline t))
;;                                  (t (:foreground "purple"
;;                                                  :background "unspecified"
;;                                                  :strike-through nil
;;                                                  :underline t))))
;;                 (face-spec-set 'trailing-whitespace
;;                                '((((class color) (background light))
;;                                   (:foreground "red"
;;                                                :background "unspecified"
;;                                                :strike-through nil
;;                                                :underline t))
;;                                  (t (:foreground "purple"
;;                                                  :background "unspecified"
;;                                                  :strike-through nil
;;                                                  :underline t))))))))

(provide 'main)
