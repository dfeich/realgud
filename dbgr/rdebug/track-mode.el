;;; Ruby "rdebug" Debugger tracking a comint or eshell buffer.

(eval-when-compile (require 'cl))
(require 'load-relative)
(require-relative-list '("../common/track-mode" "../common/cmds" 
			 "../common/menu") "dbgr-")
(require-relative-list '("../common/init/rdebug") "dbgr-init-")
(require-relative-list '("core" "cmds") "rdebug-")

(defvar rdebug-pat-hash)
(defvar rdebug-track-mode nil
  "Non-nil if using rdebug-track mode as a minor mode of some other mode.
Use the command `rdebug-track-mode' to toggle or set this variable.")

(declare-function dbgr-track-mode(bool))

(defvar rdebug-track-minor-mode-map (make-sparse-keymap)
  "Keymap used in `rdebug-track-minor-mode'.")
(dbgr-populate-common-keys rdebug-track-minor-mode-map)
(define-key rdebug-track-minor-mode-map 
  (kbd "C-c !b") 'rdebug-goto-traceback-line)

(defun rdebug-track-mode-body()
  "Called when entering or leaving rdebug-track-mode. Variable
`rdebug-track-mode' is a boolean which specifies if we are going
into or out of this mode."
  (dbgr-define-gdb-like-commands)
  ;; (dbgr-define-rdebug-commands)
  (if rdebug-track-mode
      (progn 
	(dbgr-track-set-debugger "rdebug")
	(dbgr-define-gdb-like-commands) ;; FIXME: unless already defined
	(dbgr-track-mode 't)
	(run-mode-hooks 'rdebug-track-mode-hook))
    (progn 
      (dbgr-track-mode nil)
    )))

(define-minor-mode rdebug-track-mode
  "Minor mode for tracking ruby debugging inside a process shell."
  :init-value nil
  ;; :lighter " rdebug"   ;; mode-line indicator from dbgr-track is sufficient.
  ;; The minor mode bindings.
  :global nil
  :group 'rdebug
  :keymap rdebug-track-minor-mode-map
  (rdebug-track-mode-body)
)

(provide-me "rdebug-")

;;; Local variables:
;;; eval:(put 'rbdbg-debug-enter 'lisp-indent-hook 1)
;;; End: