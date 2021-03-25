(defsystem "stumpwm-prescient"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (:stumpwm)
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "stumpwm-prescient/tests"))))

(defsystem "stumpwm-prescient/tests"
  :author ""
  :license ""
  :depends-on ("stumpwm-prescient"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for stumpwm-prescient"
  :perform (test-op (op c) (symbol-call :rove :run c)))
