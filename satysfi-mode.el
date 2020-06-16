;;; satysfi-mode.el --- Major mode for editing satysfi files  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
;; Version: 0.0.1
;; Keywords: convenience
;; Package-Requires: ((emacs "26.1"))
;; URL: https://github.com/conao3/satysfi-mode.el

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Major mode for editing satysfi files.


;;; Code:

(defgroup satysfi nil
  "Major mode for editing satysfi files."
  :group 'convenience
  :link '(url-link :tag "Github" "https://github.com/conao3/satysfi-mode.el"))

(defface satysfi-comment-face
  '((t :inherit font-lock-comment-face))
  "Face name to use for comments."
 :group 'satysfi)

(defface satysfi-comment-delimiter-face
  '((t :inherit font-lock-comment-delimiter-face))
  "Face name to use for comment delimiters."
 :group 'satysfi)

(defface satysfi-string-face
  '((t :inherit font-lock-string-face))
  "Face name to use for strings."
 :group 'satysfi)

(defface satysfi-doc-face
  '((t :inherit font-lock-doc-face))
  "Face name to use for documentation."
 :group 'satysfi)

(defface satysfi-keyword-face
  '((t :inherit font-lock-keyword-face))
  "Face name to use for keywords."
 :group 'satysfi)

(defface satysfi-builtin-face
  '((t :inherit font-lock-builtin-face))
  "Face name to use for builtins."
 :group 'satysfi)

(defface satysfi-function-name-face
  '((t :inherit font-lock-function-name-face))
  "Face name to use for function names."
 :group 'satysfi)

(defface satysfi-variable-name-face
  '((t :inherit font-lock-variable-name-face))
  "Face name to use for variable names."
 :group 'satysfi)

(defface satysfi-type-face
  '((t :inherit font-lock-type-face))
  "Face name to use for type and class names."
 :group 'satysfi)

(defface satysfi-constant-face
  '((t :inherit font-lock-constant-face))
  "Face name to use for constant and label names."
 :group 'satysfi)

(defface satysfi-warning-face
  '((t :inherit font-lock-warning-face))
  "Face name to use for things that should stand out."
  :group 'satysfi)

(defface satysfi-preprocessor-face
  '((t :inherit font-lock-preprocessor-face))
  "Font Lock mode face used to highlight preprocessor directives."
  :group 'satysfi)

(defface satysfi-row-command-face
  '((t (:foreground "#8888ff" :background "dark")))
  "SATySFi row command")

(defface satysfi-column-command-face
  '((t (:foreground "#ff8888" :background "dark")))
  "SATySFi column command")

(defface satysfi-var-in-string-face
  '((t (:foreground "#44ff88" :background "dark")))
  "SATySFi variable in string")

(defface satysfi-escaped-character
  '((t (:foreground "#cc88ff" :background "dark")))
  "SATySFi escaped character")

(defface satysfi-literal-area
  '((t (:foreground "#ffff44" :background "dark")))
  "SATySFi literal area")



(defvar satysfi-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?% "<" table)
    (modify-syntax-entry ?\r ">" table)
    (modify-syntax-entry ?\n ">" table)
    table)
  "Syntax table for `satysfi-mode'.")

(defvar satysfi-mode-font-lock-keywords
  `((,(regexp-opt
       '("let" "let-rec" "let-mutable" "let-inline" "let-block" "let-math" "in" "and"
         "match" "with" "when" "as" "if" "then" "else" "fun"
         "type" "constraint" "val" "direct" "of"
         "module" "struct" "sig" "end"
         "before" "while" "do"
         "controls" "cycle")
       'symbols)
     . font-lock-keyword-face)
    (,(regexp-opt
       '("gnu" "melpa-stable" "melpa" "org")
       'symbols)
     . font-lock-variable-name-face)
    ("\\(\\\\\\(?:\\\\\\\\\\)*[a-zA-Z0-9\\-]+\\)\\>"
     (1 'satysfi-row-command-face t))
    ("\\(\\+[a-zA-Z0-9\\-]+\\)\\>"
     (1 'satysfi-column-command-face t))
    ("\\(@[a-z][0-9A-Za-z\\-]*\\)\\>"
     (1 'satysfi-preprocessor-face t))
    ("\\(\\\\\\(?:@\\|`\\|\\*\\| \\|%\\||\\|;\\|{\\|}\\|\\\\\\)\\)"
     (1 'satysfi-escaped-character t))))

(define-derived-mode satysfi-mode prog-mode "Satysfi"
  "Major mode for editing satysfi files."
  (set-syntax-table satysfi-mode-syntax-table)
  (setq font-lock-defaults '(satysfi-mode-font-lock-keywords)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.satyh?\\'" . satysfi-mode))
;;;###autoload
(add-to-list 'interpreter-mode-alist '("saty\\(h\\|sfi\\)?" . satysfi-mode))

(provide 'satysfi-mode)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; satysfi-mode.el ends here
