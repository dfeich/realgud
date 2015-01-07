(require 'test-simple)
(load-file "../realgud/debugger/zshdb/zshdb.el")
(load-file "../realgud/common/core.el")

(declare-function realgud:expand-file-name-if-exists 'realgud-core)

(eval-when-compile (defvar test:run-process-save))

(declare-function zshdb-parse-cmd-args 'realgud:zshdb)
(declare-function realgud:zshdb        'realgud:zshdb)
(declare-function __FILE__             'require-relative)

(test-simple-start)

;; Save value realgud:run-process and change it to something we want
(setq test:run-process-save (symbol-function 'realgud:run-process))
(defun realgud:run-process(debugger-name script-filename cmd-args
				      minibuf-history
				      &optional no-reset)
  "Fake realgud:run-process used in testing"
  (note
   (format "%s %s %s" debugger-name script-filename cmd-args))
  (assert-equal "zshdb" debugger-name "debugger name gets passed")
  (let ((expanded-name
	 (realgud:expand-file-name-if-exists "./gcd.sh")))
    (assert-equal  expanded-name script-filename "file name check")
    (assert-equal (list expanded-name "3" "5")
		  (cdr cmd-args) "command args listified")
    ))

(note "zshdb-parse-cmd-args")
(assert-equal (list nil '("zshdb")
		    (list (realgud:expand-file-name-if-exists "foo")) nil)
	      (zshdb-parse-cmd-args '("zshdb" "foo")))
(assert-equal (list nil '("zshdb")
		    (list (realgud:expand-file-name-if-exists "program.sh")
			  "foo") nil)
	      (zshdb-parse-cmd-args
	       '("zshdb" "program.sh" "foo")))

(realgud:zshdb "zshdb ./gcd.sh 3 5")
;; Restore the old value of realgud:run-process
(fset 'realgud:run-process test:run-process-save)

(end-tests)
