;;; litorgy-script.el --- litorgy functions for script execution

;; Copyright (C) 2009 Eric Schulte, Dan Davison, Austin F. Frank

;; Author: Eric Schulte, Dan Davison, Austin F. Frank
;; Keywords: literate programming, reproducible research
;; Homepage: http://orgmode.org
;; Version: 0.01

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Litorgy support for evaluating shell, ruby, and python source code.

;;; Code:
(require 'litorgy)

(defun litorgy-script-add-interpreter (var cmds)
  (set-default var cmds)
  (mapc (lambda (cmd)
          (setq litorgy-interpreters (cons cmd litorgy-interpreters))
          (eval
           `(defun ,(intern (concat "litorgy-execute:" cmd)) (body params)
              (concat "Evaluate a block of " ,cmd " script with litorgy.
This function is called by `litorgy-execute-src-block'.")
              (litorgy-script-execute ,cmd body params))))
        cmds))

(defcustom litorgy-script-interpreters '("sh" "bash" "zsh" "ruby" "python")
  "List of interpreters of scripting languages which can be
executed through litorgy."
  :group 'litorgy
  :set 'litorgy-script-add-interpreter)

(defun litorgy-script-execute (cmd body params)
  "Run CMD on BODY obeying any options set with PARAMS.
TODO: currently the params part is not implemented"
  (message (format "executing source block with %s..." cmd))
  (with-temp-buffer
    (insert body)
    (shell-command-on-region (point-min) (point-max) cmd nil 'replace)
    (message "finished executing source block")
    (buffer-string)))

(provide 'litorgy-script)
;;; litorgy-script.el ends here