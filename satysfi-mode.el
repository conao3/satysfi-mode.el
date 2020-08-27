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

(require 'smie)

(defgroup satysfi nil
  "Major mode for editing satysfi files."
  :group 'convenience
  :link '(url-link :tag "Github" "https://github.com/conao3/satysfi-mode.el"))

(defface satysfi-preprocessor-face
  '((t :inherit font-lock-preprocessor-face))
  "Font Lock mode face used to highlight preprocessor directives."
  :group 'satysfi)

(defface satysfi-header-require-face
  '((t :inherit font-lock-string-face))
  "Face for header directives (@require).")

(defface satysfi-header-import-face
  '((t :inherit font-lock-string-face))
  "Face for header directives (@import).")

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



(defconst satysfi-smie-grammar
  (smie-prec2->grammar
   (smie-bnf->prec2
    '((id)
      ;; (inst (exp))
      ;; (exp (exp "+" exp))
      ;; (inst ("begin" insts "end")
      ;;       ("if" exp "then" inst "else" inst)
      ;;       (id ":=" exp)
      ;;       (exp))
      ;; (insts (insts ";" insts) (inst))
      ;; (exp (exp "+" exp)
      ;;      (exp "*" exp)
      ;;      ("(" exps ")"))
      ;; (exps (exps "," exps) (exp))
      )
    ;; '((assoc ";"))
    ;; '((assoc ","))
    ;; '((assoc "+") (assoc "*"))
    )))

;; (defun satysfi-smie-match-group ()
;;   (/ (position-if-not 'null (cddr (match-data))) 2))

(defun satysfi-smie-forward-token ()
  "Skip forward as smie utility."
  (forward-comment (point-max))
  ;; (cond
  ;;  ((looking-at satysfi-smie-token-regexp)
  ;;   (goto-char (match-end 0))
  ;;   (let ((group (car (nth (satysfi-smie-match-group) satysfi-smie-tokens))))
  ;;     (if (eq group 'keyword)
  ;;         (upcase (match-string-no-properties 0))
  ;;       group)))
  ;;  (t (buffer-substring-no-properties
  ;;      (point)
  ;;      (progn (skip-syntax-forward "w_")
  ;;             (point)))))
  )

(defun satysfi-smie-backward-token ()
  "Skip backward as smie utility."
  (forward-comment (- (point)))
  ;; (cond
  ;;  ((looking-back satysfi-smie-token-regexp (- (point) 20) t)
  ;;   (goto-char (match-beginning 0))
  ;;   (let ((group (car (nth (satysfi-smie-match-group) satysfi-smie-tokens))))
  ;;     (if (eq group 'keyword)
  ;;         (upcase (match-string-no-properties 0))
  ;;       group)))
  ;;  (t (buffer-substring-no-properties
  ;;      (point)
  ;;      (progn (skip-syntax-backward "w_")
  ;;             (point)))))
  )

(defun satysfi-smie-rules (_kind _token)
  "Additional rule as smie utility.
KIND TOKEN."
  ;; (case kind
  ;;   (:after
  ;;    (cond
  ;;     ((equal token ",") (smie-rule-separator kind))
  ;;     ((equal token "ON") satysfi-smie-indent-basic)))
  ;;   (:before
  ;;    (cond
  ;;     ((equal token ",") (smie-rule-separator kind)))))
  )

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
         "controls" "cycle"
         "command" "inline-cmd" "block-cmd" "math-cmd"
         "not" "mod" "true" "false")
       'symbols)
     . font-lock-keyword-face)
    (,(regexp-opt
       '("gnu" "melpa-stable" "melpa" "org")
       'symbols)
     . font-lock-variable-name-face)
    ("\\(\\\\\\(?:\\\\\\\\\\)*[a-zA-Z0-9\\-]+\\)\\>"
     (1 'satysfi-row-command-face))
    ("\\(\\+[a-zA-Z0-9\\-]+\\)\\>"
     (1 'satysfi-column-command-face))
    (,(rx (group "@require") ":" (* space) (group (* word)))
     (1 'satysfi-preprocessor-face)
     (2 'satysfi-header-require-face))
    (,(rx (group "@import") ":" (* space) (group (* word)))
     (1 'satysfi-preprocessor-face)
     (2 'satysfi-header-import-face))
    (,(rx (group "@" (* word)) ":" (* space) (group (* word)))
     (1 'satysfi-preprocessor-face)
     (2 'satysfi-header-require-face))
    ("\\(\\\\\\(?:@\\|`\\|\\*\\| \\|%\\||\\|;\\|{\\|}\\|\\\\\\)\\)"
     (1 'satysfi-escaped-character))))

(define-derived-mode satysfi-mode prog-mode "SATySFi"
  "Major mode for editing satysfi files."
  (set-syntax-table satysfi-mode-syntax-table)
  (setq-local font-lock-defaults '(satysfi-mode-font-lock-keywords))
  (setq-local comment-start "%")
  (setq-local electric-indent-chars '(?\n ?{ ?} ?\[ ?\] ?\( ?\)))

  (smie-setup satysfi-smie-grammar 'satysfi-smie-rules
              :forward-token 'satysfi-smie-forward-token
              :backward-token 'satysfi-smie-backward-token)
  (setq-local smie-indent-basic 2))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.satyh?\\'" . satysfi-mode))
;;;###autoload
(add-to-list 'interpreter-mode-alist '("saty\\(h\\|sfi\\)?" . satysfi-mode))

(provide 'satysfi-mode)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; satysfi-mode.el ends here
